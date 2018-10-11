;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex518) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - Argue that our-cons takes a constant amount of time to compute
;;     its result, regardless of the size of its input.

;; A - Adding 1 to a number is a constant operation and our-cons has
;;     no recursive definitions so it will always compute its result
;;     in constant time.
