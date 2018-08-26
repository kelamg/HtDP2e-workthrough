;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex270) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
 
;; N -> [List-of N]
;; creates a list (list 0 ... (- n 1)) for any natural number n
(check-expect
 (series 5) '(0 1 2 3 4))
(check-expect
 (series 10) '(0 1 2 3 4 5 6 7 8 9))

(define (series n)
  (local (;; N -> N
          ;; return n's identity
          (define (id n)
            n))
    (build-list n id)))

;; N -> [List-of N]
;; creates a list (list 1 ... n) for any natural number n
(check-expect
 (series-2 5) '(1 2 3 4 5))
(check-expect
 (series-2 10) '(1 2 3 4 5 6 7 8 9 10))

(define (series-2 n)
    (build-list n add1))

;; N -> [List-of N]
;; creates the list (list 1 1/2 ... 1/n) for any natural number n
(check-expect
 (series-3 5) '(1 1/2 1/3 1/4 1/5))

(define (series-3 n)
  (local (;; N -> N
          ;; return the reciprocal of (+ n 1)
          (define (reciprocal n)
            (/ 1 (add1 n))))
    (build-list n reciprocal)))

;; N -> [List-of N]
;; creates the list of the first n even numbers
(check-expect
 (series-4 5) '(0 2 4 6 8))

(define (series-4 n)
  (local (;; N -> N
          ;; return (+ n 2)
          (define (next-even n)
            (+ n n)))
    (build-list n next-even)))

;; N -> [List-of [List-of N]]
;; creates a diagonal square of 0s and 1s
;; already solved in exercise 262

;; [Number -> X] Number -> [List-of X]
;; abstract tabulate function
(check-expect
 (tabulate add1 10)
 '(1 2 3 4 5 6 7 8 9 10 11))
(check-expect
 (tabulate sqr 5)
 '(0 1 4 9 16 25))

(define (tabulate fn n)
  (build-list (add1 n) fn)) 

