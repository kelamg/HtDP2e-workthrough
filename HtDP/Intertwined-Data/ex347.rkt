;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex347) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add [left right])
(define-struct mul [left right])

;; A BSL-expr is one of:
;; - Number
;; - (make-add BSL-expr BSL-expr)
;; - (make-mul BSL-expr BSL-expr)

;; A NumRet is a Number


;; BSL-expr -> NumRet
;; computes the value of bexpr
(check-expect (eval-expression 3) 3)
(check-expect
 (eval-expression (make-add 1 1)) 2)
(check-expect
 (eval-expression (make-mul 3 10)) 30)
(check-expect
 (eval-expression (make-add (make-mul 1 1) 10)) 11)

(define (eval-expression bexpr)
  (match bexpr
    [(? number?) bexpr]
    [(add   l r) (+ (eval-expression l) (eval-expression r))]
    [(mul   l r) (* (eval-expression l) (eval-expression r))]))