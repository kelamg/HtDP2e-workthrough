;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex395) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [List-of X] N -> [List-of X]
;; produces the first n items from l,
;; or all of l if it is too short
(check-expect (take '() 0) '())
(check-expect (take '() 5) '())
(check-expect (take '(1) 0) '())
(check-expect (take '(1) 1) '(1))
(check-expect (take '(1 3 5 7 10) 3) '(1 3 5))
(check-expect (take '(1 3 5 7 10) 5) '(1 3 5 7 10))
(check-expect (take '(1 3 5 7 10) 6) '(1 3 5 7 10))

(define (take l n)
  (cond
    [(or (zero? n) (empty? l)) '()]
    [else (cons (first l) (take (rest l) (sub1 n)))]))


;; [List-of X] N -> [List-of X]
;; produces l with the first n items of l removed,
;; or '() if l is too short
(check-expect (drop '() 0) '())
(check-expect (drop '() 5) '())
(check-expect (drop '(1) 0) '(1))
(check-expect (drop '(1) 1) '())
(check-expect (drop '(1 3 5 7 10) 3) '(7 10))
(check-expect (drop '(1 3 5 7 10) 5) '())
(check-expect (drop '(1 3 5 7 10) 6) '())

(define (drop l n)
  (cond
    [(empty? l) '()]
    [(zero? n)    l]
    [else (drop (rest l) (sub1 n))]))