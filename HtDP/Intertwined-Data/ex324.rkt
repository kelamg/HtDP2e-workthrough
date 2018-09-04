;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex324) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct no-info [])
(define NONE (make-no-info))
 
(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; – NONE
; – (make-node Number Symbol BT BT)

(define BT1 (make-node 15 'd NONE (make-node 24 'i NONE NONE)))
(define BT2 (make-node 15 'd (make-node 87 'h NONE NONE) NONE))
(define BT3 (make-node 15 'd
                       (make-node 4 'g (make-node 1 'p NONE NONE) NONE)
                       (make-node 19 'o
                                  (make-node 16 'e NONE NONE)
                                  (make-node 45 'q NONE NONE))))

;; BT -> [List-of Number]
;; produces a sequence of all the ssn numbers in the tree
;; as they show up from left to right
(define input1 BT1)
(define input2 BT2)
(define input3 BT3)

(define expected1 '(15 24))
(define expected2 '(87 15))
(define expected3 '(1 4 15 16 19 45))

(check-expect (inorder NONE) '())
(check-expect (inorder input1) expected1)
(check-expect (inorder input2) expected2)
(check-expect (inorder input3) expected3)

(define (inorder bt)
  (cond
    [(no-info? bt) '()]
    [else (append (inorder (node-left  bt))
                  (list (node-ssn bt))
                  (inorder (node-right bt)))]))
