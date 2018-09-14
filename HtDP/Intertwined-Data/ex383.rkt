;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex383) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)
(require 2htdp/image)
(require 2htdp/universe)


; An FSM is a [List-of 1Transition]
; A 1Transition is a list of two items:
;   (cons FSM-State (cons FSM-State '()))
; An FSM-State is a String that specifies a color

; data examples 
(define fsm-traffic
  '(("red" "green") ("green" "yellow") ("yellow" "red")))

(define TEXT-SIZE  12)
(define TEXT-COLOR 'gray)

(define xm0
  '(machine ((initial "white"))
            (action ((state "white") (next "black")))
            (action ((state "black") (next "white")))))

 
; FSM FSM-State -> FSM-State 
; matches the keys pressed by a player with the given FSM 
(define (simulate state0 transitions)
  (big-bang state0 ; FSM-State
    [to-draw
      (lambda (current)
        (overlay (text current TEXT-SIZE TEXT-COLOR)
                 (square 100 "solid" current)))]
    [on-key
      (lambda (current key-event)
        (find transitions current))]))
 
; [X Y] [List-of [List X Y]] X -> Y
; finds the matching Y for the given X in alist
(check-expect (find fsm-traffic "green") "yellow")
(check-error  (find fsm-traffic "black") "not found")

(define (find alist x)
  (local ((define fm (assoc x alist)))
    (if (cons? fm) (second fm) (error "not found"))))


; XMachine -> FSM-State 
; interprets the given configuration as a state machine 
(define (simulate-xmachine xm)
  (simulate (xm-state0 xm) (xm->transitions xm)))
 
; XMachine -> FSM-State 
; extracts and translates the transition table from xm0
(define (xm-state0 xm0)
  (find-attr (xexpr-attr xm0) 'initial))
 
; XMachine -> [List-of 1Transition]
; extracts the transition table from xm
(define (xm->transitions xm)
  (local (; X1T -> 1Transition
          (define (xaction->action xa)
            (list (find-attr (xexpr-attr xa) 'state)
                  (find-attr (xexpr-attr xa) 'next))))
    (map xaction->action (xexpr-content xm))))

;; [List-of Attribute] Symbol -> [Or String false]
;; produces the associated string with sy if sy exists in la
;; produces #false otherwise
(define (find-attr la sy)
  (local ((define found (assq sy la)))
    (if (false? found) #false (second found))))

;; Xexpr -> Xe-Body
;; extracts the list of content elements
(define (xexpr-content xe)
  (match xe
    [(cons (? symbol?) (cons (? list-of-attributes?) body)) body]
    [(cons (? symbol?) body) body]))

; [List-of Attribute] or Xexpr.v3 -> Boolean
; is x a list of attributes
(define (list-of-attributes? x)
  (cond
    [(empty? x) #true]
    [else
     (local ((define possible-attribute (first x)))
       (cons? possible-attribute))]))

; Xexpr -> [List-of Attribute]
; retrieves the list of attributes of xe
(define (xexpr-attr xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '()]
      [else
       (local ((define loa-or-x
                 (first optional-loa+content)))
         (if (list-of-attributes? loa-or-x)
             loa-or-x
             '()))])))

;; uncomment to run
;  (simulate (xm-state0 xm0) (xm->transitions xm0))