;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex479) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define QUEENS 8)

; A QP is a structure:
;   (make-posn CI CI)

; A CI is an N in [0,QUEENS).
; interpretation (make-posn r c) denotes the square at 
;                the r-th row and c-th column

(define C1 (make-posn 1 5))
(define C2 (make-posn 2 6))
(define C3 (make-posn 2 7))
(define C4 (make-posn 0 7))


;; QP QP -> Boolean
;; produces #true if queens placed on both squares would
;; threaten each other
(check-expect (threatening? C1 C2)  #true)
(check-expect (threatening? C2 C3)  #true)
(check-expect (threatening? C3 C4)  #true)
(check-expect (threatening? C1 C3) #false)
(check-expect (threatening? C1 C4) #false)
(check-expect (threatening? C2 C4) #false)

(define (threatening? ca cb)
  (or (or (= (posn-x ca) (posn-x cb))
          (= (posn-y ca) (posn-y cb)))
      (=  (abs (- (posn-x ca) (posn-x cb)))
          (abs (- (posn-y ca) (posn-y cb))))))
