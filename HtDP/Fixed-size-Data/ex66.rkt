;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex66) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; structures

(define-struct movie (title producer year))
;;
(define avengers (make-movie "Marvel's Avengers Assemble" "Marvel" 2012))


(define-struct person (name hair eyes phone))
;; 
(define me (make-person "Mikel" "black" "brown" 09080073571))

(define-struct pet (name number))
;;
(define jerry (make-pet "Jerry" 2))

(define-struct CD (artist title price))
;;
(define lobster-theremin (make-CD "DJ Seinfeld"
                                  "Time spent away from u"
                                  12.99))

(define-struct sweater (material size producer))
;;
(define fave-sweater (make-sweater "Wool" "M" "Pull & Bear"))