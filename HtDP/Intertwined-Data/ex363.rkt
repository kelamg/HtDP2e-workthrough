;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex363) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An Xexpr.v2 is (cons Symbol Xe-Body)

;; An Xe-Body is one of:
;; - Body
;; - (cons [List-of Atrribute] Body)
;; where Body is short for [List-of Xexpr.v2]

; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

