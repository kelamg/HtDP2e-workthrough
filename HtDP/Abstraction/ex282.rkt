;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex282) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (f-plain x)
  (* 10 x))

(define f-lambda
  (lambda (x)
     (* 10 x)))

; Number -> Boolean
(define (compare x)
  (= (f-plain x) (f-lambda x)))

(define (loop x n)
  (cond
    [(= n 0) #true]
    [else (and (compare x)
               (loop x (sub1 n)))]))

; Run 100 times
(loop 100000 100)