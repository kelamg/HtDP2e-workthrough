;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex334) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct dir [name content size readability])
;; A Dir is a structure: 
;;   (make-dir String LOFD Number Boolean)
;; interp. a directory's name, content, size
;;         and whether or not anyone else besides
;;         the user may browse its contents
;; example:
;;         (make-dir "root" '() 1 #false)
;;         represents an empty directory called root,
;;         has a size of 1 and is read privileges reserved  
;;         for the file owner only