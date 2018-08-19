;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex218) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

(define TEXT-X     (/ WIDTH 3.5))
(define TEXT-Y     (/ HEIGHT 1.25))
(define TEXT-SIZE  18)
(define TEXT-COLOR "orange")
(define C-MSG      "worm hit border")
(define E-MSG      "worm went cannibal mode") 


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
  

;; Functions:

(define WORM-INIT W3) ; to test

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
 (make-worm (make-posn 50 50) '() "u"))
(check-expect
 (control-worm W1 "down")
 (make-worm (make-posn 50 50) '() "d"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) '() "l") "right")
 (make-worm (make-posn 50 50) '() "l"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) '() "l") "up")
 (make-worm (make-posn 50 50) '() "u"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) '() "l") "down")
 (make-worm (make-posn 50 50) '() "d"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) '() "l") "left")
 (make-worm (make-posn 50 50) '() "l"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) '() "u") "up")
 (make-worm (make-posn 50 50) '() "u"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) '() "u") "left")
 (make-worm (make-posn 50 50) '() "l"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) '() "u") "right")
 (make-worm (make-posn 50 50) '() "r"))
(check-expect
 (control-worm
  (make-worm (make-posn 50 50) '() "u") "down")
 (make-worm (make-posn 50 50) '() "u"))

(define (control-worm w ke)
  (cond
    [(and (key=? ke "up")
          (not (or (string=? (worm-dir w) "u")
                   (string=? (worm-dir w) "d"))))
     (make-worm (make-posn (posn-x (worm-head w))
                           (posn-y (worm-head w)))
                (worm-segs w)
                "u")]
    [(and (key=? ke "down")
          (not (or (string=? (worm-dir w) "d")
                   (string=? (worm-dir w) "u"))))
     (make-worm (make-posn (posn-x (worm-head w))
                           (posn-y (worm-head w)))
                (worm-segs w)
                "d")]
    [(and (key=? ke "left")
          (not (or (string=? (worm-dir w) "l")
                   (string=? (worm-dir w) "r"))))
     (make-worm (make-posn (posn-x (worm-head w))
                           (posn-y (worm-head w)))
                (worm-segs w)
                "l")]
    [(and (key=? ke "right")
          (not (or (string=? (worm-dir w) "r")
                   (string=? (worm-dir w) "l"))))
     (make-worm (make-posn (posn-x (worm-head w))
                           (posn-y (worm-head w)))
                (worm-segs w)
                "r")]
    [else w]))

;; Worm -> Boolean
;; produces true if either the worm has reached the walls of the scene
;; or its head has run into one of its segments
;; no test required
(define (deceased-worm? w)
  (or (cannibal-worm? w) (concussed-worm? w)))

;; Worm -> Boolean
;; produces true if the worm's head has run into one of its segments
(check-expect (cannibal-worm? W1) false)
(check-expect (cannibal-worm? W2) false)
(check-expect (cannibal-worm? W4) #true)

(define (cannibal-worm? w)
  (member (worm-head w) (worm-segs w)))

;; Worm -> Boolean
;; produces true if the worm's head has reached the walls of the scene
(check-expect (concussed-worm? W1) #false)
(check-expect (concussed-worm? W3) #false)
(check-expect
 (concussed-worm? (make-worm (make-posn WIDTH 50) '() "r"))
 #true)
(check-expect
 (concussed-worm? (make-worm (make-posn 0 70) '() "l"))
 #true)
(check-expect
 (concussed-worm? (make-worm (make-posn 30 0) '() "u"))
 #true)
(check-expect
 (concussed-worm? (make-worm (make-posn 100 HEIGHT) '() "d"))
 #true)

(define (concussed-worm? w)
  (or (or (>= (posn-x (worm-head w))  WIDTH)
          (>= (posn-y (worm-head w)) HEIGHT))
      (or (<= (posn-x (worm-head w))      0)
          (<= (posn-y (worm-head w))      0))))

;; Worm -> Image
;; renders E-MSG if worm ate itself, or C-MSG if worm
;; ran into the walls of the world
(check-expect
 (render-game-over (make-worm (make-posn WIDTH 50) '() "r"))
 (place-image (text C-MSG TEXT-SIZE TEXT-COLOR)
              TEXT-X TEXT-Y
              (render-worm
               (make-worm (make-posn WIDTH 50) '() "r"))))
(check-expect
 (render-game-over (make-worm (make-posn 100 HEIGHT) '() "d"))
 (place-image (text C-MSG TEXT-SIZE TEXT-COLOR)
              TEXT-X TEXT-Y
              (render-worm
               (make-worm (make-posn 100 HEIGHT) '() "d"))))
(check-expect
 (render-game-over W4)
 (place-image (text E-MSG TEXT-SIZE TEXT-COLOR)
              TEXT-X TEXT-Y
              (render-worm W4)))

(define (render-game-over w)
  (if (cannibal-worm? w)
      (place-image (text E-MSG TEXT-SIZE TEXT-COLOR)
                   TEXT-X TEXT-Y
                   (render-worm w))
      (place-image (text C-MSG TEXT-SIZE TEXT-COLOR)
                   TEXT-X TEXT-Y
                   (render-worm w))))


;; Worm -> Worm
;; Play Worm!
;; run with (worm-main r);
;; where r is the rate at which the clock ticks
(define (worm-main r)
  (big-bang WORM-INIT
    [to-draw    render-worm]
    [on-tick slither-worm r]
    [on-key    control-worm]
    [stop-when deceased-worm? render-game-over]))
    
