;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex94) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; space invaders starter

(require 2htdp/image)

; scenery
(define WIDTH  350)
(define HEIGHT 500)
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

(place-image TANK (/ WIDTH 2) TANK-Y
             (place-image UFO (/ WIDTH 2) 50 MTS))
