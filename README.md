# Project Definition
You are working on a project for the City of Grand Rapids. They have provided you with latitude and longitude coordinate information defining the shapes of the city's neighborhoods. They want an application that, given the latitude and longitude of an address, tells them what neighborhood the address is part of.

A snapshot of a map of the neighborhoods is included to help you consider the constraints and shapes you'll be dealing with (see attached neighborhood_map.png).

Your application should:

* Read in the neighborhood shape data from a file (see attached gr_neighborhoods.txt)
* Read in the points to classify from a file (example below)
* Print out the neighborhood for each point (example below)
* Keep performance and correct results in mind

Requirements:

* Use the racket programming language (http://racket-lang.org/)
* Provide instructions in a README for running your application and tests
* Submit a copy of your project by 8 AM Monday, June 11th

# Approach
1. Read in file and store in some kind of object for each neighborhood (title, list of points, max latitude, max longitude, min latitude, min longitude)
  * Min/Max Lat/Lon allows to quickly identify if test points are potentially in the area.
2. Read in test points
3. Loop through all test points
  * Loop through all neighborhoods
    * Use Min/Max Lat/Lon to identify potential neighborhoods.
    * If multiple potential neighborhoods, further analysis required.

# Obstacles
1. Racket is an unknown language
2. Identifying if a point is inside of an abstract polygon will be difficult.

# Assumptions
1. WGS84 approximation of the earth
2. Lat/Lon will always be provided in decimal degrees (85.1234567) as opposed to Degrees/Minutes/seconds notation (85 12' 36" W)
