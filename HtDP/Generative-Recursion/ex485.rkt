;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex485) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; A NumberTree is one of:
;; - Number
;; - (list NumberTree NumberTree)

(define T0 5)
(define T1 (list 2 5))
(define T3 (list 10 (list 2 5)))
(define T4 (list (list 3 (list 9 11)) (list 16 24)))

;; NumberTree -> Number
;; produces the sum of the numbers in t
(check-expect (sum-tree T0)  5)
(check-expect (sum-tree T1)  7)
(check-expect (sum-tree T3) 17)
(check-expect (sum-tree T4) 63)

(define (sum-tree t)
  (cond
    [(number? t) t]
    [else (+ (sum-tree (first t))
             (sum-tree (second t)))]))

;; Q - What is its abstract running time?
;; A - It runs on the order of n where n is the number of nodes in the tree.


;; Q - What is an acceptable measure of the size of such a tree?
;; A - Its number of nodes (numbers).


;; Q - What is the worst possible shape of the tree?
;; A - A tree with two branches the whole way down to the nodes i.e. all leaf
;;     nodes are at the deepest level of the tree.


;; Q - What’s the best possible shape?
;; A - A tree with only one node.
