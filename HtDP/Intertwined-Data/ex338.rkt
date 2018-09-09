;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex338) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require htdp/dir)
(require 2htdp/abstraction)

; A File.v3 is a structure: 
;   (make-file String N String)

; A Dir.v3 is a structure: 
;   (make-dir String [List-of Dir.v3] [List-of File.v3])

(define DIR (create-dir "Test-Dir/"))

;; Dir.v3 -> N
;; produces the number of files contained in dir
(check-expect
 (how-many (make-dir "root" '() '())) 0)
(check-expect (how-many DIR) 7)

(define (how-many dir)
  (+ (for/sum ([d (dir-dirs dir)]) (how-many d))
     (length (dir-files dir))))

;; Q - Why are you confident that how-many produces correct results for these
;;     directories?
;; A - I created a test directory to run tests on.
