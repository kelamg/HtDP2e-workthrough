;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex157) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 220) ; distances in terms of pixels 
(define WIDTH   30)
(define XSHOTS (/ WIDTH 3))
 
; graphical constants 
(define BACKGROUND (empty-scene WIDTH HEIGHT "green"))
(define SHOT (rectangle 6 20 "solid" "black"))

; A List-of-shots is one of: 
; – '()
; – (cons Shot List-of-shots)
; interpretation the collection of shots fired

; A Shot is a Number.
; interpretation represents the shot's y-coordinate

; A ShotWorld is List-of-numbers. 
; interpretation each number on such a list
;   represents the y-coordinate of a shot

(define SW1 (cons 9 '()))
(define SW2 (cons 59 (cons 15 '())))

; ShotWorld -> ShotWorld 
(define (main w0)
  (big-bang w0
    [on-tick tock]
    [on-key keyh]
    [to-draw to-image]))

; ShotWorld -> Image
; adds each shot y on w at (XSHOTS,y} to BACKGROUND
(check-expect (to-image SW1)
              (place-image SHOT XSHOTS 9 BACKGROUND))
(check-expect (to-image SW2)
              (place-image SHOT XSHOTS 59
                           (place-image SHOT XSHOTS 15 BACKGROUND)))

(define (to-image w)
  (cond
    [(empty? w) BACKGROUND]
    [else (place-image SHOT XSHOTS (first w)
                       (to-image (rest w)))]))

; ShotWorld -> ShotWorld
; moves each shot on w up by one pixel
(check-expect (tock SW1) (cons 8 '()))
(check-expect (tock SW2) (cons 58 (cons 14 '())))

(define (tock w)
  (cond
    [(empty? w) '()]
    [else (cons (sub1 (first w)) (tock (rest w)))]))

; ShotWorld KeyEvent -> ShotWorld 
; adds a shot to the world 
; if the player presses the space bar
(check-expect (keyh SW1 " ") (cons HEIGHT SW1))
(check-expect (keyh SW1 "a") SW1)
(check-expect (keyh SW1 "up") SW1)
(check-expect (keyh SW2 " ") (cons HEIGHT SW2))
(check-expect (keyh SW2 "down") SW2)

(define (keyh w ke)
  (if (key=? ke " ") (cons HEIGHT w) w))

;; Yes it is possible to change all those things without changing
;; anything else