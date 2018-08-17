;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex101) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; another data representation

(require 2htdp/image)
(require 2htdp/universe)

;; Constants:
;; ==========================

; scenery
(define WIDTH          200)
(define HEIGHT         200)
(define MTS            (empty-scene WIDTH HEIGHT "black"))
(define SW-WIN-MSG     "YOU WIN!!!")
(define SW-LOSE-MSG    "GAME OVER")
(define SW-MSG-COLOR   "red")
(define SW-MSG-SIZE    30)

; tank
(define GUN           (rectangle 5 10 "solid" "blue"))
(define TANK-BODY     (ellipse 30 15 "solid" "blue"))
(define TANK          (overlay/xy TANK-BODY
                                  (/ (image-width TANK-BODY) 2.25) -10
                                  GUN))
(define TANK-HEIGHT   (image-height TANK))
(define TANK-Y        (- HEIGHT (/ TANK-HEIGHT 2)))
(define TANK-SPEED    2)

; ufo
(define UFO-BODY      (ellipse 25 10 "solid" "red"))
(define CANOPY        (ellipse 10 20 "outline" "red"))
(define UFO           (overlay/xy UFO-BODY
                                  (/ (image-width UFO-BODY) 3) -12
                                  CANOPY))
(define UFO-SPEED     3)

; missile
(define MISSILE       (ellipse 5 15 "solid" "gray"))
(define MISSILE-SPEED (* 2 UFO-SPEED))

; hit range
(define HIT-RANGE     10)

;; Definitions:
;; ===========================

(define-struct sigs [ufo tank missile])
; A SIGS.v2 (short for SIGS version 2) is a structure:
;   (make-sigs UFO Tank MissileOrNot)
; interpretation represents the complete state of a
; space invader game
 
; A MissileOrNot is one of: 
; – #false
; – Posn
; interpretation#false means the missile is in the tank;
; Posn says the missile is at that location

; MissileOrNot Image -> Image 
; adds an image of missile m to scene s
(check-expect (missile-render.v2 false MTS) MTS)
(check-expect (missile-render.v2 (make-posn 150 100) MTS)
              (place-image MISSILE 150 100 MTS))

(define (missile-render.v2 m s)
  s)