;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex97) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; space invaders starter

(require 2htdp/image)

;; Constants:
;; ==========================

; scenery
(define WIDTH  200)
(define HEIGHT 200)
(define MTS    (empty-scene WIDTH HEIGHT "black"))

; tank
(define GUN         (rectangle 5 10 "solid" "blue"))
(define TANK-BODY   (ellipse 30 15 "solid" "blue"))
(define TANK        (overlay/xy TANK-BODY
                                (/ (image-width TANK-BODY) 2.25) -10
                                GUN))
(define TANK-HEIGHT (image-height TANK))
(define TANK-Y      (- HEIGHT (/ TANK-HEIGHT 2)))

; ufo
(define UFO-BODY    (ellipse 25 10 "solid" "red"))
(define CANOPY      (ellipse 10 20 "outline" "red"))
(define UFO         (overlay/xy UFO-BODY
                                (/ (image-width UFO-BODY) 3) -12
                                CANOPY))

; missile
(define MISSILE     (ellipse 5 15 "solid" "gray"))

;; Definitions:
;; ===========================

(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])

; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)
 
(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick 
 
; A Missile is a Posn. 
; interpretation (make-posn x y) is the missile's place

; A SIGS is one of: 
; – (make-aim UFO Tank)
; – (make-fired UFO Tank Missile)
; interpretation represents the complete state of a 
; space invader game

(define SIGS1 (make-aim (make-posn 20 10) (make-tank 28 -3)))
(define SIGS2 (make-fired (make-posn 20 10)
                          (make-tank 28 -3)
                          (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define SIGS3 (make-fired (make-posn 20 100)
                          (make-tank 100 3)
                          (make-posn 22 103)))

#;
(define (fn-for-sigs s)
  (cond
    [(aim? s) (... (aim-tank s) ... (aim-ufo s) ...)]
    [(fired? s) (... (fired-tank s) ... (fired-ufo s)
                 ... (fired-missile s) ...)]))

;; Functions:
;; ============================

; SIGS -> Image
; adds TANK, UFO, and possibly MISSILE to 
; the MTS scene
(check-expect (si-render (make-aim (make-posn 20 10) (make-tank 28 -3)))
              (place-image TANK 28 TANK-Y
                           (place-image UFO 20 10 MTS)))
(check-expect (si-render (make-fired (make-posn 20 10)
                                     (make-tank 28 -3)
                                     (make-posn 28 (- HEIGHT TANK-HEIGHT))))
              (place-image TANK 28 TANK-Y
                           (place-image UFO 20 10
                                        (place-image MISSILE 28
                                                     (- HEIGHT TANK-HEIGHT) MTS))))
(check-expect (si-render (make-fired (make-posn 20 100)
                                     (make-tank 100 3)
                                     (make-posn 22 103)))
              (place-image TANK 100 TANK-Y
                           (place-image UFO 20 100
                                        (place-image MISSILE 22 103 MTS))))

(define (si-render s)
  (cond
    [(aim? s)
     (tank-render (aim-tank s)
                  (ufo-render (aim-ufo s) MTS))]
    [(fired? s)
     (tank-render
       (fired-tank s)
       (ufo-render (fired-ufo s)
                   (missile-render (fired-missile s)
                                   MTS)))]))

; Tank Image -> Image 
; adds t to the given image im
(define (tank-render t im)
  (place-image TANK (tank-loc t) TANK-Y im))
 
; UFO Image -> Image 
; adds u to the given image im
(define (ufo-render u im)
  (place-image UFO (posn-x u) (posn-y u) im))

; Missile Image -> Image 
; adds m to the given image im
(define (missile-render m im)
  (place-image MISSILE (posn-x m) (posn-y m) im))


; Q - Compare this expression:
;       (tank-render
;         (fired-tank s)
;         (ufo-render (fired-ufo s)
;                     (missile-render (fired-missile s)
;                                     BACKGROUND)))
;
;     with this one:
;
;       (ufo-render
;         (fired-ufo s)
;         (tank-render (fired-tank s)
;                      (missile-render (fired-missile s)
;                                      BACKGROUND)))
;
;     When do the two expressions produce the same result? 
;
; A - They always produce the same result as long as they are syntactially
;     correct
;