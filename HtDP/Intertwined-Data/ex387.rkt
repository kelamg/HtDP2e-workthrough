;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex387) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

;; [List-of Symbol] [List-of Number] -> [List-of [List-of Symbol Number]]
;; produces all possible ordered pairs of symbols and numbers
(check-expect
 (cross '(a b c) '(1 2)) '((a 1) (a 2) (b 1) (b 2) (c 1) (c 2)))

(define (cross ls ln)    
  (cond
    [(empty? ls) '()]
    [else
     (append (for/list ([n ln]) (list (first ls) n))
             (cross (rest ls) ln))]))
