;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex443) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (gcd-structural n m)
  (cond
    [(and (= n 1) (= m 1)) ...]
    [(and (> n 1) (= m 1)) ...]
    [(and (= n 1) (> m 1)) ...]
    [else
     (... (gcd-structural (sub1 n) (sub1 m)) ...
      ... (gcd-structural (sub1 n) m) ...
      ... (gcd-structural n (sub1 m)) ...)]))

;; Q - Why is it impossible to find a divisor with this strategy?

;; A - Just by observing the structure of the template, the three recursive
;;     calls in the else clause is enough to arouse doubts. They seem to be
;;     recursing on smaller problems, but problems whose solutions seem to
;;     be impossible to combine to solve the initial problem.
