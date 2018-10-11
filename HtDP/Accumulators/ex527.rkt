;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex527) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

(define MT (empty-scene 400 400))
(define CL 'red)

(define TRIVIAL   15)
(define L-S      1/3)
(define L-R      0.1) ; in radians
(define R-S      1/5)
(define R-R     0.15) ; in radians

; Image Number Number Number Number -> Image
; fractal Savannah tree
(define (add-savannah img x y l θ)
  (cond
    [(<= l TRIVIAL) img]
    [else
     (local
       ((define rotate-x (* l (cos θ)))
        (define rotate-y (* l (sin θ)))
        (define line
          (scene+line img x y (+ x rotate-x) (- y rotate-y) CL))
        (define left-branch
          (add-savannah line
                        (+ x (* 1/3 rotate-x))
                        (- y (* 1/3 rotate-y))
                        (* l (- 1 L-S))
                        (+ θ L-R))))
       (add-savannah left-branch
                     (+ x (* 2/3 rotate-x))
                     (- y (* 2/3 rotate-y))
                     (* l (- 1 R-S))
                     (- θ R-R)))]))

; uncomment to draw Savannah tree
; (add-savannah MT 200 400 150 (/ pi 2))
