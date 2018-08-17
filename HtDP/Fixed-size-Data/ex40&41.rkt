;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex40&41) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

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

(define BACKGROUND
  (empty-scene WIDTH-OF-WORLD
               (* WHEEL-RADIUS 6)))
(define Y-CAR (- (* WHEEL-RADIUS 5) WHEEL-RADIUS))
(define tree
  (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))

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


; Properties that change the state of the world

; A WorldState is a Number.
; the number of pixels between the left border of
; the scene and the car.

; WorldState -> Image
; (big-bang evaluates render to obtain the image of the
; current state of the world)
;
; places the image of the car into the BACKGROUND scene,
; according to the given world state
(check-expect (render 20)
              (place-image CAR 20 Y-CAR BACKGROUND))
(check-expect (render 150)
              (place-image CAR 150 Y-CAR BACKGROUND))
(define (render ws)
  (place-images (list CAR
                      tree)
                (list (make-posn ws Y-CAR)
                      (make-posn (+ (/ WIDTH-OF-WORLD 2) 50)
                                 (image-height CAR)))
                BACKGROUND))

; WorldState -> WorldState
; for each tick of the clock, big-bang obtains the
; the next state of the world
;
; moves the car by 3 pixels for every clock tick
;  given: 20, expect 23
;  given: 78, expect 81
(check-expect (clock-tick-handler 20) 23)
(check-expect (clock-tick-handler 78) 81)

(define (clock-tick-handler ws)
  (+ ws 3))

; WorldState String -> WorldState
; for each keystroke, big-bang obtains the next state
; ke represents the key
(define (keystroke-handler cw ke)
  ...)

; WorldState -> Boolean
; after each event, big-bang evaluates end?
;
; when the car has completely disappeared from the scene,
; stop the animation.
;   given: 251, expect: #false
;   given: 300, expect: #true
(check-expect (end? 251) #false)
(check-expect (end? 320) #true)
(define (end? cw)
  (> cw (+ WIDTH-OF-WORLD (image-width CAR))))

; WorldState -> WorldState
; launches the program from some initial state
(define (main ws)
  (big-bang ws
    [on-tick clock-tick-handler]
    [to-draw render]
    [stop-when end?]))