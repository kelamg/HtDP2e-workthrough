;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex503) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Matrix -> Matrix 
; finds a row that doesn't start with 0 and
; uses it as the first one
; generative moves the first row to last place 
; no termination if all rows start with 0
(check-expect (rotate-until.v1 '((0 4 5) (1 2 3)))
              '((1 2 3) (0 4 5)))

(define (rotate-until.v1 M)
  (cond
    [(not (= (first (first M)) 0)) M]
    [else
     (rotate-until.v1 (append (rest M) (list (first M))))]))


; Matrix -> Matrix 
; finds a row that doesn't start with 0 and
; uses it as the first one
; generative moves the first row to last place 
; no termination if all rows start with 0
(check-expect (rotate-until.v2 '((0 4 5) (1 2 3)))
              '((1 2 3) (0 4 5)))

(define (rotate-until.v2 M)
  (local (; Matrix [List-of N] -> Matrix
          ; accumulator a is the list of matrices with leading
          ; coefficients of zero seen seen so far
          (define (rotate/a M0 a)
            (cond
              [(not (zero? (first (first M0)))) (cons (first M0) a)]
              [else (rotate/a (rest M0) (cons (first M0) a))])))

    (rotate/a M '())))


(define lines 5000)
(define testcase
  (build-list lines (λ (n) (if (= n (sub1 lines)) '(1 0 0) (make-list 3 0)))))

; use first to make the output more convenient to compare
(time (first (rotate-until.v1 testcase))) ; -> 424 cpu time
(time (first (rotate-until.v2 testcase))) ; -> 8   cpu time
