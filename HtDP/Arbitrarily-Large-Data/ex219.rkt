;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex219) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

;; Constants:

;; scene
(define WIDTH  400)
(define HEIGHT 400)
(define MTS    (empty-scene WIDTH HEIGHT))

;; worm
(define DMT       10) ; diameter of the worm's segments
(define WORM-SEG  (circle (/ DMT 2) "solid" "red"))
(define EAT-RANGE 8)

(define TEXT-X     (/ WIDTH 3.5))
(define TEXT-Y     (/ HEIGHT 1.25))
(define TEXT-SIZE  18)
(define TEXT-COLOR "orange")
(define C-MSG      "worm hit border : ")
(define E-MSG      "worm went cannibal mode : ")

;; food
(define FOOD   (circle (/ DMT 2) "solid" "green"))
(define MAX    (- WIDTH (/ (image-width WORM-SEG) 2)))


;; Definitions:

(define-struct worm (head segs dir))
;; A Worm is a structure:
;;   (make-worm Segment List-of-segments Direction)
;; interp. keeps track of the position of the worm's head
;;         on the canvas; segs is a list of the segments
;;         that constitute its body; dir is its direction
;;         of movement

;; A Segment is a Posn
;; interp. the position of a worm's segment

;; A List-of-segments is one of:
;; - '()
;; - (cons Segment List-of-segments)

;; A Direction is a 1String, one of:
;; - "l" (left)
;; - "r" (right)
;; - "u" (up)
;; - "d" (down)
;; interp. the directions in which a worm can move
;;         relative to the canvas

(define-struct game (worm food))
;; A Game is a structure:
;;   (make-game Worm Food)
;; interp. the entire state of the worm game

;; A Food is one of:
;; - '()
;; - Posn
;; interp. the position of food in the game world


(define W1
  (make-worm (make-posn 50 50) '() "r")) 
(define W2
  (make-worm (make-posn 30 70)
             (list (make-posn 30 (+ 70 DMT))
                   (make-posn 30 (+ 70 (* DMT 2))))
             "u"))
(define W3
  (make-worm (make-posn 30 70)
             (list (make-posn 30 (- 70 DMT))
                   (make-posn 30 (- 70 (* DMT 2)))
                   (make-posn 40 (- 70 (* DMT 2))))
             "d"))
(define W4
  (make-worm (make-posn 50 70)
             (list (make-posn 60 70)
                   (make-posn 60 80)
                   (make-posn 50 80)
                   (make-posn 50 70)
                   (make-posn 50 60)
                   (make-posn 50 50))
             "l"))

(define F1 (make-posn 120 50))
(define F2 (make-posn  30 70)) 

(define G1 (make-game W1 F1))
(define G2 (make-game W2 F2))
(define G3 (make-game W4 F1))
  

;; Functions:

; Posn -> Posn 
; generates two random numbers < MAX,
; the coordinates of a randomly-placed food
(check-satisfied (food-create (make-posn 1 1)) not=-1-1?)
(check-satisfied (food-create (make-posn 23 89)) not=-1-1?)

(define (food-create p)
  (food-check-create
     p (make-posn (random MAX) (random MAX))))
 
; Posn Posn -> Posn 
; generative recursion 
; new Food is generated at random until the currently
; generated one is not at the same position as the last one
(define (food-check-create p candidate)
  (if (equal? p candidate) (food-create p) candidate))
 
; Posn -> Boolean
; use for testing only 
(define (not=-1-1? p)
  (not (and (= (posn-x p) 1) (= (posn-y p) 1))))

(define INIT-POSN (make-posn (/ WIDTH 2) (/ HEIGHT 2)))
(define GAME-INIT
  (make-game (make-worm INIT-POSN '() "r") (food-create INIT-POSN) ))

;; Game -> Image
;; renders the world
(check-expect
 (render-game G1)
 (place-image FOOD 120 50
              (render-worm W1)))
(check-expect
 (render-game G2)
 (place-image FOOD 30 70
              (render-worm W2)))

(define (render-game g)
  (place-image FOOD
               (posn-x (game-food g))
               (posn-y (game-food g))
               (render-worm (game-worm g))))

;; Worm -> Image
;; renders the image of the worm on the canvas
(check-expect
 (render-worm W1)
 (render-seg-into (worm-head W1) MTS))
(check-expect
 (render-worm W2)
 (render-seg-into
  (second (worm-segs W2))
  (render-seg-into
   (first (worm-segs W2))
   (render-seg-into (worm-head W2) MTS))))
(check-expect
 (render-worm W3)
 (render-seg-into
  (third (worm-segs W3))
  (render-seg-into
   (second (worm-segs W3))
   (render-seg-into
    (first (worm-segs W3))
    (render-seg-into (worm-head W3) MTS)))))

(define (render-worm w)
  (render-seg-into (worm-head w)
                   (render-segs-into (worm-segs w) MTS)))

;; List-of-segments Image -> Image
;; renders a list of segments into img
(check-expect
 (render-segs-into '() MTS) MTS)
(check-expect
 (render-segs-into (list (make-posn 40 60)) MTS)
 (render-seg-into (make-posn 40 60) MTS))
(check-expect
 (render-segs-into
  (list (make-posn 40 60) (make-posn (+ 40 DMT) 60)) MTS)
 (render-seg-into
  (make-posn 40 60)
  (render-seg-into (make-posn (+ 40 DMT) 60) MTS)))

(define (render-segs-into los img)
  (cond
    [(empty? los) img]
    [else (render-seg-into (first los)
                           (render-segs-into (rest los) img))]))

;; Segment Image -> Image
;; renders a segment into img
(check-expect
 (render-seg-into (make-posn 50 100) MTS)
 (place-image WORM-SEG 50 100 MTS))
(check-expect
 (render-seg-into
  (make-posn 30 (- 70 DMT))
  (place-image
   WORM-SEG (posn-x (worm-head W1)) (posn-y (worm-head W1)) MTS))
 (place-image
  WORM-SEG 30 (- 70 DMT)
  (place-image
   WORM-SEG (posn-x (worm-head W1)) (posn-y (worm-head W1)) MTS)))

(define (render-seg-into seg img)
  (place-image WORM-SEG (posn-x seg) (posn-y seg) img))


;; Game -> Game
;; moves the worm and generates the food as necessary
(check-expect
 (next-game G1)
 (make-game (slither-worm W1) (game-food G1)))
(check-random
 (next-game G2)
 (make-game (slither-worm (grow-worm W2))
            (food-create (game-food G2))))

(define (next-game g)
  (if (close? (worm-head (game-worm g))
              (game-food g))
      (make-game (slither-worm (grow-worm (game-worm g)))
                 (food-create (game-food g)))
      (make-game (slither-worm (game-worm g))
                 (game-food g))))

;; Posn Posn -> Boolean
;; produces true if p2 is the exact same position as p1
(check-expect
 (close? (make-posn 42 42)  (make-posn 30 70)) #f)
(check-expect
 (close? (make-posn 50 120) (make-posn 50 119)) #t)
(check-expect
 (close? (make-posn 30 70) (make-posn 30 70)) #t)

(define (close? p1 p2)
  (<= (distance p1 p2) EAT-RANGE))

;; Posn -> Number
;; calculates the Eucledian distance between two posns
(check-expect (round (distance (make-posn 0 4)
                               (make-posn 3 0))) 5)
(check-expect (round (distance (make-posn 12 48)
                               (make-posn 34 28))) 30)

(define (distance a b)
  (inexact->exact (sqrt (+ (sqr (- (posn-y a) (posn-y b)))
                           (sqr (- (posn-x a) (posn-x b)))))))

;; Worm -> Worm
;; grows the worm by one segment
(check-expect
 (grow-worm W1)
 (make-worm (slither-head (worm-head W1) (worm-dir W1))
            (cons (worm-head W1) (worm-segs W1))
            (worm-dir W1)))
(check-expect
 (grow-worm W2)
 (make-worm (slither-head (worm-head W2) (worm-dir W2))
            (cons (worm-head W2) (worm-segs W2))
            (worm-dir W2)))

(define (grow-worm w)
  (make-worm (slither-head (worm-head w) (worm-dir w))
             (cons (worm-head w) (worm-segs w))
             (worm-dir w)))

 
;; Worm -> Worm
;; on each clock tick, the worm's head moves in a specific direction;
;; its segments follow suit
(check-expect
 (slither-worm W1)
 (make-worm (make-posn (+ 50 DMT) 50) '() "r"))
(check-expect
 (slither-worm W2)
 (make-worm (make-posn 30 (- 70 DMT))
            (list (make-posn 30 70)
                  (make-posn 30 (+ 70 DMT)))
            "u"))
(check-expect
 (slither-worm W3)
 (make-worm (make-posn 30 (+ 70 DMT))
            (list (make-posn 30 70)  
                  (make-posn 30 (- 70 DMT))
                  (make-posn 30 (- 70 (* DMT 2))))
            "d"))

(define (slither-worm w)
  (make-worm (slither-head (worm-head w) (worm-dir w))
             (slither-segs (worm-head w) (worm-segs w))
             (worm-dir w)))

;; Segment 1String -> Segment
;; move the worm's head in its current direction
(check-expect
 (slither-head (make-posn 50 60) "r")
 (make-posn (+ 50 DMT) 60))
(check-expect
 (slither-head (make-posn 50 60) "l")
 (make-posn (- 50 DMT) 60))
(check-expect
 (slither-head (make-posn 50 60) "u")
 (make-posn 50 (- 60 DMT)))
(check-expect
 (slither-head (make-posn 50 60) "d")
 (make-posn 50 (+ 60 DMT)))

(define (slither-head p dir)
  (cond
    [(string=? dir "r") (make-posn
                         (+ (posn-x p) DMT) (posn-y p))]
    [(string=? dir "l") (make-posn
                         (- (posn-x p) DMT) (posn-y p))]
    [(string=? dir "u") (make-posn
                         (posn-x p) (- (posn-y p) DMT))]
    [(string=? dir "d") (make-posn
                         (posn-x p) (+ (posn-y p) DMT))]))

;; Segment List-of-segments -> List-of-segments
;; moves the worm's segments by following the worm's head
;; or following the preceeding segment
(check-expect
 (slither-segs (worm-head W1) '()) '()) 
(check-expect
 (slither-segs (make-posn 30 (posn-y (worm-head W2)))
               (list (make-posn 30 (+ 70 DMT))
                     (make-posn 30 (+ 70 (* DMT 2)))))
 (list (make-posn 30 70)
       (make-posn 30 (+ 70 DMT))))
(check-expect
 (slither-segs (make-posn 30 (posn-y (worm-head W3)))
               (list (make-posn 30 (- 70 DMT))
                     (make-posn 30 (- 70 (* DMT 2)))
                     (make-posn 40 (- 70 (* DMT 2)))))
 (list (make-posn 30 70)  
       (make-posn 30 (- 70 DMT))
       (make-posn 30 (- 70 (* DMT 2)))))

(define (slither-segs s los)
  (cond
    [(empty? los) '()]
    [else (cons s (slither-segs (first los) (rest los)))]))

;; Game KeyEvent -> Game
;; control the worm
;; all arrow keys allowed, except the directly opposite direction
(check-expect
 (control-worm G1     " ") G1)
(check-expect
 (control-worm G1     "a") G1)
(check-expect
 (control-worm G1  "left") G1)
(check-expect
 (control-worm G1 "right") G1)
(check-expect
 (control-worm G1 "up")
 (make-game (make-worm (make-posn 50 50) '() "u") F1))
(check-expect
 (control-worm G1 "down")
 (make-game (make-worm (make-posn 50 50) '() "d") F1))
(check-expect
 (control-worm
  (make-game (make-worm (make-posn 50 50) '() "l") F1) "right")
 (make-game (make-worm (make-posn 50 50) '() "l") F1))
(check-expect
 (control-worm
  (make-game (make-worm (make-posn 50 50) '() "l") F1) "up")
 (make-game (make-worm (make-posn 50 50) '() "u") F1))
(check-expect
 (control-worm
  (make-game (make-worm (make-posn 50 50) '() "l") F1) "down")
 (make-game (make-worm (make-posn 50 50) '() "d") F1))
(check-expect
 (control-worm
  (make-game (make-worm (make-posn 50 50) '() "l") F1) "left")
 (make-game (make-worm (make-posn 50 50) '() "l") F1))
(check-expect
 (control-worm
  (make-game (make-worm (make-posn 50 50) '() "u") F1) "up")
 (make-game (make-worm (make-posn 50 50) '() "u") F1))
(check-expect
 (control-worm
  (make-game (make-worm (make-posn 50 50) '() "u") F1) "left")
 (make-game (make-worm (make-posn 50 50) '() "l") F1))
(check-expect
 (control-worm
  (make-game (make-worm (make-posn 50 50) '() "u") F1) "right")
 (make-game (make-worm (make-posn 50 50) '() "r") F1))
(check-expect
 (control-worm
  (make-game (make-worm (make-posn 50 50) '() "u") F1) "down")
 (make-game (make-worm (make-posn 50 50) '() "u") F1))

(define (control-worm g ke)
  (cond
    [(and (key=? ke "up")
          (not (or (string=? (worm-dir (game-worm g)) "u")
                   (string=? (worm-dir (game-worm g)) "d"))))
     (make-game (make-worm
                 (make-posn (posn-x (worm-head (game-worm g)))
                            (posn-y (worm-head (game-worm g))))
                 (worm-segs (game-worm g))
                 "u")
                (game-food g))]
    [(and (key=? ke "down")
          (not (or (string=? (worm-dir (game-worm g)) "d")
                   (string=? (worm-dir (game-worm g)) "u"))))
     (make-game (make-worm
                 (make-posn (posn-x (worm-head (game-worm g)))
                            (posn-y (worm-head (game-worm g))))
                 (worm-segs (game-worm g))
                 "d")
                (game-food g))]
    [(and (key=? ke "left")
          (not (or (string=? (worm-dir (game-worm g)) "l")
                   (string=? (worm-dir (game-worm g)) "r"))))
     (make-game (make-worm
                 (make-posn (posn-x (worm-head (game-worm g)))
                            (posn-y (worm-head (game-worm g))))
                 (worm-segs (game-worm g))
                 "l")
                (game-food g))]
    [(and (key=? ke "right")
          (not (or (string=? (worm-dir (game-worm g)) "r")
                   (string=? (worm-dir (game-worm g)) "l"))))
     (make-game (make-worm
                 (make-posn (posn-x (worm-head (game-worm g)))
                            (posn-y (worm-head (game-worm g))))
                 (worm-segs (game-worm g))
                 "r")
                (game-food g))]
    [else g]))

;; Game -> Boolean
;; produces true if either the worm has reached the walls of the scene
;; or its head has run into one of its segments
;; no test required
(define (deceased-worm? g)
  (or (cannibal-worm? g)
      (concussed-worm? g)))

;; Game -> Boolean
;; produces true if the worm's head has run into one of its segments
(check-expect (cannibal-worm? G1) false)
(check-expect (cannibal-worm? G2) false)
(check-expect (cannibal-worm? G3) #true)

(define (cannibal-worm? g)
  (member (worm-head (game-worm g))
          (worm-segs (game-worm g))))

;; Game -> Boolean
;; produces true if the worm's head has reached the walls of the scene
(check-expect (concussed-worm? G1) #false)
(check-expect (concussed-worm? G2) #false)
(check-expect
 (concussed-worm?
  (make-game (make-worm (make-posn WIDTH 50) '() "r") F1))
 #true)
(check-expect
 (concussed-worm?
  (make-game (make-worm (make-posn 0 70) '() "l") F1))
 #true)
(check-expect
 (concussed-worm?
  (make-game (make-worm (make-posn 30 0) '() "u") F1))
 #true)
(check-expect
 (concussed-worm?
  (make-game (make-worm (make-posn 100 HEIGHT) '() "d") F1))
 #true)

(define (concussed-worm? g)
  (or (or (>= (posn-x (worm-head (game-worm g)))  WIDTH)
          (>= (posn-y (worm-head (game-worm g))) HEIGHT))
      (or (<= (posn-x (worm-head (game-worm g)))      0)
          (<= (posn-y (worm-head (game-worm g)))      0))))

;; Game -> Image
;; renders E-MSG if worm ate itself, or C-MSG if worm
;; ran into the walls of the world
(check-expect
 (render-game-over
  (make-game (make-worm (make-posn WIDTH 50) '() "r") F1))
 (place-image
  (beside (text C-MSG TEXT-SIZE TEXT-COLOR)
          (text "1" TEXT-SIZE TEXT-COLOR))
  TEXT-X TEXT-Y
  (render-worm
   (make-worm (make-posn WIDTH 50) '() "r"))))
(check-expect
 (render-game-over
  (make-game (make-worm (make-posn 100 HEIGHT) '() "d") F2))
 (place-image
  (beside (text C-MSG TEXT-SIZE TEXT-COLOR)
          (text "1" TEXT-SIZE TEXT-COLOR))
  TEXT-X TEXT-Y
  (render-worm
   (make-worm (make-posn 100 HEIGHT) '() "d"))))
(check-expect
 (render-game-over G3)
 (place-image
  (beside (text E-MSG TEXT-SIZE TEXT-COLOR)
          (text (number->string
                 (+ (length (worm-segs (game-worm G3))) 1))
                TEXT-SIZE TEXT-COLOR))
  TEXT-X TEXT-Y
  (render-worm W4)))

(define (render-game-over g)
  (if (cannibal-worm? g)
      (place-image
       (beside (text E-MSG TEXT-SIZE TEXT-COLOR)
               (text (number->string
                      (+ (length (worm-segs (game-worm g))) 1))
                     TEXT-SIZE TEXT-COLOR))
       TEXT-X TEXT-Y
       (render-worm (game-worm g)))
      (place-image
       (beside (text C-MSG TEXT-SIZE TEXT-COLOR)
               (text (number->string
                     (+ (length (worm-segs (game-worm g))) 1))
                     TEXT-SIZE TEXT-COLOR))
       TEXT-X TEXT-Y
       (render-worm (game-worm g)))))


;; Gane -> Game
;; Play Worm!
;; run with (worm-main    r)
;;        - (worm-main 0.25)
;; where r is the rate at which the clock ticks
(define (worm-main r)
  (big-bang GAME-INIT
    [to-draw render-game]
    [on-tick next-game r]
    [on-key control-worm]
    [stop-when deceased-worm? render-game-over]))
    
