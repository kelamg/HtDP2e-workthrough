;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex224) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Space Invaders

(require 2htdp/image)
(require 2htdp/universe)

;; Constants:
;; ==========================

; scenery
(define WIDTH          300)
(define HEIGHT         500)
(define MTS            (empty-scene WIDTH HEIGHT "black"))
(define MSG            "GAME OVER")
(define MSG-COLOR      "red")
(define MSG-SIZE       30)

; tank
(define TANK-GUN       (rectangle 5 10 "solid" "blue"))
(define TANK-BODY      (ellipse 30 15 "solid" "blue"))
(define TANK-WIDTH     (/ (image-width TANK-BODY) 2.25))
(define TANK           (overlay/xy TANK-BODY
                                   TANK-WIDTH -10
                                   TANK-GUN))
(define TANK-HEIGHT    (image-height TANK))
(define TANK-HEIGHT/2  (/ TANK-HEIGHT 2))
(define TANK-Y         (- HEIGHT (/ TANK-HEIGHT 2)))
(define TANK-SPEED     3)

; invader
(define INVADER-INIT-Y      0)
(define INVADER-SPEED  2)
(define INVADER-BODY   (ellipse 25 10 "solid" "red"))
(define INVADER-WIDTH  (/ (image-width INVADER-BODY) 3))
(define INVADER-CANOPY (ellipse 10 20 "outline" "red"))
(define INVADER        (overlay/xy INVADER-BODY
                                   INVADER-WIDTH -12
                                   INVADER-CANOPY))

; missile
(define MISSILE        (ellipse 5 15 "solid" "gray"))
(define MISSILE-SPEED  (* 2 INVADER-SPEED))

; other game constants
(define MAX-INVADERS        10)
(define HIT-RANGE           10)

(define
  INVADER-SPAWN-PROBABILITY 0.01)

;; Definitions:
;; =========================== 

(define-struct sigs [invaders tank missiles])
; A SIGS is a structure:
;   (make-sigs Invaders Tank Missiles)
; interpretation represents the complete state of a
; space invader game

(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick

(define T0 (make-tank (/ WIDTH 2) 1)) ; center going right
(define T1 (make-tank 50  1))         ; going right
(define T2 (make-tank 50 -1))         ; going left
(define T3 (make-tank 0  -1))         ; at left boundary
(define T4 (make-tank WIDTH 1))       ; at right boundary

;; An Invader is a Posn

(define I1 (make-posn 150 100))           ; not landed, moving right
(define I2 (make-posn 150 HEIGHT))        ; exactly landed, moving left
(define I3 (make-posn 150 (+ HEIGHT 10))) ; > landed, moving right
(define I4 (make-posn WIDTH 100))         ; on the right boundary of the scene
(define I5 (make-posn 0 200))             ; on the left boundary of the scene

;; Invaders is one of:
;; - empty
;; - (cons Invader Invaders)
;; interp. a list of invaders

(define LOI1 empty)
(define LOI2 (list I1 I2))
(define LOI3 (list I1 I2 I3))
(define LOI4 (list I1 I4 I5))

;; A Missile is a Posn

(define M1 (make-posn 150 300))                               ; not hit I1
(define M2 (make-posn (posn-x I1) (+ (posn-y I1) HIT-RANGE))) ; exactly hit I1
(define M3 (make-posn  (posn-x I1) (+ (posn-y I1) 5)))        ; > hit I1

;; Missiles is one of:
;; - empty
;; - (cons Missile Missiles)
;; interp. a list of missiles

(define LOM1 empty)
(define LOM2 (list M1 M2))
(define LOM3 (list M1 M2 M3))


(define SIGS0 (make-sigs '() T0 '()))
(define SIGS1 (make-sigs '() T1 '()))
(define SIGS2 (make-sigs (list I1) T1 (list M1)))
(define SIGS3 (make-sigs (list I1 I2) T1 (list M1 M2)))
(define SIGS4 (make-sigs '() T2 '()))
(define SIGS5 (make-sigs (list I1 I3) T1 (list M1 M2)))

#;
(define (fn-for-sigs s)
  (... (fn-for-invaders (sigs-invaders s))
       (fn-for-tank         (sigs-tank s))
       (fn-for-missiles (sigs-missiles s))))

;; Functions:
;; ============================


;; SIGS -> SIGS
;; play the space invaders game! 
;; run with (si-main SIGS0)
(define (si-main s)
  (big-bang s
            [to-draw       si-render]
            [on-tick         si-next]
            [on-key       si-control]
            [stop-when si-game-over? si-render-final]))


;; SIGS -> Image
;; renders all elements of the current game state into MTS
;; this function renders directly into MTS because their will be
;; no additional rendering (like score count, time remaining etc)
(check-expect
 (si-render SIGS0)
 (render-invaders (sigs-invaders SIGS0)
                  (render-tank (sigs-tank SIGS0)
                               (render-missiles (sigs-missiles SIGS0) MTS))))
(check-expect
 (si-render SIGS1)
 (render-invaders (sigs-invaders SIGS1)
                  (render-tank (sigs-tank SIGS1)
                               (render-missiles (sigs-missiles SIGS1) MTS))))

(define (si-render gs)
  (render-invaders (sigs-invaders gs)
                   (render-tank (sigs-tank gs)
                                (render-missiles (sigs-missiles gs) MTS))))

 ;; Tank Image -> Image 
;; adds an image of tank t to img
(check-expect
 (render-tank T0 MTS)
 (place-image TANK (tank-loc T0) TANK-Y MTS))

(define (render-tank t img)
  (place-image TANK (tank-loc t) TANK-Y img))
 
;; Invader Image -> Image 
;; adds an image of an invader i to img
(check-expect
 (render-invader I1 MTS)
 (place-image INVADER (posn-x I1) (posn-y I1) MTS))

(define (render-invader i img)
  (place-image INVADER (posn-x i) (posn-y i) img))

;; Missile Image -> Image 
;; adds an image of missile m to img
(check-expect
 (render-missile M1 MTS)
 (place-image MISSILE (posn-x M1) (posn-y M1) MTS))

(define (render-missile m img)
  (place-image MISSILE (posn-x m) (posn-y m) img))

;; Invaders Image -> Image
;; render a list of invaders into img
(check-expect
 (render-invaders '() MTS) MTS)
(check-expect
 (render-invaders (list I1 I2) MTS)
 (render-invader I1
                 (render-invader I2 MTS)))

(define (render-invaders loi img)
  (cond
    [(empty? loi) img]
    [else (render-invader (first loi)
                          (render-invaders (rest loi) img))]))

;; Missiles Image -> Image
;; render a list of missiles into img
(check-expect
 (render-missiles '() MTS) MTS)
(check-expect
 (render-missiles (list M1 M2) MTS)
 (render-missile M1
                 (render-missile M2 MTS)))

(define (render-missiles lom img)
  (cond
    [(empty? lom) img]
    [else (render-missile (first lom)
                          (render-missiles (rest lom) img))]))


;; Invaders -> Invaders
;; generates a new invader based on current invaders
(define (create-invader loi)
  (create-invader-check
   (make-posn (random WIDTH) INVADER-INIT-Y) loi))
 
;; Invader Invaders -> Invaders 
;; generative recursion 
;; new Invader is generated at random until the currently
;; generated one is not at the same position as the last one
(define (create-invader-check i candidate)
  (if (same-path? i candidate)
      (create-invader candidate)
      (cons i candidate)))

;; Invader Invaders -> Boolean
;; produces true if invader i is too close to any other fiire
(check-expect
 (same-path?
  (make-posn 40 INVADER-INIT-Y)
  (list (make-posn 200 INVADER-INIT-Y)
        (make-posn  80 INVADER-INIT-Y)))
 #f)
(check-expect
 (same-path?
  (make-posn 40 INVADER-INIT-Y)
  (list (make-posn 65 INVADER-INIT-Y)
        (make-posn 40 INVADER-INIT-Y)))
 #t)

(define (same-path? i loi)
  (cond
    [(empty? loi) #f]
    [else
     (or (= (posn-x i) (posn-x (first loi)))
         (same-path? i (rest loi)))]))

;; SIGS -> SIGS
;; the next game state: get the next position of the game objects
(define (si-next gs)
  (make-sigs
   (next-invaders (process-invaders
                   (add-invader (sigs-invaders gs)) (sigs-missiles gs)))
   (next-tank     (sigs-tank gs))
   (next-missiles (process-missiles
                   (sigs-missiles gs) (sigs-invaders gs)))))


;; Invaders -> Invaders
;; produces the next state of the invaders moving on the screen, if any
(check-expect (next-invaders LOI1) LOI1)
(check-expect
 (next-invaders LOI2)
 (list (make-posn (posn-x I1) (+ (posn-y I1) INVADER-SPEED))
       (make-posn (posn-x I2) (+ (posn-y I2) INVADER-SPEED))))

(define (next-invaders loi)
  (cond [(empty? loi) '()]
        [else (cons (make-posn (posn-x (first loi))
                               (+ (posn-y (first loi)) INVADER-SPEED))
                    (next-invaders (rest loi)))]))

;; Invaders -> Invaders
;; randomly spawns invaders based on how many invaders currently exist
(define (add-invader loi)
  (if (should-create? loi)
      (create-invader loi)
      loi))

;; Invaders -> Boolean
;; produces true if length of loi is below MAX-INVADERS
;; and the probability test passes
(define (should-create? loi)
  (and (<= (length loi) MAX-INVADERS)
       (< (/ (random 1000) 1000) INVADER-SPAWN-PROBABILITY)))

 
;; Invaders Missiles -> Invaders
;; processes the game state to remove "hit" invaders
(check-expect (process-invaders empty empty) empty)
(check-expect (process-invaders (list I2) empty) (list I2))
(check-expect (process-invaders empty (list M1)) empty)
(check-expect (process-invaders (list I1 I2 I3) (list M1))    ; no successful missile
              (list I1 I2 I3))
(check-expect (process-invaders (list I2 I3) (list M1 M2))    ; no hit invaders
              (list I2 I3))
(check-expect (process-invaders (list I1 I2 I3) (list M1 M2)) ; a hit invader
              (list I2 I3))
(check-expect (process-invaders (list I1 I2 I3) (list M1 M3)) ; a hit invader
              (list I2 I3)) 

(define (process-invaders loi lom)
  (cond
    [(empty? loi) '()]
    [else
     (if (hit-invader? (first loi) lom)
         (process-invaders (rest loi) lom)
         (cons (first loi) (process-invaders (rest loi) lom)))]))

;; Missiles Invaders -> Missiles
;; processes the game state to remove "successful" missiles
(check-expect (process-missiles empty empty) empty)
(check-expect (process-missiles (list M1) empty) (list M1))
(check-expect (process-missiles empty (list I1)) empty)
(check-expect (process-missiles (list M1) (list I1 I2 I3))    ; no successful missile
              (list M1))
(check-expect (process-missiles (list M1 M2) (list I2 I3))    ; no hit invaders
              (list M1 M2))
(check-expect (process-missiles (list M1 M2) (list I1 I2 I3)) ; a successful missile
              (list M1))
(check-expect (process-missiles (list M1 M3) (list I1 I2 I3)) ; a successful missile
              (list M1)) 

(define (process-missiles lom loi)
  (cond
    [(empty? lom) '()]
    [else
     (if (hit-missile? (first lom) loi)
         (process-missiles (rest lom) loi)
         (cons (first lom) (process-missiles (rest lom) loi)))]))

;; Invader Missiles -> Boolean
;; returns true if an invader has been hit by any of the missiles
(check-expect (hit-invader? I1 (list M1))   false)
(check-expect (hit-invader? I1 (list M1 M3)) true)
(check-expect (hit-invader? I1 (list M1 M2)) true)

(define (hit-invader? i lom)
  (cond
    [(empty? lom) #false]
    [else
     (or (close? i (first lom))
         (hit-invader? i (rest lom)))]))

;; Missile ListOfInvader -> Boolean
;; returns true if a missile has hit any invaders
(check-expect (hit-missile? M1 (list I1 I2))   false)
(check-expect (hit-missile? M2 (list I2 I3))   false)
(check-expect (hit-missile? M2 (list I1 I2 I3)) true)
(check-expect (hit-missile? M3 (list I1 I2 I3)) true)

(define (hit-missile? m loi)
  (cond
    [(empty? loi) #false]
    [else
     (or (close? (first loi) m)
         (hit-missile? m (rest loi)))]))

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

;; Missiles -> Missiles
;; produces the next state of the missiles moving on the screen, if any
(check-expect (next-missiles LOM1) LOM1)
(check-expect
 (next-missiles LOM2)
 (list (make-posn (posn-x M1)
                  (- (posn-y M1) MISSILE-SPEED))
       (make-posn (posn-x M2)
                  (- (posn-y M2) MISSILE-SPEED))))

(define (next-missiles lom)
  (cond [(empty? lom) '()]
        [else
         (cons (make-posn  (posn-x (first lom))
                           (- (posn-y (first lom)) MISSILE-SPEED))
               (next-missiles (rest lom)))]))

;; Tank -> Tank
;; produces the next state of the tank
(check-expect
 (next-tank T0)
 (make-tank (+ (tank-loc T0) (* TANK-SPEED (tank-vel T0))) (tank-vel T0)))
(check-expect
 (next-tank T2)
 (make-tank (+ (tank-loc T2) (* TANK-SPEED (tank-vel T2))) (tank-vel T2)))
(check-expect (next-tank T3) T3)
(check-expect (next-tank T4) T4)

(define (next-tank t)
  (if (not (< 0 (tank-loc t) WIDTH))
      t
      (make-tank
       (+ (tank-loc t) (* TANK-SPEED (tank-vel t))) (tank-vel t))))

;; SIGS KeyEvent -> SIGS
;; advances the state to move the tank
;;          left or right (right and left arrow keys),
;;          or to fire a missile (space key)
(check-expect (si-control SIGS0  "down") SIGS0) ; unresponsive key
(check-expect (si-control SIGS4     "a") SIGS4) ; unresponsive key
(check-expect (si-control SIGS0 "right") SIGS0) ; maintains velocity (right -> right)
(check-expect (si-control SIGS4  "left") SIGS4) ; maintains velocity
(check-expect
 (si-control SIGS4 "right")                     ; changes velocity to opposite direction
 (make-sigs                                     ; (left -> right)
  '()                                           
  (make-tank (+ (tank-loc T2) TANK-SPEED)
             (* (tank-vel T2)        -1))
  '()))
(check-expect
 (si-control SIGS0 "left")                      ; changes velocity to opposite direction
 (make-sigs                                     ; (right -> left)
  '()
  (make-tank (- (tank-loc T0) TANK-SPEED)
             (* (tank-vel T0)        -1))
  '()))
(check-expect
 (si-control SIGS0 " ")
 (make-sigs
  '()
  T0
  (cons (make-posn (tank-loc T0) (- TANK-Y TANK-HEIGHT/2))
        '())))
(check-expect
 (si-control SIGS2 " ")
 (make-sigs
  (sigs-invaders SIGS2)
  T1
  (cons (make-posn (tank-loc T1) (- TANK-Y TANK-HEIGHT/2))
        (sigs-missiles SIGS2))))

(define (si-control gs ke)
  (cond [(and (key=? ke "right")
              (= (tank-vel (sigs-tank gs)) -1))
         (make-sigs (sigs-invaders gs) 
                    (make-tank (+ (tank-loc (sigs-tank gs)) TANK-SPEED)
                               (* (tank-vel (sigs-tank gs)) -1))
                    (sigs-missiles gs))]
        [(and (key=? ke "left")
              (= (tank-vel (sigs-tank gs))  1))
         (make-sigs (sigs-invaders gs) 
                    (make-tank (- (tank-loc (sigs-tank gs)) TANK-SPEED)
                               (* (tank-vel (sigs-tank gs)) -1))
                    (sigs-missiles gs))]
        [(key=? ke " ")
         (make-sigs (sigs-invaders gs)
                    (sigs-tank gs)
                    (cons (make-posn (tank-loc (sigs-tank gs))
                                     (- TANK-Y TANK-HEIGHT/2))
                          (sigs-missiles gs)))]
        [else gs]))


;; SIGS -> Boolean
;; returns true if an invader has landed
(check-expect (si-game-over? SIGS0) false)
(check-expect (si-game-over? SIGS1) false)
(check-expect (si-game-over? SIGS3)  true)
(check-expect (si-game-over? SIGS5)  true)

(define (si-game-over? gs)
  (landed-invader? (sigs-invaders gs)))

;; Invaders -> Boolean
;; produces true if all invaders have not landed (above scene height)
(check-expect (landed-invader? LOI1) false)
(check-expect (landed-invader? LOI2)  true)
(check-expect (landed-invader? LOI3)  true)
(check-expect (landed-invader? LOI4) false)

(define (landed-invader? loi)
  (cond [(empty? loi) #false]
        [else
         (or (landed?         (first loi))
             (landed-invader? (rest  loi)))]))

;; Invader -> Boolean
;; produces true if invader has landed (at or below scene height)
(check-expect (landed? I1) false)
(check-expect (landed? I2)  true)
(check-expect (landed? I3)  true)

(define (landed? invader)
(>= (posn-y invader) HEIGHT))

;; SIGS -> Image
;; renders "Game Over" screen when the game ends
(check-expect
 (si-render-final SIGS3)
 (overlay (text MSG MSG-SIZE MSG-COLOR)
          (si-render SIGS3)))

(define (si-render-final gs)
  (overlay (text MSG MSG-SIZE MSG-COLOR)
           (si-render gs)))
