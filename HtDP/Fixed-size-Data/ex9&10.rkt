;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ex9) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require 2htdp/image)

(define in "placeholder")

(if (string? in)
    (string-length in)
    (if (image? in)
        (* (image-height in) (image-width in))
        (if (number? in)
            (if (<= in 0)
                in
                (- in 1))
            (if (boolean? in)
                (if (and in #true)
                    10
                    20)
                "None"))))