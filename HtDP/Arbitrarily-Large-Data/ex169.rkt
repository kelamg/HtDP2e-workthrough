;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex169) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; List-of-posns -> List-of-posns
;; produces a new list of posn with only those posns whose
;; x-coordinates are between 0 and 100, and whose
;; y-coordinates are between 0 and 200
(check-expect (legal '()) '())
(check-expect (legal
               (cons (make-posn 42.4 20)
                     (cons (make-posn 72 341)
                           (cons (make-posn 140 75) '()))))
              (cons (make-posn 42.4 20)
                    (cons (make-posn 72 341)
                          (cons (make-posn 140 75) '()))))
(check-expect (legal
               (cons (make-posn 142.4 245.2)
                     (cons (make-posn 72 34)
                           (cons (make-posn 92 75) '()))))
              (cons (make-posn 72 34)
                    (cons (make-posn 92 75) '())))


(define (legal lop)
  (cond
    [(empty? lop) '()]
    [else
     (if (not (passes? (first lop)))
         (cons (first lop) (legal (rest lop)))
         (legal (rest lop)))]))

;; Posn -> Boolean
;; produces true if the x-coordinate of p is between 0 and 100
;; and y-coordinate is between 0 and 200
(check-expect (passes? (make-posn 40 100))  #f)
(check-expect (passes? (make-posn 105 90))  #f)
(check-expect (passes? (make-posn 73 210))  #f)
(check-expect (passes? (make-posn 105 210)) #t)

(define (passes? p)
  (and (> (posn-x p) 100) (> (posn-y p) 200)))