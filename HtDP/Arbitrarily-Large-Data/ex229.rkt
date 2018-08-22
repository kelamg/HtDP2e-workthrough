;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex229) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

; An FSM is one of:
;   – '()
;   – (cons Transition FSM)
 
(define-struct ktransition [current key next])
; A Transition.v2 is a structure:
;   (make-ktransition FSM-State KeyEvent FSM-State)
 
; FSM-State is ExpectsToSee.
 
; interpretation An FSM represents the transitions that a
; finite state machine can take from one state to another 
; in reaction to keystrokes

(define-struct fs [fsm current])
; A SimulationState.v2 is a structure: 
;   (make-fs FSM FSM-State)

(define AA "start, expect an 'a'")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")

;; ExpectsToSee is one of:
;; – AA
;; – BB
;; – DD 

(define regexp
  (list (make-ktransition AA "a" BB)
        (make-ktransition BB "b" BB)
        (make-ktransition BB "c" BB)
        (make-ktransition BB "d" DD)))

(define WHITE  "white")
(define YELLOW "yellow")
(define GREEN  "green")
(define RED    "red")


; FSM FSM-State -> SimulationState.v2 
; match the keys pressed with the given FSM 
(define (simulate.v2 an-fsm s0)
  (big-bang (make-fs an-fsm s0)
    [to-draw state-as-colored-square]
    [on-key find-next-state]))


; SimulationState.v2 -> Image 
; renders current world state as a colored square 
(check-expect (state-as-colored-square
                (make-fs regexp AA))
              (square 100 "solid" WHITE))
(check-expect (state-as-colored-square
                (make-fs regexp BB))
              (square 100 "solid" YELLOW))
(check-expect (state-as-colored-square
                (make-fs regexp DD))
              (square 100 "solid" GREEN))
 
(define (state-as-colored-square an-fsm)
  (cond
    [(string=? (fs-current an-fsm) AA) (square 100 "solid" WHITE)]
    [(string=? (fs-current an-fsm) BB) (square 100 "solid" YELLOW)]
    [(string=? (fs-current an-fsm) DD) (square 100 "solid" GREEN)]))

; SimulationState.v2 KeyEvent -> SimulationState.v2
; finds the next state from ke and cs
(check-expect
  (find-next-state (make-fs regexp AA) "a")
  (make-fs regexp BB))
(check-expect
  (find-next-state (make-fs regexp AA) "d")
  (make-fs regexp AA))
(check-expect
  (find-next-state (make-fs regexp AA) "up")
  (make-fs regexp AA))
(check-expect
  (find-next-state (make-fs regexp BB) "b")
  (make-fs regexp BB))
(check-expect
  (find-next-state (make-fs regexp BB) "c")
  (make-fs regexp BB))
(check-expect
  (find-next-state (make-fs regexp BB) "a")
  (make-fs regexp BB))
(check-expect
  (find-next-state (make-fs regexp BB) "up")
  (make-fs regexp BB))
(check-expect
  (find-next-state (make-fs regexp BB) "d")
  (make-fs regexp DD))

(define (find-next-state an-fsm ke)
  (make-fs
    (fs-fsm an-fsm)
    (find (fs-fsm an-fsm) (fs-current an-fsm) ke)))

; FSM FSM-State KeyEvent -> FSM-State
; finds the state representing current in transitions
; and retrieves the next field using ke
(check-expect (find regexp AA "a") BB)
(check-expect (find regexp BB "b") BB)
(check-expect (find regexp BB "d") DD)
(check-expect (find regexp BB "a") BB)

(define (find transitions current ke)
  (cond
    [(empty? transitions) current]
    [else
     (if (and (key=? ke (ktransition-key (first transitions)))
              (state=? current
                       (ktransition-current (first transitions))))
         (ktransition-next (first transitions))
         (find (rest transitions) current ke))]))

;; FSM-State FSM-State -> Boolean
;; equality predicate for states
;; returns true if both states are the same
(check-expect (state=? RED RED)      #t)
(check-expect (state=? RED GREEN)    #f)
(check-expect (state=? GREEN YELLOW) #f)

(define (state=? si sj)
  (string=? si sj))