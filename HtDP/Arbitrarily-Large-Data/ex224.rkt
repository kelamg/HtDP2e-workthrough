;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex224) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Space Invaders

(require 2htdp/image)
(require 2htdp/universe)

;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)
(define EPSILON  0.1)

(define INVADE-RATE 100)
(define SPAWN-PROBABILITY 0.01)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))

(define TANK-Y-POSITION (- HEIGHT TANK-HEIGHT/2))



;; Data Definitions:

(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50  1))            ;going right
(define T2 (make-tank 50 -1))           ;going left
(define T3 (make-tank 0  -1))           ;at left boundary
(define T4 (make-tank WIDTH 1))         ;at right boundary

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick;
;;                       positive dx denotes movement to the right
;;                       negative dx denotes movement to the left

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right
(define I4 (make-invader WIDTH 100 12))         ;on the right boundary of the scene
(define I5 (make-invader 0 200 -12))            ;on the left boundary of the scene


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))


;; ListOfInvader is one of:
;;  - empty
;;  - (cons Invader ListOfInvader)
;; interp. a list of invaders

(define LOI1 empty)
(define LOI2 (list I1 I2))
(define LOI3 (list I1 I2 I3))
(define LOI4 (list I1 I4 I5))

#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else
         (... (fn-for-invader (first loi))
              (fn-for-loi     (rest  loi)))]))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                               ;not hit I1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit I1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit I1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))

;; ListOfMissile is one of:
;;  - empty
;;  - (cons Missile ListOfMissile)
;; interp. a list of missiles

(define LOM1 empty)
(define LOM2 (list M1 M2))
(define LOM3 (list M1 M2 M3))

#;
(define (fn-for-lom lom)
  (cond [(empty? lom) (...)]
        [else
         (... (fn-for-missile (first lom))
              (fn-for-lom     (rest  lom)))]))



(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))
(define G4 (make-game empty empty T2))
(define G5 (make-game (list I1 I3) (list M1 M2) T1))


;; Space Invaders game
;; run with (main G0)
;; no tests for main function
(define (main gs)
  (big-bang gs
            (on-tick    next-game-state)   ; GameState -> GameState
            (to-draw  render-game-state)   ; GameState -> Image
            (on-key         tank-action)   ; GameState KeyEvent -> GameState
            (stop-when       game-over?))) ; GameState -> Boolean

;; GameState -> GameState
;; advances time to get the next state of the game
;; based on randomness, therefore no tests since helpers have been thoroughly tested                                           
              
; (define (next-game-state gs) gs) ; stub

; <template from Game>

(define (next-game-state gs)
  (make-game (next-invaders (process-invaders (add-invader (game-invaders gs)) (game-missiles gs)))
             (next-missiles (process-missiles (game-missiles gs) (game-invaders gs)))
             (next-tank     (game-tank gs))))


;; ListOfInvader ListOfMissile -> ListOfInvader
;; processes the game state to remove "hit" invaders
(check-expect (process-invaders empty empty) empty)
(check-expect (process-invaders (list I2) empty) (list I2))
(check-expect (process-invaders empty (list M1)) empty)
(check-expect (process-invaders (list I1 I2 I3) (list M1))      ; no successful missile
              (list I1 I2 I3))
(check-expect (process-invaders (list I2 I3) (list M1 M2))      ; no hit invaders
              (list I2 I3))
(check-expect (process-invaders (list I1 I2 I3) (list M1 M2))   ; a hit invader
              (list I2 I3))
(check-expect (process-invaders (list I1 I2 I3) (list M1 M3))   ; a hit invader
              (list I2 I3)) 

; (define (process-invaders loi lom) loi) ; stub

; <template from 2 one-of>

(define (process-invaders loi lom)
  (cond [(empty? loi) loi]
        [(empty? lom) loi]
        [else
         (if (hit-invader? (first loi) lom)
             (process-invaders (rest loi) lom)
             (cons (first loi) (process-invaders (rest loi) lom)))]))

;; ListOfMissile ListOfInvader -> ListOfMissile
;; processes the game state to remove "successful" missiles
(check-expect (process-missiles empty empty) empty)
(check-expect (process-missiles (list M1) empty) (list M1))
(check-expect (process-missiles empty (list I1)) empty)
(check-expect (process-missiles (list M1) (list I1 I2 I3))      ; no successful missile
              (list M1))
(check-expect (process-missiles (list M1 M2) (list I2 I3))      ; no hit invaders
              (list M1 M2))
(check-expect (process-missiles (list M1 M2) (list I1 I2 I3))   ; a successful missile
              (list M1))
(check-expect (process-missiles (list M1 M3) (list I1 I2 I3))   ; a successful missile
              (list M1)) 

; (define (process-missiles lom loi) loi) ; stub

; <template from 2 one-of>

(define (process-missiles lom loi)
  (cond [(empty? lom) lom]
        [(empty? loi) lom]
        [else
         (if (hit-missile? (first lom) loi)
             (process-missiles (rest lom) loi)
             (cons (first lom) (process-missiles (rest lom) loi)))]))

;; Invader ListOfMissile -> Boolean
;; returns true if an invader has been hit by any of the missiles
(check-expect (hit-invader? I1 (list M1))   false)
(check-expect (hit-invader? I1 (list M1 M3)) true)
(check-expect (hit-invader? I1 (list M1 M2)) true)

; (define (hit-invader? i lom) false) ; stub

(define (hit-invader? i lom)
  (cond [(empty? lom) false]
        [else
         (or (hit? (distance i (first lom)))
             (hit-invader? i (rest lom)))]))

;; Missile ListOfInvader -> Boolean
;; returns true if a missile has hit any invaders
(check-expect (hit-missile? M1 (list I1 I2))   false)
(check-expect (hit-missile? M2 (list I2 I3))   false)
(check-expect (hit-missile? M2 (list I1 I2 I3)) true)
(check-expect (hit-missile? M3 (list I1 I2 I3)) true)

; (define (hit-missile? m loi) false) ; stub

(define (hit-missile? m loi)
  (cond [(empty? loi) false]
        [else
         (or (hit? (distance (first loi) m))
             (hit-missile? m (rest loi)))]))

;; Number -> Boolean
;; returns true if n is less than or equal to HIT-RANGE
(check-expect (hit? 9.9)  true)
(check-expect (hit?  10)  true)
(check-expect (hit?  11) false)

; (define (hit? n) false) ; stub

(define (hit? n)
  (<= n HIT-RANGE))

;; Invader Missile -> Number
;; calculates the distance between an invader and a missile using the distance formula
(check-within (distance I1 M1) (sqrt (+ (sqr 0) (sqr 200))) EPSILON)
(check-within (distance (make-invader 20 285 1.5) (make-missile 124 198))
              (sqrt (+ (sqr (- 124 20)) (sqr (- 198 285))))
              EPSILON)

; (define (distance i m) 0) ; stub

(define (distance i m)
  (sqrt (+ (sqr (- (missile-x m) (invader-x i)))
           (sqr (- (missile-y m) (invader-y i))))))

;; Tank -> Tank
;; produces the next state of the tank
(check-expect (next-tank T0) (make-tank (+ (tank-x T0) (* TANK-SPEED (tank-dir T0))) (tank-dir T0)))
(check-expect (next-tank T2) (make-tank (+ (tank-x T2) (* TANK-SPEED (tank-dir T2))) (tank-dir T2)))
(check-expect (next-tank T3) T3)
(check-expect (next-tank T4) T4)

; (define (next-tank t) t) ; stub

; <template from Tank>

(define (next-tank t)
  (if (stop-tank? t)
      t
      (make-tank (+ (tank-x t) (* TANK-SPEED (tank-dir t))) (tank-dir t))))

;; Tank -> Boolean
;; returns true if the tank is outside the boundaries of the scene
(check-expect (stop-tank? T1) false)
(check-expect (stop-tank? T3)  true)
(check-expect (stop-tank? T4)  true)
              
; (define (stop-tank? t) false) ; stub

; <template from Tank>

(define (stop-tank? t)
  (not (< 0 (tank-x t) WIDTH)))

;; ListOfInvader -> ListOfInvader
;; produces the next state of the invaders moving on the screen, if any
(check-expect (next-invaders LOI1) LOI1)
(check-expect (next-invaders LOI2) (list (make-invader (+ (invader-x I1) (invader-dx I1))
                                                       (+ (invader-y I1) INVADER-Y-SPEED)
                                                       (invader-dx I1))
                                         (make-invader (+ (invader-x I2) (invader-dx I2))
                                                       (+ (invader-y I2) INVADER-Y-SPEED)
                                                       (invader-dx I2))))

; (define (next-invaders loi) loi) ; stub

; <template from ListOfInvader>

(define (next-invaders loi)
  (cond [(empty? loi) loi]
        [else
         (cons (bounced-invader (first loi))
               (next-invaders   (rest loi)))]))

;; ListOfInvader -> ListOfInvader
;; adds a new invader to the passed-in loi at random, and with a random x position
;; no tests for random function

; (define (add-invader loi) loi) ; stub

(define (add-invader loi)
  (if (add? INVADE-RATE)
      (cons (create-randomly-placed-invader 0 INVADER-X-SPEED) loi)
      loi))

;; Integer Number -> Invader
;; makes a new invader with the given y position, width is random
(check-random (create-randomly-placed-invader 0 12)
              (make-invader (random WIDTH) 0 12))

; (define (create-randomly-placed-invader y dx) empty) ; stub

(define (create-randomly-placed-invader y dx)
  (make-invader (random WIDTH) y dx))


;; Integer -> Boolean
;; produces true if a random number in [0, n) is less than INVADER-RATE / 4
(check-random (add? INVADE-RATE) (is-less? (random INVADE-RATE)))

; (define (add? n) false) ; stub

(define (add? n)
  (is-less? (random n)))

;; Integer -> Boolean
;; returns true if the passed-in number is less than (/ INVADE-RATE 4)
(check-expect (is-less? (* SPAWN-PROBABILITY INVADE-RATE)) #t)
(check-expect (is-less? 11) #f)
(check-expect (is-less? 25) #f)

; (define (is-less? i) false) ; stub

(define (is-less? i)
  (<= i (* SPAWN-PROBABILITY INVADE-RATE)))

;; Invader -> Invader
;; produces a new invader moving in the opposite direction if right-bound?
;; or left-bound? returns true
(check-expect (bounced-invader I1) (make-invader (+ 150 12) (+ 100 INVADER-Y-SPEED) 12))
(check-expect (bounced-invader I4) (make-invader (- WIDTH 12) (+ 100 INVADER-Y-SPEED) -12))
(check-expect (bounced-invader I5) (make-invader (+ 0 12) (+ 200 INVADER-Y-SPEED) 12))

; (define (bounced-invader invader) invader) ; stub

; <template from Invader>

(define (bounced-invader invader)
  (cond [(or (left-bound? invader) (right-bound? invader))
         (make-invader (+ (invader-x invader) (- (invader-dx invader)))
                       (+ (invader-y invader) INVADER-Y-SPEED)
                       (- (invader-dx invader)))]
        [else
         (make-invader (+ (invader-x invader) (invader-dx invader))
                       (+ (invader-y invader) INVADER-Y-SPEED)
                       (invader-dx invader))]))

;; Invader -> Boolean
;; returns true if invader is on or outside of the scene's right boundary
(check-expect (right-bound? I1) false)
(check-expect (right-bound? I4) true)

; (define (right-bound? invader) false) ; stub

; <template from Invader>

(define (right-bound? invader)
  (>= (invader-x invader) WIDTH))

;; Invader -> Boolean
;; returns true if invader is on or outside of the scene's left boundary
(check-expect (left-bound? I1) false)
(check-expect (left-bound? I5) true)

; (define (left-bound? invader) false) ; stub

; <template from Invader>

(define (left-bound? invader)
  (<= (invader-x invader) 0))


;; ListOfMissile -> ListOfMissile
;; produces the next state of the missiles moving on the screen, if any
(check-expect (next-missiles LOM1) LOM1)
(check-expect (next-missiles LOM2) (list (make-missile (missile-x M1)
                                                       (- (missile-y M1) MISSILE-SPEED))
                                         (make-missile (missile-x M2)
                                                       (- (missile-y M2) MISSILE-SPEED))))

; (define (next-missiles loi) loi) ; stub

; <template from ListOfMissile>

(define (next-missiles lom)
  (cond [(empty? lom) lom]
        [else
         (cons (make-missile  (missile-x (first lom))
                              (- (missile-y (first lom)) MISSILE-SPEED))
               (next-missiles (rest lom)))]))


;; GameState -> Image
;; draws all elements of the current game state into an image
(check-expect (render-game-state G3)
              (game-state-render-into-image (game-invaders G3)
                                            (game-missiles G3)
                                            (game-tank     G3)
                                                   BACKGROUND))

; (define (render-game-state gs) BACKGROUND) ; stub

; <template from Game with added param>

(define (render-game-state s)
  (game-state-render-into-image (game-invaders s)
                                (game-missiles s)
                                (game-tank     s)
                                      BACKGROUND))



;; ListOfInvader ListOfMissile Tank Image -> Image
;; renders a list of invaders, missiles and tanks into a given image
(check-expect (game-state-render-into-image LOI3 LOM3 T1 BACKGROUND)
              (render-loi-into-image LOI3
                                     (render-lom-into-image LOM3
                                                            (render-tank-into-image T1 BACKGROUND))))

; (define (game-state-render-into-image loi lom t img) BACKGROUND) ; stub

(define (game-state-render-into-image loi lom t img)
  (cond [(and (empty? loi) (empty? lom) (empty? t)) BACKGROUND]
        [else
         (render-loi-into-image loi
                                (render-lom-into-image lom
                                                       (render-tank-into-image t img)))]))

;; ListOfInvader Image -> Image
;; renders a list of invaders into an image
(check-expect (render-loi-into-image LOI3 BACKGROUND)
              (place-image INVADER (invader-x I1) (invader-y I1)
                           (place-image INVADER (invader-x I2) (invader-y I2)
                                        (place-image INVADER (invader-x I3) (invader-y I3) BACKGROUND))))

; (define (render-loi-into-image loi img) img) ; stub

; <template from ListOfInvader>

(define (render-loi-into-image loi img)
  (cond [(empty? loi) img]
        [else
         (render-invader-into-image (first loi)
                                    (render-loi-into-image (rest loi) img))]))

;; Invader Image -> Image
;; renders an invader into an image
(check-expect (render-invader-into-image I1 BACKGROUND)
              (place-image INVADER (invader-x I1) (invader-y I1) BACKGROUND))

; (define (render-invader-into-image invader img) img) ; stub

(define (render-invader-into-image invader img)
  (place-image INVADER (invader-x invader) (invader-y invader) img))

;; ListOfMissile Image -> Image
;; renders a list of missiles into an image
(check-expect (render-lom-into-image LOM3 BACKGROUND)
              (place-image MISSILE (missile-x M1) (missile-y M1)
                           (place-image MISSILE (missile-x M2) (missile-y M2)
                                        (place-image MISSILE (missile-x M3) (missile-y M3) BACKGROUND))))

; (define (render-lom-into-image lom img) img) ; stub

; <template from ListOfMissile>

(define (render-lom-into-image lom img)
  (cond [(empty? lom) img]
        [else
         (render-missile-into-image (first lom)
                                    (render-lom-into-image (rest lom) img))]))

;; Missile Image -> Image
;; renders a missle into an image
(check-expect (render-missile-into-image M1 BACKGROUND)
              (place-image MISSILE (missile-x M1) (missile-y M1) BACKGROUND))

; (define (render-missile-into-image m img) img) ; stub

(define (render-missile-into-image m img)
  (place-image MISSILE (missile-x m) (missile-y m) img))


;; Tank Image -> Image
;; renders the tank into an image
(check-expect (render-tank-into-image T0 BACKGROUND) (place-image TANK (tank-x T0) TANK-Y-POSITION BACKGROUND))
(check-expect (render-tank-into-image T1 BACKGROUND) (place-image TANK (tank-x T1) TANK-Y-POSITION BACKGROUND))

; (define (render-tank-into-image t img) empty-image) ; stub

; <template from Tank>

(define (render-tank-into-image t img)
  (place-image TANK (tank-x t) TANK-Y-POSITION img))

;; GameState KeyEvent -> GameState
;; advances the state to move the tank left or right (right and left arrow keys),
;                                 or to fire a missile (space key)
(check-expect (tank-action G0  "down") G0)                          ; unresponsive key
(check-expect (tank-action G4     "a") G4)                          ; unresponsive key
(check-expect (tank-action G0 "right") G0)                          ; maintains velocity (right -> right)
(check-expect (tank-action G4  "left") G4)                          ; maintains velocity
(check-expect (tank-action G4 "right")                              ; changes velocity to opposite direction
              (make-game empty empty                                ; (left -> right)
                         (make-tank (+ (tank-x T2) TANK-SPEED)
                                    (* (tank-dir T2)       -1))))
(check-expect (tank-action G0  "left")                              ; changes velocity to opposite direction
              (make-game empty empty                                ; (right -> left)
                         (make-tank (- (tank-x T0) TANK-SPEED)
                                    (* (tank-dir T0)       -1))))
(check-expect (tank-action G0     " ")
              (make-game empty
                         (cons (make-missile (tank-x T0)
                                             (- TANK-Y-POSITION TANK-HEIGHT/2))
                               empty)
                         T0))
(check-expect (tank-action G2     " ")
              (make-game (game-invaders G2)
                         (cons (make-missile (tank-x T1)
                                             (- TANK-Y-POSITION TANK-HEIGHT/2))
                               (game-missiles G2))
                         T1))

; (define (tank-action gs kevt) gs) ; stub

; <template from KeyEvent>

(define (tank-action gs kevt)
  (cond [(and (key=? kevt "right")
              (= (tank-dir (game-tank gs)) -1))
         (make-game (game-invaders gs) (game-missiles gs)
                    (make-tank (+ (tank-x (game-tank gs)) TANK-SPEED)
                               (* (tank-dir (game-tank gs)) -1)))]
        [(and (key=? kevt  "left")
              (= (tank-dir (game-tank gs))  1))
         (make-game (game-invaders gs) (game-missiles gs)
                    (make-tank (- (tank-x (game-tank gs)) TANK-SPEED)
                               (* (tank-dir (game-tank gs)) -1)))]
        [(key=? kevt     " ") (make-game (game-invaders gs)
                                         (cons (make-missile (tank-x (game-tank gs))
                                                             (- TANK-Y-POSITION TANK-HEIGHT/2))
                                               (game-missiles gs))
                                         (game-tank gs))]
        [else gs]))

;; GameState -> Boolean
;; returns true if an invader has landed
(check-expect (game-over? G0) false)
(check-expect (game-over? G1) false)
(check-expect (game-over? G3)  true)
(check-expect (game-over? G5)  true)

; (define (game-over? gs) false) ; stub

(define (game-over? s)
  (landed-invader? (game-invaders s)))

;; ListOfInvader -> Boolean
;; produces true if all invaders have not landed (above scene height)
(check-expect (landed-invader? LOI1) false)
(check-expect (landed-invader? LOI2)  true)
(check-expect (landed-invader? LOI3)  true)
(check-expect (landed-invader? LOI4) false)

; (define (landed-invader? loi) false) ; stub

; <template from ListOfInvader>

(define (landed-invader? loi)
  (cond [(empty? loi) false]
        [else
         (or (landed?         (first loi))
             (landed-invader? (rest  loi)))]))

;; Invader -> Boolean
;; produces true if invader has landed (at or below scene height)
(check-expect (landed? I1) false)
(check-expect (landed? I2)  true)
(check-expect (landed? I3)  true)

; (define (landed? invader) false) ; stub

(define (landed? invader)
  (>= (invader-y invader) HEIGHT))
