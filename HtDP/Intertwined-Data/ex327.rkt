;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex327) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

(define TREE-A
  (make-node 63 'a
             (make-node 29 'b
                        (make-node 15 'd
                                   (make-node 10 'h NONE NONE)
                                   (make-node 24 'i NONE NONE))
                        NONE)
             (make-node 89 'c
                        (make-node 77 'l NONE NONE)
                        (make-node 95 'g NONE (make-node 99 'o NONE NONE)))))

(define BST1 (make-node 15 'd NONE (make-node 24 'i NONE NONE)))
(define BST2 (make-node 90 'd (make-node 87 'h NONE NONE) NONE))
(define BST3 (make-node 15 'd
                       (make-node 4 'g (make-node 1 'p NONE NONE) NONE)
                       (make-node 19 'o
                                  (make-node 16 'e NONE NONE)
                                  (make-node 45 'q NONE NONE))))

;; BST N Symbol -> BST
;; consumes B, N and S, and produces a BST just like B
;; and that in place of one NONE subtree, contains the node structure
;; (make-node N S NONE NONE)
(check-expect
 (create-bst NONE 5 'a) (make-node 5 'a NONE NONE))
(check-expect
 (create-bst BST1 5 'a)
 (make-node 15 'd (make-node 5 'a NONE NONE) (make-node 24 'i NONE NONE)))
(check-expect
 (create-bst BST2 5 'a)
 (make-node 90 'd (make-node 87 'h (make-node 5 'a NONE NONE) NONE) NONE))
(check-expect
 (create-bst BST3 5 'a)
 (make-node 15 'd
            (make-node 4 'g (make-node 1 'p NONE NONE) (make-node 5 'a NONE NONE))
            (make-node 19 'o
                       (make-node 16 'e NONE NONE)
                       (make-node 45 'q NONE NONE))))
 
(define (create-bst B N S)
  (cond
    [(no-info? B) (make-node N S NONE NONE)]
    [else
     (local ((define this.ssn   (node-ssn   B))
             (define this.name  (node-name  B))
             (define this.left  (node-left  B))
             (define this.right (node-right B)))
       
       (if (< N (node-ssn B))
         (make-node
          this.ssn this.name (create-bst this.left N S) this.right)
         (make-node
          this.ssn this.name this.left (create-bst this.right N S))))]))

;; [List-of [List Number Symbol]] -> BST
;; produces a BST from the number and name pairs in l
(check-expect (create-bst-from-list '()) NONE)
(check-expect
 (create-bst-from-list '((99 o) (77 l) (24 i) (10 h) (95 g)
                                (15 d) (89 c) (29 b) (63 a)))
 TREE-A)

(define (create-bst-from-list l)   
  (foldr (λ (p bst) (create-bst bst (first p) (second p))) NONE l))

;; Q - If you use an existing abstraction, you may still get this tree
;;     but you may also get an “inverted” one. Why?

;; A - If foldl is used, the resulting tree is an inverted one.
;;     This happens because foldl processes the list, whose items
;;     are already ordered to produce an inverted tree, from left to right.
;;     When foldr is used instead, the resulting tree is identical to the
;;     one in figure 119, as it processes the list from right to left.
;;     The list could also be first reversed before being passed to foldl.
