;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex275) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

;; Dictionary -> LetterCount
;; produces the most frequently used letter (and its count) in dict
(check-expect (most-frequent DICT) (make-lcount "v" 5))

(define (most-frequent dict)
  (local ((define (get-count lc)
            (lcount-count lc)))
        (argmax get-count (count-by-letter LETTERS dict))))

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
  (local (; Letter -> LetterCount
          ; make a letter count for letter l
          (define (build-lc l)
            (make-lcount l (letter-count l dict))))
    (map build-lc lol)))


;; Letter Dictionary -> N
;; counts how many words in dict that start with l
(check-expect (letter-count "a" '()) 0)
(check-expect (letter-count "b" DICT) 1)
(check-expect (letter-count "a" DICT) 2)
(check-expect (letter-count "v" DICT) 5)

(define (letter-count l dict)
  (local (; Letter -> String
          ; add 1 to sum if s starts with l
          (define (add1-if 1s count)
            (if (starts-with? l 1s) (add1 count) count)))
    (foldr add1-if 0 dict)))

;; 1String String -> Boolean
;; produces true if s starts with 1s
(check-expect (starts-with? "a" "ant") #t)
(check-expect (starts-with? "1" "ant") #f)

(define (starts-with? 1s s)
  (string=? 1s (substring s 0 1)))

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
  (local (; 1String [List-of Dictionary] -> [List-of Dictionary]
          ; append dictionary for 1s with current list of dicts
          (define (combine 1s l)
            (local (; String -> Dictionary
                    ; build dictionary for 1s
                    (define (pick s)
                      (if (starts-with? 1s s) s '())))
              
              (cons (filter-empty (map pick dict)) l)))

          ; Dictionary -> Dictionary
          ; remove all '() from dictionary
          (define (filter-empty lst)
            (remove-all '() lst)))

    (filter-empty (foldr combine '() LETTERS))))
