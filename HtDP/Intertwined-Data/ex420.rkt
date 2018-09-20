;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex420) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [List-of Number] -> Number
;; sums up all numbers in a list
(check-expect (sum '(2 4 6 8)) 20)

(define (sum l)
  (foldl + 0 l))

(define (oscillate n)
  (local ((define (O i)
            (cond
              [(> i n) '()]
              [else
               (cons (expt #i-0.99 i) (O (+ i 1)))])))
    (O 1)))

(oscillate 15)

(sum (oscillate #i1000.0))
(sum (reverse (oscillate #i1000.0)))

(- (* 1e+16 (sum (oscillate #i1000.0)))
   (* 1e+16 (sum (reverse (oscillate #i1000.0)))))