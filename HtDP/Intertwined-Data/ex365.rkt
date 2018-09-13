;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex365) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An Xexpr.v2 is (cons Symbol Xe-Body)

;; An Xe-Body is one of:
;; - Body
;; - (cons [List-of Atrribute] Body)
;; where Body is short for [List-of Xexpr.v2]

; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

; 1 - <server name="example.org" />
;
; 2 - <carcas>
;         <board> <grass /> <board>
;         <player name="sam" />
;     </carcas>
;
; 3 - <start />

;; Q - Which ones are elements of Xexpr.v0 or Xexpr.v1?

;; A - Only 3 is an element of Xexpr.v0 and Xexpr.v1