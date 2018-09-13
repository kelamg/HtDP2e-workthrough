;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex364) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An Xexpr.v2 is (cons Symbol Xe-Body)

;; An Xe-Body is one of:
;; - Body
;; - (cons [List-of Atrribute] Body)
;; where Body is short for [List-of Xexpr.v2]

; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

(define x1 '(transition ((from "seen-e") (to "seen-f"))))
(define x2 '(ul (li (word) (word)) (li (word))))

;; Q - Which one could be represented in Xexpr.v0 or Xexpr.v1?

;; A - None of the examples can be represented in Xexpr.v0 as both
;;     have sub-elements which Xexpr.v0 does not define.
;;     x2 can be represented in Xexpr.v1 however, as it does define
;;     sub-elements, but it cannot be used for x1 as it does not
;;     define attributes
