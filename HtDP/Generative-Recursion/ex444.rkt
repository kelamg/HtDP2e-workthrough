;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex444) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (gcd-structural S L)
  (largest-common (divisors S S) (divisors S L)))
 
; N[>= 1] N[>= 1] -> [List-of N]
; computes the divisors of l smaller or equal to k
(define (divisors k l)
  '())
 
; [List-of N] [List-of N] -> N
; finds the largest number common to both k and l
(define (largest-common k l)
  1)

;; Q - Why do you think divisors consumes two numbers?
;;     Why does it consume S as the first argument in both uses?

;; A - The largest common divisor in two numbers will ALWAYS be limited
;;     by the smaller of the two numbers, because a factor of a number
;;     HAS to be smaller than that number. divisor takes two numbers mostly
;;     for efficiency reasons; it would be pointless to find the divisors
;;     of the larger number which are larger than the smaller number because
;;     those divisors cannot also be factors of the smaller one.
;;     All divisors of the smaller number are candidates for divisors of the
;;     larger one as well, which is why we use S as the first argument in both uses.
