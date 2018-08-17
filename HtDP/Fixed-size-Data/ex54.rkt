;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex54) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; An LRCD (for launching rocket countdown) is one of:
; – "resting"
; – a Number between -3 and -1
; – a NonnegativeNumber 
; interpretation a grounded rocket, in countdown mode,
; a number denotes the number of pixels between the
; top of the canvas and the rocket (its height)
 
(define HEIGHT 300) ; distances in pixels 
(define WIDTH  100)
(define YDELTA 3)
(define BACKG  (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))
(define CENTER (/ (image-height ROCKET) 2))

; main
(define (main s)
  (big-bang s
    [on-tick fly]
    [to-draw show]
    [on-key launch]))

; LRCD -> LRCD
; raises the rocket by YDELTA,
;  if it is moving already
(check-expect (fly 14) 11)
(check-expect (fly -2) -2)
(check-expect (fly "resting") "resting")
(define (fly x)
  (cond
    [(number? x) (if (positive? x)
                     (- x YDELTA)
                     x)]
    [else x]))

; LRCD -> Image
; renders the state as a resting or flying rocket
(check-expect
 (show "resting")
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))
(check-expect
 (show -2)
 (place-image (text "-2" 20 "red")
              10 (* 3/4 WIDTH)
              (place-image ROCKET 10 (- HEIGHT CENTER) BACKG)))
(check-expect
 (show 53)
 (place-image ROCKET 10 (- 53 CENTER) BACKG))

(define (show x) empty-image)

(define (launch x ke) x)
