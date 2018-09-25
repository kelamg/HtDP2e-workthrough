;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex458) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define ε 0.1)

(define constant  (λ (x) 20))
(define linear    (λ (x) (* 2 x)))
(define quadratic (λ (x) (* 3 (sqr x))))

; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
(check-within (integrate-kepler constant 12 22) 200  ε)
(check-within (integrate-kepler linear    0 10) 100  ε)
(check-within (integrate-kepler quadratic 0 10) 1000 ε)
 
(define (integrate-kepler f a b)
  (* 1/2 (- b a) (+ (f a) (f b))))


;; Q - Which of the three tests fails and by how much?

;; A - The quadratic function test fails by a +50% error.