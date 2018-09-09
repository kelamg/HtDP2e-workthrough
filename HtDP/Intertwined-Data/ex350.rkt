;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex350) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; The definition for the parse function is unusual with respect to the
;; design recipe in the fact that it does not iterate through the input
;; list, acting on its items and then merging them into some output.
;; Rather, it does some sort of typechecking using the first item of the list only.