;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex195) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

(define LOCATION "/usr/share/dict/words")

; A Dictionary is a List-of-strings.
(define AS-LIST (read-lines LOCATION))

; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS
  (explode "abcdefghijklmnopqrstuvwxyz"))

;; Any -> Boolean
;; produces true if s is a Letter
(check-expect (letter? 1) #f)
(check-expect (letter? (list "a" "z")) #f)
(check-expect (letter? "az") #f)
(check-expect (letter? "a") #t)
(check-expect (letter? "z") #t)

(define (letter? s)
  (member? s LETTERS))

(define DICT
  (list "antelope" "assimilate" "bravo" "class"
        "orthogonal" "padantic" "quasi" "trope"
        "set" "ventriloquist" "vindictive" "violence"
        "vilify" "vapid" "wallow" "zealous"))

;; Letter Dictionary -> N
;; counts how many words in dict that start with l
(check-expect (starts-with# "a" '()) 0)
(check-expect (starts-with# "b" DICT) 1)
(check-expect (starts-with# "a" DICT) 2)
(check-expect (starts-with# "v" DICT) 5)

(define (starts-with# l dict)
  (cond
    [(empty? dict) 0]
    [else
     (if (starts-with? l (first dict))
         (add1 (starts-with# l (rest dict)))
         (starts-with# l (rest dict)))]))

;; 1String String -> Boolean
;; produces true if s starts with 1s
(check-expect (starts-with? "a" "ant") #t)
(check-expect (starts-with? "1" "ant") #f)

(define (starts-with? 1s s)
  (string=? 1s (substring s 0 1)))

;; Once you know that your function works, determine how many words
;; start with "e" in your computer’s dictionary and how many with "z".
(starts-with# "e" AS-LIST)
(starts-with# "z" AS-LIST)