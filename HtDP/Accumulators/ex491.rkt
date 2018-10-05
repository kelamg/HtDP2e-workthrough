;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex491) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; [List-of Number] -> [List-of Number]
; converts a list of relative to absolute distances
; the first number represents the distance to the origin
 
(check-expect (relative->absolute '(50 40 70 30 30))
              '(50 90 160 190 220))

(define (relative->absolute l)
 (reverse
   (foldr (lambda (f l) (cons (+ f (first l)) l))
          (list (first l))
          (reverse (rest l)))))

; design reverse to see how it operates on relative->absolute
(define (myreverse l)
  (cond
    [(empty? l) '()]
    [else (append (myreverse (rest l))
                  (list (first l)))]))


;; Q - Does your friend’s solution mean there is no need for our
;;     complicated design in this motivational section?

;; A - reverse visits every element of a given list and so does foldr.
;;     For a call to relative->absolute, the entire rest of the list is
;;     traversed in a call to reverse, then its result is traversed by
;;     foldr after which it is again processed by another reverse call.
;;     These calls are not nested, meaning that if the number of items in
;;     l are doubled, then the time taken will consequently double.
;;     Thus, while the number of operations in this implementation is 3n,
;;     it is still in the order of O(n) as 3n is indeed a linear relationship.

