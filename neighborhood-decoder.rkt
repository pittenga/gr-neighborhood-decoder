#lang racket
(require 2htdp/batch-io)
(require geometry-library/planar-geometry)

;Neighborhood structure
(struct neighborhood (name points))

;Test data structure
(struct struct-testdata (name testpoint))

;Read in the raw data
(define/contract raw-data
    (listof string?) (read-lines "gr_neighborhoods.txt"))

;Trim off all the whitespace
(define trimmed-data (map (lambda (i) (string-trim i))
       raw-data))

;create some temp placeholders for use below
(define neighborhoods empty)
(define points empty)
(define name "")
(define test-data empty)

;Making a list of neighborhoods as defined by the structure above by going through
;the trimmed-data and parsing it out
(for-each (lambda (i)
        ;If the line is blank - we know it's a break between neighborhoods,
        ;let's save all the temp data we've been keeping up
       (if (string=? "" i) (begin
                             (set! neighborhoods (append neighborhoods (list (neighborhood (string-copy name) points))))
                             (set! points empty)
                             (set! name ""))
        ;If the line starts with a negative, we know it's a lat/long, save it
       (if (string=? "-" (substring i 0 1)) (begin
                                              (set! points (append points (list (point (string->number (first (string-split i ","))) (string->number (second (string-split i ",")))))))
                                              )
                                              ;Else - it's a name of a neighborhood, save it
                                              (begin
                                                (set! name (string-trim i ":"))
                                                )
                                              )))
       trimmed-data)

;Add in the last one since it doesn't get added in the list.
(set! neighborhoods (append neighborhoods (list (neighborhood (string-copy name) points))))

;Read in the test data
(define/contract raw-test-data
    (listof string?) (read-lines "test-points.txt"))

;Another temp variable to be used below
(define point-string "")

;Map the test data into the test-data structure (list)
(for-each (lambda (i)
       (if (string=? "" i) void
           (begin
             (set! point-string (string-trim (second (string-split i ":"))))
             (set! test-data (append test-data (list (struct-testdata (first (string-split i ":")) (point (string->number (first (string-split point-string ","))) (string->number (second (string-split point-string ","))))))))
             )
           ))
       raw-test-data)

;Now we have 2 lists,
;   test-data is a list of "struct-testdata" ( Name, Point(x,y) )
;   neighborhoods is a list of "neighborhood" ( Name, list ( Point(x,y) ) )

(define found #f)
;go through all the test data
(for ([i (in-list test-data)])
  (begin
    ;check each neighborhood for the point being in the polygon, break as soon as we find it
    (for ([j (in-list neighborhoods)]) #:break (eq? found #t)
      ;create the polygon for this neighborhood
      (define poly (polygon (neighborhood-points j)))
      (begin
        ;If the point is in the polygon, print a success message and set the found variable!
        (if (point-in-polygon? (struct-testdata-testpoint i) poly)
            (begin
              (printf "~a: ~a\n" (struct-testdata-name i) (neighborhood-name j))
              (set! found #t)
            )
            ;Else - keep searching
            void )
      )
    )
    ;If we don't find it after searching all the neighborhoods - print <none>
    (if (not found) (printf "~a: <none>\n" (struct-testdata-name i)) void)
    (set! found #f)
  )
)
