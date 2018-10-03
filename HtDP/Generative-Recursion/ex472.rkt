;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex472) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

; A Node is a Symbol.

; A DestinationNode is a Node

; A Neighbors is a [List-of DestinationNode]

; A Graph is a [List-of [List-of Node Neighbours]]

; A Path is a [List-of Node].
; interpretation The list of nodes specifies a sequence
; of immediate neighbors that leads from the first 
; Node on the list to the last one. 

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


; Node Node Graph -> [Maybe Path]
; finds a path from origination to destination in G
; if there is no path, the function produces #false
(check-expect (find-path 'C 'D G)
              '(C D))
(check-member-of (find-path 'E 'D G)
                 '(E F D) '(E C D))
(check-expect (find-path 'C 'G G)
              #false)
 
(define (find-path origination destination G)
  (cond
    [(symbol=? origination destination) (list destination)]
    [else (local ((define next (neighbors origination G))
                  (define candidate
                    (find-path/list next destination G)))
            (cond
              [(boolean? candidate) #false]
              [else (cons origination candidate)]))]))

; [List-of Node] Node Graph -> [Maybe Path]
; finds a path from some node on lo-originations to
; destination; otherwise, it produces #false
(define (find-path/list lo-Os D G)
  (cond
    [(empty? lo-Os) #false]
    [else (local ((define candidate
                    (find-path (first lo-Os) D G)))
            (cond
              [(boolean? candidate)
               (find-path/list (rest lo-Os) D G)]
              [else candidate]))]))

;; Node Graph -> Neighbours
;; produces the nodes to which one edge exists from node n
(check-expect (neighbors 'A G) '(B E))
(check-expect (neighbors 'G G) '())

(define (neighbors n g)
  (local ((define found (assq n g)))
    (if (false? found) (error "node does not exist") (second found))))


;; Q - Test find-path. Use the function to find a path from 'A to 'G in
;;     sample-graph. Which one does it find? Why?

;; > (find-path 'A 'G G)
;; (list 'A 'B 'E 'F 'G)

;; A - While (list 'A 'E 'F 'G) or (list 'A 'B 'F 'G) would also have been
;;     a valid path, the function specifically finds the path by testing the
;;     the current node's edges and moving from there. Thus, it picks the first
;;     node in the neighbours list, and that is why the result contains 'B, the
;;     first node in 'A's neighbours list, and 'E, the first node in 'B's
;;     neighbours list.

(define all-have-paths
  '((A (B))
    (B (E))
    (E (A))))

;; Graph -> Boolean
;; produces #true if there is a path between any pair of nodes
(check-expect (test-on-all-nodes G) #false)
(check-expect (test-on-all-nodes all-have-paths) #true)

(define (test-on-all-nodes g)
  (local ((define all-nodes (map first g))
          (define all-pairs
            (for*/list ([i all-nodes] [j all-nodes])
              (list i j))))
    
    (for/and ([pair all-pairs])
      (cons? (find-path (first pair) (second pair) g)))))

