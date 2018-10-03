;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex478) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - You can also place the first queen in all squares of the top-most row,
;;     the right-most column, and the bottom-most row. Explain why all of these
;;     solutions are just like the three scenarios depicted in figure 173.

;; A - For n = 3 with a queen placed at any position on the board, there will
;;     be a square 2 steps in the vertical or horizontal direction, then 1 step
;;     in the corresponding other direction, which the first queen does not
;;     threaten. This generalization holds for the three scenarios depicted in
;;     figure 173. Notice how each queen is on a square an L-shaped pattern away.


;; Q - This leaves the central square. Is it possible to place even a second queen
;;     after you place one on the central square of a 3 by 3 board?

;; A - No. A queen in the central square threatens every other square on an n = 3
;;     board. The generalization earlier also holds here. Notice how it isn't
;;     possible to move place a second queen two squares away from a queen in the
;;     central position.
