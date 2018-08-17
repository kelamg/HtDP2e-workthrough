;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex118) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (f x) x)

(define (f x) y)

(define (f x y) 3)

;; A legal BSL function definition begins with an open parenthesis,
;; then the "define" keyword followed by parentheses enclosing at
;;least two variables, an expression, then a balancing closing parenthesis.
;;
;; def = (define (variable variable variable ...) expr)
;;
;; All three sentences follow the correct syntax