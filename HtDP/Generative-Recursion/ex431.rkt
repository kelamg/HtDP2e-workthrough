;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex431) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; ---------------------------------------------------------------------------
; BUNDLE
;----------------------------------------------------------------------------

; What is a trivially solvable problem?
; 1 - an empty list
; 2 - 0 chunk size

; How are trivial solutions solved?
; 1 - return an empty list
; 2 - return the supplied list, or return an error

; How does the algorithm generate new problems that are more easily solvable
; than the original one? Is there one new problem that we generate or are
; there several?
; - We generate one new problem, which is more easily solvable than the
;   original because it is a shorter list than the previous one, which
;   inevitably leads to the trivial case

; Is the solution of the given problem the same as the solution of (one of)
; the new problems? Or, do we need to combine the solutions to create a
; solution for the original problem? And, if so, do we need anything from
; the original problem data?
; - We combine the solutions using cons to create a solution for the
;   original problem.

; ---------------------------------------------------------------------------
; END BUNDLE
;----------------------------------------------------------------------------


; ---------------------------------------------------------------------------
; QUICK-SORT<
;----------------------------------------------------------------------------

; What is a trivially solvable problem?
; 1 - an empty list
; 2 - a one-item list

; How are trivial solutions solved?
; 1 - return an empty list
; 2 - return the supplied list as it is already sorted

; How does the algorithm generate new problems that are more easily solvable
; than the original one? Is there one new problem that we generate or are
; there several?
; - We generate several new problems; we sort a new list of the numbers
;   smaller than the first number in the given list and another of those
;   numbers larger than the first number in the given list. These new problems
;   are more easily solvable than the original because they are smaller than the
;   original, which means they inevitably reach the trivial case.

; Is the solution of the given problem the same as the solution of (one of)
; the new problems? Or, do we need to combine the solutions to create a
; solution for the original problem? And, if so, do we need anything from
; the original problem data?
; - We combine the solutions using append to group the solutions of all
;   generated problems and pivots. We need the first number of the original list
;   to solve the entire problem.

; ---------------------------------------------------------------------------
; END QUICK-SORT<
;----------------------------------------------------------------------------
