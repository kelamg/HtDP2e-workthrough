;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 114a) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; space invaders

(require 2htdp/image)
(require 2htdp/universe)

;; Constants:
;; ==========================

; scenery
(define WIDTH          200)
(define HEIGHT         200)
(define MTS            (empty-scene WIDTH HEIGHT "black"))
(define SW-WIN-MSG     "YOU WIN!!!")
(define SW-LOSE-MSG    "GAME OVER")
(define SW-MSG-COLOR   "red")
(define SW-MSG-SIZE    30)

; tank
(define GUN           (rectangle 5 10 "solid" "blue"))
(define TANK-BODY     (ellipse 30 15 "solid" "blue"))
(define TANK          (overlay/xy TANK-BODY
                                  (/ (image-width TANK-BODY) 2.25) -10
                                  GUN))
(define TANK-HEIGHT   (image-height TANK))
(define TANK-Y        (- HEIGHT (/ TANK-HEIGHT 2)))
(define TANK-SPEED    2)

; ufo
(define UFO-BODY      (ellipse 25 10 "solid" "red"))
(define CANOPY        (ellipse 10 20 "outline" "red"))
(define UFO           (overlay/xy UFO-BODY
                                  (/ (image-width UFO-BODY) 3) -12
                                  CANOPY))
(define UFO-SPEED     3)

; missile
(define MISSILE       (ellipse 5 15 "solid" "gray"))
(define MISSILE-SPEED (* 2 UFO-SPEED))

; hit range
(define HIT-RANGE     10)

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
(define SIGS4 (make-fired (make-posn 20 HEIGHT)
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

;; SIGS -> Boolean
;; produces true if the UFO lands or if the missile hits the UFO
(check-expect (si-game-over? SIGS1) false)
(check-expect (si-game-over? SIGS2) false)
(check-expect (si-game-over? SIGS3)  true)
(check-expect (si-game-over? SIGS4)  true)

(define (si-game-over? s)
  (cond
    [(aim? s)   (>= (posn-y (aim-ufo s)) HEIGHT)]
    [(fired? s) (or (>= (posn-y (fired-ufo s)) HEIGHT)
                    (close? (fired-ufo s) (fired-missile s)))]))

;; Posn Posn -> False
;; produces true if the Eucledian distance between the two
;; posns is within HIT-RANGE
(check-expect (close? (make-posn 0 4)
                      (make-posn 3 0))    true)
(check-expect (close? (make-posn 0 2)
                      (make-posn 1 0))    true)
(check-expect (close? (make-posn 12 48)
                      (make-posn 34 128)) false)
  
(define (close? a b)
  (<= (distance a b) HIT-RANGE))

;; Posn -> Number
;; calculates the Eucledian distance between two posns
(check-expect (round (distance (make-posn 0 4)
                               (make-posn 3 0))) 5)
(check-expect (round (distance (make-posn 12 48)
                               (make-posn 34 28))) 30)

(define (distance a b)
  (inexact->exact (sqrt (+ (sqr (- (posn-y a) (posn-y b)))
                           (sqr (- (posn-x a) (posn-x b)))))))

;; SIGS -> Image
;; renders "Game Over" or "You Win" when the game ends
(check-expect (si-render-final SIGS4)
              (text SW-LOSE-MSG SW-MSG-SIZE SW-MSG-COLOR))
(check-expect (si-render-final (make-aim (make-posn 20 HEIGHT) (make-tank 28 -3)))
              (text SW-LOSE-MSG SW-MSG-SIZE SW-MSG-COLOR))
(check-expect (si-render-final (make-fired (make-posn 20 100)
                                           (make-tank 100 3)
                                           (make-posn 20 100)))
              (text SW-WIN-MSG SW-MSG-SIZE SW-MSG-COLOR))

(define (si-render-final s)
  (cond
    [(aim? s)   (if (>= (posn-y (aim-ufo s)) HEIGHT)
                    (text SW-LOSE-MSG SW-MSG-SIZE SW-MSG-COLOR)
                    s)]
    [(fired? s) (if (>= (posn-y (fired-ufo s)) HEIGHT)
                    (text SW-LOSE-MSG SW-MSG-SIZE SW-MSG-COLOR)
                    (text SW-WIN-MSG SW-MSG-SIZE SW-MSG-COLOR))]))

;; SIGS -> SIGS
;; the next game state;
;; get the next position of the game objects
;; no tests necessary
(define (si-move s)
  (si-move-proper s (/ (random WIDTH) 3)))
 
;; SIGS Number -> SIGS 
;; produces the next game state with the UFO's x-coordinate
;; placed at x
(check-expect (si-move-proper SIGS1 56)
              (make-aim (make-posn 56 (+ 10 UFO-SPEED)) (make-tank 28 -3)))
(check-expect (si-move-proper SIGS2 120)
              (make-fired (make-posn 120 (+ 10 UFO-SPEED))
                          (make-tank 28 -3)
                          (make-posn 28 (- (- HEIGHT TANK-HEIGHT)
                                           MISSILE-SPEED))))
              
(define (si-move-proper s x)
  (cond
    [(aim? s)   (make-aim (make-posn x (+ (posn-y (aim-ufo s)) UFO-SPEED))
                          (aim-tank s))]
    [(fired? s) (make-fired (make-posn x (+ (posn-y (fired-ufo s)) UFO-SPEED))
                            (fired-tank s)
                            (make-posn (posn-x (fired-missile s))
                                       (- (posn-y (fired-missile s))
                                          MISSILE-SPEED)))]))

;; SIGS KeyEvent -> SIGS
;; left and right arrow keys move the tank
;; spacebar fires a missile
;; no tests necessary
(define (si-control s ke)
  (cond
    [(aim? s)   (aim-control   s ke)]
    [(fired? s) (fired-control s ke)]))

;; SIGS KeyEvent -> SIGS
;; control aim game state
(check-expect (aim-control SIGS1 "left")
              (make-aim (make-posn 20 10) (make-tank (+ 28 (* TANK-SPEED -3)) -3)))
(check-expect (aim-control SIGS1 "right")
              (make-aim (make-posn 20 10) (make-tank (+ 28 (* TANK-SPEED  3))  3)))
(check-expect (aim-control
               (make-aim (make-posn 20 10) (make-tank 28 3)) "left")
              (make-aim (make-posn 20 10) (make-tank (+ 28 (* TANK-SPEED -3)) -3)))
(check-expect (aim-control
               (make-aim (make-posn 20 10) (make-tank 28 3)) "right")
              (make-aim (make-posn 20 10) (make-tank (+ 28 (* TANK-SPEED  3))  3)))
(check-expect (aim-control SIGS1 "up") SIGS1)
(check-expect (aim-control SIGS1 "down") SIGS1)
(check-expect (aim-control SIGS1 " ")
              (make-fired (make-posn 20 10)
                          (make-tank 28 -3)
                          (make-posn 28 (- HEIGHT TANK-HEIGHT))))

(define (aim-control s ke)
  (cond
    [(and
      (string=? ke "left")
      (negative? (tank-vel
                  (aim-tank s)))) (make-aim
                                   (aim-ufo s)
                                   (make-tank (+ (tank-loc (aim-tank s))
                                                 (* (tank-vel (aim-tank s))
                                                    TANK-SPEED))
                                              (tank-vel (aim-tank s))))]
    [(and
      (string=? ke "left")
      (positive? (tank-vel
                  (aim-tank s)))) (make-aim
                                   (aim-ufo s)
                                   (make-tank (- (tank-loc (aim-tank s))
                                                 (* (tank-vel (aim-tank s))
                                                    TANK-SPEED))
                                              (* -1
                                                 (tank-vel (aim-tank s)))))]
    [(and
      (string=? ke "right")
      (negative? (tank-vel
                  (aim-tank s)))) (make-aim
                                   (aim-ufo s)
                                   (make-tank (- (tank-loc (aim-tank s))
                                                 (* (tank-vel (aim-tank s))
                                                    TANK-SPEED))
                                              (* -1
                                                 (tank-vel (aim-tank s)))))]
    [(and
      (string=? ke "right")
      (positive? (tank-vel
                  (aim-tank s)))) (make-aim
                                   (aim-ufo s)
                                   (make-tank (+ (tank-loc (aim-tank s))
                                                 (* (tank-vel (aim-tank s))
                                                    TANK-SPEED))
                                              (tank-vel (aim-tank s))))]
    [(string=? ke " ")            (make-fired
                                   (aim-ufo s)
                                   (aim-tank s)
                                   (make-posn (tank-loc (aim-tank s))
                                              (- HEIGHT TANK-HEIGHT)))]
    [else s]))

;; SIGS KeyEvent -> SIGS
;; control fired game state
(check-expect (fired-control SIGS3 "left")
              (make-fired (make-posn 20 100)
                          (make-tank (+ 100 (* TANK-SPEED -3)) -3)
                          (make-posn 22 103)))
(check-expect (fired-control SIGS3 "right")
              (make-fired (make-posn 20 100)
                          (make-tank (+ 100 (* TANK-SPEED  3))  3)
                          (make-posn 22 103)))
(check-expect (fired-control
               (make-fired (make-posn 20 100)
                           (make-tank 100 -3)
                           (make-posn 22 103)) "left")
              (make-fired (make-posn 20 100)
                          (make-tank (+ 100 (* TANK-SPEED -3)) -3)
                          (make-posn 22 103)))
(check-expect (fired-control
               (make-fired (make-posn 20 100)
                           (make-tank 100 -3)
                           (make-posn 22 103)) "right")
              (make-fired (make-posn 20 100)
                          (make-tank (+ 100 (* TANK-SPEED  3))  3)
                          (make-posn 22 103)))
(check-expect (fired-control SIGS3 "up") SIGS3)
(check-expect (fired-control SIGS3 "down") SIGS3)

(define (fired-control s ke)
  (cond
    [(and
      (string=? ke "left")
      (negative? (tank-vel
                  (fired-tank s)))) (make-fired
                                     (fired-ufo s)
                                     (make-tank (+ (tank-loc (fired-tank s))
                                                   (* (tank-vel (fired-tank s))
                                                      TANK-SPEED))
                                                (tank-vel (fired-tank s)))
                                     (fired-missile s))]
    [(and
      (string=? ke "left")
      (positive? (tank-vel
                  (fired-tank s)))) (make-fired
                                     (fired-ufo s)
                                     (make-tank (- (tank-loc (fired-tank s))
                                                   (* (tank-vel (fired-tank s))
                                                      TANK-SPEED))
                                                (* -1
                                                   (tank-vel (fired-tank s))))
                                     (fired-missile s))]
    [(and
      (string=? ke "right")
      (negative? (tank-vel
                  (fired-tank s)))) (make-fired
                                     (fired-ufo s)
                                     (make-tank (- (tank-loc (fired-tank s))
                                                   (* (tank-vel (fired-tank s))
                                                      TANK-SPEED))
                                                (* -1
                                                   (tank-vel (fired-tank s))))
                                     (fired-missile s))]
    [(and
      (string=? ke "right")
      (positive? (tank-vel
                  (fired-tank s)))) (make-fired
                                     (fired-ufo s)
                                     (make-tank (+ (tank-loc (fired-tank s))
                                                   (* (tank-vel (fired-tank s))
                                                      TANK-SPEED))
                                                (tank-vel (fired-tank s)))
                                     (fired-missile s))]
    [else s]))

;; Any -> Boolean
;; is s a member of SIGS?
(define (is-sigs? s)
  (cond
    [(or (aim? s)
         (fired? s)) #t]
    [else #f]))

;; SIGS -> SIGS
;; play the space invaders game!
(define (si-main s)
  (big-bang s
            [to-draw       si-render]
            [on-tick         si-move]
            [on-key       si-control]
            [check-with     is-sigs?]
            [stop-when si-game-over? si-render-final]))