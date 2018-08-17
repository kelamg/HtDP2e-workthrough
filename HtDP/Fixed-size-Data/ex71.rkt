;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex71) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; structures

; distances in terms of pixels:
(define HEIGHT 200)
(define MIDDLE (quotient HEIGHT 2))
(define WIDTH  400)
(define CENTER (quotient WIDTH 2))

(define-struct game [left-player right-player ball])

(define game0
  (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))

;; ===============
(game-ball game0)

(game-ball (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))

(make-posn CENTER CENTER)

(make-posn 200 200)

;; ===============
(posn? (game-ball game0))

(posn? (game-ball (make-game MIDDLE MIDDLE (make-posn CENTER CENTER))))

(posn? (make-posn CENTER CENTER))

(posn? (make-posn 200 200))

#true

;; ===============
(game-left-player game0)

(game-left-player (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))

MIDDLE

100