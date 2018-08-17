;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex159) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; Constants
(define ROWS    18)
(define COLS     8)
(define SIZE    10)
(define IMG     (square SIZE "outline" "black"))
(define BALLOON (circle 3 "solid" "red"))

(define-struct pair [balloon# lob])
; A Pair is a structure (make-pair N List-of-posns)
; A List-of-posns is one of: 
; – '()
; – (cons Posn List-of-posns)
; interpretation (make-pair n lob) means n balloons 
; must yet be thrown and added to lob

(define P1 (make-pair 2 '()))
(define P2
  (make-pair 1 (cons (make-posn 100 120) '())))
(define P3
  (make-pair 3
             (cons (make-posn 40 90)
                   (cons (make-posn 80 50)
                         (cons (make-posn 120 155) '())))))
(define P4 (make-pair 0 (cons (make-posn 100 200) '())))

;; N Image -> Image
;; produces a vertical arrangement of n copies of img
(check-expect (col 0 IMG) empty-image)
(check-expect (col 2 IMG) (above IMG IMG))
(check-expect (col 5 IMG) (above IMG IMG IMG IMG IMG))

(define (col n img)
  (cond
    [(zero? n) empty-image]
    [else (above img (col (sub1 n) img))]))

;; N Image -> Image
;; produces a horizontal arrangement of n copies of img
(check-expect (row 0 IMG) empty-image)
(check-expect (row 2 IMG) (beside IMG IMG))
(check-expect (row 5 IMG) (beside IMG IMG IMG IMG IMG))

(define (row n img)
  (cond
    [(zero? n) empty-image]
    [else (beside img (row (sub1 n) img))]))

(define BACKGROUND (empty-scene (* COLS SIZE) (* ROWS SIZE)))
(define MTS (col ROWS (row COLS IMG)))

;; A Pair is the state of the world

;; Pair -> Pair
;; lecture hall riot
;; run with (riot N)
(define (riot n)
  (big-bang (make-pair n '())
    [to-draw    add-balloons]
    [on-tick throw-balloon 1]))

;; Pair -> Image
;; consumes a Pair and produces an image of MTS with balloons added
;; as specified by each lob in the Pair
(check-expect (add-balloons P1) MTS)
(check-expect (add-balloons P2)
              (place-image BALLOON 100 120 MTS))
(check-expect
 (add-balloons P3)
 (place-image BALLOON 40 90
              (place-image BALLOON 80 50
                           (place-image BALLOON 120 155 MTS))))

(define (add-balloons p)
  (process-balloons (pair-lob p)))

;; List-of-posns -> Image
;; renders the images of the balloons into MTS
(define (process-balloons lop)
  (cond
    [(empty? lop) MTS]
    [else
     (place-image BALLOON
                  (posn-x (first lop))
                  (posn-y (first lop))
                  (process-balloons (rest lop)))]))


;; Pair -> Pair
;; adds another balloon at a random position to lob
;; as long as balloon# is above 0
(define (throw-balloon p)
  (throw p
         (make-posn (random (image-width MTS))
                    (random (image-height MTS)))))

;; Pair Posn -> Pair
;; makes a new pair with one less balloon remaining to add
;; and a new balloon added to lob
(check-expect (throw P1 (make-posn 50 130))
              (make-pair 1 (cons (make-posn 50 130) '())))
(check-expect (throw P2 (make-posn 20 25))
              (make-pair 0 (cons (make-posn 20 25)
                                 (cons (make-posn 100 120) '()))))
(check-expect
 (throw P3 (make-posn 75 80))
 (make-pair
  2 (cons (make-posn 75 80)
          (cons (make-posn 40 90)
                   (cons (make-posn 80 50)
                         (cons (make-posn 120 155) '()))))))
(check-expect (throw P4 (make-posn 15 100)) P4)

(define (throw p pos)
  (if (zero? (pair-balloon# p))
      p
      (make-pair (sub1 (pair-balloon# p))
                 (cons pos (pair-lob p)))))


                         