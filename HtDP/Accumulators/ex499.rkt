;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex499) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [List-of Numbers] -> Number
;; produces the product of all numbers in l
(check-expect (product '()) 1)
(check-expect (product '(1 5 2 10)) 100)

(define (product l)
  (local (; [List-of Number] Number -> Number
          ; accumulator a is the product of all
          ; the numbers that l0 lacks from l
          (define (product/a l0 a)
            (cond
              [(empty? l0) a]
              [else (product/a (rest l0) (* (first l0) a))])))

    (product/a l 1)))

;; Q - The performance of product is O(n) where n is the length of
;;     the list. Does the accumulator version improve on this?

;; A - No. The accumulator traverses the entire list as well which means that
;;     as n increases, so will the time to process the list with the accumulator
;;     style product function.
