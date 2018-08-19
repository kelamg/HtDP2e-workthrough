;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex215) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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


;; Definitions:

(define-struct worm (head dir))
;; A Worm is a structure:
;;   (make-worm Segment Direction)
;; interp. keeps track of the position of the worm's head
;;         on the canvas; dir is its direction of movement

;; A Segment is a Posn
;; interp. the position of a worm's segment

;; A Direction is a 1String, one of:
;; - "l" (left)
;; - "r" (right)
;; - "u" (up)
;; - "d" (down)
;; interp. the directions in which a worm can move
;;         relative to the canvas


(define W1
  (make-worm (make-posn 50 50) "r")) 
(define W2
  (make-worm (make-posn 30 70) "l"))
(define W3
  (make-worm (make-posn 100 140) "u"))


;; Functions:

(define WORM-INIT
  (make-worm (make-posn (/ WIDTH 2) (/ HEIGHT 2)) "r"))

;; Worm -> Image
;; renders the image of the worm on the canvas
(check-expect
 (render-worm W1)
 (render-seg-into (worm-head W1) MTS))
(check-expect
 (render-worm W2)
 (render-seg-into (worm-head W2) MTS))

(define (render-worm w)
  (render-seg-into (worm-head w) MTS))

;; Segment Image -> Image
;; renders a segment into img
(check-expect
 (render-seg-into (make-posn 50 100) MTS)
 (place-image WORM-SEG 50 100 MTS))
(check-expect
 (render-seg-into (worm-head W1) MTS)
  (place-image WORM-SEG
               (posn-x (worm-head W1)) (posn-y (worm-head W1))
               MTS))

(define (render-seg-into seg img)
  (place-image WORM-SEG (posn-x seg) (posn-y seg) img))


;; Worm -> Worm
;; on each clock tick, the worm's head moves in a specific direction;
;; its segments follow suit
(check-expect
 (slither-worm W1)
 (make-worm (make-posn (+ 50 DMT) 50) "r"))
(check-expect
 (slither-worm W2)
 (make-worm (make-posn (- 30 DMT) 70) "l"))
(check-expect
 (slither-worm W3)
 (make-worm (make-posn 100 (- 140 DMT)) "u"))

(define (slither-worm w)
  (make-worm (slither-head (worm-head w) (worm-dir w))
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

;; Worm KeyEvent -> Worm
;; control the worm
;; all arrow keys allowed, except the directly opposite direction
(check-expect
 (control-worm W1     " ") W1)
(check-expect
 (control-worm W1     "a") W1)
(check-expect
 (control-worm W1  "left") W1)
(check-expect
 (control-worm W1 "right") W1)
(check-expect
 (control-worm W1 "up")
 (make-worm (make-posn 50 50) "u"))
(check-expect
 (control-worm W1 "down")
 (make-worm (make-posn 50 50) "d"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) "l") "right")
 (make-worm (make-posn 50 50) "l"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) "l") "up")
 (make-worm (make-posn 50 50) "u"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) "l") "down")
 (make-worm (make-posn 50 50) "d"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) "l") "left")
 (make-worm (make-posn 50 50) "l"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) "u") "up")
 (make-worm (make-posn 50 50) "u"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) "u") "left")
 (make-worm (make-posn 50 50) "l"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) "u") "right")
 (make-worm (make-posn 50 50) "r"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) "u") "down")
 (make-worm (make-posn 50 50) "u"))

(define (control-worm w ke)
  (cond
    [(and (key=? ke "up")
          (not (or (string=? (worm-dir w) "u")
                   (string=? (worm-dir w) "d"))))
     (make-worm (make-posn (posn-x (worm-head w))
                           (posn-y (worm-head w)))
                "u")]
    [(and (key=? ke "down")
          (not (or (string=? (worm-dir w) "d")
                   (string=? (worm-dir w) "u"))))
     (make-worm (make-posn (posn-x (worm-head w))
                           (posn-y (worm-head w)))
                "d")]
    [(and (key=? ke "left")
          (not (or (string=? (worm-dir w) "l")
                   (string=? (worm-dir w) "r"))))
     (make-worm (make-posn (posn-x (worm-head w))
                           (posn-y (worm-head w)))
                "l")]
    [(and (key=? ke "right")
          (not (or (string=? (worm-dir w) "r")
                   (string=? (worm-dir w) "l"))))
     (make-worm (make-posn (posn-x (worm-head w))
                           (posn-y (worm-head w)))
                "r")]
    [else w]))


;; Worm -> Worm
;; Play Worm!
;; run with (worm-main r);
;; where r is the rate at which the clock ticks
(define (worm-main r)
  (big-bang WORM-INIT
    [to-draw    render-worm]
    [on-tick slither-worm r]
    [on-key    control-worm]))
    
