;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex42&43&44) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; A WorldState is a Number.
; the number of pixels between the left border of the scene
; and the right-most edge of the car.

(define WIDTH-OF-WORLD 250)
(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))
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
(define BACKGROUND
  (empty-scene WIDTH-OF-WORLD
               (* WHEEL-RADIUS 20)))
(define Y-CAR (- (* WHEEL-RADIUS 5) WHEEL-RADIUS))

; An AnimationState is a Number.
; the number of clock ticks since the animation started

; AnimationState -> AnimationState
; returns the next animation state
(check-expect (tock 20) 23)
(check-expect (tock 78) 81)
(define (tock as)
  (+ as 3))

; AnimationState -> Image
; returns the image of the background with the car in it
; to be rendered accordingly
;(check-expect (render 20)
;              (place-image CAR 20 Y-CAR BACKGROUND))
;(check-expect (render 150)
;              (place-image CAR 150 Y-CAR BACKGROUND))
(define (render as)
  (place-image CAR as (+ (* WHEEL-RADIUS 10)
                         (* WHEEL-RADIUS (sin (* as 2))
                            5))
               BACKGROUND))

; AnimationState -> Boolean
; ends the program when the car leaves the right edge.
(check-expect (end? 100) #false)
(check-expect (end? (+ WIDTH-OF-WORLD (image-width CAR))) #false)
(check-expect (end? (+ 1 (+ WIDTH-OF-WORLD (image-width CAR)))) #true)
(define (end? as)
  (> as (+ WIDTH-OF-WORLD (image-width CAR))))

; WorldState Number Number String -> WorldState
; places the car at x-mouse
; if the given me is "button-down"
;   given: 21 10 20 "enter"
;   expected: 21
;   given: 42 10 20 "button-down"
;   expected 10
;   given: 42 10 20 "move"
;   expected: 42
(check-expect (hyper 21 10 20 "enter") 21)
(check-expect (hyper 42 10 20 "button-down") 10)
(check-expect (hyper 42 10 20 "move") 42)
(define (hyper x-pos-of-car x-mouse y-mouse me)
  (cond
    [(string=? "button-down" me) x-mouse]
    [else x-pos-of-car]))

;(define (hyper-test x-pos x-mouse y-mouse me)
;  x-pos)
;(check-expect (hyper-test 21 10 20 "enter") 21)
;(check-expect (hyper-test 42 10 20 "button-down") 10)
;(check-expect (hyper-test 42 10 20 "move") 42)

(define (main as)
  (big-bang as
    [to-draw render]
    [on-tick tock]
    [on-mouse hyper]
    [stop-when end?]))
