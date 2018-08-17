;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex198) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

;; A LoD (list of dictionary) is one of:
;; - '()
;; - (cons Dictionary LoD)

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
        "orthogonal" "padantic" "quasi" "set"
        "trope" "ventriloquist" "vindictive" "violence"
        "vilify" "vapid" "wallow" "zealous"))
(define LODICT
  (list (list "antelope" "assimilate")
        (list "bravo") (list "class") (list "orthogonal")
        (list "padantic") (list "quasi") (list "set") (list "trope") 
        (list "ventriloquist" "vindictive" "violence" "vilify" "vapid")
        (list "wallow") (list "zealous")))

(define LLC1
  (list
   (make-lcount "a" 2) (make-lcount "b" 1) (make-lcount "c" 1)
   (make-lcount "o" 1) (make-lcount "p" 1) (make-lcount "q" 1)
   (make-lcount "t" 1) (make-lcount "s" 1) (make-lcount "v" 5)
   (make-lcount "w" 1) (make-lcount "z" 1)))
(define LLC2
  (list (make-lcount "a" 12) (make-lcount "b" 4) (make-lcount "c" 7)))

;; Dictionary -> LoD
;; produces a list of dictionary, one for each first letter in dict
(check-expect
 (words-by-first-letter '()) '()) 
(check-expect
 (words-by-first-letter (list "a")) (list (list "a"))) 
(check-expect
 (words-by-first-letter (list "a" "ab" "ac" "b" "ca" "cbda"))
 (list (list "a" "ab" "ac") (list "b") (list "ca" "cbda")))
(check-expect (words-by-first-letter DICT) LODICT)

(define (words-by-first-letter dict)
  (make-dicts-by-letter LETTERS dict))

;; LoL Dictionary -> LoD
;; for each letter in Lol, makes a new dictionary of words
;; starting with the letter
;; if dict contains no words for a particular letter,
;; that letter's dictionary is excluded from the resulting list
(check-expect
 (make-dicts-by-letter '() DICT) '())
(check-expect
 (make-dicts-by-letter (list "a") DICT)
 (list (list "antelope" "assimilate")))
(check-expect
 (make-dicts-by-letter (list "a" "b" "c" "v") DICT)
 (list (list "antelope" "assimilate")
       (list "bravo") (list "class")
       (list "ventriloquist" "vindictive" "violence" "vilify" "vapid")))

(define (make-dicts-by-letter lol dict)
  (cond
    [(empty? lol) '()]
    [else
     (filter-empty
      (cons (make-dict-for-letter (first lol) dict)
            (make-dicts-by-letter (rest lol) dict)))]))

;; List -> List
;; returns list with all '() removed
(check-expect (filter-empty '()) '())
(check-expect
 (filter-empty (list '())) '())
(check-expect
 (filter-empty (list "a")) (list "a"))
(check-expect
 (filter-empty (list "a" '())) (list "a"))
(check-expect
 (filter-empty (list "a" '() "ab" "c" '())) (list "a" "ab" "c"))

(define (filter-empty l)
  (cond
    [(empty? l) '()]
    [else
     (if (empty? (first l))
         (filter-empty (rest l))
         (cons (first l) (filter-empty (rest l))))]))
     

;; Letter Dictionary -> Dictionary
;; produces a list of the words beginning with l in dict
(check-expect
 (make-dict-for-letter "c" (list "a" "ab" "ac" "b")) '())
(check-expect
 (make-dict-for-letter "c" (list "a" "ab" "ac" "b" "ca" "cbda"))
 (list "ca" "cbda"))
(check-expect
 (make-dict-for-letter "v" DICT)
 (list "ventriloquist" "vindictive" "violence" "vilify" "vapid"))

(define (make-dict-for-letter l dict)
  (cond
    [(empty? dict) '()]
    [else
     (if (starts-with? l (first dict))
         (cons (first dict)
               (make-dict-for-letter l (rest dict)))
         (make-dict-for-letter l (rest dict)))]))

;; Dictionary -> LetterCount
;; produces the most frequently used letter (and its count) in dict
(check-expect (most-frequent DICT) (make-lcount "v" 5))

(define (most-frequent dict)
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

;; Dictionary -> LetterCount
;; produces the most frequently used letter (and its count) in dict
;; using words-by-first-letter
(check-expect (most-frequent.v2 DICT) (make-lcount "v" 5))

(define (most-frequent.v2 dict)
  (max-lcount.v2 (words-by-first-letter dict)))

;; LoD -> LetterCount
;; produces the maximum letter count of all dicts in lod
(check-expect (max-lcount.v2 '()) '())
(check-expect
 (max-lcount.v2 (list (list "a" "ab" "ac") (list "b") (list "ca" "cbda")))
 (make-lcount "a" 3))
(check-expect
 (max-lcount.v2 LODICT)
 (make-lcount "v" 5))

(define (max-lcount.v2 lod)
  (cond
    [(empty? lod) '()]
    [(empty? (rest lod)) (get-lcount (first lod))]
    [else
     (if (> (length (first lod)) (length (second lod)))
         (max-lcount.v2 (cons (first lod) (rest (rest lod))))
         (max-lcount.v2 (rest lod)))]))

;; Dictionary -> LetterCount
;; turns a one letter dictionary into a letter count
(check-expect
 (get-lcount (list "a" "ab" "ac"))
 (make-lcount "a" 3))
(check-expect
 (get-lcount (list "antelope" "assimilate"))
 (make-lcount "a" 2))

(define (get-lcount dict)
  (make-lcount (substring (first dict) 0 1) (length dict)))

;; Once you have completed the design, ensure that the two functions
;; compute the same result on your computer’s dictionary
(check-expect
  (most-frequent AS-LIST)
  (most-frequent.v2 AS-LIST))
