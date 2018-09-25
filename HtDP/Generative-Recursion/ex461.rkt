;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex461) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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
(check-within (integrate-adaptive constant 12 22) 200  ε)
(check-within (integrate-adaptive linear    0 10) 100  ε)
(check-within (integrate-adaptive quadratic 0 10) 1000 ε)

(define (integrate-adaptive f a b)
  (local ((define mid   (/ (+ a b) 2))
          (define this.trap  (integrate-kepler f a b))
          (define left.trap  (integrate-kepler f a mid))
          (define right.trap (integrate-kepler f mid b))
          (define difference (- left.trap right.trap))
          (define good-enough?
            (< (abs difference) (* ε (- b a)))))
    
    (if good-enough?
        this.trap
        (+ (integrate-adaptive f a mid)
           (integrate-adaptive f mid b)))))

;; Q - Does integrate-adaptive always compute a better answer than either
;;     integrate-kepler or integrate-rectangles? Which aspect is integrate-adaptive
;;     guaranteed to improve?

;; A - integrate-adaptive will always compute a better answer than integrate-kepler
;;     because of the preemptive test. It doesn't always computer a better answer
;;     than integrate-rectangles however. integrate-adaptive is guaranteed to improve
;;     time performance however since it uses a binary search algorithm as opposed
;;     to integrate-rectangles, which is more of a linear search algorithm.
