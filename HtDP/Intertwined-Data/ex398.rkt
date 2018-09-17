;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex398) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; A Combination is a [List-of Number]
;; interp. coefficients of a linear term
;;         (list 2 3) represents 2x + 3y
(define comb1 '(5))
(define comb2 '(5 17))
(define comb3 '(5 17 3))

;; A Var* is a [List-of Number]
;; interp. variable values of a linear term
;;         (list 5 4) represents 2(5) + 3(4)
(define vars1 '(10))
(define vars2 '(10 1))
(define vars3 '(10 1 2))


;; Combination Var* -> Number
;; produces the value of the combination of the given values
(check-expect (value '() '()) 0)
(check-error  (value '() vars1))
(check-error  (value comb1 '()))
(check-expect (value comb1 vars1) 50)
(check-expect (value comb2 vars2) 67)
(check-expect (value comb3 vars3) 73)

(define (value c v)
  (cond
    [(and (empty? c) (empty? v)) 0]
    [(or  (empty? c) (empty? c)) (error 'value "differing lengths")]
    [else (+ (* (first c) (first v))
             (value (rest c) (rest v)))]))