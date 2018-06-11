import os
from shapely.geometry import *

class Neighborhood:
    name = ""
    points = []

    def __init__(self):
        self.name = ""
        self.points = []

    def __str__(self):
        return self.name


def readNeighborhoods():
    hoodList = []
    with open('gr_neighborhoods.txt') as f:
        for line in f:
            if line.strip().startswith("-"):
                lat, lon = line.strip(' \n').split(',')
                newPoint = Point(float(lat), float(lon))
                newHood.points.append(newPoint)

            elif line.strip() == "":
                continue
            else:
                try:
                    hoodList.append(newHood)
                except NameError:
                    print "Just the start - creating a new 'hood!"

                newHood = Neighborhood()
                newHood.name = line.strip(' \r\n:')

    #We exit the loop before appending the last neighborhood,
    #so add it here. All the info is already filled out
    hoodList.append(newHood)
    return hoodList

def readTestPoints():
    testPoints = []
    with open('test-points.txt') as f:
        for line in f:
            name, datapoint = line.split(':')
            lat, lon = datapoint.split(',')
            testPoints.append(Point(float(lat), float(lon)))

    return testPoints

hoodList = readNeighborhoods()
testList = readTestPoints()

for index, point in enumerate(testList):
    pointFound = False
    for hood in hoodList:
        if point.within(Polygon([[p.x, p.y] for p in hood.points])):
            print "Point " + str(index+1) + ": " + hood.name
            pointFound = True
    if not pointFound:
        print "Point " + str(index+1) + ": <none>"
