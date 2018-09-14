;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex382) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; <machine initial="white">
;     <action state="white" next="black" />
;     <action state="black" next="white" />
; </machine>

(define xm0
  '(machine ((initial "white"))
            (action ((state "white") (next "black")))
            (action ((state "black") (next "white")))))
  