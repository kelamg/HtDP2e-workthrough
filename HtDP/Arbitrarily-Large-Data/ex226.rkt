;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex226) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An FSM is one of:
;   – '()
;   – (cons Transition FSM)
 
(define-struct transition [current next])
; A Transition is a structure:
;   (make-transition FSM-State FSM-State)
 
; FSM-State is a Color.
 
; interpretation An FSM represents the transitions that a
; finite state machine can take from one state to another 
; in reaction to keystrokes

(define RED    "red")
(define YELLOW "yellow")
(define GREEN  "green")

;; FSM-State FSM-State -> Boolean
;; equality predicate for states
;; returns true if both states are the same
(check-expect (state=? RED RED)      #t)
(check-expect (state=? RED GREEN)    #f)
(check-expect (state=? GREEN YELLOW) #f)

(define (state=? si sj)
  (string=? si sj))