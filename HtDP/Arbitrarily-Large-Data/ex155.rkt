;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex155) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct layer [color doll])
; An RD (short for Russian doll) is one of: 
; – String 
; – (make-layer String RD)

(define RD1 "yellow")
(define RD2 (make-layer "yellow" (make-layer "green" "red")))


; RD -> Number
; how many dolls are part of an-rd
(check-expect (depth RD1) 1)
(check-expect (depth RD2) 3)

(define (depth an-rd)
  (cond
    [(string? an-rd) 1]
    [else (+ (depth (layer-doll an-rd)) 1)]))


;; RD -> String
;; produces the color of the innermost doll
(check-expect (colors RD1) "yellow")
(check-expect (colors RD2) "red")
(check-expect
 (colors
  (make-layer "orange" (make-layer "purple" (make-layer "white" "blue"))))
 "blue")

(define (colors rd)
  (cond
    [(string? rd) rd]
    [else
     (colors (layer-doll rd))]))