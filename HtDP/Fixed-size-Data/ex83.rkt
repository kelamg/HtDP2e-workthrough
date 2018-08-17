;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex83) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; graphical editor

(require 2htdp/image)
(require 2htdp/universe)

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with 
; the cursor displayed between s and t

(define E1 (make-editor "" ""))
(define E2 (make-editor "Some " "text"))
(define E3 (make-editor "Eskettit!" ""))
(define E4 (make-editor "A longer " "text"))

;; Constants:

(define WIDTH  200)
(define HEIGHT  20)
(define MTS    (empty-scene WIDTH HEIGHT))

(define CURSOR     (rectangle 1 20 "solid" "red"))
(define TEXT-COLOR "black")
(define TEXT-SIZE  16)

;; Editor -> Image
;; produces an image of the current state of the editor
(check-expect (render E2)
              (overlay/align "left" "center"
                             (beside (text "Some " TEXT-SIZE TEXT-COLOR)
                                     CURSOR
                                     (text "text" TEXT-SIZE TEXT-COLOR))
                             MTS))
(check-expect (render (make-editor "hello " "world"))
              (overlay/align "left" "center"
                             (beside (text "hello " TEXT-SIZE TEXT-COLOR)
                                     CURSOR
                                     (text "world" TEXT-SIZE TEXT-COLOR))
                             MTS))

(define (render e)
  (overlay/align "left" "center"
                 (beside (text (editor-pre e) TEXT-SIZE TEXT-COLOR)
                         CURSOR
                         (text (editor-post e) TEXT-SIZE TEXT-COLOR))
                 MTS))

