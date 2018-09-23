;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex432) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define MAX 200)

; Posn -> Posn 
; produces a randomly chosen Posn that is guaranteed to be
; distinct from the given one
(define (food-create p)
  (local (; Posn Posn -> Posn 
          ; generative recursion 
          ; choses a new Posn if the p is same as the previous one
          (define (food-check-create p candidate)
            (if (equal? p candidate) (food-create p) candidate)))
          
    (food-check-create
     p (make-posn (random MAX) (random MAX)))))


;; Q - Justify the design of food-create

;; A - food-create choses another Posn at random, if and only if
;;     the given posn is the same as the newly randomly picked one.
;;     Even though it doesn't look like bundle and quick-sort<'s
;;     definition, it does generate a similar problem to be solved
;;     and it eventually terminates when a different posn from the
;;     given one is produced.