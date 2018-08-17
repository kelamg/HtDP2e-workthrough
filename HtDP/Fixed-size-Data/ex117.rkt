;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex117) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(3 + 4)

number?

(x)

;; (3 + 4) is illegal because it places a value after a parenthesis
;; causes BSL to treat it like a function call, which it isn't

;; number? is treated as a plain expression here rather than
;; the function it is. It is illegal because BSL expects it to be called
;; with open parenthesis and a variable

;; (x) looks like a function call but is illegal because it is not
;; immediately followed by at least one argument