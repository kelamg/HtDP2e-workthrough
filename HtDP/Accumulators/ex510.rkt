;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex510) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

;; N String String -> File
;; arrange all words in in-f in the given order
;; into lines of maximal width w, and write to out-f
(check-expect (fmt 50 "IO/in-f" "IO/out-f") "IO/out-f")

(define (fmt w in-f out-f)
  (local (; [List-of String] String -> String
          ; accumulator a is the strings (each of width w)
          ; that make up the output file so far
          (define (fmt/a l a)
            (cond
              [(empty? l) a]
              [else
               (fmt/a (rest l)
                      (string-append a (fmt-line (first l))))]))

          ; String -> String
          ; rearrange a line from input file
          (define (fmt-line s)
            (local ((define strlen (string-length s)))
              (cond
                [(<= strlen w) (string-append s "\n")]
                [else
                 (fmt/a
                  (list (substring s 0 w) (substring s w strlen)) "")]))))

    (write-file out-f (fmt/a (read-lines in-f) ""))))

