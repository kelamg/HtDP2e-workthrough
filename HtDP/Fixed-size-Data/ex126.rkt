;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex126) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct point [x y z])
(define-struct none  [])

(make-point 1 2 3) ; 1

(make-point (make-point 1 2 3) 4 5) ; 2

(make-point (+ 1 2) 3 4) ; 3

(make-none) ; 4

(make-point (point-x (make-point 1 2 3)) 4 5) ; 5


;; 1 is a structure value. The constructor returns a structure value.

;; 2 is a structure value. The constructor returns a structure value
;; after evaluating the nested structure value.

;; 3 is a structure value. The constructor returns a structure value
;; after evaluating the nested primitive call expression.

;; 4 is a structure value. The constructor returns a structure value,
;; albeit a not very useful.

;; 5 is a structure value. The constructor returns a structure value
;; after evaluating the nested selector expression.