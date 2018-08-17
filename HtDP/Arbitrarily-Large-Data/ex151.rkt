;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex151) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; N Number -> Number
; computes (* n x) without using *
(check-expect (multiply 0 3) 0)
(check-expect (multiply 3 0) 0)
(check-expect (multiply 1 3) 3)
(check-expect (multiply 5 5) 25)
(check-expect (multiply 20 10) 200)

(define (multiply n x)
  (cond
    [(or (zero? n)
         (zero? x)) 0]
    [else
     (+ x (multiply (sub1 n) x))]))
