;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex85) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with 
; the cursor displayed between s and t

(define E1 (make-editor " " ""))
(define E2 (make-editor "Some " "text"))
(define E3 (make-editor "Eskettit!" ""))
(define E4 (make-editor "A longer " "text"))

;; Constants:

(define WIDTH  200)
(define HEIGHT 20)
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


;; Editor KeyEvent -> Editor
;; adds a single-character KeyEvent ke to the end of the pre field of ed
;; unless ke denotes the backspace ("\b") key, ,in which case the character
;; immediately to the left of the cursor (if any) is deleted
;;
;; ignore tab key ("\t") and return key ("\r")
;;
;; pays attention to only two KeyEvents longer than one letter:
;;      "left" and "right"
(check-expect (edit E1 "a")     (make-editor " a" ""))
(check-expect (edit E1 "\b")    (make-editor "" ""))
(check-expect (edit E1 "left")  (make-editor "" " "))
(check-expect (edit E1 "right") (make-editor " " ""))
(check-expect (edit E1 "up")    E1)
(check-expect (edit E1 "down")  E1)
(check-expect (edit E1 "shift") E1)
(check-expect (edit E2 "s")     (make-editor "Some s" "text"))
(check-expect (edit E2 "\b")    (make-editor "Some" "text"))
(check-expect (edit E2 "\t")    E2)
(check-expect (edit E2 "\r")    E2)
(check-expect (edit E2 "left")  (make-editor "Some" " text"))
(check-expect (edit E2 "right") (make-editor "Some t" "ext"))
(check-expect (edit E2 "up")    E2)
(check-expect (edit E2 "down")  E2)
(check-expect (edit E2 "shift") E2)
(check-expect (edit E3 "\b")    (make-editor "Eskettit" ""))
(check-expect (edit E3 "\t")    E3)
(check-expect (edit E3 "\r")    E3)
(check-expect (edit E3 "left")  (make-editor "Eskettit" "!"))
(check-expect (edit E4 "right") (make-editor "A longer t" "ext"))

(define (edit e ke)
  (cond
    [(string=? ke "\b")        (backspace e)]
    [(or (string=? ke "left")
         (string=? ke "right")) (arrow e ke)]
    [(or (string=? ke "\t")
         (string=? ke "\r"))               e]
    [(= (string-length ke) 1)  (insert e ke)]
    [else                                  e]))

;; Editor -> Editor
;; backspace functionality
(check-expect (backspace E1)
              (make-editor "" ""))
(check-expect (backspace (make-editor "abc" "de"))
              (make-editor "ab" "de"))

(define (backspace e)
  (make-editor (string-remove-last (editor-pre e))
               (editor-post e)))

;; Editor KeyEvent -> Editor
;; arrow key functionality
(check-expect (arrow E1 "right") E1)
(check-expect (arrow E1 "left") (make-editor "" " "))
(check-expect (arrow (make-editor "make-e" "ditor") "left")
              (make-editor "make-" "editor"))
(check-expect (arrow (make-editor "make-e" "ditor") "right")
              (make-editor "make-ed" "itor"))

(define (arrow e ke)
  (cond
    [(string=? ke "left")  (make-editor
                            (string-remove-last (editor-pre e))
                            (string-insert (string-last (editor-pre e))
                                           (editor-post e)
                                           0))]
    [(string=? ke "right") (make-editor
                            (string-append (editor-pre e)
                                           (string-first (editor-post e)))
                            (string-rest (editor-post e)))]))

;; Editor KeyEvent -> Editor
;; inserts ke into e's pre field
(check-expect (insert (make-editor "dwee" "") "b")
              (make-editor "dweeb" ""))

(define (insert e ke)
  (make-editor (string-insert ke (editor-pre e) (string-length (editor-pre e)))
               (editor-post e)))

;; String -> Image
;; constructs an editor with s as the pre field and
;; launces an interactive editor
(define (run s)
  (big-bang (make-editor s "")
    [to-draw render]
    [on-key    edit]))
                                          
; String -> 1String
; returns the first character from a non-empty string
; given:
;    "Datboi" for str
; expected:
;    "D"
(define (string-first str)
  (if (> (string-length str) 0)
      (string-ith str 0)
      str))

; String -> 1String
; extracts the last character from a non-empty string
; given:
;    "Datboi" for str
; expected:
;    "i"
(define (string-last str)
  (if (> (string-length str) 0)
      (string-ith str (- (string-length str) 1))
      str))

; String -> String/1String
; removes the last character from the given string
; given:
;    "axes" for str
; expected:
;    "axe"
(define (string-remove-last str)
  (if (> (string-length str) 0)
      (string-append (substring str 0 (- (string-length str) 1)))
      str))

; String/1String String Index -> String
; inserts a string s into the string index i
; given:
;    "het" for str
;    "a"   for s
;    2     for i
; expected:
;    "heat"
(define (string-insert s str i)
  (if (> (string-length str) 0)
      (string-append (substring str 0 i) s (substring str i))
      s))

; String -> String/1String
; removes the first character from the given string
; given:
;    "bright" for str
; expected:
;    "right"
(define (string-rest str)
  (if (> (string-length str) 0)
      (string-append (substring str 1))
      str))