;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex197) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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
(define LLC2
  (list (make-lcount "a" 12) (make-lcount "b" 4) (make-lcount "c" 7)))

;; Dictionary -> LetterCount
;; produces the most frequently used letter (and its count) in dict
(check-expect (most-frequent.v1 DICT) (make-lcount "v" 5))

(define (most-frequent.v1 dict)
  (max-lcount (count-by-letter LETTERS dict)))

;; LLC -> LetterCount
;; produces the max letter count in a list of letter count
(check-expect (max-lcount '()) (make-lcount "a" 0))
(check-expect (max-lcount LLC2) (make-lcount "a" 12))

(define (max-lcount llc)
  (cond
    [(empty? llc) (make-lcount "a" 0)]
    [(empty? (rest llc)) (first llc)]
    [else
     (if (lc>? (first llc) (second llc))
         (max-lcount (cons (first llc) (rest (rest llc))))
         (max-lcount (rest llc)))]))

;; Dictionary -> LetterCount
;; produces the most frequently used letter (and its count) in dict
(check-expect (most-frequent.v2 DICT) (make-lcount "v" 5))

(define (most-frequent.v2 dict)
  (first (sort-llc (count-by-letter LETTERS dict))))

;; LLC -> LLC
;; sorts llc by count in descending order
(check-expect (sort-llc '()) '())
(check-expect
 (sort-llc LLC1)
 (append (list (make-lcount "v" 5) (make-lcount "a" 2))
         (reverse (list (make-lcount "b" 1) (make-lcount "c" 1)
                        (make-lcount "o" 1) (make-lcount "p" 1)
                        (make-lcount "q" 1) (make-lcount "t" 1)
                        (make-lcount "s" 1) (make-lcount "w" 1)
                        (make-lcount "z" 1)))))
(check-expect
 (sort-llc LLC2)
 (list (make-lcount "a" 12) (make-lcount "c" 7) (make-lcount "b" 4)))

(define (sort-llc llc)
  (cond
    [(empty? llc) '()]
    [else
     (insert (first llc) (sort-llc (rest llc)))]))

;; LetterCount LLC -> LLC
;; inserts a letter count into a sorted list of letter count
(check-expect
 (insert (make-lcount "d" 2) '()) (list (make-lcount "d" 2)))
(check-expect
 (insert
  (make-lcount "d" 2)
  (list (make-lcount "a" 12) (make-lcount "c" 7) (make-lcount "b" 4)))
 (list (make-lcount "a" 12)
       (make-lcount "c" 7)
       (make-lcount "b" 4)
       (make-lcount "d" 2)))
(check-expect
 (insert
  (make-lcount "d" 3)
  (list
   (make-lcount "v" 5) (make-lcount "a" 2) (make-lcount "b" 1)
   (make-lcount "c" 1) (make-lcount "o" 1) (make-lcount "p" 1)
   (make-lcount "q" 1) (make-lcount "t" 1) (make-lcount "s" 1)
   (make-lcount "w" 1) (make-lcount "z" 1)))
 (list
   (make-lcount "v" 5) (make-lcount "d" 3) (make-lcount "a" 2)
   (make-lcount "b" 1) (make-lcount "c" 1) (make-lcount "o" 1)
   (make-lcount "p" 1) (make-lcount "q" 1) (make-lcount "t" 1)
   (make-lcount "s" 1) (make-lcount "w" 1) (make-lcount "z" 1)))

(define (insert lc llc)
  (cond
    [(empty? llc) (cons lc '())]
    [else
     (if (lc>? lc (first llc))
         (cons lc (cons (first llc) (rest llc)))
         (cons  (first llc) (insert lc (rest llc))))]))

;; LetterCount LetterCount -> Boolean
;; returns true if lc1 > lc2, compared by their counts
(check-expect
 (lc>? (make-lcount "a" 3) (make-lcount "f" 3)) #f)
(check-expect
 (lc>? (make-lcount "a" 3) (make-lcount "f" 4)) #f)
(check-expect
 (lc>? (make-lcount "a" 3) (make-lcount "f" 2)) #t)

(define (lc>? lc1 lc2)
  (> (lcount-count lc1) (lcount-count lc2)))

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

;; Consider designing both. Which one do you prefer? Why?
;; I prefer most-frequent.v1, mostly because the max-lcount
;; function it utilises makes designing the function,
;; as a whole, a lot eaiser.
