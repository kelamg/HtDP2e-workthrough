;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex167) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; List-of-posns -> Number
;; produces the sum of all x-coordinates in each posn in lop
(check-expect (sum '()) 0)
(check-expect (sum (cons (make-posn 12.5 40)
                         (cons (make-posn 43 51.3) '())))
              (+ 12.5 43))

(define (sum lop)
  (cond
    [(empty? lop) 0]
    [else
     (+ (posn-x (first lop))
        (sum (rest lop)))]))