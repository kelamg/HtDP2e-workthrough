;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex193) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

; An NELoP is one of: 
; – (cons Posn '())
; – (cons Posn NELoP)

; A Polygon is one of:
; – (list Posn Posn Posn)
; – (cons Posn Polygon)

; a plain background image 
(define MT (empty-scene 50 50))

(define triangle-p
  (list
    (make-posn 20 10)
    (make-posn 20 20)
    (make-posn 30 20)))

(define square-p
  (list
    (make-posn 10 10)
    (make-posn 20 10)
    (make-posn 20 20)
    (make-posn 10 20)))

; Image Posn Posn -> Image 
; renders a line from p to q into img
(check-expect
 (render-line
  MT
  (make-posn 20 40)
  (make-posn 30 40))
 (scene+line MT 20 40 30 40 "red"))

(define (render-line img p q)
  (scene+line
    img
    (posn-x p) (posn-y p) (posn-x q) (posn-y q)
    "red"))

; Image NELoP -> Image 
; connects the dots in p by rendering lines in img
(check-expect
 (connect-dots MT square-p)
 (scene+line
  (scene+line
   (scene+line MT 10 10 20 10 "red")
   20 10 20 20 "red")
  20 20 10 20 "red"))

(define (connect-dots img p)
  (cond
    [(empty? (rest p)) img]
    [else
     (render-line
      (connect-dots img (rest p))
      (first p)
      (second p))]))

; NELoP -> Posn
; extracts the last item from p
(check-expect
 (last (list (make-posn 40 50)))
 (make-posn 40 50))
(check-expect
 (last square-p)
 (make-posn 10 20))

(define (last p)
  (cond
    [(empty? (rest p)) (first p)]
    [else (last (rest p))]))


; Image Polygon -> Image 
; adds an image of p to img
(check-expect
 (render-poly.v1 MT triangle-p)
 (scene+line
  (scene+line
   (scene+line MT 20 10 20 20 "red")
   20 20 30 20 "red")
  30 20 20 10 "red"))
(check-expect
 (render-poly.v1 MT square-p)
 (scene+line
  (scene+line
   (scene+line
    (scene+line MT 10 10 20 10 "red")
    20 10 20 20 "red")
   20 20 10 20 "red")
  10 20 10 10 "red"))

(define (render-poly.v1 img p)
  (connect-dots img (cons (last p) p)))

; Image Polygon -> Image 
; adds an image of p to img
(check-expect
 (render-poly.v2 MT triangle-p)
 (scene+line
  (scene+line
   (scene+line MT 20 10 20 20 "red")
   20 20 30 20 "red")
  30 20 20 10 "red"))
(check-expect
 (render-poly.v2 MT square-p)
 (scene+line
  (scene+line
   (scene+line
    (scene+line MT 10 10 20 10 "red")
    20 10 20 20 "red")
   20 20 10 20 "red")
  10 20 10 10 "red"))

(define (render-poly.v2 img p)
  (connect-dots img (add-at-end (first p) p)))

;; Posn NELoP -> NELoP
;; adds pos to the end of p
(check-expect
 (add-at-end (make-posn 50 35) (list (make-posn 50 35)))
 (list (make-posn 50 35) (make-posn 50 35)))
(check-expect
 (add-at-end
  (make-posn 15 50)
  (list (make-posn 15 50) (make-posn 54 13) (make-posn 8 10)))
 (list (make-posn 15 50)
       (make-posn 54 13)
       (make-posn 8 10)
       (make-posn 15 50)))

(define (add-at-end pos p)
  (cond
    [(empty? (rest p))
     (cons (first p) (cons pos '()))]
    [else
     (cons (first p) (add-at-end pos (rest p)))])) 
