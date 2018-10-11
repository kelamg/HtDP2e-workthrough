;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex520) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - The solve* function generates all states reachable with n boat trips
;;     before it looks at states that require n + 1 boat trips, even if some
;;     of those boat trips return to previously encountered states. Because
;;     of this systematic way of traversing the tree, solve* cannot go into
;;     an infinite loop. Why?

;; A - solve* uses an ormap to test these different states before proceeding,
;;     which means that it does not call the solve function recursively on
;;     each state and thus an infinite loop cannot be reached.

