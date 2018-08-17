;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex36) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; Image -> Number
; counts the number of pixels in a given image
; given:
;    (rectangle 20 40 "solid" "magenta") for img
; expected:
;    800  
(define (image-area img)
  (* (image-height img) (image-width img)))

(image-area (rectangle 20 40 "solid" "magenta"))