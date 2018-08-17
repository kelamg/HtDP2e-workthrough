;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex60&61) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; An S-TrafficLight is one of:
; – RED
; – GREEN
; – YELLOW

(define HEIGHT 30)
(define WIDTH 90)
(define SCALE (/ HEIGHT 10))
(define RADIUS (/ HEIGHT SCALE))
(define BG (empty-scene WIDTH HEIGHT))
(define SPACE (rectangle (* SCALE SCALE) SCALE "solid" "white"))

(define RED    "red")
(define GREEN  "green")
(define YELLOW "yellow")

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

; S-TrafficLight -> S-TrafficLight
; yields the next state, given current state cs
(check-expect (tl-next-symbolic RED)    GREEN)
(check-expect (tl-next-symbolic YELLOW)   RED)
(check-expect (tl-next-symbolic GREEN) YELLOW)

#;
(define (tl-next-numeric cs)
  (modulo (+ cs 1) 3))
	
(define (tl-next-symbolic cs)
  (cond
    [(equal? cs RED) GREEN]
    [(equal? cs GREEN) YELLOW]
    [(equal? cs YELLOW) RED]))

 
; S-TrafficLight -> Image
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

; S-TrafficLight -> S-TrafficLight
; simulates a clock-based American traffic light
(define (traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render]
    [on-tick tl-next-symbolic 1]))
