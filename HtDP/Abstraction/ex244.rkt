;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex244) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (f x) (x 10))

(define (f x) (x f))

(define (f x y) (x 'a y 'b))

;; These are legal because the passed in function x, is used in all
;; definitions by supplying arguments to it in the function body
;; of f in each case. This is legal because in this case, function
;; arguments are being used to perform computations on values inside
;; the function body of f