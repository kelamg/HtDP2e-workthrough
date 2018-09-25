;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex451) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct table [length array])
; A Table is a structure:
;   (make-table N [N -> Number])

(define table1 (make-table 3 (lambda (i) i)))
 
; N -> Number
(define (a2 i)
  (if (= i 0)
      pi
      (error "table2 is not defined for i =!= 0")))
 
(define table2 (make-table 1 a2))

; Table N -> Number
; looks up the ith value in array of t
(define (table-ref t i)
  ((table-array t) i))

(define table3 (make-table 5  (λ (i) (add1 (* 3 i)))))
(define table4 (make-table 12 (λ (i) (* (+ i 3) (- i 4)))))
(define table5 (make-table 1024 (λ (i) (- (* (/ i 11) 1/3) 31))))

;; Table -> N
;; finds the smallest index for a root of the table using linear search
;; assume: table is monotonically increasing
(check-expect (find-linear table1) 0)
(check-expect (find-linear table4) 4)
(check-error  (find-linear table2))
(check-error  (find-linear table3))

(define (find-linear t)
  (local ((define (find f len n)
            (cond
              [(zero? (f n)) n]
              [(= n len) (error "not found")]
              [else (find f len (add1 n))])))
    
    (find (table-array t) (table-length t) 0)))


;; Table -> Number
;; finds the smallest index for a root of the table using linear search
;; assume: table is monotonically increasing
;; generative: Like ordinary binary search, the algorithm narrows an
;;             interval down to the smallest possible size and then
;;             chooses the index.
;; termination: As long as we keep halving positive intervals, we will
;;              eventually converge to [x, (x + 1)], from which we can
;;              then pick the closest one to zero
(check-expect (find-binary table1) 0)
(check-expect (find-binary table4) 4)
(check-expect (find-binary table5) 1023)
(check-error  (find-binary table2))
(check-error  (find-binary table3))

(define (find-binary t)
  (local ((define (find i1 i2)
            (local ((define within? (<= (abs (- i2 i1)) 1))
                    (define mid (quotient (+ i1 i2) 2))
                    (define @mid (table-ref t mid)))
              (cond
                [within? (cond [(zero? (table-ref t i1)) i1]
                               [(zero? (table-ref t i2)) i2]
                               [else (error "not found")])]
                [(zero? @mid)     mid]
                [(negative? @mid) (find mid i2)]
                [(positive? @mid) (find i1 mid)]))))
    
    (find 0 (table-length t))))

;; Q - To make this concrete, imagine a table with 1024 slots and the root
;;     at 1023. How many calls to find are needed in find-linear and find-binary,
;;     respectively?

;; A - find-linear would need 1024 calls to find the root. find-binary however,
;;     will only need half the calls to find the root because it repeatedly
;;     halves the search space on each call. Since the log of 1024 in base 2 is
;;     10, it would only need 10 calls to find the root.
