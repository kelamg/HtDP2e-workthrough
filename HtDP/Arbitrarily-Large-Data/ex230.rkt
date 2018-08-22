;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex230) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

(define-struct fsm [initial transitions final])
(define-struct transition [current key next])
; An FSM.v2 is a structure: 
;   (make-fsm FSM-State LOT FSM-State)

; A LOT is one of: 
; – '() 
; – (cons Transition.v3 LOT)

; A Transition.v3 is a structure: 
;   (make-transition FSM-State KeyEvent FSM-State)
 
; FSM-State is ExpectsToSee.
 
; interpretation An FSM represents the transitions that a
; finite state machine can take from one state to another 
; in reaction to keystrokes

(define AA "start, expect an 'a'")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")

;; ExpectsToSee is one of:
;; – AA
;; – BB
;; – DD 

(define regexp
  (list (make-transition AA "a" BB)
        (make-transition BB "b" BB)
        (make-transition BB "c" BB)
        (make-transition BB "d" DD)))

(define WHITE  "white")
(define YELLOW "yellow")
(define GREEN  "green")
(define RED    "red")


; FSM.v2 -> FSM.v2
; match the keys pressed with the given FSM 
(define (fsm-simulate fsm)
  (big-bang fsm
    [to-draw state-as-colored-square]
    [on-key find-next-state]
    [stop-when final? state-as-colored-square]))


; FSM.v2 -> Image 
; renders current world state as a colored square 
(check-expect
 (state-as-colored-square (make-fsm AA regexp DD))
 (square 100 "solid" WHITE))
(check-expect
 (state-as-colored-square (make-fsm BB regexp DD))
 (square 100 "solid" YELLOW))
(check-expect
 (state-as-colored-square (make-fsm DD regexp DD))
 (square 100 "solid" GREEN))
 
(define (state-as-colored-square fsm)
  (cond
    [(string=? (fsm-initial fsm) AA) (square 100 "solid" WHITE)]
    [(string=? (fsm-initial fsm) BB) (square 100 "solid" YELLOW)]
    [(string=? (fsm-initial fsm) DD) (square 100 "solid" GREEN)]))

; FSM.v2 KeyEvent -> FSM.v2
; finds the next state from ke and cs
(check-expect
  (find-next-state (make-fsm AA regexp DD) "a")
  (make-fsm BB regexp DD))
(check-expect
  (find-next-state (make-fsm AA regexp DD) "d")
  (make-fsm AA regexp DD))
(check-expect
  (find-next-state (make-fsm AA regexp DD) "up")
  (make-fsm AA regexp DD))
(check-expect
  (find-next-state (make-fsm BB regexp DD) "b")
  (make-fsm BB regexp DD))
(check-expect
  (find-next-state (make-fsm BB regexp DD) "c")
  (make-fsm BB regexp DD))
(check-expect
  (find-next-state (make-fsm BB regexp DD) "a")
  (make-fsm BB regexp DD))
(check-expect
  (find-next-state (make-fsm BB regexp DD) "up")
  (make-fsm BB regexp DD))
(check-expect
  (find-next-state (make-fsm BB regexp DD) "d")
  (make-fsm DD regexp DD))

(define (find-next-state fsm ke)
  (make-fsm
    (find (fsm-transitions fsm) (fsm-initial fsm) ke)
    (fsm-transitions fsm)
    (fsm-final fsm)))

; LOT FSM-State KeyEvent -> FSM-State
; finds the state representing current in lot
; and retrieves the next field using ke
(check-expect (find regexp AA "a") BB)
(check-expect (find regexp BB "b") BB)
(check-expect (find regexp BB "d") DD)
(check-expect (find regexp BB "a") BB)

(define (find lot current ke)
  (cond
    [(empty? lot) current]
    [else
     (if (and (key=? ke (transition-key (first lot)))
              (state=? current (transition-current (first lot))))
         (transition-next (first lot))
         (find (rest lot) current ke))]))

;; FSM.v2 -> Boolean
;; stops big-bang when the final state is reached
(check-expect (final? (make-fsm AA regexp DD)) false)
(check-expect (final? (make-fsm BB regexp DD)) false)
(check-expect (final? (make-fsm DD regexp DD))  true)

(define (final? fsm)
  (equal? (fsm-initial fsm) (fsm-final fsm)))

;; FSM-State FSM-State -> Boolean
;; equality predicate for states
;; returns true if both states are the same
(check-expect (state=? RED RED)      #t)
(check-expect (state=? RED GREEN)    #f)
(check-expect (state=? GREEN YELLOW) #f)

(define (state=? si sj)
  (string=? si sj))