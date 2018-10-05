;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex495) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [List-of N] -> N
;; sums all the numbers in alon0
(check-expect (sum.v2 '()) 0)
(check-expect (sum.v2 '(10 4 6)) 20)

(define (sum.v2 alon0)
  (sum/a alon0 0))

; [List-of Number] ??? -> Number
; computes the sum of the numbers on alon
; accumulator a is the sum of the numbers 
; that alon lacks from alon0
(define (sum/a alon a)
  (cond
    [(empty? alon) a]
    [else (sum/a (rest alon)
                 (+ (first alon) a))]))


(sum/a '(10 4 6) 0)

(sum/a (rest '(10 4 6)) (+ (first '(10 4 6)) 0))

(sum/a '(4 6) (+ (first '(10 4 6)) 0))

(sum/a '(4 6) (+ 10 0))

(sum/a '(4 6) 10)

(sum/a (rest '(4 6)) (+ (first '(4 6)) 10))

(sum/a '(6) (+ (first '(4 6)) 10))

(sum/a '(6) (+ 4 10))

(sum/a '(6) 14)

(sum/a (rest '(6)) (+ (first '(6)) 14))

(sum/a '() (+ (first '(6)) 14))

(sum/a '() (+ 6 14))

(sum/a '() 20)

20
