;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex95) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; Q - Explain why the three instances are generated according to
;;     the first or second clause of the data definition.
;;
;; A - The data definition describes an itemisation of structure
;;     instances, both of which represent the two possible states
;;     of the game: when the missile does not yet exist, and
;;                  when it does exist in the game state.
;;     Both states are mutually exclusive; a missile cannot exist
;;     and not exist at the same time, so the data definition
;;     reflects this. 

