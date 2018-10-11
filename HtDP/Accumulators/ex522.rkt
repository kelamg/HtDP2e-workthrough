;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex522) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

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

;; PuzzleState -> Boolean
;; checks whether all people are on the right river bank
(check-expect (final? initial-state) #false)
(check-expect (final? a-state)       #false)

(define (final? state)
  (local ((define b (state-right state)))
    (and (= (bank-miss b) MISS#)
         (= (bank-cann b) CANN#))))

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

    (beside (render-bank (state-left  state))
            (render-boat (state-boat  state))
            (render-bank (state-right state)))))
