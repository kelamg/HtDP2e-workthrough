;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex223) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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
(define block-dropped (make-block 1 (sub1 HEIGHT)))
(define block-dropping-hitting (make-block 1 (- HEIGHT 2)))
(define block-left-edge (make-block 0 5))
(define block-right-edge (make-block (sub1 WIDTH) 5))
(define block-top (make-block 1 0))

(define landscape0 (list block-landed block-on-block))
(define landscape1 (list block-top (make-block 1 1)))

(define tetris0 (make-tetris block-dropping landscape0))
(define tetris0-drop (make-tetris block-dropped landscape0))
(define tetris0-confined (make-tetris block-dropping-hitting landscape0))
(define tetris1 (make-tetris block-left-edge landscape0))
(define tetris2 (make-tetris block-right-edge landscape0))
(define tetris3 (make-tetris (make-block 0 0) landscape1))

;; possible block translations
(define b-left  "l")
(define b-right "r")
(define b-down  "d")

;; Block -> Block
;; generates a new block with random x < WIDTH 
;; the position of a random dropping block
(check-satisfied (block-create (make-block 1 Y-SPAWN)) proper?)
(check-satisfied (block-create (make-block 5 Y-SPAWN)) proper?)

(define (block-create b)
  (block-check-create
   b (make-block (random WIDTH) Y-SPAWN)))
 
; Block Block -> Posn 
; generative recursion 
; new Block is generated at random until the currently
; generated one is not at the same position as the last one
(define (block-check-create b candidate)
  (if (equal? (block-x b) (block-x candidate))
      (block-create b)
      candidate))

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
    [on-tick drop-blocks r]
    [on-key  control-block]
    [stop-when        end?]))


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
  (if (hitting? (block-translate (tetris-block t) b-down)
                (tetris-landscape t))
      (make-tetris (block-create (tetris-block t))
                   (cons (tetris-block t)
                         (tetris-landscape t)))
      (make-tetris (block-translate (tetris-block t) b-down)
                   (tetris-landscape t))))

;; Block Landscape -> Boolean
;; produces true if the block has hit the floor or
;; any other block
(check-expect (hitting? block-dropping landscape0) #f)
(check-expect
 (hitting? (block-translate block-dropped b-down) landscape0) #t)
(check-expect
 (hitting? (block-translate block-dropping-hitting b-left)
           landscape0)
 #t)

(define (hitting? b l)
  (or (member? b l)
      (= (block-y b) HEIGHT)))

;; Block -> Block
;; move block down, left or right
(check-expect
 (block-translate block-dropping b-left)
 (make-block (sub1 (block-x block-dropping))
             (block-y block-dropping)))
(check-expect
 (block-translate block-dropping b-right)
 (make-block (add1 (block-x block-dropping))
             (block-y block-dropping)))
(check-expect
 (block-translate block-dropping b-down)
 (make-block (block-x block-dropping)
             (add1 (block-y block-dropping))))

(define (block-translate b dir)
  (cond
    [(string=? "d" dir) (make-block (block-x b)
                                    (add1 (block-y b)))]
    [(string=? "l" dir) (make-block (sub1 (block-x b))
                                    (block-y b))]
    [(string=? "r" dir) (make-block (add1 (block-x b))
                                    (block-y b))]
    [else (error "block-translate: unsupported direction")]))


;; Tetris KeyEvent -> Tetris
;; control the horizontal movement of the dropping block
;; "left" shifts the block one column to the left
;;        unless at x = 0 or there is a block to the left
;; "right" shifts the block one column to the right
;;        unless at x = (sub1 WIDTH) or there is a block to the right
;; "down" shifts the block down one block size
;;        unless at y = (sub1 HEIGHT)
(check-expect
 (control-block tetris0 "up") tetris0)
(check-expect
 (control-block tetris0 "left")
 (make-tetris (block-translate (tetris-block tetris0) b-left)
              (tetris-landscape tetris0)))
(check-expect
 (control-block tetris0 "right")
 (make-tetris (block-translate (tetris-block tetris0) b-right)
              (tetris-landscape tetris0)))
(check-expect
 (control-block tetris0 "down")
 (make-tetris (block-translate (tetris-block tetris0) b-down)
              (tetris-landscape tetris0)))
(check-expect
 (control-block tetris0-confined "left") tetris0-confined)
(check-expect
 (control-block tetris1 "left") tetris1)
(check-expect
 (control-block tetris2 "right") tetris2)
(check-expect
 (control-block tetris0-drop "down") tetris0-drop)


(define (control-block t ke)
  (cond
    [(and (key=? ke "left")
          (not (= (block-x (tetris-block t)) 0))
          (not (hitting? (block-translate (tetris-block t) b-left)
                         (tetris-landscape t))))
     (make-tetris (block-translate (tetris-block t) b-left)
                  (tetris-landscape t))]
    [(and (key=? ke "right")
          (not (= (block-x (tetris-block t)) (sub1 WIDTH)))
          (not (hitting? (block-translate (tetris-block t) b-right)
                         (tetris-landscape t))))
     (make-tetris (block-translate (tetris-block t) b-right)
                  (tetris-landscape t))]
    [(and (key=? ke "down")
          (not (= (block-y (tetris-block t)) (sub1 HEIGHT)))
          (not (hitting? (block-translate (tetris-block t) b-down)
                         (tetris-landscape t))))
     (make-tetris (block-translate (tetris-block t) b-down)
                  (tetris-landscape t))]
    [else t]))

;; Tetris -> Boolean
;; produces true when a column has enough blocks to touch
;; the top of the canvas
(check-expect (end? tetris0)      #f)
(check-expect (end? tetris0-drop) #f)
(check-expect (end? tetris3)      #t)

(define (end? t)
  (block-exists? 0 (tetris-landscape t)))

;; N Landscape -> Boolean
;; returns true if a block with block-y of n exists
(check-expect (block-exists? 5 landscape0) #f)
(check-expect (block-exists? 0 landscape0) #f)
(check-expect (block-exists? (sub1 HEIGHT) landscape0) #t)
(check-expect (block-exists? 0 landscape1) #t)

(define (block-exists? n l)
  (cond
    [(empty? l) #f]
    [else (or (= n (block-y (first l)))
              (block-exists? n (rest l)))]))
