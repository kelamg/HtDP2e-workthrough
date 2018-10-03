;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex481) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define QUEENS 8)

; A QP is a structure:
;   (make-posn CI CI)

; A CI is an N in [0,QUEENS).
; interpretation (make-posn r c) denotes the square at 
;                the r-th row and c-th column

(define C1 (make-posn 1 5))
(define C2 (make-posn 2 6))
(define C3 (make-posn 2 7))
(define C4 (make-posn 0 7))

; data example: [List-of QP]
(define 4QUEEN-SOLUTION-2
  (list  (make-posn 0 2) (make-posn 1 0)
         (make-posn 2 3) (make-posn 3 1)))
(define 4QUEEN-SOLUTION-1
  (list  (make-posn 0 1) (make-posn 1 3)
         (make-posn 2 0) (make-posn 3 2)))

;; [List-of X] [List-of X] -> Boolean
;; determines whether la and lb contain the same items
(check-expect (set=? '(1 3 4) '(4 1 3))  #true)
(check-expect (set=? '(1 3 5) '(4 1 3)) #false)
(check-expect (set=? '(1 3 5)   '(1 3)) #false)

(define (set=? la lb)
  (cond
    [(and (empty? la) (empty? lb)) #true]
    [(member? (first la) lb) (set=? (rest la) (remove (first la) lb))]
    [else #false]))
 
; [List-of QP] -> Boolean
; is the result equal [as a set] to one of two lists
(check-expect (is-queens-result? 4QUEEN-SOLUTION-2) #true)
(check-expect (is-queens-result? (rest 4QUEEN-SOLUTION-2)) #false)

(define (is-queens-result? x)
  (or (set=? 4QUEEN-SOLUTION-1 x)
      (set=? 4QUEEN-SOLUTION-2 x)))

;; QP QP -> Boolean
;; produces #true if queens placed on both squares would
;; threaten each other
(check-expect (threatening? C1 C2)  #true)
(check-expect (threatening? C2 C3)  #true)
(check-expect (threatening? C3 C4)  #true)
(check-expect (threatening? C1 C3) #false)
(check-expect (threatening? C1 C4) #false)
(check-expect (threatening? C2 C4) #false)

(define (threatening? ca cb)
  (or (or (= (posn-x ca) (posn-x cb))
          (= (posn-y ca) (posn-y cb)))
      (=  (abs (- (posn-x ca) (posn-x cb)))
          (abs (- (posn-y ca) (posn-y cb))))))
