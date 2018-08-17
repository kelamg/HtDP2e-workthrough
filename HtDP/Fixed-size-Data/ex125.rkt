;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex125) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct oops []) ; legal

(define-struct child [parents dob date]) ; legal

(define-struct (child person) [dob date]) ; illegal

;; (define-struct oops []) is legal because it follows the syntax rules for
;; a structure definition. Even though it has no variables in the enclosing
;; parenthesis, it is still syntactically legal.

;; (define-struct child [parents dob date]) is legal because it uses the
;; define-struct keyword, followed by a variable name, and a sequence of 3
;; variable names enclosed within square brackets. Square brackets or
;; parentheses can be used here legally in DrRacket

;; (define-struct (child person) [dob date]) is illegal because it
;; defines a function call in place of the strcture's variable name