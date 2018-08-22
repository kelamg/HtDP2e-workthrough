;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex236) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; N Lon -> Lon
;; adds n to each item in l
(define (addn n l)
  (cond
    [(empty? l) '()]
    [else
     (cons (+ n (first l))
           (addn n (rest l)))]))

; Lon -> Lon
; adds 1 to each item in l
(check-expect (add1* '()) '())
(check-expect
 (add1* (list 4 10 27)) (list 5 11 28))

(define (add1* l)
  (addn 1 l))

; Lon -> Lon
; adds 5 to each item in l
(check-expect (plus5 '()) '())
(check-expect
 (plus5 (list 2 11 55)) (list 7 16 60))

(define (plus5 l)
  (addn 5 l))

;; Lon -> Lon
;; subtracts 2 from each item in l
(check-expect (subtract2 '()) '())
(check-expect
 (subtract2 (list 2 10 25))
 (list 0 8 23))

(define (subtract2 l)
  (addn -2 l))
