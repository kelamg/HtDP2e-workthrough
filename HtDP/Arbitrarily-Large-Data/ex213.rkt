;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex213) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

(define LOCATION "/usr/share/dict/words")
 
; A Dictionary is a List-of-strings.
;(define DICT-AS-LIST (read-lines LOCATION))
(define DICT-AS-LIST '())

; A Word is one of:
; – '()
; – (cons 1String Word)
; interpretation a Word is a list of 1Strings (letters)

;; A List-of-words is one of:
;; - '()
;; - (cons Word List-of-words)

(define W1 (list "d" "e"))
(define W2 (list "r" "a" "t"))

(define LW1 (list (list "d" "e")
                  (list "e" "d")))
(define LW2 (list (list "r" "a" "t")
                  (list "a" "r" "t")
                  (list "a" "t" "r")
                  (list "r" "t" "a")
                  (list "t" "r" "a")
                  (list "t" "a" "r")))

; Word -> List-of-words
; creates all rearrangements of the letters in w
(check-expect (arrangements '()) (list '()))
(check-expect (arrangements  W1) LW1)
(check-expect (arrangements  W2) LW2)

(define (arrangements w)
  (cond
    [(empty? w) (list '())]
    [else (insert-everywhere/in-all-words (first w)
            (arrangements (rest w)))]))

;; 1String List-of-words -> List-of-words
;; produces a list of words with 1s inserted at the beginning,
;; between all letters, and at the end of all words in low
(check-expect
 (insert-everywhere/in-all-words "d" (list '()))
 (list (list "d")))
(check-expect
 (insert-everywhere/in-all-words "d" (list (list "e")))
 (list (list "d" "e") (list "e" "d")))
(check-expect
 (insert-everywhere/in-all-words "d"
  (list (list "e" "r") (list "r" "e")))
 (list (list "d" "e" "r") (list "e" "d" "r") (list "e" "r" "d")
       (list "d" "r" "e") (list "r" "d" "e") (list "r" "e" "d")))

(define (insert-everywhere/in-all-words 1s low)
  (cond
    [(empty? low) '()]
    [else
     (append (insert-everywhere 0 1s (first low))
             (insert-everywhere/in-all-words 1s (rest low)))]))

;; N 1String Word -> List-of-words
;; produces a list of words with 1s inserted into w
;; starting from index n
(check-expect
 (insert-everywhere 0 "a" '()) (list (list "a")))
(check-expect
 (insert-everywhere 0 "a" (list "b"))
 (list (list "a" "b") (list "b" "a")))
(check-expect
 (insert-everywhere 0 "a" (list "b" "c"))
 (list (list "a" "b" "c") (list "b" "a" "c") (list "b" "c" "a")))

(define (insert-everywhere i 1s w)
  (cond
    [(> i (length w)) '()]
    [else
     (cons (1string-insert 1s w i)
           (insert-everywhere (add1 i) 1s w))]))

;; 1String Word N -> Word
;; produces a word with 1s inserted at index i of w
(define (1string-insert 1s w i)
  (if (> (length w) 0)
      (explode
       (string-append
        (substring (implode w) 0 i) 1s (substring (implode w) i)))
      (cons 1s w)))

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
(check-expect (words->strings '()) '())
(check-expect
 (words->strings (list (list "a")))
 (list "a"))
(check-expect
 (words->strings (list (list "a" "b" "c")))
 (list "abc"))
(check-expect
 (words->strings
  (list (list "a" "b" "c") (list "d" "e" "f") (list "g" "h")))
 (list "abc" "def" "gh"))

(define (words->strings low)
  (cond
    [(empty? low) '()]
    [else
     (cons (word->string (first low))
           (words->strings (rest low)))]))
 
; List-of-strings -> List-of-strings
; picks out all those Strings that occur in the dictionary
(check-expect (in-dictionary '()) '())
(check-expect
 (in-dictionary (list "cat")) (list "cat"))
(check-expect
 (in-dictionary (list "rat" "art" "tar"))
 (list "rat" "art" "tar"))
(check-expect
 (in-dictionary (list "rat" "tra" "rta")) (list "rat"))
(check-expect
 (in-dictionary (list "atr" "tra" "rta")) '())

(define (in-dictionary los)
  (cond
    [(empty? los) '()]
    [else
     (if (member? (first los) DICT-AS-LIST)
         (cons (first los)
               (in-dictionary (rest los)))
         (in-dictionary (rest los)))]))

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
