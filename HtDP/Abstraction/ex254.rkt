;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex254) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [List-of Number] [Number Number -> Boolean] -> [List-of Number]
(define (sort-n lon fn) lon)

;; [List-of String] [String String -> Boolean] -> [List-of String]
(define (sort-s los fn) los)

;; [List-of X] [X X -> Y] -> [List-of X]
(define (abstract l b fn) l)

;; [List-of IR] [IR IR -> Boolean] -> [List-of IR]