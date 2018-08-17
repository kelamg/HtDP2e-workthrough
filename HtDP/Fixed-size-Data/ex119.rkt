;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex119) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (f "x") x)

(define (f x y z) (x))

;; The correct BSL function definition syntax follows:
;;
;; def = (define (variable variable variable ...) expr)

;; (define (f "x") x) has a value of class String as the second
;; variable, in place of an actual variable name, hence it is illegal

;; (define (f x y z) (x)) has an illegal expr in its definition.
;; (x) is treated as a function call but because it does not include
;; at least one argument, it is illegal in BSL
