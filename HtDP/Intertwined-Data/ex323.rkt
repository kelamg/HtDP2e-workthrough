;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex323) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct no-info [])
(define NONE (make-no-info))
 
(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; – NONE
; – (make-node Number Symbol BT BT)

(define BT1 (make-node 15 'd NONE (make-node 24 'i NONE NONE)))
(define BT2 (make-node 15 'd (make-node 87 'h NONE NONE) NONE))

;; BT N -> Boolean
;; produces true if n is contained in bt
(check-expect (contains-bt? NONE  5) #false)
(check-expect (contains-bt?  BT1  5) #false)
(check-expect (contains-bt?  BT1 15)  #true)
(check-expect (contains-bt?  BT2 30) #false)
(check-expect (contains-bt?  BT2 87)  #true)

(define (contains-bt? bt n)
  (cond
    [(no-info? bt) #false]
    [else (or (= (node-ssn bt) n)
              (contains-bt? (node-left  bt) n)
              (contains-bt? (node-right bt) n))]))

;; BT N -> Symbol or #false
;; produces the name of the node whose ssn field is n
;; #false if n is not in bt 
(check-expect (search-bt NONE  5) #false)
(check-expect (search-bt  BT1  5) #false)
(check-expect (search-bt  BT1 15)     'd)
(check-expect (search-bt  BT1 24)     'i)
(check-expect (search-bt  BT2 30) #false)
(check-expect (search-bt  BT2 87)     'h)

(define (search-bt bt n)
  (cond
    [(no-info? bt)               #false]
    [(= (node-ssn bt) n) (node-name bt)]
    [else (if (contains-bt? (node-left bt) n)
              (search-bt (node-left  bt) n)
              (search-bt (node-right bt) n))]))
