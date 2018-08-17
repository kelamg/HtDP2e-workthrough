;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex196) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

(define-struct lcount (letter count))
;; A LetterCount is a structure:
;;   (make-lcount Letter N)
;; interp. (make-lcount s n) means s appears as the
;;         first letter of a word n times

;; A LLC is one of:
;; - '()
;; - (cons LetterCount LLC)

;; A LoL (list of letters) is one of:
;; - '()
;; - (cons Letter LoL)

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

(define LLC1
  (list
   (make-lcount "a" 2) (make-lcount "b" 1) (make-lcount "c" 1)
   (make-lcount "o" 1) (make-lcount "p" 1) (make-lcount "q" 1)
   (make-lcount "t" 1) (make-lcount "s" 1) (make-lcount "v" 5)
   (make-lcount "w" 1) (make-lcount "z" 1)))

;; LoL Dictionary -> LLC
;; produces a list of lcount for all letters in dict
(check-expect (count-by-letter '() DICT) '())
(check-expect
 (count-by-letter (list "v") DICT)
 (list (make-lcount "v" 5)))
(check-expect
 (count-by-letter (list "a" "b" "c") DICT)
 (list (make-lcount "a" 2) (make-lcount "b" 1) (make-lcount "c" 1)))

(define (count-by-letter lol dict)
  (cond
    [(empty? lol) '()]
    [else
     (cons (make-lcount (first lol)
                        (starts-with# (first lol) dict))
           (count-by-letter (rest lol) dict))]))


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


;; Once your function is designed, determine how many words
;; appear for all letters in your computer’s dictionary.
(count-by-letter LETTERS AS-LIST)