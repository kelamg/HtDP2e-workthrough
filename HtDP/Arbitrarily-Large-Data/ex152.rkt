;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex152) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

(define IMG (circle 5 "solid" "red"))

;; N Image -> Image
;; produces a vertical arrangement of n copies of img
(check-expect (col 0 IMG) empty-image)
(check-expect (col 2 IMG) (above IMG IMG))
(check-expect (col 5 IMG) (above IMG IMG IMG IMG IMG))

(define (col n img)
  (cond
    [(zero? n) empty-image]
    [else
     (above img
            (col (sub1 n) img))]))

;; N Image -> Image
;; produces a horizontal arrangement of n copies of img
(check-expect (row 0 IMG) empty-image)
(check-expect (row 2 IMG) (beside IMG IMG))
(check-expect (row 5 IMG) (beside IMG IMG IMG IMG IMG))

(define (row n img)
  (cond
    [(zero? n) empty-image]
    [else
     (beside img
             (row (sub1 n) img))]))
