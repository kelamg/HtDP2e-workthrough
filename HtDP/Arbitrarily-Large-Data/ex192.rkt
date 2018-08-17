;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex192) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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
 
; Image Polygon -> Image
; renders the given polygon p into img
(check-expect
 (render-poly MT triangle-p)
 (scene+line
  (scene+line
   (scene+line MT 20 10 20 20 "red")
   20 20 30 20 "red")
  30 20 20 10 "red"))
#;
(check-expect ; throws error
 (render-poly MT square-p)
 (scene+line
  (scene+line
   (scene+line
    (scene+line MT 10 10 20 10 "red")
    20 10 20 20 "red")
   20 20 10 20 "red")
  10 20 10 10 "red"))

(define (render-poly img p)
  (cond
    [(empty? (rest (rest (rest p))))
     (render-line
      (render-line
       (render-line MT (first p) (second p))
       (second p) (third p))
      (third p) (first p))]
    [else
     (render-line (render-poly img (rest p))
                  (first p)
                  (second p))]))

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

; Image Polygon -> Image 
; adds an image of p to img
(check-expect
 (render-polygon MT triangle-p)
 (scene+line
  (scene+line
   (scene+line MT 20 10 20 20 "red")
   20 20 30 20 "red")
  30 20 20 10 "red"))
(check-expect
 (render-polygon MT square-p)
 (scene+line
  (scene+line
   (scene+line
    (scene+line MT 10 10 20 10 "red")
    20 10 20 20 "red")
   20 20 10 20 "red")
  10 20 10 10 "red"))

(define (render-polygon img p)
  (render-line (connect-dots img p)
               (first p)
               (last p)))

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

;; Why is it acceptable to use first for the stub definition of last?
;; ---|
;; It is the base case clause. NELoP is non-empty which means
;; there is at least one item on the list.

;; Q - Argue why it is acceptable to use last on Polygons.
;;     Also argue why you may adapt the template for connect-dots to last:
;;
;;     (define (last p)
;;       (cond
;;         [(empty? (rest p)) (... (first p) ...)]
;;         [else (... (first p) ... (last (rest p)) ...)]))
;;
;; A - It is acceptable to use last on Polygons because according to its
;;     data definition, we see that it always has a minimum number of Posns
;;     of 3 and NELop has at least one Posn, which means there will always be
;;     at least one Posn left on the list.  We will never call last on an empty list
;;
;;     The template for connect-dots can be adapted to last because it is a template
;;     for a non-empty list.

