;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex480) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

(define QUEENS 8)
(define QUEEN  (overlay/offset (radial-star 6 6 10 'solid 'black)
                               0 5
                               (triangle 20 'solid 'black)))
(define SQUARE (square (+ (image-height QUEEN) 10) 'outline 'black))
(define SQ-WTH (image-width SQUARE))
(define OFFSET (/ SQ-WTH 2))

; A QP is a structure:
;   (make-posn CI CI)

; A CI is an N in [0,QUEENS).
; interpretation (make-posn r c) denotes the square at 
;                the r-th row and c-th column

(define C1 (make-posn 1 5))
(define C2 (make-posn 2 6))
(define C3 (make-posn 2 7))
(define C4 (make-posn 0 7))

;; N -> Image
;; draws the board
(define (draw-board n)
  (local (; draws a section of the board
          (define (draw-section f n img)
            (cond
              [(zero? n) empty-image]
              [else (f img
                       (draw-section f (sub1 n) img))])))
    
    (draw-section above n (draw-section beside n SQUARE))))

;; N [List-of QP] Image -> Image
;; produces an image of an n by n chess board with the
;; img placed according to the qps
(check-expect
 (render-queens QUEENS (list C1 C2) QUEEN)
 (place-image
  QUEEN (+ OFFSET (* SQ-WTH (posn-x C1))) (+ OFFSET (* SQ-WTH (posn-y C1)))
  (place-image
   QUEEN (+ OFFSET (* SQ-WTH (posn-x C2))) (+ OFFSET (* SQ-WTH (posn-y C2)))
   (draw-board QUEENS))))

(define (render-queens n qps img)
  (foldr (λ (this others)
           (local (; place the queen in the center of the square
                   (define x (* SQ-WTH (posn-x this)))
                   (define y (* SQ-WTH (posn-y this))))
             (place-image
              img (+ OFFSET x) (+ OFFSET y) others)))
         (draw-board n)
         qps))

;; QP QP -> Boolean
;; produces #true if queens placed on both squares would
;; threaten each other
(check-expect (threatening? C1 C2)  #true)
(check-expect (threatening? C2 C3)  #true)
(check-expect (threatening? C3 C4)  #true)
(check-expect (threatening? C1 C3) #false)
(check-expect (threatening? C1 C4) #false)
(check-expect (threatening? C2 C4) #false)

(define (threatening? ca cb)
  (or (or (= (posn-x ca) (posn-x cb))
          (= (posn-y ca) (posn-y cb)))
      (=  (abs (- (posn-x ca) (posn-x cb)))
          (abs (- (posn-y ca) (posn-y cb))))))
