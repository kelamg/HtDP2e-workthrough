;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex265) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

((local ((define (f x) (+ (* 4 (sqr x)) 3))) f) 1)

((lambda (x) (+ (* 4 (sqr x)) 3)) 1)

(+ (* 4 (sqr 1)) 3)

(+ (* 4 1) 3)

(+ 4 3)

7