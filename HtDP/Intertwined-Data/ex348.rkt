;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex348) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct bor (left right))
(define-struct band (left right))
(define-struct bnot (expr))

;; A BooleanBSL-expr is one of:
;; - #true
;; - #false
;; - (band BooleanBSL-Expr BooleanBSL-expr)
;; - (bor  BooleanBSL-Expr BooleanBSL-expr)
;; - (bnot BooleanBSL-Expr)

;; A BoolRet is one of:
;; - #true
;; - #false


;; BooleanBSL-expr -> BoolRet
;; computes the values of bool-bexpr
(check-expect
 (eval-bool-expression #true) #true)
(check-expect
 (eval-bool-expression #false) #false)
(check-expect
 (eval-bool-expression (make-band #false #true)) #false)
(check-expect
 (eval-bool-expression (make-band #false #false)) #false)
(check-expect
 (eval-bool-expression (make-band #true #true)) #true)
(check-expect
 (eval-bool-expression (make-bor #true #true)) #true)
(check-expect
 (eval-bool-expression (make-bor #false #true)) #true)
(check-expect
 (eval-bool-expression (make-bor #false #false)) #false)
(check-expect
 (eval-bool-expression (make-bnot #false)) #true)
(check-expect
 (eval-bool-expression (make-bnot #true)) #false)

(define (eval-bool-expression bool-bexpr)
  (match bool-bexpr
    [(? boolean?) bool-bexpr]
    [(bor    l r) (or  (eval-bool-expression l) (eval-bool-expression r))]
    [(band   l r) (and (eval-bool-expression l) (eval-bool-expression r))]
    [(bnot  expr) (not (eval-bool-expression expr))]))
