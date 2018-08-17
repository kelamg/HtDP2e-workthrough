;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex143) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A List-of-temperatures is one of: 
; – '()
; – (cons CTemperature List-of-temperatures)
 
; A CTemperature is a Number greater than -273.

;; List-of-temperatures -> Number
;; computes the average temperature
(check-expect
 (average (cons 1 (cons 2 (cons 3 '())))) 2)

; List-of-temperatures -> Number
; computes the average temperature 
(define (average alot)
  (/ (sum alot) (how-many alot)))
 
; List-of-temperatures -> Number 
; adds up the temperatures on the given list
(check-expect
 (sum (cons 1 (cons 2 (cons 3 '())))) 6)

(define (sum alot)
  (cond
    [(empty? alot) 0]
    [else (+ (first alot) (sum (rest alot)))]))
 
; List-of-temperatures -> Number 
; counts the temperatures on the given list
(define (how-many alot)
  (cond
    [(empty? alot) 0]
    [else (+ (how-many (rest alot)) 1)]))



;; When '() is applied to average, we get a division by zero error

;; List-of-temperatures -> Number
;; computes the average temperature
;; raises an error message when supplied an empty list
(check-error (checked-average '()))
(check-expect
 (checked-average (cons 1 (cons 2 (cons 3 '())))) 2)

(define (checked-average alot)
  (if (empty? alot)
      (error
       "checked-average: average of an empty list is a division by zero error")
      (average alot)))