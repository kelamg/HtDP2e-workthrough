;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex96) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; space invaders starter

(require 2htdp/image)

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
(define TANK-HEIGHT (/ (image-height TANK) 2))
(define TANK-Y      (- HEIGHT TANK-HEIGHT))

; ufo
(define UFO-BODY    (ellipse 25 10 "solid" "red"))
(define CANOPY      (ellipse 10 20 "outline" "red"))
(define UFO         (overlay/xy UFO-BODY
                                (/ (image-width UFO-BODY) 3) -12
                                CANOPY))

; missile
(define MISSILE     (ellipse 5 15 "solid" "gray"))

; Game state one: Missile not yet fired
(place-image TANK (/ WIDTH 2) TANK-Y
             (place-image UFO (/ WIDTH 2) 30 MTS))

; Game state two: Missile fired, but not at all close to the UFO
(place-image TANK (/ WIDTH 2) TANK-Y
             (place-image UFO (/ WIDTH 2) 30
                          (place-image MISSILE 100 100 MTS)))

; Game state two: Missile about to collide with UFO
(place-image TANK (/ WIDTH 2) TANK-Y
             (place-image UFO (/ WIDTH 2) 30
                          (place-image MISSILE 100 50 MTS)))
