;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex38) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; String -> String/1String
; removes the last character from the given string
; given:
;    "axes" for str
; expected:
;    "axe"
(define (string-remove-last str)
  (if (> (string-length str) 0)
      (string-append (substring str 0 (- (string-length str) 1)))
      "supplied an empty string"))

(string-remove-last "axes")

; Testing in BSL
; Number -> Number
; converts Fahrenheit temperatures to Celsius temperatures 
(check-expect (f2c -40) -40)
(check-expect (f2c 32) 0)
(check-expect (f2c 212) 100)
 
(define (f2c f)
  (* 5/9 (- f 32)))

; Design World

; Physical constants
(define WIDTH-OF-WORLD 250)
 
(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))

; Graphical constants
(define WHEEL
  (circle WHEEL-RADIUS "solid" "black"))
(define SPACE
  (rectangle (* WHEEL-RADIUS 2) WHEEL-RADIUS 0 "white"))
(define BOTH-WHEELS
  (beside WHEEL SPACE WHEEL))

(define CAR-BODY
  (above (rectangle (* WHEEL-RADIUS 5)
                    (* WHEEL-RADIUS 1)
                    "solid" "red")
         (rectangle (* WHEEL-RADIUS 10)
                    (* WHEEL-RADIUS 2)
                    "solid" "red")))

(define CAR
  (overlay/offset CAR-BODY
                  0 (* WHEEL-RADIUS 1.5)
                  BOTH-WHEELS))
