;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex331) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

; A Dir.v1 (short for directory) is one of: 
; – '()
; – (cons File.v1 Dir.v1)
; – (cons Dir.v1 Dir.v1)
 
; A File.v1 is a String.

;; figure 123
(define DIR
  '(("part1" "part2" "part3")
    "read!"
    (("hang" "draw")
     ("read!"))))

;; Dir.v1 -> N
;; produces the number of files contained in dir
(check-expect (how-many '()) 0)
(check-expect (how-many DIR) 7)

(define (how-many dir)
  (foldr (λ (d dirs)
           (+ (match d
                [(cons f r) (how-many d)]
                [(? string?)           1])
              dirs))
         0
         dir))