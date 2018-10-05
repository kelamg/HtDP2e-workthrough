;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex500) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [List-of X] -> N
;; produces the number of items on l
(check-expect (how-many '()) 0)
(check-expect (how-many '(1 5 2 10)) 4)

(define (how-many l)
  (local (; [List-of X] N -> N
          ; accumulator a is the number of items
          ; since counting from the start of l
          (define (how-many/a l0 a)
            (cond
              [(empty? l0) a]
              [else (how-many/a (rest l0) (add1 a))])))

    (how-many/a l 0)))

;; Q - The performance of how-many is O(n) where n is the length of
;;     the list. Does the accumulator version improve on this?

;; A - No. The accumulator traverses the entire list as well which means that
;;     as n increases, so will the time to process the list with the accumulator
;;     style how-many function.

;; Q - When you evaluate (how-many some-non-empty-list) by hand, n applications
;;     of add1 are pending by the time the function reaches '()—where n is the
;;     number of items on the list. Computer scientists sometime say that how-many
;;     needs O(n) space to represent these pending function applications.
;;     Does the accumulator reduce the amount of space needed to compute the result?

;; A - Yes the accumulator reduces the amount of space needed because each recursive
;;     call when carrying an accumulator is a new, non-pending function call i.e. old
;;     function calls do not wait for other recursive calls to finish; thus reducing
;;     the space needed to compute the result.
