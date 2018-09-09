;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex353) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add (left right))
(define-struct mul (left right))

; A BSL-var-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-var-expr BSL-var-expr)
; – (make-mul BSL-var-expr BSL-var-expr)

;; A BSL-expr is one of:
;; - Number
;; - (make-add BSL-expr BSL-expr)
;; - (make-mul BSL-expr BSL-expr)

;; BSL-var-expr -> Boolean
;; produces #true if ex is also a BSL-expr
(check-expect
 (numeric? 'x) #false)
(check-expect
 (numeric? (make-add 'x 3)) #false)
(check-expect
 (numeric? (make-add 10 32)) #true)
(check-expect
 (numeric? (make-mul 10 32)) #true)

(define (numeric? ex)
  (match ex
    [(? number?) #true]
    [(add   l r) (andmap numeric? (list l r))]
    [(mul   l r) (andmap numeric? (list l r))]
    [else #false]))
