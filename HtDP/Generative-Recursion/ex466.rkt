;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex466) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

; An SOE is a non-empty Matrix.
; constraint for (list r1 ... rn), (length ri) is (+ n 1)
; interpretation represents a system of linear equations
 
; An Equation is a [List-of Number].
; constraint an Equation contains at least two numbers. 
; interpretation if (list a1 ... an b) is an Equation, 
; a1, ..., an are the left-hand-side variable coefficients 
; and b is the right-hand side
 
; A Solution is a [List-of Number]

; A TM is an [NEList-of Equation]
; such that the Equations are of decreasing length: 
;   n + 1, n, n - 1, ..., 2. 
; interpretation represents a triangular matrix

(define M ; an SOE 
  (list (list 2 2  3 10) ; an Equation 
        (list 2 5 12 31)
        (list 4 1 -2  1)))

(define MT ; M triangulated
  (list (list 2 2  3 10)
        (list   3  9 21)
        (list      1  2)))

(define MERR
  (list (list 2  3  3 8)
        (list 2  3 -2 3)
        (list 4 -2  2 4)))

; SOE -> TM
; triangulates the given system of equations
; generative: a new matrix to triangulate is created by subtracting
;             each of the rest of the equations from the first equation
;             and building them up as a new list. The global solution
;             is the result of consing the first equation to the resulting
;             triangular matrix (the solved problem)
(check-expect (triangulate '((1 2))) '((1 2)))
(check-expect (triangulate M) MT)
(check-error  (triangulate MERR))
  
(define (triangulate M)
  (match M
    [(cons eqn '()) M]
    [(cons first eqns)
     (cons first
           (triangulate
            (for/list ([eqn eqns])
              (subtract eqn first))))]))

;; Equation Equation -> Equation
;; produces a new equation by subtracting a multiple of the
;; second equation from the first, item by item, so that
;; the first coefficient is zero
;; the leading zero is dropped from the resulting equation
(check-expect
 (subtract '(1 1 2) '(2 4 5)) '(-1 -0.5))
(check-expect
 (subtract (second M) (first M)) '(3 9 21))
(check-expect
 (subtract '(6 3 4 2) '(1 1 3 4)) '(-3 -14 -22))

(define (subtract eqa eqb)
  (local ((define fac (/ (first eqa) (first eqb))))
    (for/list ([i (rest eqa)] [j (rest eqb)])
      (- i (* fac j)))))
