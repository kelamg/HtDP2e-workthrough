;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex492) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define cyclic-graph
  '((A (B E))
    (B (E F))
    (C (B D))
    (D ())
    (E (C F))
    (F (D))
    (G ())))

; Node Node Graph -> [Maybe Path]
; finds a path from origination to destination in G
; if there is no path, the function produces #false
(check-expect (find-path 'C 'D cyclic-graph)
              '(C B F D))
(check-member-of (find-path 'E 'D cyclic-graph)
                 '(E F D) '(E C D))
(check-expect (find-path 'C 'G cyclic-graph)
              #false)

(define (find-path origination destination G)
  (local ((define (find-path/a origination destination G seen)
            (cond
              [(symbol=? origination destination) (list destination)]
              [else (local ((define next (neighbors origination G))
                            (define candidate
                              (find-path/list next destination G
                                              (cons origination seen))))
                      (cond
                        [(boolean? candidate) #false]
                        [else (cons origination candidate)]))]))

          ; [List-of Node] Node Graph [List-of Node] -> [Maybe Path]
          ; finds a path from some node on lo-Os to D
          ; if there is no path, the function produces #false
          (define (find-path/list lo-Os D G seen)
            (cond
              [(empty? lo-Os) #false]
              [(member? (first lo-Os) seen) #false]
              [else (local ((define candidate
                              (find-path/a (first lo-Os) D G seen)))
                      (cond
                        [(boolean? candidate)
                         (find-path/list (rest lo-Os) D G seen)]
                        [else candidate]))])))
    
    (find-path/a origination destination G '())))

; Node Graph -> Neighbours
;; produces the nodes to which one edge exists from node n
(define (neighbors n g)
  (local ((define found (assq n g)))
    (if (false? found) (error "node does not exist") (second found))))
