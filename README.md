# Project Definition
You are working on a project for the City of Grand Rapids. They have provided you with latitude and longitude coordinate information defining the shapes of the city's neighborhoods. They want an application that, given the latitude and longitude of an address, tells them what neighborhood the address is part of.

A snapshot of a map of the neighborhoods is included to help you consider the constraints and shapes you'll be dealing with.

Your application should:

* Read in the neighborhood shape data from a file ([gr_neighborhoods.txt](gr_neighborhoods.txt))
* Read in the points to classify from a file ([test-points.txt](test-points.txt)])
* Print out the neighborhood for each point
  * Point 1: ken-O-Sha Park
  * Point 2: Alger Heights
  * Point 3: Southeast Community
  * Point 4: <none>
  * Point 5: John Ball Park
  * Point 6: Oldtown-Heartside
  * Point 7: Bellknap Lookout
  * Point 8: Heritage Hill
  * Point 9: <none>
  * Point 10: Creston
  * Point 11: North End
  * Point 12: Creston
* Keep performance and correct results in mind

Requirements:

* Use the racket programming language (http://racket-lang.org/)
* Provide instructions in a README for running your application and tests
* Submit a copy of your project by 8 AM Monday, June 11th

Note: Someone has obviously done this before: https://stackoverflow.com/questions/20753667/how-to-find-if-a-point-is-inside-of-a-polygon-using-racket

# Approach
1. Read in file and store in some kind of object for each neighborhood (title, list of points, ~~max latitude, max longitude, min latitude, min longitude~~)
  * ~~Min/Max Lat/Lon allows to quickly identify if test points are potentially in the area.~~ This probably won't work as many of the test points are in places specifically made to mess this up. Would probably work for 90% of normal use-cases and would speed up execution.
2. Read in test points
3. Loop through all test points
  * Loop through all neighborhoods
  * Figure out which neighborhood it's in

# Obstacles
1. Racket is an unknown language
  * Mitigate by utilizing other languages and running from Racket and using template code.
  * Or just learn it...
2. Identifying if a point is inside of an abstract polygon will be difficult.
  * Mitigate by using pre-tested libraries and code examples.
    * Appears to be 2 camps to figuring this out:
      * The "hard" way (and probably most correct) - using the [DE-9IM model](https://en.wikipedia.org/wiki/DE-9IM) which uses matrix multiplication, dot products and corss products
      * The "easy" way (and easiest to understand) - using the [Ray Polygon Intersection method](https://pdfs.semanticscholar.org/presentation/d30b/29b1c9306540a2891d2830ee65d55d3fb836.pdf) which uses some assumptions and simple math to identify inside vs outside.

# Assumptions
1. ~~WGS84 approximation of the earth~~ Actually - just using a flat-earth model should be good enough. Math is way easier
2. Lat/Lon will always be provided in decimal degrees (85.1234567) as opposed to Degrees/Minutes/seconds notation (85 12' 36" W)

# Solution
## Solution 1 - master branch
Using the shapely library and building this in python allows for us to quickly formulate to a correct answer. Wrapping it in a racket application basically allows us to complete the "must be racket" part of the assignment :) Shapely is using the DE-9IM model references above.

### Build and Run Instructions
Be sure to have installed:
* [Racket](http://racket-lang.org/download/) (tested with 6.12)
* [python](https://www.python.org/downloads/release/python-2710/) (tested with 2.7.10)
* [pip](https://pip.pypa.io/en/stable/installing/) (tested with 10.0.1)
* [shapely python library](https://pypi.org/project/Shapely/) (tested with 1.6.4.post1)

Run with racket on the command line by running
```
racket racket_wrapper.rkt
```
Or using the DrRacket GUI by opening the file racket_wrapper.rkt and selecting "Run"

time: about 1.5s (with racket wrapper), 1.2s (standalone python)

## Solution 2 - develop branch
There are multiple ways to do this in Racket. After struggling with Racket in general for a *long* time (my first functional language), I stumbled upon a project to bring the python language to Racket called [PyonR](https://github.com/pedropramos/PyonR). I also spent some time trying to get this to work. I thought since I already wrote Solution 1 in python, I could just pull it in. I struggled for a while to get the type definitions to match between python and Racket (mostly has problems with "lists") so I decided to bite the bullet and just learn Racket.

The first thing I tired to do was find a library that did the geometric math. There are a couple out there, but ultimately, the one that looked the most promising was a racket library written by [Vincent Toups](https://github.com/VincentToups/racket-lib). I pulled the files I needed from it they are included in [geometry-library](geometry-library). There are no instructions on pulling in the entire library (and I couldn't figure out how to do it...and I didn't need it) so I just used what I needed.

After struggling with the language some more, I finally started to get it (and understand the API documentation). I finally got to the point where I can read in the files, save them off to proper object and pass those objects to the geometry library. Unfortunately, the geometry library I selected doesn't appear to be tested properly. Quickly running out of time, I couldn't figure out what changes needed to be made to come up with the correct answers, but, I'm positive, given another day or 2, I could make it work properly.

I haven't merged this into master because....well....it isn't done yet.

### Build and Run Instructions
Be sure to have installed:
* [Racket](http://racket-lang.org/download/) (tested with 6.12)

In the directory where the geometry-library exists, link in the geometry-library using:
```
raco link geometry-library
```
Run the application using
```
racket neighborhood-decoder.rkt
```
You should see the output in the proper format but incorrect solutions.

time: about 1.4s
