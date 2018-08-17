;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex116) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

x

(= y z)

(= (= y z) 0)

;; x is a variable; every variable is an expression

;; (= y z) is a primitive call using two variables;
;; = is a primitive, x and y are variales

;; (= (= y z) 0) is the same as the previous expression but
;; with another expression as one argument to the primitive
;; call instead of a variable, which is legal because
;; primitive calls and variables are both expressions in DrRacket

