;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex122) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (f x y)
  (+ (* 3 x) (* y y)))

; ===========================

(+ (f 1 2) (f 2 1))

(+ (+ (* 3 1) (* 2 2))
   (+ (* 3 2) (* 1 1)))

(+ (+ 3 (* 2 2))
   (+ (* 3 2) (* 1 1)))

(+ (+ 3 4)
   (+ (* 3 2) (* 1 1)))

(+ 7
   (+ (* 3 2) (* 1 1)))

(+ 7 (+ 6 (* 1 1)))

(+ 7 (+ 6 1))

(+ 7 7)

14

; ============================

(f 1 (* 2 3))

(+ (* 3 1) (* (* 2 3) (* 2 3)))

(+ 3 (* (* 2 3) (* 2 3)))

(+ 3 (* 6 (* 2 3)))

(+ 3 (* 6 6))

(+ 3 36)

39

; =============================

(f (f 1 (* 2 3)) 19)

(+ (* 3 (f 1 (* 2 3))) (* 19 19))

(+ (* 3 (+ (* 3 1) (* 6 6))) (* 19 19))

(+ (* 3 (+ 3 (* 6 6))) (* 19 19))

(+ (* 3 (+ 3 36)) (* 19 19))

(+ (* 3 39) (* 19 19))

(+ 117 (* 19 19))

(+ 117 361)

478