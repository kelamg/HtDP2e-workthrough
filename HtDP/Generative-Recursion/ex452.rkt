;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex452) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A File is one of: 
; – '()
; – (cons "\n" File)
; – (cons 1String File)
; interpretation represents the content of a file 
; "\n" is the newline character

; A Line is a [List-of 1String]

(define NEWLINE "\n") ; the 1String 

; File -> [List-of Line]
; converts a file into a list of lines 
(check-expect
 (file->list-of-lines '()) '())
(check-expect
 (file->list-of-lines
  '("a" "b" "c" "\n"
    "d" "e" "\n"
    "f" "g" "h" "\n"))
 '(("a" "b" "c")
   ("d" "e")
   ( "f" "g" "h")))
 
(define (file->list-of-lines afile)
  (cond
    [(empty? afile) '()]
    [else
     (cons (first-line afile)
           (file->list-of-lines (remove-first-line afile)))]))
 
; File -> Line
; produces the first line of afile
; i.e. everything before the first occurence of NEWLINE
(define (first-line afile)
  (cond
    [(empty? afile) '()]
    [(string=? (first afile) NEWLINE) '()]
    [else (cons (first afile) (first-line (rest afile)))]))
 
; File -> Line
; like first-line but produces everything after the first
; occurence of NEWLINE
(define (remove-first-line afile)
  (cond
    [(empty? afile) '()]
    [(string=? (first afile) NEWLINE) (rest afile)]
    [else (remove-first-line (rest afile))]))

