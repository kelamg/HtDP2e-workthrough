;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex50&51&52) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; TrafficLight -> TrafficLight
;; yields the next state given current state s
;(check-expect (traffic-light-next "red") "green")
;(check-expect (traffic-light-next "green") "yellow")
;(check-expect (traffic-light-next "yellow") "red")
;(define (traffic-light-next s)
;  (cond
;    [(string=? "red" s) "green"]
;    [(string=? "green" s) "yellow"]
;    [(string=? "yellow" s) "red"]))

; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume

(define WIDTH 100)
(define HEIGHT 100)
(define HALF-WIDTH (/ WIDTH 2))
(define HALF-HEIGHT (/ HEIGHT 2))
(define RADIUS 20)
(define BACKGROUND (empty-scene WIDTH HEIGHT))

; TrafficLight -> TrafficLight
; changes the traffic light color state on every
; clock tick
(check-expect (tock "red") "green")
(check-expect (tock "green") "yellow")
(check-expect (tock "yellow") "red")
(define (tock ts)
  (traffic-light-next ts))

; TrafficLight -> Image
; renders the state of a traffic light as a solid
; circle
(check-expect (render "red")
              (place-image (circle RADIUS "solid" "red")
                           HALF-WIDTH HALF-HEIGHT BACKGROUND))
(check-expect (render "green")
              (place-image (circle RADIUS "solid" "green")
                           HALF-WIDTH HALF-HEIGHT BACKGROUND))
(check-expect (render "yellow")
              (place-image (circle RADIUS "solid" "yellow")
                           HALF-WIDTH HALF-HEIGHT BACKGROUND))
(define (render ts)
  (place-image (circle RADIUS "solid" ts)
               HALF-WIDTH HALF-HEIGHT BACKGROUND))

; TrafficLight -> TrafficLight
; yields the next state given current state s
(check-expect (traffic-light-next "red") "green")
(check-expect (traffic-light-next "green") "yellow")
(check-expect (traffic-light-next "yellow") "red")
(define (traffic-light-next s)
  (cond
    [(string=? "red" s) "green"]
    [(string=? "green" s) "yellow"]
    [(string=? "yellow" s) "red"]))

(define (main ts)
  (big-bang ts
    [to-draw render]
    [on-tick tock]))

