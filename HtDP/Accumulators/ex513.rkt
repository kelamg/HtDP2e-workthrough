;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex513) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A Lam is one of: 
; – Symbol
; – Lexpr
; – Lapp

(define-struct lexpr (params body))
;; A LExpr is a structure:
;;   (make-lexpr Params Lam)
;; A Params is a [List-of Symbol]

(define-struct lapp  (func arg))
;; A LApp is a structure:
;;   (make-lapp Lam Lam)

(define ex1 (make-lexpr '(x) 'x))
(define ex2 (make-lexpr '(x) 'y))
(define ex3 (make-lexpr '(y) (make-lexpr '(x) 'y)))
