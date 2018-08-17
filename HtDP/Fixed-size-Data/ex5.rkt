;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ex5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require 2htdp/image)

(define tree-size 50)

(above (star-polygon (/ tree-size 2) 10 3 "solid" "green")
       (rectangle (/ tree-size 4) tree-size "solid" "brown"))