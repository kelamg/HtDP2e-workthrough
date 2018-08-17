;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex82) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; even more designing with structures

(define-struct 3word (first second third))
;; A 3Word is a structure:
;;   (make-3word 1String/false 1String/false 1String/false)
;; interp. a three-letter word, which consists of lowercase
;;         letters represented with 1Strings, "a" through "z"
;;         or #false if no letter fills that position

;; 3Word 3Word -> 3Word
;; produces a word where the letters of the given words agree and disagree
(check-expect (compare-words (make-3word "Y" "e" "s")
                             (make-3word "N" "o" false))
              (make-3word false false false))
(check-expect (compare-words (make-3word "Y" "e" "s")
                             (make-3word "Y" "e" "a"))
              (make-3word "Y" "e" false))

#;
(define (compare-words a b)
  (... (3word-first a)
       (3word-second a)
       (3word-third a)
       (3word-first b)
       (3word-second b)
       (3word-third b)))

(define (compare-words a b)
  (if (equal? a b)
      a
      (make-3word (compare-letters (3word-first a)  (3word-first b))
                  (compare-letters (3word-second a) (3word-second b))
                  (compare-letters (3word-third a)  (3word-third b)))))

;; 3Word 3Word -> 1String/false
;; produces a 1String if both letters are the same, false otherwise
(check-expect (compare-letters "a" "b")   false)
(check-expect (compare-letters "a" "a")     "a")
(check-expect (compare-letters "a" false) false)

#;
(define (compare-letters a b)
  (cond
    [(or (false? a)
         (false? b)) (...)]
    [(string=? a b)  (...)]
    [else            (...)]))

(define (compare-letters a b)
  (cond
    [(or (false? a)
         (false? b)) false]
    [(string=? a b)      a]
    [else            false]))
