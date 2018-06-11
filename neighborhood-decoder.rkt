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

;create some temp placeholders
(define neighborhoods empty)
(define points empty)
(define name "")
(define test-data empty)
;Making a list of neighborhoods as defined by the structure above by going through the trimmed-data and parsing it out
(for-each (lambda (i)
       (if (string=? "" i) (begin
                             (set! neighborhoods (append neighborhoods (list (neighborhood (string-copy name) points))))
                             (set! points empty)
                             (set! name ""))
       (if (string=? "-" (substring i 0 1)) (begin
                                              (set! points (append points (list (point (string->number (first (string-split i ","))) (string->number (second (string-split i ",")))))))
                                              )

                                              (begin
                                                (set! name (string-trim i ":"))
                                                )
                                              )))
       trimmed-data)

;Add in the last one
(set! neighborhoods (append neighborhoods (list (neighborhood (string-copy name) points))))

;Read in the test data
(define/contract raw-test-data
    (listof string?) (read-lines "test-points.txt"))
(define point-string "")

;Map the test data into the test-data list
(for-each (lambda (i)
       (if (string=? "" i) void
           (begin
             (set! point-string (string-trim (second (string-split i ":"))))
             (set! test-data (append test-data (list (struct-testdata (first (string-split i ":")) (point (string->number (first (string-split point-string ","))) (string->number (second (string-split point-string ","))))))))
             )
           ))
       raw-test-data)

(define found #f)
;go through all the test data
(for ([i (in-list test-data)])
  (begin
    ;check each neighborhood for the point being in the polygon
    (for ([j (in-list neighborhoods)]) #:break (eq? found #t)
      (define poly (polygon (neighborhood-points j)))
      (begin
        (if (point-in-polygon? (struct-testdata-testpoint i) poly)
            (begin
              (printf "~a: ~a\n" (struct-testdata-name i) (neighborhood-name j))
              (set! found #t)
            )
            void )
      )
    )
    (if (not found) (printf "~a: <none>\n" (struct-testdata-name i)) void)
    (set! found #f)
  )
)