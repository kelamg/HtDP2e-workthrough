;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex502) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [NEList-of 1String] -> [NEList-of 1String]
;; constructs a palindrome by mirroring the list
;; around the last item
(check-expect (palindrome (explode "abc")) (explode "abcba"))

(define (palindrome l)
  (local (; [NEList-of 1String] [List-of 1String] -> [NEList-of 1String]
          ; accumulator a is the list of 1Strings traversed from l 
          (define (palindrome/a l0 a)
            (cond
              [(empty? (rest l0)) a]
              [else (palindrome/a (rest l0) (cons (first l0) a))])))
    
    (append l (palindrome/a l '()))))

; [NEList-of 1String] -> [NEList-of 1String]
; creates a palindrome from s0
(check-expect
  (mirror (explode "abc")) (explode "abcba"))

(define (mirror s0)
  (local (; [List-of X] -> X
          ; extracts the last item from p
          (define (last p)
            (cond
              [(empty? (rest (rest (rest p)))) (third p)]
              [else (last (rest p))]))

          ; [List-of X] -> [List-of X]
          ; extracts all but the last item in l
          (define (all-but-last l)
            (cond
              [(empty? (rest l)) '()]
              [else (cons (first l) (all-but-last (rest l)))])))
    
    (append (all-but-last s0)
            (list (last s0))
            (reverse (all-but-last s0)))))
