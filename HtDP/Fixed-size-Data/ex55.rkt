;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex55) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 200) ; distances in pixels 
(define WIDTH  100)
(define YDELTA 3)
(define BACKG  (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))
(define CENTER (/ (image-height ROCKET) 2))


(define (to-show what where in)
  (place-image what 10 where in))

(check-expect (show HEIGHT)
              (to-show ROCKET (- HEIGHT CENTER) BACKG))
(check-expect (show 53)
              (to-show ROCKET (- 53 CENTER) BACKG))
(check-expect (show 0)
              (to-show ROCKET (- 0 CENTER) BACKG))
(define (show x)
  (cond
    [(string? x)
     (to-show ROCKET (- HEIGHT CENTER) BACKG)]
    [(<= -3 x -1)
     (to-show (text (number->string x) 20 "red")
              (* 3/4 WIDTH)
              (to-show ROCKET (- HEIGHT CENTER) BACKG))]
    [(>= x 0)
     (to-show ROCKET (- x CENTER) BACKG)]))
 
; LRCD KeyEvent -> LRCD
; starts the countdown when space bar is pressed, 
; if the rocket is still resting
(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)
(define (launch x ke)
  (cond
    [(string? x) (if (string=? " " ke) -3 x)]
    [(<= -3 x -1) x]
    [(>= x 0) x]))

; LRCD -> LRCD
; raises the rocket by YDELTA if it is moving already 
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) HEIGHT)
(check-expect (fly 10) (- 10 YDELTA))
(check-expect (fly 22) (- 22 YDELTA))
(define (fly x)
  (cond
    [(string? x) x]
    [(<= -3 x -1) (if (= x -1) HEIGHT (+ x 1))]
    [(>= x 0) (- x YDELTA)]))

; main
(define (main s)
  (big-bang s
    [on-tick fly]
    [to-draw show]
    [on-key launch]))