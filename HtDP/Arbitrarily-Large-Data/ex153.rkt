;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex153) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define ROWS 18)
(define COLS 8)
(define SIZE 10)
(define IMG (square SIZE "outline" "black"))
(define BALLOON (circle 3 "solid" "red"))

;; N Image -> Image
;; produces a vertical arrangement of n copies of img
(check-expect (col 0 IMG) empty-image)
(check-expect (col 2 IMG) (above IMG IMG))
(check-expect (col 5 IMG) (above IMG IMG IMG IMG IMG))

(define (col n img)
  (cond
    [(zero? n) empty-image]
    [else
     (above img
            (col (sub1 n) img))]))

;; N Image -> Image
;; produces a horizontal arrangement of n copies of img
(check-expect (row 0 IMG) empty-image)
(check-expect (row 2 IMG) (beside IMG IMG))
(check-expect (row 5 IMG) (beside IMG IMG IMG IMG IMG))

(define (row n img)
  (cond
    [(zero? n) empty-image]
    [else
     (beside img
             (row (sub1 n) img))]))

(define BACKGROUND
  (empty-scene (* COLS SIZE) (* ROWS SIZE)))

(define MTS (col ROWS (row COLS IMG)))


;; List-of-Posn -> Image
;; consumes a lop and produces an image of MTS with red dots added
;; as specified by each Posn
(check-expect (add-balloons '()) MTS)
(check-expect (add-balloons
               (cons (make-posn 5 10) '()))
              (place-image BALLOON 5 10 MTS))
(check-expect (add-balloons
               (cons (make-posn 5 10)
                     (cons (make-posn 50 120) '())))
              (place-image BALLOON 5 10
                           (place-image BALLOON 50 120 MTS)))

(define (add-balloons lop)
  (cond
    [(empty? lop) MTS]
    [else
     (place-image BALLOON
                  (posn-x (first lop))
                  (posn-y (first lop))
                  (add-balloons (rest lop)))]))

;; The last image in figure 60 is 10 by 20 squares which means the 10th
;; dot is placed in the bottom right corner

(add-balloons
 (cons (make-posn 0 0)
       (cons (make-posn 10 20)
             (cons (make-posn 20 40)
                   (cons (make-posn 30 60)
                         (cons (make-posn 40 80)
                               (cons (make-posn 50 100)
                                     (cons (make-posn 60 120)
                                           (cons (make-posn 70 140) '())))))))))
