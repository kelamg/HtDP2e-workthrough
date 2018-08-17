;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex161) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define RATE 14)

; Number -> Number
; computes the wage for h hours of work
(define (wage h)
  (* RATE h))

; List-of-numbers -> List-of-numbers
; computes the weekly wages for the weekly hours
(check-expect (wage* '()) '())
(check-expect
 (wage* (cons 28 '())) (cons 392 '()))
(check-expect
 (wage* (cons 4 (cons 2 '()))) (cons 56 (cons 28 '())))
              
(define (wage* whrs)
  (cond
    [(empty? whrs) '()]
    [else (cons (wage (first whrs)) (wage* (rest whrs)))]))



