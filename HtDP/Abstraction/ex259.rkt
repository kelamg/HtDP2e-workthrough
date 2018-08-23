;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex259) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

(define LOCATION "/usr/share/dict/words")
 
; A Dictionary is a List-of-strings.
(define DICT-AS-LIST (read-lines LOCATION))

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


; List-of-strings -> Boolean
(define (all-words-from-rat? w)
  (and
    (member? "rat" w) (member? "art" w) (member? "tar" w)))
 
; String -> List-of-strings
; finds all words that the letters of some given word spell
(check-member-of (alternative-words "cat")
                 (list "act" "cat")
                 (list "cat" "act"))
 
(check-satisfied (alternative-words "rat")
                 all-words-from-rat?)

(define (alternative-words s)
  (local
    [; List-of-strings -> List-of-strings
     ; picks out all those Strings that occur in the dictionary
     (define (in-dictionary los)
       (cond
         [(empty? los) '()]
         [else
          (if (member? (first los) DICT-AS-LIST)
              (cons (first los)
                    (in-dictionary (rest los)))
              (in-dictionary (rest los)))]))
     
     ; List-of-words -> List-of-strings
     ; turns all Words in low into Strings
     (define (words->strings low)
       (local [; Word -> String
               ; converts w to a string
               (define (word->string w)
                 (cond
                   [(empty? w) ""]
                   [else
                    (string-append (first w)
                                   (word->string (rest w)))]))]
         (cond
           [(empty? low) '()]
           [else
            (cons (word->string (first low))
                  (words->strings (rest low)))])))
     
     ; Word -> List-of-words
     ; creates all rearrangements of the letters in w
     (define (arrangements w)
       (local
         [;; 1String List-of-words -> List-of-words
          ;; produces a list of words with 1s inserted
          ;; at the beginning, between all letters,
          ;; and at the end of all words in low
          (define (insert-everywhere/in-all-words 1s low)
            (local
              [;; N 1String Word -> List-of-words
               ;; produces a list of words with 1s inserted into w
               ;; starting from index n
               (define (insert-everywhere i 1s w)
                 (local
                   [;; 1String Word N -> Word
                    ;; produces a word with 1s inserted at index i of w
                    (define (1string-insert 1s w i)
                      (if (> (length w) 0)
                          (explode
                           (string-append
                            (substring (implode w) 0 i)
                            1s
                            (substring (implode w) i)))
                          (cons 1s w)))]
                   (cond
                     [(> i (length w)) '()]
                     [else
                      (cons (1string-insert 1s w i)
                            (insert-everywhere (add1 i) 1s w))])))]
              (cond
                [(empty? low) '()]
                [else
                 (append
                  (insert-everywhere 0 1s (first low))
                  (insert-everywhere/in-all-words 1s (rest low)))])))]
         (cond
           [(empty? w) (list '())]
           [else (insert-everywhere/in-all-words
                  (first w) (arrangements (rest w)))])))
     
     ; String -> Word
     ; converts s to a list-of-1Strings
     (define (string->word s)
       (cond
         [(string=? s "") '()]
         [else
          (cons (substring s 0 1)
                (string->word (substring s 1)))]))]
     
     (in-dictionary
      (words->strings (arrangements (string->word s))))))
     

;; Run the entire program
(alternative-words "dear")
;; -> (list "dear" "dare" "read")

(alternative-words "design")
;; -> (list "design" "signed" "deigns" "singed")
