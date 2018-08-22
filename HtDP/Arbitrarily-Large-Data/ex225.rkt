;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex225) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

;; CONSTANTS

;; Scene
(define WIDTH  800)
(define HEIGHT 400)
(define CENTER (/ WIDTH 2))
(define MTS    (empty-scene WIDTH HEIGHT "black"))

;; airplane
(define AIRPLANE-SPEED        10)
(define AIRPLANE-WIDTH       120)
(define AIRPLANE-HEIGHT       30)
(define AIRPLANE-Y           (+ AIRPLANE-HEIGHT 20))
(define AIRPLANE-RUDDER-SIZE AIRPLANE-HEIGHT)
(define AIRPLANE-RUDDER
  (rotate 25 (triangle AIRPLANE-RUDDER-SIZE "solid" "red")))
(define AIRPLANE
  (underlay/xy AIRPLANE-RUDDER
               (- (/ AIRPLANE-RUDDER-SIZE 2)) (/ AIRPLANE-RUDDER-SIZE 2)
               (ellipse AIRPLANE-WIDTH AIRPLANE-HEIGHT "solid" "gray")))
(define AIRPLANE-FLIP-LEFT
  (flip-horizontal AIRPLANE))

;; fire
(define FIRE                   (overlay (ellipse 10 30 "solid" "red")
                                        (ellipse 20 40 "solid" "orange")))
(define FIRE-Y                 (- HEIGHT (/ (image-height FIRE) 2)))
(define FIRE-SPAWN-PROBABILITY 0.01) ; .005 probability of spawning per tick
(define MAX-FIRE-PROXIMITY     (image-width FIRE))
(define MAX-FIRES              5)
(define HIT-RANGE              10)

;; water
(define BABY-BLUE      (make-color 137 207 240))
(define WATER          (overlay (ellipse 15 35 "solid" "blue")
                                (ellipse 25 45 "solid" BABY-BLUE)))
(define WATER-SPEED    5)

(define TIME-LIMIT     60) ; in secs


;; DEFINITIONS

(define-struct plane (x dir))
;; An Airplane is a structure:
;;    (make-plane Number Direction N)
;; interp. at any time, a plane is at x-coordinate x,
;;         and has a direction dir

;; A Direction is one of:
;; - 1
;; - -1
;; interp. 1 means going right, -1 means going left

;; A Water is a Posn 
;; interp. the position of a waterload on the canvas

;; List-of-water is one of:
;; - '()
;; - (cons Water List-of-water)

;; A Fire is a Posn
;; interp. the position of a fire on the canvas

;; List-of-fire is one of:
;; - '()
;; - (cons Fire List-of-fire)

(define-struct game (plane fires waters))
;; A Game is a structure:
;;   (make-game Plane List-of-fire List-of-water)
;; interp. the entire state of the world


(define P1 (make-plane 0 -1))
(define P2 (make-plane WIDTH 1))
(define P3 (make-plane CENTER 1))

(define F0 '())
(define F1 (list (make-posn 75 FIRE-Y)))
(define F2 (list (make-posn 650 FIRE-Y)))
(define F3 (list (make-posn 110 135) (make-posn CENTER FIRE-Y)))

(define W0 '())
(define W1 (list (make-posn 75 (- FIRE-Y HIT-RANGE))))
(define W2 (list (make-posn 590 100)))
(define W3 (list (make-posn 214 253) (make-posn CENTER 183)))
(define W4 (cons (make-posn 200 (+ HEIGHT (image-height WATER) 1)) W3))

(define GS0 (make-game P1 '() '()))
(define GS1 (make-game P1 F1 W1))
(define GS2 (make-game P2 F2 W2))
(define GS3 (make-game P3 F3 W3))
(define GS4 (make-game P3 F3 W4))
(define GS-INIT
  (make-game (make-plane CENTER 1) '() '()))
                           


;; FUNCTIONS

;; GameState -> GameState
;; run with (main GS-INIT)
(define (main gs)
  (big-bang gs
    [to-draw       render-game]
    [on-tick         next-game
                          1/28
             (* TIME-LIMIT 28)]
    [on-key      plane-control]
    [check-with  is-gamestate?]))

;; GameState -> Image
;; renders an image of the entire state of the game
(check-expect
 (render-game GS0)
 (render-plane P1 MTS))
(check-expect
 (render-game GS1)
 (render-plane P1
               (render-posn-objs F1
                                 FIRE
                                 (render-posn-objs W1
                                                   WATER
                                                   MTS))))
(check-expect
 (render-game GS3)
 (render-plane P3
               (render-posn-objs F3
                                 FIRE
                                 (render-posn-objs W3
                                                   WATER
                                                   MTS))))

(define (render-game gs)
  (render-plane (game-plane gs)
                (render-posn-objs (game-fires gs)
                                  FIRE
                                  (render-posn-objs (game-waters gs)
                                                    WATER
                                                    MTS))))

;; List-of-posn Image Image -> Image
;; renders posn objects of akin image into img at their specified positions
(check-expect (render-posn-objs F0 FIRE MTS) MTS)
(check-expect
 (render-posn-objs F3 FIRE MTS)
 (place-image FIRE (posn-x (first F3)) (posn-y (first F3))
              (place-image FIRE (posn-x (second F3)) (posn-y (second F3))
                           MTS)))
(check-expect (render-posn-objs W0 WATER MTS) MTS)
(check-expect
 (render-posn-objs W3 WATER MTS)
 (place-image WATER (posn-x (first W3)) (posn-y (first W3))
              (place-image WATER (posn-x (second W3)) (posn-y (second W3))
                           MTS)))


(define (render-posn-objs lop p-img img)
  (cond
    [(empty? lop) img]
    [else
     (place-image p-img (posn-x (first lop)) (posn-y (first lop))
                  (render-posn-objs (rest lop) p-img img))]))

;; Plane Image -> Image
;; renders a plane into image img
;; flips the plane if at edges of the scene
(check-expect
 (render-plane P1 MTS)
 (place-image AIRPLANE-FLIP-LEFT (plane-x P1) AIRPLANE-Y MTS))
(check-expect
 (render-plane P2 MTS)
 (place-image AIRPLANE (plane-x P2) AIRPLANE-Y MTS))
(check-expect
 (render-plane P3 MTS)
 (place-image AIRPLANE (plane-x P3) AIRPLANE-Y MTS))

(define (render-plane p img)
  (if (= (plane-dir p) 1)
      (place-image AIRPLANE (plane-x p) AIRPLANE-Y img)
      (place-image AIRPLANE-FLIP-LEFT (plane-x p) AIRPLANE-Y img)))


;; GameState -> GameState
;; produces the next state of the game
(define (next-game gs)
  (make-game (game-plane  gs)
             (process-fires      (game-fires  gs) (game-waters gs))
             (process-waterloads (game-waters gs) (game-fires  gs))))

;; List-of-fire List-of-water -> List-of-fire
;; randomly spawns fires based on how many fires are currently burning
(define (process-fires lof low)
  (if (should-create? lof)
      (fire-create (cancel-out lof low))
      (cancel-out lof low)))

;; List-of-fire -> Boolean
;; produces true if length of lof is below MAX-FIRES
;; and the probability test passes
(define (should-create? lof)
  (and (<= (length lof) MAX-FIRES)
       (< (/ (random 1000) 1000) FIRE-SPAWN-PROBABILITY)))

;; List-of-fire -> List-of-fire
;; generates a new fire based on currently burning fires
(check-satisfied (fire-create F0) proper?)
(check-satisfied (fire-create F1) proper?)

(define (fire-create lof)
  (fire-check-create
   (make-posn (random WIDTH) FIRE-Y) lof))
 
;; Fire List-of-fire -> List-of-fire 
;; generative recursion 
;; new Fire is generated at random until the currently
;; generated one is not at the same position as the last one
(define (fire-check-create f candidate)
  (if (close-proximity? f candidate)
      (fire-create candidate)
      (cons f candidate)))

;; Fire List-of-fire -> Boolean
;; produces true if fire f is too close to any other fire
(check-expect
 (close-proximity?
  (make-posn 40 FIRE-Y)
  (list (make-posn 450 FIRE-Y)
        (make-posn 80 FIRE-Y)))
 #f)
(check-expect
 (close-proximity?
  (make-posn 40 FIRE-Y)
  (list (make-posn (+ 40 MAX-FIRE-PROXIMITY) FIRE-Y)
        (make-posn 80 FIRE-Y)))
 #t)

(define (close-proximity? f lof)
  (cond
    [(empty? lof) #f]
    [else
     (or (<= (abs (- (posn-x f) (posn-x (first lof))))
             MAX-FIRE-PROXIMITY)
         (close-proximity? f (rest lof)))]))

; Fire -> Boolean
; use for testing only 
(define (proper? lof)
  (not (member? (first lof) (rest lof))))

;; List-of-water List-of-fire -> List-of-water
;; advances each waterload (if any) down the canvas
;; waterloads that hit a fire get used (removed from list), 
;; as well as those that fall out beneath the scene
(check-expect (process-waterloads W0 F0) '())
(check-expect (process-waterloads W1 F1) '())
(check-expect
 (process-waterloads W1 F2)
 (list (make-posn (posn-x (first W1))
                  (+ (posn-y (first W1)) WATER-SPEED))))
(check-expect
 (process-waterloads W2 F2)
 (list (make-posn (posn-x (first W2))
                  (+ (posn-y (first W2)) WATER-SPEED))))
(check-expect
 (process-waterloads W3 F3)
 (list (make-posn (posn-x (first W3))
                  (+ (posn-y (first W3)) WATER-SPEED))
       (make-posn (posn-x (second W3))
                  (+ (posn-y (second W3)) WATER-SPEED)))) 

(define (process-waterloads low lof)
  (drop-waterloads
   (cancel-out
    (filter-missed-waterloads low) lof)))

;; List-of-water -> List-of-water
;; drops each waterload towards to the bottom of the scene
(check-expect
 (drop-waterloads W2)
 (list (make-posn (posn-x (first W2))
                  (+ (posn-y (first W2)) WATER-SPEED))))
(check-expect
 (drop-waterloads W3)
 (list (make-posn (posn-x (first W3))
                  (+ (posn-y (first W3)) WATER-SPEED))
       (make-posn (posn-x (second W3))
                  (+ (posn-y (second W3)) WATER-SPEED))))

(define (drop-waterloads low)
  (cond
    [(empty? low) '()]
    [else
     (cons (make-posn (posn-x (first low))
                      (+ (posn-y (first low)) WATER-SPEED))
           (drop-waterloads (rest low)))]))


;; List-of-water -> List-of-water
;; only keeps the waterloads that are still visible in the scene
;; removes those that have fallen off the bottom of the scene
(check-expect (filter-missed-waterloads W3) W3)
(check-expect (filter-missed-waterloads W4) W3)

(define (filter-missed-waterloads low)
  (cond
    [(empty? low) '()]
    [else
     (if (>= (posn-y (first low)) (+ HEIGHT (image-height WATER)))
         (filter-missed-waterloads (rest low))
         (cons (first low) (filter-missed-waterloads (rest low))))]))

;; List-of-posn List-of-posn -> List-of-posn
;; removes all posns in lopa that are "too close" to any posns in lopb
(check-expect
 (cancel-out (list (make-posn 23 50) (make-posn 63 79))
             (list (make-posn 20 51) (make-posn 80 100)))
 (list (make-posn 63 79)))
(check-expect
 (cancel-out (list (make-posn 23 50) (make-posn 63 79))
             (list (make-posn 200 51) (make-posn 80 100)))
 (list (make-posn 23 50) (make-posn 63 79)))

(define (cancel-out lopa lopb)
  (cond
    [(empty? lopa) '()]
    [else
     (if (hit? (first lopa) lopb)
         (cancel-out (rest lopa) lopb)
         (cons (first lopa)
               (cancel-out (rest lopa) lopb)))]))

;; Posn List-of-Posn -> Boolean
;; produces true if p is close enough to any posn in lop
(check-expect
 (hit? (make-posn 23 50)
       (list (make-posn 20 51) (make-posn 80 100)))
 #t)
(check-expect
 (hit? (make-posn 23 50)
       (list (make-posn 200 51) (make-posn 80 100)))
 #f)

(define (hit? w lof)
  (cond
    [(empty? lof) #f]
    [else
     (or (close? w (first lof))
         (hit? w (rest lof)))]))

;; Posn Posn -> Boolean
;; produces true if p1 and p2 are close enough to each others
(check-expect
 (close? (make-posn 42 42)  (make-posn 30 70)) #f)
(check-expect
 (close? (make-posn 50 120) (make-posn 50 119)) #t)
(check-expect
 (close? (make-posn 30 70) (make-posn 30 70)) #t)

(define (close? p1 p2)
  (<= (distance p1 p2) HIT-RANGE))

;; Posn -> Number
;; calculates the Eucledian distance between two posns
(check-expect (round (distance (make-posn 0 4)
                               (make-posn 3 0))) 5)
(check-expect (round (distance (make-posn 12 48)
                               (make-posn 34 28))) 30)

(define (distance a b)
  (inexact->exact (sqrt (+ (sqr (- (posn-y a) (posn-y b)))
                           (sqr (- (posn-x a) (posn-x b)))))))

;; Plane Direction -> Plane
;; translates the plane right or left
(check-expect (plane-translate P1 1)
 (make-plane (+ (plane-x P1) AIRPLANE-SPEED) 1))
(check-expect (plane-translate P1 -1)
 (make-plane (+ (plane-x P1) (* AIRPLANE-SPEED (plane-dir P1))) -1))
(check-expect (plane-translate P2 1)
 (make-plane (+ (plane-x P2) (* AIRPLANE-SPEED (plane-dir P2)))  1))
(check-expect (plane-translate P2 -1)
 (make-plane (- (plane-x P2) AIRPLANE-SPEED) -1))

(define (plane-translate p dir)
  (cond
    [(= dir (plane-dir p))      (make-plane
                                 (+ (plane-x p)
                                    (* AIRPLANE-SPEED (plane-dir p)))
                                 (plane-dir p))]
    [(and (= dir 1)
          (= (plane-dir p) -1)) (make-plane
                                 (+ (plane-x p) AIRPLANE-SPEED) 1)]
    [(and (= dir -1)
          (= (plane-dir p)  1)) (make-plane
                                 (- (plane-x p) AIRPLANE-SPEED) -1)]))

;; GameState KeyEvent -> GameState
;; controls the movement of the plane
;; "left" moves the plane left, "right" moves the plane "right"
;; " " drops waterloads
(check-expect (plane-control GS0 "left")  GS0)
(check-expect
 (plane-control GS0 "right")
 (make-game (plane-translate P1 1)
            (game-fires  GS0)
            (game-waters GS0)))
(check-expect (plane-control GS2 "right") GS2)
(check-expect
 (plane-control GS2 "left")
 (make-game (plane-translate P2 -1)
            (game-fires  GS2)
            (game-waters GS2)))
(check-expect (plane-control GS3 "down")  GS3)
(check-expect (plane-control GS3    "a")  GS3)
(check-expect
 (plane-control GS3 "right")
 (make-game (plane-translate P3 1)
            (game-fires  GS3)
            (game-waters GS3)))
(check-expect
 (plane-control GS3 "left")
 (make-game (plane-translate P3 -1)
            (game-fires  GS3)
            (game-waters GS3)))
(check-expect
 (plane-control GS3 " ")
 (make-game (game-plane GS3)
            (game-fires GS3)
            (cons (make-posn (plane-x (game-plane GS3))
                             (+ AIRPLANE-Y AIRPLANE-HEIGHT))
                  (game-waters GS3))))

(define (plane-control gs ke)
  (cond
    [(and (key=? ke "left")
          (not (<= (plane-x (game-plane gs)) 0)))
     (make-game (plane-translate (game-plane gs) -1)
                (game-fires  gs)
                (game-waters gs))]
    [(and (key=? ke "right")
          (not (>= (plane-x (game-plane gs)) WIDTH)))
     (make-game (plane-translate (game-plane gs) 1)
                (game-fires  gs)
                (game-waters gs))]
    [(key=? ke " ")
     (make-game (game-plane gs)
                (game-fires gs)
                (cons (make-posn (plane-x (game-plane gs))
                                 (+ AIRPLANE-Y AIRPLANE-HEIGHT))
                      (game-waters gs)))]
    [else gs]))

;; GameState -> Boolean
(define (is-gamestate? gs)
  (game? gs))
