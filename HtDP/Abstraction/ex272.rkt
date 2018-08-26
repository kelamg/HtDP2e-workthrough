;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex272) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

;; [List-of X] [List-of X] -> [List-of X]
;; append la and lb together using an abstract fold function
(check-expect
 (append-from-fold '(1 2 3) '(4 5 6 7 8))
 '(1 2 3 4 5 6 7 8))

(define (append-from-fold la lb)
  (foldr cons lb la))

;; When append-from-fold is used with foldl, the order of the first list
;; becomes reversed.

;; [List-of Number] -> Number
;; produces the sum of all numbers in l
(check-expect (sum '()) 0)
(check-expect
 (sum '(1 2 3 4 5 6 7 8)) 36)

(define (sum l)
  (foldr + 0 l))

;; [List-of Number] -> Number
;; produces the product of all numbers in l
(check-expect
 (product '(1 2 3 4 5)) 120)

(define (product l)
  (foldr * 1 l))

;; [List-of Image] -> Image
;; produces an image of all images in l arranged side by side
(check-expect
 (compose-images-beside (list (rectangle 20 10 "solid" "red")
                              (triangle 30 "solid" "blue")
                              (ellipse 40 20 "outline" "green")))
 (beside (rectangle 20 10 "solid" "red")
         (triangle 30 "solid" "blue")
         (ellipse 40 20 "outline" "green")))

(define (compose-images-beside l)
  (foldr beside empty-image l))

;; foldl also works for compose-images but it reverses the order
;; of the images compared to foldl

;; [List-of Image] -> Image
;; produces an image of all images in l arranged side by side
(check-expect
 (compose-images-above (list (rectangle 20 10 "solid" "red")
                             (triangle 30 "solid" "blue")
                             (ellipse 40 20 "outline" "green")))
 (above (rectangle 20 10 "solid" "red")
        (triangle 30 "solid" "blue")
        (ellipse 40 20 "outline" "green")))

(define (compose-images-above l)
  (foldr above empty-image l))
