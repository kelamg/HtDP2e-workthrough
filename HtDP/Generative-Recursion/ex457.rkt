;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex457) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define eps 0.001)

(define msg "r is not \"small\"")

;; Number -> N
;; computes how many months it takes to double a given
;; amount of money at a given interest rate in %
(check-within (double-amount 100)  1 eps)
(check-within (double-amount   1) 72 eps)
(check-within (double-amount   6) 12 eps)
(check-within (double-amount  12)  6 eps)
(check-error  (double-amount 101))

(define (double-amount rate)
  (local ((define (find n)
            (cond
              [(<= (- 0.72 (* (/ rate 100) n)) eps) n]
              [else (find (add1 n))])))
    (if (> rate 100) (error msg) (find 1))))
