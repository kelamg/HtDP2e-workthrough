;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex281) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

(define-struct ir (name price))
;; An InventoryRecord is (make-ir String Number)

((lambda (x) (< x 10)) 5)

((lambda (x y) (number->string (* x y))) 3 4)

((lambda (x) (if (even? x) 0 1)) 10)

((lambda (ir1 ir2)
   (< (ir-price ir1) (ir-price ir2)))
 (make-ir "bear" 10) (make-ir "dignity" 2.50))

((lambda (p img)
   (place-image
    (circle 5 "solid" "red") (posn-x p) (posn-y p) img))
 (make-posn 42 50) (empty-scene 100 200))