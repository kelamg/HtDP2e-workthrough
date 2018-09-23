;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex434) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; [List-of Number] Number -> [List-of Number]
(define (smallers l n)
  (cond
    [(empty? l) '()]
    [else (if (<= (first l) n)
              (cons (first l) (smallers (rest l) n))
              (smallers (rest l) n))]))

;; Q - What can go wrong when this version is used with the quick-sort< definition?

;; A - Imagine a situation where a list containing n is passed to smallers together
;;     with two other numbers both less than n. Since smallers returns all numbers
;;     less than or equal to n, it will return the exact same list as a newly
;;     generated problem to be solved, and it will recurse indefinitely with the exact
;;     same list because n never changes, and neither does the list.
