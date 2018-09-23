;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex442) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require racket/base)

; [List-of Number] [X X -> Boolean] -> [List-of Number]
; produces a sorted version of alon based on cmp
; assume the numbers are all distinct
(check-expect
 (quick-sort< '()) '())
(check-expect
 (quick-sort< '(1)) '(1))
(check-expect
 (quick-sort< (list 11 8 14 7))
 '(7 8 11 14))
(check-expect
 (quick-sort< (list 11 9 2 18 12 14 4 1))
 (list 1 2 4 9 11 12 14 18))

(define (quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [(empty? (rest alon)) alon]
    [else (local ((define pivot (first alon)))
            (append (quick-sort< (smallers (rest alon) pivot))
                    (equals alon pivot)
                    (quick-sort< (largers (rest alon) pivot))))]))

;; [List-of Number] N -> [List-of Number]
;; returns all the numbers equal to pivot
(define (equals alon pivot)
  (filter (λ (n) (= n pivot)) alon))

; [List-of Number] Number -> [List-of Number]
; produces all the numbers in alon larger than n
(define (largers alon pivot)
  (filter (λ (n) (> n pivot)) alon))
 
; [List-of Number] Number -> [List-of Number]
; produces all the numbers in alon smaller than n
(define (smallers alon pivot)
  (filter (λ (n) (< n pivot)) alon))

; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(check-expect
 (sort< '()) '())
(check-expect
 (sort< '(4 0 8 10 3))
 '(0 3 4 8 10))

(define (sort< l)
  (cond
    [(empty? l) '()]
    [(cons? l) (insert (first l) (sort< (rest l)))]))
 
; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers l 
(define (insert n l)
  (cond
    [(empty? l) (cons n '())]
    [else (if (<= n (first l))
              (cons n l)
              (cons (first l) (insert n (rest l))))]))


;; create a list of len elements containing random numbers
(define TEST-MAX 100)

(define (create-test len)
  (build-list len (λ (n) (random TEST-MAX))))

;; A FuncTest is [List-of String Function]
;;   (list s f)
;; where s is a function name string, and f is the function itself

;; prints a comparison of the performances of a list of FuncTest
;; using n randomly generated test cases (lists of length len)
;; on each function in the list
(define (sort-perf fns n len)
  (local ((define case (create-test len))
          (define (run-tests fn)
            (time (for ([_ n]) (fn case))))
          
          ; pretty print
          (define (pad s)
            (local ((define longest
                      (string-length
                       (car (argmax (λ (s) (string-length (car s))) fns)))))
              (build-string (- longest (string-length s))
                            (λ (n) #\space)))))
    
    (for ([ft fns])
      (display (format "~a~a (len=~a) => " (first ft) (pad (first ft)) len))
      (run-tests (second ft)))))


(define funcs
  (list (list "quick-sort<" quick-sort<)
        (list "sort<"       sort<)))

; run
(define (perf funcs trials)
  (for [(len (in-range 0 40 2))]
    (sort-perf funcs trials len)
    (display "\n")))

;; Q - Does the experiment confirm the claim that the plain sort< function
;;     often wins over quick-sort< for short lists and vice versa?
;; A - Yes it does. When lists of length 20 are supplied to each, quick-sort<
;;     really starts to dominate sort< in performance.

(define CROSS-OVER 20)

; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
; assume the numbers are all distinct
; uses sort< if length of alon is below CROSS-OVER
(check-expect
 (clever-sort '()) '())
(check-expect
 (clever-sort '(1)) '(1))
(check-expect
 (clever-sort (list 11 8 14 7))
 '(7 8 11 14))
(check-expect
 (clever-sort (list 11 9 2 18 12 14 4 1))
 (list 1 2 4 9 11 12 14 18))

(define (clever-sort alon)
  (cond
    [(< (length alon) CROSS-OVER) (sort< alon)]
    [else (local ((define pivot (first alon)))
            (append (quick-sort< (smallers alon pivot))
                    (list pivot)
                    (quick-sort< (largers alon pivot))))]))

(define THRESHOLD 5)

; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
; assume the numbers are all distinct
; uses sort< if length of alon is below THRESHOLD
(check-expect
 (ex427quick-sort< '()) '())
(check-expect
 (ex427quick-sort< '(1)) '(1))
(check-expect
 (ex427quick-sort< (list 11 8 14 7))
 '(7 8 11 14))
(check-expect
 (ex427quick-sort< (list 11 9 2 18 12 14 4 1))
 (list 1 2 4 9 11 12 14 18))

(define (ex427quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [(empty? (rest alon)) alon]
    [(< (length alon) THRESHOLD) (sort< alon)]
    [else (local ((define pivot (first alon)))
            (append (ex427quick-sort< (smallers alon pivot))
                    (list pivot)
                    (ex427quick-sort< (largers alon pivot))))]))

; Compare with exercise 427
(define cmp-funcs
  (append funcs
          (list (list "ex427quick-sort<" ex427quick-sort<)
                (list "cleversort" clever-sort))))

; uncomment to compare
; -> (perf cmp-funcs 1000)

