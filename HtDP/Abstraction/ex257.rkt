;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex257) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


;; PositiveInteger [PositiveInteger -> Y] -> [List-of Y]
;; build-list clone
(check-expect
 (build-l*st 3 add1)
 (build-list 3 add1))
(check-expect
 (build-l*st 5 sub1)
 (build-list 5 sub1))
(check-expect
 (build-l*st 5 sqr)
 (build-list 5 sqr))

(define (build-l*st n fn)
  (cond
    [(= n 0) '()]
    [else
     (add-at-end (fn (sub1 n))
                 (build-l*st (sub1 n) fn))]))

;; X [List-of X] -> [List-of X]
;; append x to the end of lx
(define (add-at-end x lx)
  (cond
    [(empty? lx) (cons x '())]
    [else
     (cons (first lx) (add-at-end x (rest lx)))]))