;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex345) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct add [left right])
(define-struct mul [left right])

;; A BSL-expr is one of:
;; - Number
;; - (make-add BSL-expr BSL-expr)
;; - (make-mul BSL-expr BSL-expr)

;; (+ 10 -10)
(make-add 10 -10)

;; (+ (* 20 3) 33)
(make-add (make-mul 20 3) 33)

;; (+ (* 3.14 (* 2 3)) (* 3.14 (* -1 -9)))
(make-add (make-mul 3.14 (make-mul  2  3))
          (make-mul 3.14 (make-mul -1 -9)))


;; (make-add -1 2)
(+ -1 2)

;; (make-add (make-mul -2 -3) 33)
(+ (* -2 -3) 33)

;; (make-mul (make-add 1 (make-mul 2 3)) 3.14)
(* (+ 1 (* 2 3)) 3.14)

