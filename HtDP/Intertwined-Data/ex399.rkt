;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex399) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)
(require racket/list)

; [List-of String] -> [List-of String] 
; picks a random non-identity arrangement of names
(define input '("cisse" "gerrard" "baros" "alonso"))
(check-satisfied (gift-pick input) not-same?)

(define (gift-pick names)
  (random-pick
    (non-same names (arrangements names))))

; hard-coded for testing
(define (not-same? l)
  (cond
    [(empty? l) #true]
    [else
     (and
      (not (string=? (list-ref input (- (length input) (length l))) (first l)))
      (not-same? (rest l)))]))

; [NEList-of X] -> X 
; returns a random item from the list
(define (random-pick l)
  (list-ref l (random (length l))))
 
; [List-of String] [List-of [List-of String]] 
; -> 
; [List-of [List-of String]]
; produces the list of those lists in ll that do 
; not agree with names at any place
(check-expect 
 (non-same '("a" "b" "c") '(("a" "b" "c") ("b" "a" "c") ("c" "a" "b")))
 '(("c" "a" "b")))

(define (non-same names ll) 
  (cond
    [(empty? ll) '()]
    [(ormap identity (map string=? names (first ll)))
     (non-same names (rest ll))]
    [else (cons (first ll) (non-same names (rest ll)))]))
 
; [List-of String] -> [List-of [List-of String]]
; returns all possible permutations of names
(check-expect (arrangements '()) '(()))
(check-expect
 (arrangements '("bee" "optimus"))
 '(("bee" "optimus") ("optimus" "bee")))

(define (arrangements names)
  (cond
    [(empty? names) '(())]
    [else
     (for*/list ([name names]
                 [others (arrangements (remove name names))])
       (cons name others))]))
