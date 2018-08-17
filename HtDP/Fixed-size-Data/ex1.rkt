;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ex1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

(define x 12)
(define y 5)

; Taking x and y as coordinates of a Cartesian point, the distance
; from the origin can be computed as follows:
(sqrt (+ (* x x) (* y y)))