;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex358) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add (left right))
(define-struct mul (left right))

(define-struct fn-call (name arg))
;; A FunctionCall is a structure:
;;   (make-fn-call Symbol BSL-fun-expr)
;; interp. data representation for a function
;;         called with only one argument, arg

(define-struct fn-def (name param body))
;; A BSL-fun-def is a structure:
;;   (make-fn-def Symbol Symbol BSL-var-expr)
;; interp. a data representation of a function definition

(define f (make-fn-def 'f 'x (make-add 3 'x)))
(define g (make-fn-def 'g 'y (make-fn-call 'f (make-mul 2 'y))))
(define h (make-fn-def 'h 'v (make-add (make-fn-call 'f 'v) (make-fn-call 'g 'v))))

;; A BSL-fun-def* is [List-of BL-fun-def]
(define da-fgh (list f g h))

(define UNDEF-FUN-ERROR "lookup-def: undefined function")

; BSL-fun-def* Symbol -> [Or BSL-fun-def error]
; retrieves the definition of f in da
; signals an error if there is none
(check-expect (lookup-def da-fgh 'g) g)

(define (lookup-def da f)
  (match da
    ['() (error UNDEF-FUN-ERROR)]
    [(cons def rest)
     (if (symbol=? f (fn-def-name def)) def (lookup-def rest f))]))
