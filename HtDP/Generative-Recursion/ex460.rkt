;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex460) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define ε 0.01)

(define constant  (λ (x) 20))
(define linear    (λ (x) (* 2 x)))
(define quadratic (λ (x) (* 3 (sqr x))))

; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
(check-within (integrate-kepler constant 12 22) 200  ε)
(check-within (integrate-kepler linear    0 10) 100  ε)

; fail -> (check-within (integrate-kepler quadratic 0 10) 1000 ε)
 
(define (integrate-kepler f a b)
  (* 1/2 (- b a) (+ (f a) (f b))))


;; [Number -> Number] Number Number -> Number
;; computes the area under the graph of f between a and b
;; assume (< a b) holds
;; generative: splits the interval [a, b] into two pieces
;;             and recursively computes the area of each
;;             piece, and adds the two results.
;; termination: same as with previous binary search algorithms
(check-within (integrate-dc constant 12 22) 200  ε)
(check-within (integrate-dc linear    0 10) 100  ε)
(check-within (integrate-dc quadratic 0 10) 1000 ε)

(define (integrate-dc f a b)
  (cond
    [(<= (- b a) ε) (integrate-kepler f a b)]
    [else
     (local ((define mid (/ (+ a b) 2)))
       (+ (integrate-dc f a mid)
          (integrate-dc f mid b)))]))
