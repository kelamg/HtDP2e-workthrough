;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex144) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An NEList-of-temperatures is one of: 
; – (cons CTemperature '())
; – (cons CTemperature NEList-of-temperatures)
; interpretation non-empty lists of Celsius temperatures

; NEList-of-temperatures -> Number
; computes the average temperature
(check-expect (average (cons 2 '())) 2)
(check-expect (average (cons 1 (cons 2 (cons 3 '())))) 2)
 
(define (average ne-l)
  (/ (sum ne-l)
     (how-many ne-l)))

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


;; sum and how-many work because the base case clause of the data
;; definition of List-of-temperatures is '(); the base case clause
;; in NEList-of-temperatures, (cons CTemperature '()), means that
;; at some point in sum and how-many, (rest alot) will be '()