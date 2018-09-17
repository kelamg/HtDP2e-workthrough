;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex394) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [List-of Number] [List-of Number] -> [List-of Number]
;; merges la and lb into a single sorted list in ascending order
(check-expect (merge '() '()) '())
(check-expect (merge '(1 3) '()) '(1 3))
(check-expect (merge '() '(1 3)) '(1 3))
(check-expect (merge '(2 5 7) '(1 2 3 8 9)) '(1 2 2 3 5 7 8 9))

(define (merge la lb)
  (cond
    [(empty? la) lb]
    [(empty? lb) la]
    [(>= (first la) (first lb))
     (cons (first lb) (merge la (rest lb)))]
    [else (cons (first la) (merge (rest la) lb))]))
