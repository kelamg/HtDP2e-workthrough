;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex256) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; [X] [X -> Number] [NEList-of X] -> X 
; finds the (first) item in lx that maximizes f
; if (argmax f (list x-1 ... x-n)) == x-i, 
; then (>= (f x-i) (f x-1)), (>= (f x-i) (f x-2)), ...

;; This function takes a list and produce the item
;; in the list for which the result of the function f
;; is the greatest numerical value

(check-expect
 (argmax length (list (list 1 3 5) (list 2) (list 1 3)))
 (list 1 3 5))

; For argmin:

; [X] [X -> Number] [NEList-of X] -> X
; finds the (first) item in lx that minimizes f
; if (argmax f (list x-1 ... x-n)) == x-i, 
; then (>= (f x-i) (f x-1)), (>= (f x-i) (f x-2)), ...