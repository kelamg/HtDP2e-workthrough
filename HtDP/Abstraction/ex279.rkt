;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex279) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; (lambda (x y) (x y y))
;; Legal because variables for the lambda expr exist and are used in
;; the body of the expression; thus the expr will be legal as long
;; as the supplied x argument is a function.

;; (lambda () 10)
;; Not legal because there are no variables for the lambda expr.

;; (lambda (x) x)
;; Legal. There is at least one variable and it is used in the body.

;; (lambda (x y) x)
;; Legal. Both variables and a legal expr exist in the lambda expr.

;; (lambda x 10)
;; Illegal. Bad syntax.