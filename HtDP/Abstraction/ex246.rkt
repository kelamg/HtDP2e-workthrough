;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex246) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (extract R l t)
  (cond
    [(empty? l) '()]
    [else (cond
            [(R (first l) t)
             (cons (first l)
                   (extract R (rest l) t))]
            [else
             (extract R (rest l) t)])]))

(extract < (cons 6 (cons 4 '())) 5)

(cond
  [(empty? (cons 6 (cons 4 '()))) '()]
  [else (cond
          [(< (first (cons 6 (cons 4 '()))) 5)
           (cons (first (cons 6 (cons 4 '())))
                 (extract < (rest (cons 6 (cons 4 '()))) 5))]
          [else
           (extract < (rest (cons 6 (cons 4 '()))) 5)])])

(cond
  [#false '()]
  [else (cond
          [(< (first (cons 6 (cons 4 '()))) 5)
           (cons (first (cons 6 (cons 4 '())))
                 (extract < (rest (cons 6 (cons 4 '()))) 5))]
          [else
           (extract < (rest (cons 6 (cons 4 '()))) 5)])])

(cond
  [else (cond
          [(< (first (cons 6 (cons 4 '()))) 5)
           (cons (first (cons 6 (cons 4 '())))
                 (extract < (rest (cons 6 (cons 4 '()))) 5))]
          [else
           (extract < (rest (cons 6 (cons 4 '()))) 5)])])

(cond
  [(< (first (cons 6 (cons 4 '()))) 5)
   (cons (first (cons 6 (cons 4 '())))
         (extract < (rest (cons 6 (cons 4 '()))) 5))]
  [else
   (extract < (rest (cons 6 (cons 4 '()))) 5)])

(cond
  [(< 6 5)
   (cons (first (cons 6 (cons 4 '())))
         (extract < (rest (cons 6 (cons 4 '()))) 5))]
  [else
   (extract < (rest (cons 6 (cons 4 '()))) 5)])

(cond
  [#false
   (cons (first (cons 6 (cons 4 '())))
         (extract < (rest (cons 6 (cons 4 '()))) 5))]
  [else
   (extract < (rest (cons 6 (cons 4 '()))) 5)])

(extract < (rest (cons 6 (cons 4 '()))) 5)

(extract < (cons 4 '()) 5)
