;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex339) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require htdp/dir)

; A File is a structure: 
;   (make-file String N String)

; A Dir is a structure: 
;   (make-dir String [List-of Dir] [List-of File])

(define DIR (create-dir "Test-Dir/"))

(define FN1 "b.cpp")
(define FN2 "fn.py")

;; Dir String -> Boolean
;; produces true if s is contained in dir
(check-expect (find? DIR "fn.py") #false)
(check-expect (find? DIR "b.cpp")  #true)
(check-expect (find? DIR "f.md")   #true)

(define (find? dir s)
  (or (ormap (λ (f) (string=? s (file-name f))) (dir-files dir))
      (ormap (λ (d) (find? d s)) (dir-dirs dir))))