;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex352) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add (left right))
(define-struct mul (left right))

; A BSL-var-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-var-expr BSL-var-expr)
; – (make-mul BSL-var-expr BSL-var-expr)

;; BSL-var-expr Symbol Number -> BSL-var-expr
;; produces a BSL-var-expr like ex
;; with all occurences of x replaced by v
(check-expect
 (subst 'x 'x 5) 5)
(check-expect
 (subst (make-add 'x 3) 'x 5) (make-add 5 3))
(check-expect
 (subst (make-add (make-mul 'x 'x) (make-mul 'y 'y)) 'x 5)
 (make-add (make-mul 5 5) (make-mul 'y 'y)))

(define (subst ex x v)
  (match ex
    [(? number?) ex]
    [(? symbol?) (if (symbol=? ex x) v ex)]
    [(add   l r) (make-add (subst l x v) (subst r x v))]
    [(mul   l r) (make-mul (subst l x v) (subst r x v))]))
