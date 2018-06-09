import os

class Coordinate:
    name = ""
    latitude = 0
    longitude = 0

    def __init__(self, lat, lon):
        self.latitude = lat
        self.longitude = lon

    def __init__(self, name, lat, lon):
        self.latitude = lat
        self.longitude = lon
        self.name = name

    def __str__(self):
        return "(%.18f, %.18f)" % (self.latitude, self.longitude)

class Neighborhood:
    name = ""
    points = []
    maxPoint = Coordinate("", -90, -180)
    minPoint = Coordinate("", 90, 180)

    def __str__(self):
        return self.name + ": " + str(self.maxPoint) + " " + str(self.minPoint)


def readNeighborhoods():
    hoodList = []
    with open('gr_neighborhoods.txt') as f:
        for line in f:
            if line.strip().startswith("-"):
                lat, lon = line.strip(' \n').split(',')
                newPoint = Coordinate("", float(lat), float(lon))
                newHood.points.append(newPoint)
                if(newPoint.latitude > newHood.maxPoint.latitude and newPoint.longitude > newHood.maxPoint.longitude):
                    newHood.maxPoint = newPoint

                if(newPoint.latitude < newHood.minPoint.latitude and newPoint.longitude < newHood.minPoint.longitude):
                    newHood.minPoint = newPoint

            elif line.strip() == "":
                continue
            else:
                try:
                    hoodList.append(newHood)
                except NameError:
                    print "Just the start - creating a new hood!"

                newHood = Neighborhood()
                newHood.name = line.strip(' \n').rstrip(':')

    return hoodList

def readTestPoints():
    testPoints = []
    with open('test-points.txt') as f:
        for line in f:
            name, datapoint = line.split(':')
            lat, lon = datapoint.split(',')
            testPoints.append(Coordinate(name, float(lat), float(lon)))

    return testPoints

hoodList = readNeighborhoods()
testList = readTestPoints()
for point in testList:
    for hood in hoodList:
        if point.latitude > hood.minPoint.latitude and point.latitude < hood.maxPoint.latitude and point.longitude > hood.minPoint.longitude and point.longitude < hood.maxPoint.longitude:
            print point.name + " is in hood " + hood.name
