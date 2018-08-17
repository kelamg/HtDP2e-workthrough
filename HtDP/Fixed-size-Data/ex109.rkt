;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex109) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; sequence recognition

(require 2htdp/image)
(require 2htdp/universe)

;; Constants
(define HEIGHT 400)
(define WIDTH  400)
(define MTS    (empty-scene WIDTH HEIGHT))
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))

(define RWIDTH  100)
(define RHEIGHT 100)
(define WHITE  (rectangle RWIDTH RHEIGHT "solid" "white"))
(define YELLOW (rectangle RWIDTH RHEIGHT "solid" "yellow"))
(define GREEN  (rectangle RWIDTH RHEIGHT "solid" "green"))
(define RED    (rectangle RWIDTH RHEIGHT "solid" "red"))

;; Definitions

(define AA "start, expect an 'a'")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")
(define ER "error, illegal key")

;; ExpectsToSee is one of:
;; – AA
;; – BB
;; – DD 
;; – ER


;; Functions

;; ExpectsToSee -> Image
;; renders the given key into a corresponding rectangle
(check-expect (render-state AA)  WHITE)
(check-expect (render-state BB) YELLOW)
(check-expect (render-state DD)  GREEN)
(check-expect (render-state ER)    RED)

(define (render-state e)
  (cond
    [(string=? e AA)  WHITE]
    [(string=? e BB) YELLOW]
    [(string=? e DD)  GREEN]
    [(string=? e ER)    RED]))

;; ExpectsToSee KeyEvent -> ExpectsToSee
;; transitions to the next state or stays in the current one
(check-expect (next-state AA "a")  BB)
(check-expect (next-state AA "d")  ER)
(check-expect (next-state AA "up") ER)
(check-expect (next-state BB "b")  BB)
(check-expect (next-state BB "c")  BB)
(check-expect (next-state BB "a")  ER)
(check-expect (next-state BB "up") ER)
(check-expect (next-state BB "d")  DD)

(define (next-state e ke)
  (cond
    [(and (equal? e AA)
          (string=? ke "a"))      BB]
    [(and (equal? e BB)
          (or (string=? ke "b")
              (string=? ke "c"))) BB]
    [(and (equal? e BB)
          (string=? ke "d"))      DD]
    [else ER]))

;; ExpectsToSee -> Boolean
;; stops the program upon encoutering the ER or DD state
(check-expect (regexed? AA) false)
(check-expect (regexed? BB) false)
(check-expect (regexed? DD)  true)
(check-expect (regexed? ER)  true)

(define (regexed? e)
  (or (equal? e ER) (equal? e DD)))

;; ExpectsToSee -> ExpectsToSee
;; run the regex program with (regexp AA)
(define (regexp e)
  (big-bang e
            [to-draw render-state]
            [on-key    next-state]
            [stop-when   regexed? render-state]))