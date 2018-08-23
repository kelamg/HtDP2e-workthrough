;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex240) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An LStr is one of: 
; – String
; – (make-layer LStr)

; An LNum is one of: 
; – Number
; – (make-layer LNum)

(define-struct layer [stuff])

(make-layer "chad")
(make-layer
 (make-layer
  (make-layer "chad")))

;; A [Layer STUFF] is one of:
;; - STUFF
;; - (make-layer [Layer STUFF])

;; A [Layer String] is one of:
;; - String
;; - (make-layer [Layer String])

;; A [Layer Number] is one of:
;; - String
;; - (make-laer [Layer Number])
