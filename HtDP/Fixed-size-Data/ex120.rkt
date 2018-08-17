;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex120) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(x) ; illegal

(+ 1 (not x)) ; legal expr

(+ 1 2 3) ; legal expr

;; (x) is a function call with no arguments which is illegal in BSL

;; (+ 1 (not x)) is legal because it is a primitive call with two arguments,
;; each of which are valid expressions. It is not semantically legal, but it
;; is syntactically legal

;; (+ 1 2 3) is legal because it is a primitive call on 3 valid arguments (expressions)