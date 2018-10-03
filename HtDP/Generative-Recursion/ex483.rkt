;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex483) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

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

;; A Board.v1 is a [List-of [List-of QP] [List-of QP]]
;; interp. a board is a two-item list of all positions on the board
;;         and positions where a queen can still be placed

;; A Board.v2 is a [List-of [List-of QP] [List-of QP]]
;; interp. a board is a two-item list of all positions on the board
;;         and positions where a queen has been placed

(define-struct sq (x y threatened?))
;; A Square is a structure:
;;   (make-sq N N Boolean)
;; interp. a representation of a square
;;         (make-sq 2 4 #t) denotes a threatened square
;;         at the 2nd row and 4th column

;; A Board.v3 is a [List-of [List-of Square] [List-of Square]]
;; interp. a board is a two-item list of squares each holding information
;;         about a position and whether or not it is a threatened position,
;;         and a list of squares occupied by a queen

(define B0
  (list (list (make-posn 0 0) (make-posn 0 1) (make-posn 1 0) (make-posn 1 1))
        (list (make-posn 0 0) (make-posn 0 1) (make-posn 1 0) (make-posn 1 1))))

; data example: [List-of QP]
(define 4QUEEN-SOLUTION-2
  (list  (make-posn 0 2) (make-posn 1 0)
         (make-posn 2 3) (make-posn 3 1)))
(define 4QUEEN-SOLUTION-1
  (list  (make-posn 0 1) (make-posn 1 3)
         (make-posn 2 0) (make-posn 3 2)))

;; Board.v1 -> [List-of QP]]
;; get queens positions for a board
(define (get-queens b)
  (filter (λ (qp) (not (member? qp (second b)))) (first b)))

; N -> [Maybe [List-of QP]]
; finds a solution to the n queens problem
(check-expect (n-queens 2) #false)
(check-expect (n-queens 3) #false)
(check-satisfied (n-queens 4) is-queens-result?)

(define (n-queens n)
  (place-queens
   (build-board n make-posn '() posn?) n get-queens remove))

; Board N [Board -> [List-of QP]]
;         [QP [List-of QP] -> [List-of QP]] -> [Maybe [List-of QP]]
; places n queens on board; otherwise, returns #false
(define (place-queens a-board n find-fn add-fn)
  (cond
    [(zero? n) (find-fn a-board)]
    [else (local ((define possible-spots (find-open-spots a-board find-fn)))
            (place-queens/list possible-spots a-board (sub1 n) find-fn add-fn))]))

;; [List-of QP] Board N [QP [List-of QP] -> [List-of QP]] -> [Maybe [List-of Board]]
;; place n queens on all possible spots
;; returns a list of correctly filled boards,
;; or false if not possible
(define (place-queens/list spots a-board n find-fn add-fn)
  (cond
    [(empty? spots) #false]
    [else
     (local ((define candidate
               (place-queens
                (add-queen a-board (first spots) add-fn) n find-fn add-fn)))
       
       (cond
         [(boolean? candidate)
          (place-queens/list (rest spots) a-board n find-fn add-fn)]
         [else candidate]))]))

;; N [X ... -> Y] [List-of Z] [[List-of Y] -> [List-of Y]] -> Board
;; abstract function for building boards out of any data definition
;; creates the initial n by n board
(check-expect
 (build-board 2 make-posn '() posn?) B0)
(check-expect
 (build-board 2 make-sq '(#false) sq?)
 (list (list (make-sq 0 0 #false) (make-sq 0 1 #false)
             (make-sq 1 0 #false) (make-sq 1 1 #false))
       (list (make-sq 0 0 #false) (make-sq 0 1 #false)
             (make-sq 1 0 #false) (make-sq 1 1 #false))))
(check-expect
 (build-board 2 make-sq '(#false) posn?)
 (list (list (make-sq 0 0 #false) (make-sq 0 1 #false)
             (make-sq 1 0 #false) (make-sq 1 1 #false))
       '()))

(define (build-board n fn args selector)
  (local ((define rows (build-list n identity))
          (define grid 
            (for*/list ([i n] [j rows])
              (apply fn (append (list i j) args)))))

    (list grid (filter selector grid))))

;; Board QP [QP [List-of QP] -> [List-of QP]] -> Board 
;; places a queen at qp on a-board
;; fn is the functionality of adding a queen
(check-expect
 (add-queen B0 (make-posn 0 0) remove)
 (list (first B0)
       (list (make-posn 0 1) (make-posn 1 0) (make-posn 1 1))))

(define (add-queen a-board qp fn)
  (cons (first a-board)
        (list (fn qp (second a-board)))))
 
; Board [Board -> [List-of QP]] -> [List-of QP]
; finds spots where it is still safe to place a queen
; fn gets the positions of all queens on the board
(check-expect
 (find-open-spots B0 (λ (b) (list (first (second b))))) '())

(define (find-open-spots a-board fn)
  (local ((define queens-positions (fn a-board))
          (define (safe? qp)
            (andmap (λ (q) (not (threatening? q qp))) queens-positions)))

    (filter safe? (first a-board))))

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
  (local ((define nca (if (sq? ca) (make-posn (sq-x ca) (sq-y ca)) ca))
          (define ncb (if (sq? cb) (make-posn (sq-x cb) (sq-y cb)) cb)))
  
    (or (or (= (posn-x nca) (posn-x ncb))
            (= (posn-y nca) (posn-y ncb)))
        (=  (abs (- (posn-x nca) (posn-x ncb)))
            (abs (- (posn-y nca) (posn-y ncb)))))))
