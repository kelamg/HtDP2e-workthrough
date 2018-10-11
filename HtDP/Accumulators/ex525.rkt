;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex525) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

(define MT (empty-scene 400 400))
(define A (make-posn 200  50))
(define B (make-posn  27 350))
(define C (make-posn 373 350))

(define COLOR 'black) 

; Image Posn Posn Posn -> Image 
; adds the black triangle a, b, c to scene
(define (add-triangle scene a b c)
  (scene+line
   (scene+line
    (scene+line scene (posn-x a) (posn-y a) (posn-x b) (posn-y b) COLOR)
    (posn-x b) (posn-y b) (posn-x c) (posn-y c) COLOR)
   (posn-x c) (posn-y c) (posn-x a) (posn-y a) COLOR))

; Posn Posn Posn -> Boolean 
; is the triangle a, b, c too small to be divided
(define (too-small? a b c)
  (<= (min (distance a b) (distance b c) (distance c a)) pi))

; Posn Posn -> Number
; produces the eucledian distance between two Posns
(define (distance a b)
  (sqrt (+ (sqr (- (posn-y a) (posn-y b)))
           (sqr (- (posn-x a) (posn-x b))))))
 
; Posn Posn -> Posn 
; determines the midpoint between a and b
(define (mid-point a b)
  (make-posn (* 0.5 (+ (posn-x a) (posn-x b)))
             (* 0.5 (+ (posn-y a) (posn-y b)))))

; Image Posn Posn Posn -> Image 
; generative adds the triangle (a, b, c) to s, 
; subdivides it into three triangles by taking the 
; midpoints of its sides; stop if (a, b, c) is too small
; accumulator the function accumulates the triangles scene0
(define (add-sierpinski scene0 a b c)
  (cond
    [(too-small? a b c) scene0]
    [else
     (local
       ((define scene1 (add-triangle scene0 a b c))
        (define mid-a-b (mid-point a b))
        (define mid-b-c (mid-point b c))
        (define mid-c-a (mid-point c a))
        (define scene2
          (add-sierpinski scene1 a mid-a-b mid-c-a))
        (define scene3
          (add-sierpinski scene2 b mid-b-c mid-a-b)))
       ; —IN—
       (add-sierpinski scene3 c mid-c-a mid-b-c))]))

; uncomment to run
; (add-sierpinski MT A B C)


