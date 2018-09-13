;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex370) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

; An XWord is '(word ((text String)))

(define xw1 '(word ((text "Python"))))
(define xw2 '(word ((text "is"))))
(define xw3 '(word ((text "great"))))

;; Any -> Boolean
;; is a in XWord
(check-expect (word? 1)                #false)
(check-expect (word? "ja")             #false)
(check-expect (word? '((initial "X"))) #false)
(check-expect (word? xw1)               #true)
(check-expect (word? xw2)               #true)
(check-expect (word? xw3)               #true)

(define (word? a)
  (match a
    [`(word ((text ,s))) #true]
    [else #false]))

;; XWord -> String
;; extracts the value xw
(check-expect (word-text xw1) "Python")
(check-expect (word-text xw2) "is")
(check-expect (word-text xw3) "great")

(define (word-text xw)
  (second (first (second xw))))