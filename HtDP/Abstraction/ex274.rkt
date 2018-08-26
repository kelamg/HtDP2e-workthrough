;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex274) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; List-of-1Strings -> List-of-1Strings
;; produces a list of all prefixes
;; a list p is a prefix of l if p and l are the same up
;; through all items in p
(check-expect (prefixes '()) '())
(check-expect
 (prefixes (list "a")) (list (list "a")))
(check-expect
 (prefixes (list "a" "b"))
 (list (list "a") (list "a" "b")))
(check-expect
 (prefixes (list "a" "b" "c"))
 (list (list "a") (list "a" "b") (list "a" "b" "c")))

(define (prefixes lo1s)
  (local (; 1String [List-of [List-of 1s]]
          ;      -> [List-of [List-of 1s]]
          ; append s to all lists in l
          (define (combine s l)
            (local (; [List-of 1s] -> [List-of 1s]
                    ; add s to beginning of ls
                    (define (prepend ls)
                      (cons s ls)))
                    
              (map prepend (cons '() l)))))
    
    (foldr combine '() lo1s)))

;; List-of-1Strings -> List-of-1Strings
;; produces a list of all suffixes
;; a list s is a suffix of l if p and l are the same from the end,
;; up through all items in s
(check-expect (suffixes '()) '())
(check-expect
 (suffixes (list "a")) (list (list "a")))
(check-expect
 (suffixes (list "a" "b"))
 (list (list "b") (list "a" "b")))
(check-expect
 (suffixes (list "a" "b" "c"))
 (list (list "c") (list "b" "c") (list "a" "b" "c")))

(define (suffixes lo1s)
  (local (; 1String [List-of [List-of 1s]]
          ;      -> [List-of [List-of 1s]]
          ; append s to all lists in l
          (define (combine s l)
            (local (; [List-of 1s] -> [List-of 1s]
                    ; add s to end of ls
                    (define (append-to-end ls)
                      (append ls (list s))))
                    
              (map append-to-end (cons '() l)))))
    
    (foldl combine '() lo1s)))
