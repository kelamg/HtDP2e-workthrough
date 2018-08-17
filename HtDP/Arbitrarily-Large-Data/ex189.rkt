;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex189) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Number List-of-numbers -> Boolean
(define (search n alon)
  (cond
    [(empty? alon) #false]
    [else (or (= (first alon) n)
              (search n (rest alon)))]))

;; Number List-of-numbers -> Boolean
;; search a sorted list slon
(check-expect
 (search-sorted 2 '()) #false)
(check-expect
 (search-sorted 7 (list 3 7 10)) #true)
(check-expect
 (search-sorted 5 (list 2 6 14 25 32)) #false)

(define (search-sorted n slon)
  (cond
    [(empty? slon) #false]
    [(< n (first slon)) #false]
    [else (or (= (first slon) n)
              (search-sorted n (rest slon)))]))

;; List-of-numbers -> List-of-numbers
;; sorts lon in descending order
(check-expect
 (sort< '()) '())
(check-expect
 (sort< (list 3)) (list 3))
(check-expect
 (sort< (list 3 10 7)) (list 3 7 10))

(define (sort< lon)
  (cond
    [(empty? lon) '()]
    [else
     (insert (first lon) (sort< (rest lon)))]))

; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of lon
(check-expect
 (insert 5 '()) (list 5))
(check-expect
 (insert 2 (list 1)) (list 1 2))
(check-expect
 (insert 1 (list 2)) (list 1 2))
(check-expect
 (insert 7 (list 3 10)) (list 3 7 10))

(define (insert n lon)
  (cond
    [(empty? lon) (cons n '())]
    [else (if (< n (first lon))
              (cons n lon)
              (cons (first lon) (insert n (rest lon))))]))

