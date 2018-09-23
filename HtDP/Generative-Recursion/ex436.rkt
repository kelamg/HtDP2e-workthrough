;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex436) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define MAX 200)

; Posn -> Posn 
; produces a randomly chosen Posn that is guaranteed to be
; distinct from the given one
; termination food-create terminates when the randomly generated
;             posn is not the same as the given posn, which is
;             bound to happen given that the probability of choosing
;             a random number different from the given one is
;             (sub1 MAX) / MAX
(define (food-create p)
  (local (; Posn Posn -> Posn 
          ; generative recursion 
          ; choses a new Posn if the p is same as the previous one
          (define (food-check-create p candidate)
            (if (equal? p candidate) (food-create p) candidate)))
          
    (food-check-create
     p (make-posn (random MAX) (random MAX)))))
