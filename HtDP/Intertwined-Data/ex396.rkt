;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex396) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)

; An HM-Word is a [List-of Letter or "_"]
; interpretation "_" represents a letter to be guessed

(define LOCATION "/usr/share/dict/words")
(define AS-LIST (read-lines LOCATION))
(define SIZE (length AS-LIST))

(define LETTERS (explode "abcdefghijklmnopqrstuvwxyz"))


;; HM-Word HM-Word Letter -> HM-Word
;; produces s with "_" replaced with l, if correctly guessed
(check-expect
 (compare-word (explode "ford") (explode "____") "a")
 (explode "____"))
(check-expect
 (compare-word (explode "ford") (explode "____") "r")
 (explode "__r_"))

(define (compare-word w s l)
  (cond
    [(empty? w) '()]
    [(string=? (first w) l) (cons l (compare-word (rest w) (rest s) l))]
    [else (cons (first s) (compare-word (rest w) (rest s) l))]))

; HM-Word N -> String
; runs a simplistic hangman game, produces the current state
(define (play the-pick time-limit)
  (local ((define the-word  (explode the-pick))
          (define the-guess (make-list (length the-word) "_"))
          ; HM-Word -> HM-Word
          (define (do-nothing s) s)
          ; HM-Word KeyEvent -> HM-Word 
          (define (checked-compare current-status ke)
            (if (member? ke LETTERS)
                (compare-word the-word current-status ke)
                current-status)))
    (implode
     (big-bang the-guess ; HM-Word
       [to-draw render-word]
       [on-tick do-nothing 1 time-limit]
       [on-key  checked-compare]))))
 
; HM-Word -> Image
(define (render-word w)
  (text (implode w) 22 "black"))

;; uncomment to play
; (play (list-ref AS-LIST (random SIZE)) 10)
