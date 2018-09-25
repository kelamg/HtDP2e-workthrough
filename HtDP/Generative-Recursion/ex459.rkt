;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex459) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define ε 0.01)
(define R  160)

(define constant  (λ (x) 20))
(define linear    (λ (x) (* 2 x)))
(define quadratic (λ (x) (* 3 (sqr x))))

; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
(check-within (integrate-R constant 12 22) 200  ε)
(check-within (integrate-R linear    0 10) 100  ε)
(check-within (integrate-R quadratic 0 10) 1000 ε)
 
(define (integrate-R f a b)
  (local ((define W (/ (- b a) R))
          (define S (/ W 2)))
    (for/sum ([i R])
      (* W (f (+ a (* i W) S))))))