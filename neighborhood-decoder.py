import os

class Coordinate:
    latitude = 0
    longitude = 0

    def __init__(self, lat, lon):
        self.latitude = lat
        self.longitude = lon

    def __str__(self):
        return "(%.18f, %.18f)" % (self.latitude, self.longitude)

class Neighborhood:
    name = ""
    points = []
    maxPoint = Coordinate(-90, -180)
    minPoint = Coordinate(90, 180)

    def __str__(self):
        return self.name + ": " + str(self.maxPoint) + " " + str(self.minPoint)


def readNeighborhoods():
    hoodList = []
    with open('gr_neighborhoods.txt') as f:
        for line in f:
            if line.strip().startswith("-"):
                lat, lon = line.strip(' \n').split(',')
                newPoint = Coordinate(float(lat), float(lon))
                newHood.points.append(newPoint)
                if(newPoint.latitude > newHood.maxPoint.latitude):
                    newHood.maxPoint.latitude = newPoint.latitude
                if(newPoint.longitude > newHood.maxPoint.longitude):
                    newHood.maxPoint.longitude = newPoint.longitude
                if(newPoint.latitude < newHood.minPoint.latitude):
                    newHood.minPoint.latitude = newPoint.latitude
                if(newPoint.longitude < newHood.minPoint.longitude):
                    newHood.minPoint.longitude = newPoint.longitude
            else:
                try:
                    hoodList.append(newHood)
                except NameError:
                    print "Just the start - creating a new hood!"

                newHood = Neighborhood()
                newHood.name = line.strip(' :\n')


    return hoodList

hoodList = readNeighborhoods()
    
