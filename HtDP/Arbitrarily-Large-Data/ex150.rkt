;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex150) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; N -> Number
; computes (+ n pi) without using +
(check-within (add-to-pi 3) (+ 3 pi) 0.001)
 
(define (add-to-pi n)
  (cond
    [(zero? n) pi]
    [else
     (add1 (add-to-pi (sub1 n)))]))

; N Number -> Number
; computes (+ n x) without using +
(check-expect (add 0 3) 3)
(check-expect (add 1 3) 4)
(check-expect (add 5 5) 10)
(check-expect (add 20 10) 30)

(define (add n x)
  (cond
    [(zero? n) x]
    [else
     (add1 (add (sub1 n) x))]))

;; check-within is used because pi is an irrational number