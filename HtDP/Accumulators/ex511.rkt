;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex511) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; binding
;   |  bound
;   |  |
(λ (x) x)

; binding
;   |  free (unbound)
;   |  |
(λ (x) y)

; binding
;   |       bound
;   |         |
(λ (y) (λ (x) y))

; binding    binding
;    |  bound  |  bound
;    |  |      |  |
((λ (x) x) (λ (x) x))

; binding        binding
;    |  bound      |  bound
;    |   | |       |   | |
((λ (x) (x x)) (λ (x) (x x)))

;  binding  binding    binding   binding
;     |      | bound    |  bound   |  bound
;     |      |  |       |  |       |  |
(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w))
