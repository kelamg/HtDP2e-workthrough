;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex414) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define EPSILON 0.0001)

;; N -> Number
;; adds n copies of #i1/185
(check-expect (add 0) 0)
(check-within (add 1) 1/185 EPSILON)
(check-within (add 185) 1 EPSILON)

(define (add n)
  (cond
    [(zero? n) 0]
    [else (+ #i1/185 (add (sub1 n)))]))

;; Number -> N
;; counts how often 1/185 can be subtracted from n
;; until it is 0
(check-expect (sub 0) 0)
(check-expect (sub 1/185) 1)

(check-expect (sub 1) 185)

; -> (check-expect (sub #i1.0) 185)
; - the above is non-terminating. This happens because
;   the floating point is a representation that never
;   causes the function to reach the base case; it 
;   never reaches the exact representation of zero

(define (sub n)
  (cond
    [(zero? n) 0]
    [else (add1 (sub (- n 1/185)))]))