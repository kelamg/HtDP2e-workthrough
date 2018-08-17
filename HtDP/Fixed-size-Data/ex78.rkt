;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex78) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; yet more data universe

(define-struct 3word (first second third))
;; A 3Word is a structure:
;;   (make-3word 1String/false 1String/false 1String/false)
;; interp. a three-letter word, which consists of lowercase
;;         letters represented with 1Strings, "a" through "z"
;;         or #false if no letter fills that position