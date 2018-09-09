;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex336) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct file [name size content])
; A File.v3 is a structure: 
;   (make-file String N String)

(define-struct dir [name dirs files])
; A Dir.v3 is a structure: 
;   (make-dir String Dir* File*)
 
; A Dir* is one of: 
; – '()
; – (cons Dir.v3 Dir*)
 
; A File* is one of: 
; – '()
; – (cons File.v3 File*)

;; figure 123
(define DIR
  (make-dir
   "TS"
   (list
    (make-dir "Text" '() (list (make-file "part1" 99 "")
                               (make-file "part2" 52 "")
                               (make-file "part3" 17 "")))
    (make-dir "Libs"
              (list (make-dir "Code" '() (list (make-file "hang" 8 "")
                                               (make-file "draw" 2 "")))
                    (make-dir "Docs" '() (list (make-file "read!" 19 ""))))
              '()))
   (list (make-file "read!" 10 ""))))

;; Dir.v3 -> N
;; produces the number of files contained in dir
(check-expect
 (how-many (make-dir "root" '() '())) 0)
(check-expect (how-many DIR) 7)

(define (how-many dir)
  (+ (foldr + 0 (map how-many (dir-dirs dir)))
     (length (dir-files dir))))

;; Q - Why are you confident that how-many produces correct results?

;; A - By running the same tests as we ran on previous definitions
;;     on this version, we can be confident in the results if the tests pass.

