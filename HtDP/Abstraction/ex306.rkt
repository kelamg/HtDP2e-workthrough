;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex306) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

;; N -> [List-of N]
;; creates a list (list 0 ... (- n 1)) for any natural number n
(check-expect
 (series 5) '(0 1 2 3 4))
(check-expect
 (series 10) '(0 1 2 3 4 5 6 7 8 9))

(define (series n)
  (for/list ([i n]) i))

;; N -> [List-of N]
;; creates a list (list 1 ... n) for any natural number n
(check-expect
 (series-2 5) '(1 2 3 4 5))
(check-expect
 (series-2 10) '(1 2 3 4 5 6 7 8 9 10))

(define (series-2 n)
  (for/list ([i n]) (add1 i)))

;; N -> [List-of N]
;; creates the list (list 1 1/2 ... 1/n) for any natural number n
(check-expect
 (series-3 5) '(1 1/2 1/3 1/4 1/5))

(define (series-3 n)
  (for/list ([i n]) (/ 1 (add1 i))))

;; N -> [List-of N]
;; creates the list of the first n even numbers
(check-expect
 (series-4 5) '(0 2 4 6 8))
(check-expect
 (series-4 10) '(0 2 4 6 8 10 12 14 16 18))

(define (series-4 n)
  (for/list ([i (in-range 0 (* n 2) 2)]) i))

; An NMatrix is a [List-of [List-of N]]

;; N -> NMatrix
;; creates diagonal squares of 0s and 1s (identity matrix)
(check-expect
 (identityM 1)
 '((1)))
(check-expect
 (identityM 3)
 '((1 0 0)
   (0 1 0)
   (0 0 1)))
(check-expect
 (identityM 5)
 '((1 0 0 0 0)
   (0 1 0 0 0)
   (0 0 1 0 0)
   (0 0 0 1 0)
   (0 0 0 0 1)))

(define (identityM n)
  (for/list ([i n])
    (for/list ([j n])
      (if (= i j) 1 0))))

;; [Number -> X] Number -> [List-of X]
;; abstract tabulate function
(check-expect
 (tabulate add1 10)
 '(1 2 3 4 5 6 7 8 9 10 11))
(check-expect
 (tabulate sqr 5)
 '(0 1 4 9 16 25))

(define (tabulate fn n)
  (for/list ([i (add1 n)])
    (fn i)))