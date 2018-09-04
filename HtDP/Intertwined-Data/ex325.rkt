;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex325) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct no-info [])
(define NONE (make-no-info))
 
(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; – NONE
; – (make-node Number Symbol BT BT)

;; A BST (short for binary search tree) is a BT according to the following conditions:
;; - NONE is always a BST.
;; - (make-node ssn0 name0 L R) is a BST if
;; - L is a BST,
;; - R is a BST,
;; - all ssn fields in L are smaller than ssn0,
;; - all ssn fields in R are larger than ssn0.

(define BST1 (make-node 15 'd NONE (make-node 24 'i NONE NONE)))
(define BST2 (make-node 90 'd (make-node 87 'h NONE NONE) NONE))
(define BST3 (make-node 15 'd
                       (make-node 4 'g (make-node 1 'p NONE NONE) NONE)
                       (make-node 19 'o
                                  (make-node 16 'e NONE NONE)
                                  (make-node 45 'q NONE NONE))))

;; BST N -> Symbol or NONE
;; if bst contains a node whose ssn field is n,
;; the value of the name field is produced
;; NONE produced otherwise
(check-expect (search-bst NONE 15) NONE)
(check-expect (search-bst BST1  5) NONE)
(check-expect (search-bst BST1 15)   'd)
(check-expect (search-bst BST2 87)   'h)
(check-expect (search-bst BST3 45)   'q)

(define (search-bst bst n)
  (cond
    [(no-info? bst)                 NONE]
    [(= n (node-ssn bst)) (node-name bst)]
    [else (if (< n (node-ssn bst))
              (search-bst (node-left  bst) n)
              (search-bst (node-right bst) n))]))
