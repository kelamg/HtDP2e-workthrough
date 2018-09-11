;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex356) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct add (left right))
(define-struct mul (left right))

(define-struct fn-call  (name arg))
;; A FunctionCall is a structure:
;;   (make-fn-call Symbol BSL-fun-expr)
;; interp. data representation for a function
;;         called with only one argument, arg

; A BSL-fun-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-fun-expr BSL-fun-expr)
; – (make-mul BSL-fun-expr BSL-fun-expr)
; - (make-fn-call Symbol BSL-fun-expr)

(define EX1 (make-fn-call 'k (make-add 1 1)))
(define EX2 (make-mul 5 E1))
(define EX3 (make-mul (make-fn-call 'i 5) E1))

