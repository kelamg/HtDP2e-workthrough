;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex263&264) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Nelon -> Number
; determines the smallest number on l
(define (inf l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (local ((define smallest-in-rest (inf (rest l))))
       (if (< (first l) smallest-in-rest)
           (first l)
           smallest-in-rest))]))

; Nelon -> Number
; determines the largest number on l
(define (sup l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (local ((define largest-in-rest (sup (rest l))))
       (if (> (first l) largest-in-rest)
           (first l)
           largest-in-rest))]))

(inf '(2 1 3))

(sup '(2 1 3))