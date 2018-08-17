;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex59) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume

(define HEIGHT 30)
(define WIDTH 90)
(define SCALE (/ HEIGHT 10))
(define RADIUS (/ HEIGHT SCALE))
(define BG (empty-scene WIDTH HEIGHT))
(define SPACE (rectangle (* SCALE SCALE) SCALE "solid" "white"))

; Mode Color -> Bulb
; A Bulb is one of:
; - outline
; - solid
; interpretation returns a bulb based on the color and mode of
; the bulb
(check-expect (bulb "outline" "red")
              (circle RADIUS "outline" "red"))
(check-expect (bulb "solid" "green")
              (circle RADIUS "solid" "green"))
(define (bulb mode color)
  (circle RADIUS mode color))

; TrafficLight -> TrafficLight
; yields the next state, given current state cs
(check-expect (tl-next "red") "green")
(check-expect (tl-next "yellow") "red")
(check-expect (tl-next "green") "yellow")
(define (tl-next cs)
  (cond
    [(string=? cs "red") "green"]
    [(string=? cs "yellow") "red"]
    [(string=? cs "green") "yellow"]))
 
; TrafficLight -> Image
; renders the current state cs as an image
(check-expect (tl-render "red")
              (place-image (beside (bulb "solid" "red")
                                   SPACE
                                   (bulb "outline" "yellow")
                                   SPACE
                                   (bulb "outline" "green"))
                           45 15
                           BG))
(check-expect (tl-render "yellow")
              (place-image (beside (bulb "outline" "red")
                                   SPACE
                                   (bulb "solid" "yellow")
                                   SPACE
                                   (bulb "outline" "green"))
                           45 15
                           BG))
(define (tl-render cs)
  (place-image
   (beside (if (string=? cs "red")
               (bulb "solid" "red")
               (bulb "outline" "red"))
           SPACE
           (if (string=? cs "yellow")
               (bulb "solid" "yellow")
               (bulb "outline" "yellow"))
           SPACE
           (if (string=? cs "green")
               (bulb "solid" "green")
               (bulb "outline" "green")))
   45 15
   BG))

; TrafficLight -> TrafficLight
; simulates a clock-based American traffic light
(define (traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render]
    [on-tick tl-next 1]))