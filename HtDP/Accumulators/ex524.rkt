;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex524) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

(define RADIUS 10)
(define CANN#   3)
(define MISS#   3)
(define CANN   (circle RADIUS 'solid 'white))
(define MISS   (circle RADIUS 'solid   'black))
(define HEIGHT (+ (* (image-height CANN) 3) RADIUS))
(define BOAT   (above (rotate 30 (square RADIUS 'solid 'black))
                      (rectangle (* RADIUS 2) RADIUS 'solid 'black)))
(define BANK   (rectangle (* 8 RADIUS)  HEIGHT 'solid 'lightgreen))
(define RIVER  (rectangle (* 10 RADIUS) HEIGHT 'solid 'skyblue))

(define SPI         10)
(define BOAT-MAXCAP 2)

;; A Vector is (list N N)

(define-struct pstate (left boat right ps))
;; A PuzzleState is a structure:
;;   (make-pstate Bank Boat Bank [Or PuzzleState null])
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
  (make-pstate (make-bank 3 3) 'left  (make-bank 0 0) null))
(define a-state
  (make-pstate (make-bank 2 2) 'right (make-bank 1 1) initial-state))
(define final-state
  (make-pstate (make-bank 0 0) 'right (make-bank 3 3)
   (make-pstate (make-bank 1 1) 'left (make-bank 2 2)
    (make-pstate (make-bank 0 1) 'right (make-bank 3 2)
     (make-pstate (make-bank 1 2) 'left (make-bank 2 1)
      (make-pstate (make-bank 0 2) 'right (make-bank 3 1)
       (make-pstate (make-bank 1 3) 'left  (make-bank 2 0)
        (make-pstate (make-bank 0 3) 'right (make-bank 3 0)
         (make-pstate (make-bank 2 3) 'left (make-bank 1 0)
          (make-pstate (make-bank 1 3) 'right (make-bank 2 0)
           initial-state))))))))))

(define next-from-intial
  (list (make-pstate (make-bank 3 2) 'right  (make-bank 0 1) initial-state)
        (make-pstate (make-bank 3 1) 'right  (make-bank 0 2) initial-state)
        (make-pstate (make-bank 2 2) 'right  (make-bank 1 1) initial-state)
        (make-pstate (make-bank 1 3) 'right  (make-bank 2 0) initial-state)
        (make-pstate (make-bank 2 3) 'right  (make-bank 1 0) initial-state)))

; PuzzleState -> PuzzleState
; is the final state reachable from state0
; generative creates a tree of possible boat rides 
; termination ormap in the base case executes a breath-first search
;             which determines whether there are any states that
;             lead to a final state before recursing. This effectively
;             means that the function will eventually terminate 
(check-expect (solve initial-state) final-state)

(define (solve state0)
  (local (; [List-of PuzzleState] -> PuzzleState
          ; generative generates the successors of los
          (define (solve/a los)
            (cond
              [(ormap final? los)
               (first (filter final? los))]
              [else
               (solve/a (create-next-states los))])))
    (solve/a (list state0))))

;; PuzzleState -> Boolean
;; checks whether all people are on the right river bank
(check-expect (final? initial-state) #false)
(check-expect (final? a-state)       #false)
(check-expect (final? final-state)    #true)

(define (final? state)
  (local ((define b (pstate-right state)))
    (and (= (bank-miss b) MISS#)
         (= (bank-cann b) CANN#))))

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
          (make-pstate (make-bank 3 3) 'left (make-bank 0 0) a-state))
 #true)

(define (state=? a b)
  (and (equal? (pstate-left  a) (pstate-left  b))
       (equal? (pstate-boat  a) (pstate-boat  b))
       (equal? (pstate-right a) (pstate-right b))))

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
            (if (symbol=? (pstate-boat s) 'left)
                (pstate-left  s)
                (pstate-right s)))
          
          ; Vector PuzzleState -> PuzzleState
          (define (apply-vector v s)
            (local ((define m  (first v))
                    (define c  (second v))
                    (define blm (bank-miss (pstate-left s)))
                    (define blc (bank-cann (pstate-left s)))
                    (define brm (bank-miss (pstate-right s)))
                    (define brc (bank-cann (pstate-right s))))
              (cond
                [(symbol=? (pstate-boat s) 'left)
                 (make-pstate
                  (make-bank (- blm m) (- blc c)) 'right
                  (make-bank (+ brm m) (+ brc c)) s)]
                [else (make-pstate
                       (make-bank (+ blm m) (+ blc c)) 'left
                       (make-bank (- brm m) (- brc c)) s)])))

          ; PuzzleState PuzzleState -> Boolean
          ; check whether state a has already been encountered
          (define (seen? a b)
            (cond
              [(null? b) #false]
              [(state=? a b) #true]
              [else (seen? a (pstate-ps b))]))

          ; PuzzleState -> [List-of PuzzleState]
          (define (clean-possible-states s)
            (local ((define nv (next-vectors (get-next-bank s)))
                    (define possible-states
                      (map (λ (v) (apply-vector v s)) nv)))
              (filter (λ (s0) (not (seen? s0 (pstate-ps s0))))
                      possible-states))))
          
    (foldr (λ (s states) (append (clean-possible-states s) states)) '() los)))

;; PuzzleState -> Image
;; renders an image of the given state
(check-expect
 (render-mc initial-state)
 (beside
  (overlay (beside (above MISS MISS MISS) (above CANN CANN CANN)) BANK)
  (overlay/align "left" "middle" BOAT RIVER)
  BANK))
(check-expect
 (render-mc a-state)
 (beside
  (overlay (beside (above MISS MISS) (above CANN CANN)) BANK)
  (overlay/align "right" "middle" BOAT RIVER)
  (overlay (beside MISS CANN) BANK)))

(define (render-mc state)
  (local ((define (render-peeps img peeps#)
            (cond
              [(zero? peeps#) empty-image]
              [else (above img (render-peeps img (sub1 peeps#)))]))
          
          (define (render-bank peeps)
            (overlay (beside (render-peeps MISS (bank-miss peeps))
                             (render-peeps CANN (bank-cann peeps)))
                     BANK))

          (define (render-boat boat)
            (cond
              [(symbol=? boat 'left)
               (overlay/align "left" "middle" BOAT RIVER)]
              [else (overlay/align "right" "middle" BOAT RIVER)])))

    (beside (render-bank (pstate-left  state))
            (render-boat (pstate-boat  state))
            (render-bank (pstate-right state)))))

;; PuzzleState -> [List-of Image]
;; play an animation of the solution
(define (animate-solution s)
  (local ((define final-state (solve s))
          (define (generate-images fs)
            (cond
              [(null? fs) '()]
              [else (cons (render-mc fs)
                          (generate-images (pstate-ps fs)))])))
    (run-movie SPI (reverse (generate-images final-state)))))
