;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex476) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct transition [current key next])
(define-struct fsm [initial transitions final])
 
; An FSM is a structure:
;   (make-fsm FSM-State [List-of 1Transition] FSM-State)
; A 1Transition is a structure:
;   (make-transition FSM-State 1String FSM-State)
; An FSM-State is String.
 
; data example: see exercise 109
 
(define fsm-a-bc*-d
  (make-fsm
   "AA"
   (list (make-transition "AA" "a" "BC")
         (make-transition "BC" "b" "BC")
         (make-transition "BC" "c" "BC")
         (make-transition "BC" "d" "DD"))
   "DD"))

; FSM String -> Boolean 
; does an-fsm recognize the given string
(check-expect (fsm-match? fsm-a-bc*-d "acbd")  #t)
(check-expect (fsm-match? fsm-a-bc*-d "ad")    #t)
(check-expect (fsm-match? fsm-a-bc*-d "abcd")  #t)
(check-expect (fsm-match? fsm-a-bc*-d "da")    #f)
(check-expect (fsm-match? fsm-a-bc*-d "aa")    #f)
(check-expect (fsm-match? fsm-a-bc*-d "shtap") #f)

(define (fsm-match? an-fsm a-string)
  (local ((define trans (fsm-transitions an-fsm))
          (define final (fsm-final an-fsm))

          ; FSM-State [List-of 1String] -> Boolean
          (define (match? current-state sl)
            (cond
              [(empty? sl) (string=? current-state final)]
              [else
               (local ((define next-state
                         (get-next-state current-state (first sl))))
                 (if (not (false? next-state))
                     (match? next-state (rest sl))
                     #false))]))

          ; FSM-State 1String -> [Maybe FSM-State]
          (define (get-next-state state 1s)
            (for/or ([t trans])
              (if (and (string=? (transition-current t) state)
                       (string=? (transition-key     t)    1s))
                  (transition-next t)
                  #false))))

    (match? (fsm-initial an-fsm) (explode a-string))))
