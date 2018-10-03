;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex471) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A Node is a Symbol.

; A DestinationNode is a Node

; A Neighbors is a [List-of DestinationNode]

; A Graph is a [List-of [List-of Node Neighbours]]

(define sample-graph-quote
  '((A (B E))
    (B (E F))
    (C (D))
    (D ())
    (E (C F))
    (F (D G))
    (G ())))

(define sample-graph-list
  (list (list 'A (list 'B 'E))
        (list 'B (list 'E 'F))
        (list 'C (list 'D))
        (list 'D '())
        (list 'E (list 'C 'F))
        (list 'F (list 'D 'G))
        (list 'G '())))

(check-expect sample-graph-quote sample-graph-list)

(define G sample-graph-list)


;; Node Graph -> Neighbours
;; produces the nodes to which one edge exists from node n
(check-expect (neighbors 'A G) '(B E))
(check-expect (neighbors 'G G) '())

(define (neighbors n g)
  (local ((define found (assq n g)))
    (if (false? found) (error "no edges exist") (second found))))
