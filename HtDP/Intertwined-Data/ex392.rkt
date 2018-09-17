;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex392) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct branch [left right])
     
; A TOS is one of:
; – Symbol
; – (make-branch TOS TOS)

; A Direction is one of:
; – 'left
; – 'right

; A Path is [List-of Direction]


;; TOS Path -> [Or Symbol error]
;; returns the symbol to which the path points in the tree
;; produces an error when given a symbol and a non-empty path,
;;                     or a branch and an empty path
(check-expect
 (tree-pick 'a '()) 'a)
(check-expect
 (tree-pick (make-branch 'a 'b) '(left)) 'a)
(check-expect
 (tree-pick (make-branch 'a (make-branch 'b 'c)) '(right left)) 'b)
(check-error (tree-pick 'a '(left)) "out of routes")
(check-error (tree-pick (make-branch 'a 'b) '(left left)))
(check-error (tree-pick (make-branch 'a 'b) '()) "out of paths")

(define (tree-pick t p)
  (cond
    [(symbol? t) (if (empty? p) t (error "out of routes"))]
    [(branch? t) (cond [(empty? p) (error "out of paths")]
                       [else (if (symbol=? (first p) 'left)
                                 (tree-pick (branch-left  t) (rest p))
                                 (tree-pick (branch-right t) (rest p)))])]))