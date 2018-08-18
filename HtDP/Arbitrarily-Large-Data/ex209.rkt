;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex209) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A Word is one of:
; – '() or
; – (cons 1String Word)
; interpretation a Word is a list of 1Strings (letters)

; List-of-strings -> Boolean
(define (all-words-from-rat? w)
  (and
    (member? "rat" w) (member? "art" w) (member? "tar" w)))
 
;; String -> List-of-strings
;; finds all words that the letters of some given word spell
;(check-member-of (alternative-words "cat")
;                 (list "act" "cat")
;                 (list "cat" "act"))
; 
;(check-satisfied (alternative-words "rat")
;                 all-words-from-rat?)
;
;(define (alternative-words s)
;  (in-dictionary
;    (words->strings (arrangements (string->word s)))))
 
; List-of-words -> List-of-strings
; turns all Words in low into Strings
(define (words->strings low) '())
 
; List-of-strings -> List-of-strings
; picks out all those Strings that occur in the dictionary 
(define (in-dictionary los) '())

; String -> Word
; converts s to a list-of-1Strings
(check-expect (string->word "") '())
(check-expect (string->word "a") (list "a"))
(check-expect (string->word "abc") (list "a" "b" "c"))

(define (string->word s)
  (cond
    [(string=? s "") '()]
    [else
     (cons (substring s 0 1)
           (string->word (substring s 1)))]))
 
; Word -> String
; converts w to a string
(check-expect (word->string '()) "")
(check-expect (word->string (list "a")) "a")
(check-expect (word->string (list "a" "b" "c")) "abc")

(define (word->string w)
  (cond
    [(empty? w) ""]
    [else
     (string-append (first w)
                    (word->string (rest w)))]))
