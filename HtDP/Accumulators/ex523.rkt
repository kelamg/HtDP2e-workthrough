;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex523) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define BOAT-MAXCAP 2)

;; A Vector is (list N N)

(define-struct state (left boat right ps))
;; A PuzzleState is a structure:
;;   (make-state Bank Boat Bank [Or PuzzleState null])
;; accumulator ps is the previous state that led to this one,
;;             or null to represent the initial state

(define-struct bank (miss cann))
;; A Bank is a structure:
;;   (make-bank N N)
;; interp. miss is the number of missionaries and
;;         cann is the number of cannibals

;; A Boat is one of:
;;   - 'left
;;   - 'right

(define initial-state
  (make-state (make-bank 3 3) 'left  (make-bank 0 0) '()))
(define a-state
  (make-state (make-bank 2 2) 'right (make-bank 1 1) initial-state))

(define next-from-intial
  (list (make-state (make-bank 3 2) 'right  (make-bank 0 1) initial-state)
        (make-state (make-bank 3 1) 'right  (make-bank 0 2) initial-state)
        (make-state (make-bank 2 2) 'right  (make-bank 1 1) initial-state)
        (make-state (make-bank 1 3) 'right  (make-bank 2 0) initial-state)
        (make-state (make-bank 2 3) 'right  (make-bank 1 0) initial-state)))

;; N -> [List-of Vector]
;; produces a list of vectors whose sum of numbers add up to n
;; represents the action of taking missionaries and cannibals from a river bank
;; effectively produces the vectors of a boat of capacity n
(check-expect (make-vectors 1) '((1 0) (0 1)))
(check-expect (make-vectors 2) '((2 0) (1 0) (1 1) (0 1) (0 2)))

(define (make-vectors n)
  (local (; N -> [List-of Vector]
          (define (keep i j)
            (cond [(> j n) '()]
                  [else (local ((define sum (+ i j)))
                          (if (and (> sum 0) (<= sum n))
                              (cons (list i j) (keep i (add1 j)))
                              (keep i (add1 j))))]))
          ; N -> [List-of Vector]
          (define (helper k)
            (cond [(zero? k) (keep k 0)]
                  [else (append (keep k 0) (helper (sub1 k)))])))
    (helper n)))

;; PuzzleState PuzzleState -> Boolean
;; produces #true if two states are equal
(check-expect (state=? initial-state a-state) #false)
(check-expect
 (state=? initial-state
          (make-state (make-bank 3 3) 'left  (make-bank 0 0) a-state))
 #true)

(define (state=? a b)
  (and (equal? (state-left  a) (state-left  b))
       (equal? (state-boat  a) (state-boat  b))
       (equal? (state-right a) (state-right b))))

;; for testing
(define (good? states)
  (andmap (λ (s) (member? s next-from-intial)) states))

;; [List-of PuzzleState] -> [List-of PuzzleState]
;; generates a list of all the states that a boat ride can reach
(check-satisfied
 (create-next-states (list initial-state)) good?)

(define (create-next-states los)
  (local ((define vectors (make-vectors BOAT-MAXCAP))

          ; Bank -> [List-of Vector]
          ; get the correct next set of vectors for this bank
          (define (next-vectors bank)
            (local ((define bm (bank-miss bank))
                    (define bc (bank-cann bank)))
              (filter (λ (v)
                        (not (or (negative? (- bm (first v)))
                                 (negative? (- bc (second v))))))
                      vectors)))

          ; PuzzleState -> Bank
          (define (get-next-bank s)
            (if (symbol=? (state-boat s) 'left)
                (state-left  s)
                (state-right s)))
          
          ; Vector PuzzleState -> PuzzleState
          (define (apply-vector v s)
            (local ((define m  (first v))
                    (define c  (second v))
                    (define blm (bank-miss (state-left s)))
                    (define blc (bank-cann (state-left s)))
                    (define brm (bank-miss (state-right s)))
                    (define brc (bank-cann (state-right s))))
              (cond
                [(symbol=? (state-boat s) 'left)
                 (make-state
                  (make-bank (- blm m) (- blc c)) 'right
                  (make-bank (+ brm m) (+ brc c)) s)]
                [else (make-state
                       (make-bank (+ blm m) (+ blc c)) 'left
                       (make-bank (- brm m) (- brc c)) s)])))

          ; PuzzleState PuzzleState -> Boolean
          ; check whether state a has already been encountered
          (define (seen? a b)
            (cond
              [(empty? b) #false]
              [(state=? a b) #true]
              [else (seen? a (state-ps b))]))

          ; PuzzleState -> [List-of PuzzleState]
          (define (clean-possible-states s)
            (local ((define nv (next-vectors (get-next-bank s)))
                    (define possible-states
                      (map (λ (v) (apply-vector v s)) nv)))
              (filter (λ (s0) (not (seen? s0 (state-ps s0))))
                      possible-states))))
          
    (foldr (λ (s states) (append (clean-possible-states s) states)) '() los)))
  