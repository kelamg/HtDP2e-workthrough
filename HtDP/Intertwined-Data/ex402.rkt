;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex402) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - Why was it a good a idea to think of the given expression 
;;     as an atomic value at first in exercise 354?
;;
;; A - Thinking of it as atomic was a good idea because we could
;;     bypass the need to process both the expression and the
;;     association list simultaneously. We could just use the
;;     expression as is, and substitute into it any variables in the
;;     association list, by processing the association list ONLY.
;;     Doing the same exercise now would simply require
;;     simultaneously processing both the expression and the association
;;     list in one go, and without using `subst`.