;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex168) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; List-of-posns -> List-of-posns
;; produces a new list of posn with 1 added to each y-coordinate
(check-expect (translate '()) '())
(check-expect (translate (cons (make-posn 42.4 20)
                               (cons (make-posn 72 34) '())))
              (cons (make-posn 42.4 21)
                    (cons (make-posn 72 35) '())))

(define (translate lop)
  (cond
    [(empty? lop) '()]
    [else
     (cons (make-posn (posn-x (first lop))
                      (+ 1 (posn-y (first lop))))
           (translate (rest lop)))]))