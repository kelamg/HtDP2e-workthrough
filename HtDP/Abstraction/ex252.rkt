;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex252) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

; [List-of Number] -> Number
(define (product l)
  (cond
    [(empty? l) 1]
    [else
     (* (first l)
        (product
          (rest l)))]))

	
; [List-of Posn] -> Image
(define (image* l)
  (cond
    [(empty? l) emt]
    [else
     (place-dot
      (first l)
      (image* (rest l)))]))
 
; Posn Image -> Image 
(define (place-dot p img)
  (place-image
     dot
     (posn-x p) (posn-y p)
     img))
 
; graphical constants:    
(define emt
  (empty-scene 100 100))
(define dot
  (circle 3 "solid" "red"))

;; [X Y -> Y] Y [List-of X] -> Number
;; abstract fold function
(check-expect
 (fold2 + 0 (list 3 7 10)) 20)
(check-expect
 (fold2 cons '() (list 3 7 10)) (list 3 7 10))
(check-expect
 (fold2 place-dot emt (list (make-posn 49 42) (make-posn 12 83)))
 (place-dot (make-posn 49 42)
            (place-dot (make-posn 12 83) emt)))

(define (fold2 fn b l)
  (cond
    [(empty? l) b]
    [else
     (fn (first l)
         (fold2 fn b (rest l)))]))