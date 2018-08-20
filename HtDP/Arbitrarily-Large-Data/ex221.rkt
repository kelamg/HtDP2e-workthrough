;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex221) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 20) ; # of blocks, vertically 
(define WIDTH 10) ; # of blocks, horizontally 
(define SIZE 30) ; blocks are squares
(define MTS (empty-scene (* WIDTH SIZE) (* HEIGHT SIZE)))

(define Y-SPAWN 0)

(define BLOCK ; red squares with black rims
  (overlay
    (square (- SIZE 1) "solid" "red")
    (square SIZE "outline" "black")))

(define-struct tetris [block landscape])
(define-struct block [x y])
 
; A Tetris is a structure:
;   (make-tetris Block Landscape)

; A Landscape is one of: 
; – '() 
; – (cons Block Landscape)

; A Block is a structure:
;   (make-block N N)
 
; interpretations
; (make-block x y) depicts a block whose left 
; corner is (* x SIZE) pixels from the left and
; (* y SIZE) pixels from the top;
; (make-tetris b0 (list b1 b2 ...)) means b0 is the
; dropping block, while b1, b2, and ... are resting

(define block-landed (make-block 0 (- HEIGHT 1)))
(define block-on-block (make-block 0 (- HEIGHT 2)))
(define block-dropping (make-block 1 5))
(define block-dropped (make-block 1 (- HEIGHT 1)))

(define landscape0 (list block-landed block-on-block))

(define tetris0 (make-tetris block-dropping landscape0))
(define tetris0-drop (make-tetris block-dropped landscape0))


;; Block -> Block
;; generates a new block with random x < WIDTH 
;; the position of a random dropping block
(check-satisfied (block-create (make-block 1 Y-SPAWN)) proper?)
(check-satisfied (block-create (make-block 5 Y-SPAWN)) proper?)

(define (block-create b)
  (make-block (random WIDTH) Y-SPAWN))
 
; Block -> Boolean
; use for testing only 
(define (proper? b)
  (< (block-x b) WIDTH))


(define INIT
  (make-tetris (block-create (make-block 1 1)) '()))

;; Tetris -> Tetris
;; Play Simple Tetris!
;; run with (tetris-main    r)
;;        - (tetris-main 0.25)
;; where r is the rate at which the clock ticks
(define (tetris-main r)
  (big-bang INIT
    [to-draw tetris-render]
    [on-tick drop-blocks r]))


;; Tetris -> Image
;; renders the tetris game state into an image
(check-expect
 (tetris-render tetris0)
 (render-block block-dropping
               (render-landscape landscape0 MTS)))
(check-expect
 (tetris-render tetris0-drop)
 (render-block block-dropped
               (render-landscape landscape0 MTS)))

(define (tetris-render t)
  (render-block (tetris-block t)
                (render-landscape (tetris-landscape t) MTS)))

;; Block Image -> Image
;; renders a given block into img
(check-expect
 (render-block block-landed MTS)
 (underlay/xy MTS
              (* (block-x block-landed) SIZE)
              (* (block-y block-landed) SIZE)
              BLOCK))

(define (render-block b img)
  (underlay/xy img
               (* (block-x b) SIZE)
               (* (block-y b) SIZE)
               BLOCK))

;; Landscape Image -> Image
;; renders the landscape into img
(check-expect (render-landscape '() MTS) MTS)
(check-expect
 (render-landscape landscape0 MTS)
 (render-block block-landed
               (render-block block-on-block MTS)))

(define (render-landscape l img)
  (cond
    [(empty? l) img]
    [else (render-block (first l)
                        (render-landscape (rest l) img))]))

;; Tetris -> Tetris
;; drop blocks from top of canvas and lands them on the floor
;; or on blocks already resting on the floor
(check-expect
 (drop-blocks tetris0)
 (make-tetris (make-block (block-x (tetris-block tetris0))
                          (add1 (block-y (tetris-block tetris0))))
              (tetris-landscape tetris0)))
(check-random
 (drop-blocks tetris0-drop)
 (make-tetris (block-create (tetris-block tetris0-drop))
              (cons (tetris-block tetris0-drop)
                    (tetris-landscape tetris0-drop))))

(define (drop-blocks t)
  (if (dropped? (tetris-block t) (tetris-landscape t))
      (make-tetris (block-create (tetris-block t))
                   (cons (tetris-block t)
                         (tetris-landscape t)))
      (make-tetris (make-block (block-x (tetris-block t))
                               (add1 (block-y (tetris-block t))))
                   (tetris-landscape t))))

;; Block Landscape -> Boolean
;; produces true if the block is dropping, false if it is on the floor
;; or is directly above one of the resting blocks
(check-expect (dropped? block-dropping landscape0) #f)
(check-expect (dropped? block-dropped landscape0) #t)

(define (dropped? b l)
  (or (member? (make-block (block-x b) (add1 (block-y b))) l)
      (= (block-y b) (sub1 HEIGHT))))
                    