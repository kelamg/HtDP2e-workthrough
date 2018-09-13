;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex371) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An Xexpr is (cons Symbol Xe-Body)

; An XWord is '(word ((text String)))

;; An Xe-Body is one of:
;; - Body
;; - (cons [List-of Atrribute] Body)
;; - XWord
;; where Body is short for [List-of Xexpr]

; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))
