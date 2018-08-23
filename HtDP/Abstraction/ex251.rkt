;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex251) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; [List-of Number] -> Number
; computes the sum of 
; the numbers on l
(define (sum l)
  (cond
    [(empty? l) 0]
    [else
     (+ (first l)
        (sum (rest l)))]))

; [List-of Number] -> Number
; computes the product of 
; the numbers on l
(define (product l)
  (cond
    [(empty? l) 1]
    [else
     (* (first l)
        (product (rest l)))]))

;; [Number -> Number] [List-of Number] -> Number
;; abstract fold function
(check-expect
 (fold1 + 0 (list 3 7 10)) 20)
(check-expect
 (fold1 cons '() (list 3 7 10)) (list 3 7 10))

(define (fold1 fn b l)
  (cond
    [(empty? l) b]
    [else
     (fn (first l)
         (fold1 fn b (rest l)))]))
