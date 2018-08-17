;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex102) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; another data representation

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
(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick 

(define-struct sigs [ufo tank missile])
; A SIGS.v2 (short for SIGS version 2) is a structure:
;   (make-sigs UFO Tank MissileOrNot)
; interpretation represents the complete state of a
; space invader game

 
; A MissileOrNot is one of: 
; – #false
; – Posn
; interpretation#false means the missile is in the tank;
; Posn says the missile is at that location

(define SIGS1 (make-sigs (make-posn 20 10) (make-tank 28 -3) false))
(define SIGS2 (make-sigs (make-posn 20 10)
                         (make-tank 28 -3)
                         (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define SIGS3 (make-sigs (make-posn 20 100)
                         (make-tank 100 3)
                         (make-posn 22 103)))
(define SIGS4 (make-sigs (make-posn 20 HEIGHT)
                         (make-tank 100 3)
                         (make-posn 22 103)))

#;
(define (fn-for-sigs s)
  (... (sigs-ufo s)
       (sigs-tank s)
       (cond
         [(boolean? (sigs-missile s)) ...]
         [(posn? m)
          (... (posn-x (sigs-missile s))
               (posn-y (sigs-missile s)))])))

;; Functions:
;; ============================

; Tank Image -> Image 
; adds an image of tank t to scene s
(define (tank-render t s)
  (place-image TANK (tank-loc t) TANK-Y s))
 
; UFO Image -> Image 
; adds an image of UFO u to scene s
(define (ufo-render u s)
  (place-image UFO (posn-x u) (posn-y u) s))

; MissileOrNot Image -> Image 
; adds an image of missile m to scene s
(check-expect (missile-render false MTS) MTS)
(check-expect (missile-render (make-posn 150 100) MTS)
              (place-image MISSILE 150 100 MTS))

(define (missile-render m s)
  (cond
    [(boolean? m) s]
    [(posn? m)
     (place-image MISSILE (posn-x m) (posn-y m) s)]))

; SIGS -> Image
; adds TANK, UFO, and possibly MISSILE to 
; the MTS scene
(check-expect (si-render SIGS1)
              (place-image TANK 28 TANK-Y
                           (place-image UFO 20 10 MTS)))
(check-expect (si-render SIGS2)
              (place-image TANK 28 TANK-Y
                           (place-image UFO 20 10
                                        (place-image MISSILE 28
                                                     (- HEIGHT TANK-HEIGHT) MTS))))
(check-expect (si-render SIGS3)
              (place-image TANK 100 TANK-Y
                           (place-image UFO 20 100
                                        (place-image MISSILE 22 103 MTS))))

(define (si-render s)
  (tank-render (sigs-tank s)
               (ufo-render (sigs-ufo s)
                           (missile-render (sigs-missile s)
                                           MTS))))

;; SIGS -> Boolean
;; produces true if the UFO lands or if the missile hits the UFO
(check-expect (si-game-over? SIGS1) false)
(check-expect (si-game-over? SIGS2) false)
(check-expect (si-game-over? SIGS3)  true)
(check-expect (si-game-over? SIGS4)  true)

(define (si-game-over? s)
  (if (boolean? (sigs-missile s))
      (>= (posn-y (sigs-ufo s)) HEIGHT)
      (or (>= (posn-y (sigs-ufo s)) HEIGHT)
          (close? (sigs-ufo s) (sigs-missile s)))))

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
(check-expect (si-render-final
               (make-sigs (make-posn 20 HEIGHT) (make-tank 28 -3) false))
              (text SW-LOSE-MSG SW-MSG-SIZE SW-MSG-COLOR))
(check-expect (si-render-final
               (make-sigs (make-posn 20 100)
                          (make-tank 100 3)
                          (make-posn 20 100)))
              (text SW-WIN-MSG SW-MSG-SIZE SW-MSG-COLOR))

(define (si-render-final s)
  (if (boolean? (sigs-missile s))
      (if (>= (posn-y (sigs-ufo s)) HEIGHT)
          (text SW-LOSE-MSG SW-MSG-SIZE SW-MSG-COLOR) s)
      (if (>= (posn-y (sigs-ufo s)) HEIGHT)
          (text SW-LOSE-MSG SW-MSG-SIZE SW-MSG-COLOR)
          (text SW-WIN-MSG SW-MSG-SIZE SW-MSG-COLOR))))

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
              (make-sigs
               (make-posn 56 (+ 10 UFO-SPEED)) (make-tank 28 -3) false))
(check-expect (si-move-proper SIGS2 120)
              (make-sigs (make-posn 120 (+ 10 UFO-SPEED))
                         (make-tank 28 -3)
                         (make-posn 28 (- (- HEIGHT TANK-HEIGHT)
                                          MISSILE-SPEED))))
              
(define (si-move-proper s x)
  (if (boolean? (sigs-missile s))
      (make-sigs (make-posn x (+ (posn-y (sigs-ufo s)) UFO-SPEED))
                 (sigs-tank s)
                 false)
      (make-sigs (make-posn x (+ (posn-y (sigs-ufo s)) UFO-SPEED))
                 (sigs-tank s)
                 (make-posn (posn-x (sigs-missile s))
                            (- (posn-y (sigs-missile s))
                               MISSILE-SPEED)))))

;; SIGS KeyEvent -> SIGS
;; left and right arrow keys move the tank
;; spacebar fires a missile
;; no tests necessary
(define (si-control s ke)
  (if (boolean? (sigs-missile s))
      (aim-control   s ke)
      (sigs-control s ke)))

;; SIGS KeyEvent -> SIGS
;; control game state with no missile
(check-expect (aim-control SIGS1 "left")
              (make-sigs (make-posn 20 10)
                         (make-tank (+ 28 (* TANK-SPEED -3)) -3)
                         false))
(check-expect (aim-control SIGS1 "right")
              (make-sigs (make-posn 20 10)
                         (make-tank (+ 28 (* TANK-SPEED  3))  3)
                         false))
(check-expect (aim-control
               (make-sigs
                (make-posn 20 10) (make-tank 28 3) false) "left")
              (make-sigs (make-posn 20 10)
                         (make-tank (+ 28 (* TANK-SPEED -3)) -3)
                         false))
(check-expect (aim-control
               (make-sigs
                (make-posn 20 10) (make-tank 28 3) false) "right")
              (make-sigs (make-posn 20 10)
                         (make-tank (+ 28 (* TANK-SPEED  3))  3)
                         false))
(check-expect (aim-control SIGS1 "up") SIGS1)
(check-expect (aim-control SIGS1 "down") SIGS1)
(check-expect (aim-control SIGS1 " ")
              (make-sigs (make-posn 20 10)
                         (make-tank 28 -3)
                         (make-posn 28 (- HEIGHT TANK-HEIGHT))))

(define (aim-control s ke)
  (cond
    [(and
      (string=? ke "left")
      (negative? (tank-vel
                  (sigs-tank s)))) (make-sigs
                                    (sigs-ufo s)
                                    (make-tank (+ (tank-loc (sigs-tank s))
                                                  (* (tank-vel (sigs-tank s))
                                                     TANK-SPEED))
                                               (tank-vel (sigs-tank s)))
                                    false)]
    [(and
      (string=? ke "left")
      (positive? (tank-vel
                  (sigs-tank s)))) (make-sigs
                                    (sigs-ufo s)
                                    (make-tank (- (tank-loc (sigs-tank s))
                                                  (* (tank-vel (sigs-tank s))
                                                     TANK-SPEED))
                                               (* -1
                                                  (tank-vel (sigs-tank s))))
                                    false)]
    [(and
      (string=? ke "right")
      (negative? (tank-vel
                  (sigs-tank s)))) (make-sigs
                                    (sigs-ufo s)
                                    (make-tank (- (tank-loc (sigs-tank s))
                                                  (* (tank-vel (sigs-tank s))
                                                     TANK-SPEED))
                                               (* -1
                                                  (tank-vel (sigs-tank s))))
                                    false)]
    [(and
      (string=? ke "right")
      (positive? (tank-vel
                  (sigs-tank s)))) (make-sigs
                                    (sigs-ufo s)
                                    (make-tank (+ (tank-loc (sigs-tank s))
                                                  (* (tank-vel (sigs-tank s))
                                                     TANK-SPEED))
                                               (tank-vel (sigs-tank s)))
                                    false)]
    [(string=? ke " ")             (make-sigs
                                    (sigs-ufo s)
                                    (sigs-tank s)
                                    (make-posn (tank-loc (sigs-tank s))
                                               (- HEIGHT TANK-HEIGHT)))]
    [else s]))

;; SIGS KeyEvent -> SIGS
;; control game state with missile
(check-expect (sigs-control SIGS3 "left")
              (make-sigs (make-posn 20 100)
                         (make-tank (+ 100 (* TANK-SPEED -3)) -3)
                         (make-posn 22 103)))
(check-expect (sigs-control SIGS3 "right")
              (make-sigs (make-posn 20 100)
                         (make-tank (+ 100 (* TANK-SPEED  3))  3)
                         (make-posn 22 103)))
(check-expect (sigs-control
               (make-sigs (make-posn 20 100)
                          (make-tank 100 -3)
                          (make-posn 22 103)) "left")
              (make-sigs (make-posn 20 100)
                         (make-tank (+ 100 (* TANK-SPEED -3)) -3)
                         (make-posn 22 103)))
(check-expect (sigs-control
               (make-sigs (make-posn 20 100)
                          (make-tank 100 -3)
                          (make-posn 22 103)) "right")
              (make-sigs (make-posn 20 100)
                         (make-tank (+ 100 (* TANK-SPEED  3))  3)
                         (make-posn 22 103)))
(check-expect (sigs-control SIGS3 "up") SIGS3)
(check-expect (sigs-control SIGS3 "down") SIGS3)

(define (sigs-control s ke)
  (cond
    [(and
      (string=? ke "left")
      (negative? (tank-vel
                  (sigs-tank s)))) (make-sigs
                                    (sigs-ufo s)
                                    (make-tank (+ (tank-loc (sigs-tank s))
                                                  (* (tank-vel (sigs-tank s))
                                                     TANK-SPEED))
                                               (tank-vel (sigs-tank s)))
                                    (sigs-missile s))]
    [(and
      (string=? ke "left")
      (positive? (tank-vel
                  (sigs-tank s)))) (make-sigs
                                    (sigs-ufo s)
                                    (make-tank (- (tank-loc (sigs-tank s))
                                                  (* (tank-vel (sigs-tank s))
                                                     TANK-SPEED))
                                               (* -1
                                                  (tank-vel (sigs-tank s))))
                                    (sigs-missile s))]
    [(and
      (string=? ke "right")
      (negative? (tank-vel
                  (sigs-tank s)))) (make-sigs
                                    (sigs-ufo s)
                                    (make-tank (- (tank-loc (sigs-tank s))
                                                  (* (tank-vel (sigs-tank s))
                                                     TANK-SPEED))
                                               (* -1
                                                  (tank-vel (sigs-tank s))))
                                    (sigs-missile s))]
    [(and
      (string=? ke "right")
      (positive? (tank-vel
                  (sigs-tank s)))) (make-sigs
                                    (sigs-ufo s)
                                    (make-tank (+ (tank-loc (sigs-tank s))
                                                  (* (tank-vel (sigs-tank s))
                                                     TANK-SPEED))
                                               (tank-vel (sigs-tank s)))
                                    (sigs-missile s))]
    [else s]))

;; SIGS -> SIGS
;; play the space invaders game!
(define (si-main s)
  (big-bang s
            [to-draw       si-render]
            [on-tick         si-move]
            [on-key       si-control]
            [stop-when si-game-over? si-render-final]))