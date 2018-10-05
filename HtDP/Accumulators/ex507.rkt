;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex507) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; [X Y] [X Y -> Y] Y [List-of X] -> Y
; custom foldl function
(check-expect (f*ldl + 0 '(1 2 3))
              (foldl + 0 '(1 2 3)))
(check-expect (f*ldl cons '() '(a b c))
              (foldl cons '() '(a b c)))
 
(define (f*ldl f e l0)
  (local (; Y [List-of X] -> Y
          ; accumulator a is the result of processing
          ; l0 up to l with f
          (define (fold/a a l)
            (cond
              [(empty? l) a]
              [else
               (fold/a (f (first l) a) (rest l))])))
    
    (fold/a e l0)))

; N [N -> X] -> [List-of X]
; custom build-list function using an accumulator style approach
(check-expect (build-l*st 5 add1) (build-list 5 add1))

(define (build-l*st n f)
  (local (; N [List-of X] -> [List-of X]
          ; accumulator a is the result of applying
          ; f to n so far
          (define (build/a n0 a)
            (cond
              [(zero? n0) a]
              [else (build/a (sub1 n0) (cons (f (sub1 n0)) a))])))

    (build/a n '())))
