;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex250) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Number -> [List-of Number]
; tabulates sin between n 
; and 0 (incl.) in a list
(define (tab-sin n)
  (cond
    [(= n 0) (list (sin 0))]
    [else
     (cons
      (sin n)
      (tab-sin (sub1 n)))]))

; Number -> [List-of Number]
; tabulates sqrt between n 
; and 0 (incl.) in a list
(define (tab-sqrt n)
  (cond
    [(= n 0) (list (sqrt 0))]
    [else
     (cons
      (sqrt n)
      (tab-sqrt (sub1 n)))]))

;; [Number -> Number] Number -> [List-of Number]
;; abstract tabulate function
(check-expect
 (tabulate add1 10)
 (list 11 10 9 8 7 6 5 4 3 2 1))
(check-expect
 (tabulate sqr 5)
 (list 25 16 9 4 1 0))

(define (tabulate fn n)
  (cond
    [(= n 0) (list (fn 0))]
    [else
     (cons (fn n)
           (tabulate fn (sub1 n)))]))

;; Number -> [List-of Number]
;; tabulates the sqr between n
;; and 0 (incl.) in a list
(define (tab-sqr n)
  (tabulate sqr n))

;; Number -> [List-of Number]
;; tabulates the tan between n
;; and 0 (incl.) in a list
(define (tab-tan n)
  (tabulate tan n))