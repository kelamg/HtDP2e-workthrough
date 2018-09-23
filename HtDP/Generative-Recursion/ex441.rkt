;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex441) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; [List-of Number] [X X -> Boolean] -> [List-of Number]
; produces a sorted version of alon based on cmp
; assume the numbers are all distinct
(check-expect
 (quick-sort< '()) '())
(check-expect
 (quick-sort< '(1)) '(1))
(check-expect
 (quick-sort< (list 11 8 14 7))
 '(7 8 11 14))
(check-expect
 (quick-sort< (list 11 9 2 18 12 14 4 1))
 (list 1 2 4 9 11 12 14 18))

(define (quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [(empty? (rest alon)) alon]
    [else (local ((define pivot (first alon)))
            (append (quick-sort< (smallers (rest alon) pivot))
                    (equals alon pivot)
                    (quick-sort< (largers (rest alon) pivot))))]))

;; [List-of Number] N -> [List-of Number]
;; returns all the numbers equal to pivot
(define (equals alon pivot)
  (filter (λ (n) (= n pivot)) alon))

; [List-of Number] Number -> [List-of Number]
; produces all the numbers in alon larger than n
(define (largers alon pivot)
  (filter (λ (n) (> n pivot)) alon))
 
; [List-of Number] Number -> [List-of Number]
; produces all the numbers in alon smaller than n
(define (smallers alon pivot)
  (filter (λ (n) (< n pivot)) alon))


; HAND EVALUATION
; ----------------------------------------------------------------

(quick-sort< (list 10 6 8 9 14 12 3 11 14 16 2))

(append (quick-sort< '(6 8 9 3 2))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append (append (quick-sort< '(3 2))
                '(6)
                (quick-sort< '(8 9)))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append (append (append (quick-sort< '(2))
                        '(3)
                        (quick-sort< '()))
                '(6)
                (quick-sort< '(8 9)))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append (append (append '(2)
                        '(3)
                        (quick-sort< '()))
                '(6)
                (quick-sort< '(8 9)))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append (append (append '(2)
                        '(3)
                        '())
                '(6)
                (quick-sort< '(8 9)))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append (append '(2 3)
                '(6)
                (quick-sort< '(8 9)))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append (append '(2 3)
                '(6)
                (append (quick-sort< '())
                        '(8)
                        (quick-sort< '(9))))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append (append '(2 3)
                '(6)
                (append '()
                        '(8)
                        (quick-sort< '(9))))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append (append '(2 3)
                '(6)
                (append '()
                        '(8)
                        '(9)))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append (append '(2 3)
                '(6)
                '(8 9))
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append '(2 3 6 8 9)
        '(10)
        (quick-sort< '(14 12 11 14 16)))

(append '(2 3 6 8 9)
        '(10)
        (append (quick-sort< '(12 11))
                '(14 14)
                (quick-sort< '(16))))

(append '(2 3 6 8 9)
        '(10)
        (append (append (quick-sort< '(11))
                        '(12)
                        (quick-sort< '()))
                '(14 14)
                (quick-sort< '(16))))

(append '(2 3 6 8 9)
        '(10)
        (append (append '(11)
                        '(12)
                        (quick-sort< '()))
                '(14 14)
                (quick-sort< '(16))))

(append '(2 3 6 8 9)
        '(10)
        (append (append '(11)
                        '(12)
                        '())
                '(14 14)
                (quick-sort< '(16))))

(append '(2 3 6 8 9)
        '(10)
        (append '(11 12)
                '(14 14)
                (quick-sort< '(16))))

(append '(2 3 6 8 9)
        '(10)
        (append '(11 12)
                '(14 14)
                '(16)))

(append '(2 3 6 8 9)
        '(10)
        '(11 12 14 14 16))

'(2 3 6 8 9 10 11 12 14 14 16)

;; Q - How many recursive applications of quick-sort< are required?
;; A - 12

;; Q - How many recursive applications of the append function?
;; A - 5

;; Q - Suggest a general rule for a list of length n.
;; A - For a list of length n, there is 1 recursive quick-sort< call per item,
;;     and 1 recursive append call per two items


(quick-sort< (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14))

(append
 (quick-sort< '())
 '(1)
 (quick-sort< '(2 3 4 5 6 7 8 9 10 11 12 13 14)))

(append '() '(1)
 (quick-sort< '(2 3 4 5 6 7 8 9 10 11 12 13 14)))

(append '() '(1)
 (append
  (quick-sort< '())
  '(2)
  (quick-sort< '(3 4 5 6 7 8 9 10 11 12 13 14))))

(append '() '(1)
 (append '() '(2)
  (append
   (quick-sort< '())
   '(3)
   (quick-sort< '(4 5 6 7 8 9 10 11 12 13 14)))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append
    (quick-sort< '())
    '(4)
    (quick-sort< '(5 6 7 8 9 10 11 12 13 14))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append
     (quick-sort< '())
     '(5)
     (quick-sort< '(6 7 8 9 10 11 12 13 14)))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append
      (quick-sort< '())
      '(6)
      (quick-sort< '(7 8 9 10 11 12 13 14))))))))

(append
 '() '(1)
 (append
  '() '(2)
  (append
   '() '(3)
   (append
    '() '(4)
    (append
     '() '(5)
     (append
      '() '(6)
      (append
       (quick-sort< '())
       '(7)
       (quick-sort< '(8 9 10 11 12 13 14)))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append
        (quick-sort< '())
        '(8)
        (quick-sort< '(9 10 11 12 13 14))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append
         (quick-sort< '())
         '(9)
         (quick-sort< '(10 11 12 13 14)))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append '() '(9)
         (append
          (quick-sort< '())
          '(10)
          (quick-sort< '(11 12 13 14))))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append '() '(9)
         (append '() '(10)
          (append
           (quick-sort< '())
           '(11)
           (quick-sort< '(12 13 14)))))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append '() '(9)
         (append '() '(10)
          (append '() '(11)
           (append
            (quick-sort< '())
            '(12)
            (quick-sort< '(13 14))))))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append '() '(9)
         (append '() '(10)
          (append '() '(11)
           (append '() '(12)
            (append
             (quick-sort< '())
             '(13)
             (quick-sort< '(14)))))))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append '() '(9)
         (append '() '(10)
          (append '() '(11)
           (append '() '(12)
            (append '() '(13) '(14))))))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append '() '(9)
         (append '() '(10)
          (append '() '(11)
           (append '() '(12)
            '(13 14)))))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append '() '(9)
         (append '() '(10)
          (append '() '(11)
           '(12 13 14))))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append '() '(9)
         (append '() '(10)
          '(11 12 13 14)))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        (append '() '(9)
         '(10 11 12 13 14))))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       (append '() '(8)
        '(9 10 11 12 13 14)))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      (append '() '(7)
       '(8 9 10 11 12 13 14))))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     (append '() '(6)
      '(7 8 9 10 11 12 13 14)))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    (append '() '(5)
     '(6 7 8 9 10 11 12 13 14))))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   (append '() '(4)
    '(5 6 7 8 9 10 11 12 13 14)))))

(append '() '(1)
 (append '() '(2)
  (append '() '(3)
   '(4 5 6 7 8 9 10 11 12 13 14))))

(append '() '(1)
 (append '() '(2)
  '(3 4 5 6 7 8 9 10 11 12 13 14)))

(append '() '(1)
 '(2 3 4 5 6 7 8 9 10 11 12 13 14))

'(1 2 3 4 5 6 7 8 9 10 11 12 13 14)

;; Q - How many recursive applications of quick-sort< are required?
;; A - 25

;; Q - How many recursive applications of the append function?
;; A - 12

;; Q - Does this contradict the first part of the exercise?
;; A - Yes it does. quick-sort< sucks at processing already sorted data.
