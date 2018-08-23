;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex245) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Number -> Number
;; add zero to n
(define (add0 n)
  (+ n 0))

;; Number -> Number
;; returns the identity of the number
(define (id n)
  (* 1 n))

;; (Number -> Number) (Number -> Number) -> Boolean
;; produces true if f and g produce the same results
;; for the arguments 1.2, 3 and -5.775
(check-expect
 (function=at-1.2-3-and-5.775? add1 id) #f)
(check-expect
 (function=at-1.2-3-and-5.775? add0 id) #t)

(define (function=at-1.2-3-and-5.775? f g)
  (and (equal? (f    1.2) (g    1.2))
       (equal? (f      3) (g      3))
       (equal? (f -5.775) (g -5.775))))

;; Q - Can we hope to define function=?, which determines
;;     whether two functions from numbers to numbers are equal?

;; A - No. Designing such a function would require inputting all possible data
;;     in the ISL data universe and checking their outputs for equality.