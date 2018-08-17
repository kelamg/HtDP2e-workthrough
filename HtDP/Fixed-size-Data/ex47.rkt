;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex47) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

(define WIDTH 50)
(define HEIGHT 100)
(define HALF-HEIGHT (/ HEIGHT 2))
(define RATE 0.1)
(define MIN-HAP-SCORE 0)
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define GUAGE-HEIGHT (- HEIGHT HALF-HEIGHT))

; A HappinessState is a Number.
; it is the maximum level of happiness.

; HappinessState -> HappinessState
; with each clock tick, happiness decreases by -0.1
(check-expect (tock 2) 1.9)
(check-expect (tock 13.5) 13.4)
(check-expect (tock 0) 0)
(define (tock hs)
  (if (= hs MIN-HAP-SCORE)
      MIN-HAP-SCORE
      (- hs RATE)))

; HappinessState -> Image
; renders a guage showing the happiness guage
(check-expect (render 100)
              (place-image (frame (rectangle 100 GUAGE-HEIGHT
                                             "solid" "red"))
                           0 HALF-HEIGHT BACKGROUND))
(check-expect (render 0)
              (place-image (frame (rectangle 0 GUAGE-HEIGHT
                                             "solid" "red"))
                           0 HALF-HEIGHT BACKGROUND))
(define (render hs)
  (place-image (frame (rectangle hs GUAGE-HEIGHT
                                "solid" "red"))
               0 HALF-HEIGHT BACKGROUND))

; HappinessState String -> HappinessState
; when the down arrow key is pressed, happiness increases
; by 1/5 but if the up arrow key is pressed, happiness
; increases by 1/3.
(check-expect (key-handler 5 "down") 5.2)
(check-expect (key-handler 5 "up") 5.3)
(check-expect (key-handler 100 "right") 100)
(define (key-handler hs ke)
  (cond
    [(key=? ke "down") (+ hs 0.2)]
    [(key=? ke "up") (+ hs 0.3)]
    [else hs]))

(define (guage-prog hs)
  (big-bang hs
    [to-draw render]
    [on-tick tock]
    [on-key key-handler]))