;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex142) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

; ImageOrFalse is one of:
; – Image
; – #false

(define LOI0 '())
(define LOI1 (cons (rectangle 20 10 "solid" "blue") '()))
(define LOI2 (cons (rectangle 20 10 "solid" "blue")
                   (cons (square 4 "solid" "green") '())))
(define LOI3 (cons (square 4 "solid" "red")
                   (cons (circle 20 "solid" "blue")
                         (cons (square 4 "solid" "green") '()))))
(define LOI4 (cons (square 4 "solid" "red") 
                   (cons (square 4 "solid" "green") '())))
(define LOI5 (cons (square 3 "solid" "red")
                   (cons (ellipse 20 10 "solid" "blue")
                         (cons (square 4 "solid" "green") '()))))

;; List-of-images PositiveNumber -> ImageOrFalse
;; produces the first image on loi that is not an n by n square
;; if the image cannot be found, produces #false
(check-expect (ill-sized? LOI0 4) #false)
(check-expect (ill-sized? LOI1 4) (rectangle 20 10 "solid" "blue"))
(check-expect (ill-sized? LOI2 4) (rectangle 20 10 "solid" "blue"))
(check-expect (ill-sized? LOI3 4) (circle 20 "solid" "blue"))
(check-expect (ill-sized? LOI4 4) #false)
(check-expect (ill-sized? LOI5 4) (square 3 "solid" "red"))
(check-expect (ill-sized? LOI5 3) (ellipse 20 10 "solid" "blue"))

(define (ill-sized? loi n)
  (cond
    [(empty? loi)                            #false]
    [(not
      (= (* (image-width (first loi))
            (image-height (first loi)))
         (* n n)))                      (first loi)]
    [else
     (ill-sized? (rest loi) n)]))
