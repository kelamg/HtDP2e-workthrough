;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex508) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require racket/list)

(define FONT-SIZE 11)
(define FONT-COLOR "black")
 
; [List-of 1String] -> Image
; renders a string as an image for the editor 
(define (editor-text s)
  (text (implode s) FONT-SIZE FONT-COLOR))
 
(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor [List-of 1String] [List-of 1String])
; interpretation if (make-editor p s) is the state of 
; an interactive editor, (reverse p) corresponds to
; the text to the left of the cursor and s to the
; text on the right


;; [List-of 1String] Number -> Editor
;; produces an editor with ed split into
;; a pre field:
;;   everything before x
;; and a post field:
;;   everything after x
;; where x is the x-coordinate of the mouse click
(define testcase "sometext")

(check-expect
 (split-structural (explode testcase) 0)
 (make-editor '() (explode testcase)))
(check-expect
 (split-structural
  (explode testcase) (image-width (text "somet" FONT-SIZE FONT-COLOR)))
 (make-editor (explode "somet") (explode "ext")))
(check-expect
 (split-structural
  (explode testcase) (image-width (text testcase FONT-SIZE FONT-COLOR)))
 (make-editor (explode "sometext") '()))
(check-expect
 (split-structural
  (explode testcase) (+ 1 (image-width (text testcase FONT-SIZE FONT-COLOR))))
 (make-editor (explode "sometext") '()))
(check-expect
 (split-structural '() 100)
 (make-editor '() '()))

(define (split-structural ed x)
  (local (; [List-of 1String] Number -> [List-of 1String]
          ; gets the pre field by subtracting the image width of each
          ; item in ed0 from n
          (define (get-pre ed0 n)
            (cond
              [(or (<= n 0) (empty? ed0)) '()]
              [else
               (local ((define rem
                         (- n (image-width (editor-text (list (first ed0)))))))
                 (cons (first ed0)
                       (get-pre (rest ed0) rem)))]))
          
          (define pre (get-pre ed x)))

    (make-editor pre (drop ed (length pre)))))
