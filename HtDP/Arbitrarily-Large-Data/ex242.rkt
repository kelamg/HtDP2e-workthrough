;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex242) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A [Maybe X] is one of: 
; – #false 
; – X

;; [Maybe String] is either #false or a string

;; [Maybe [List-of-string]] is either #false or a list of strings

;; [List-of [Maybe String]] is a list of either #false or a string

; String [List-of String] -> [Maybe [List-of String]]
; returns the remainder of los starting with s 
; #false otherwise
;
; The signature means that the function accepts two arguments:
;     a String and a list of strings
; and returns:
;     either #false or a list of strings
(check-expect (occurs "a" (list "b" "a" "d" "e"))
              (list "d" "e"))
(check-expect (occurs "a" (list "b" "c" "d")) #f)

(define (occurs s los)
  (cond
    [(empty? los) #f]
    [(string=? s (first los)) (rest los)]
    [else (occurs s (rest los))]))