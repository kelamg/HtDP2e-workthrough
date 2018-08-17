;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex87) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define-struct editor [text index])
; An Editor is a structure:
;   (make-editor String Natural)
; interpretation (make-editor s i) describes an editor
; whose visible text is s, and i is the number of characters
; between the first character and the cursor 

(define E1 (make-editor " " 1))
(define E2 (make-editor "Some text" 5))
(define E3 (make-editor "Eskettit!" 9))
(define E4 (make-editor "A longer text" 9))

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
(check-expect (render (make-editor "hello world" 6))
              (overlay/align "left" "center"
                             (beside (text "hello " TEXT-SIZE TEXT-COLOR)
                                     CURSOR
                                     (text "world" TEXT-SIZE TEXT-COLOR))
                             MTS))

(define (render e)
  (overlay/align "left" "center"
                 (place-cursor e CURSOR)
                 MTS))

;; Editor Image -> Image
;; places img at the editor cursor index
(check-expect (place-cursor E2 CURSOR)
              (beside (text "Some " TEXT-SIZE TEXT-COLOR)
                      CURSOR
                      (text "text" TEXT-SIZE TEXT-COLOR)))
(check-expect (place-cursor E3 CURSOR)
              (beside (text "Eskettit!" TEXT-SIZE TEXT-COLOR)
                      CURSOR
                      (text "" TEXT-SIZE TEXT-COLOR)))

(define (place-cursor e img)
  (beside (text (substring (editor-text e) 0 (editor-index e))
                TEXT-SIZE TEXT-COLOR)
          img
          (text (substring (editor-text e) (editor-index e))
                TEXT-SIZE TEXT-COLOR)))


;; Editor KeyEvent -> Editor
;; adds a single-character KeyEvent ke to the end of the pre field of ed
;; unless ke denotes the backspace ("\b") key, ,in which case the character
;; immediately to the left of the cursor (if any) is deleted
;;
;; ignore tab key ("\t") and return key ("\r")
;;
;; pays attention to only two KeyEvents longer than one letter:
;;      "left" and "right"
(check-expect (edit E1 "a")     (make-editor " a" 2))
(check-expect (edit E1 "\b")    (make-editor "" 0))
(check-expect (edit E1 "left")  (make-editor " " 0))
(check-expect (edit E1 "right") E1)
(check-expect (edit E1 "up")    E1)
(check-expect (edit E1 "down")  E1)
(check-expect (edit E1 "shift") E1)
(check-expect (edit E2 "s")     (make-editor "Some stext" 6))
(check-expect (edit E2 "\b")    (make-editor "Sometext" 4))
(check-expect (edit E2 "\t")    E2)
(check-expect (edit E2 "\r")    E2)
(check-expect (edit E2 "left")  (make-editor "Some text" 4))
(check-expect (edit E2 "right") (make-editor "Some text" 6))
(check-expect (edit E2 "up")    E2)
(check-expect (edit E2 "down")  E2)
(check-expect (edit E2 "shift") E2)
(check-expect (edit E3 "!")     (make-editor "Eskettit!!" 10))
(check-expect (edit E3 "\b")    (make-editor "Eskettit" 8))
(check-expect (edit E3 "\t")    E3)
(check-expect (edit E3 "\r")    E3)
(check-expect (edit E3 "left")  (make-editor "Eskettit!" 8))
(check-expect (edit E4 "right") (make-editor "A longer text" 10))

(define (edit e ke)
  (cond
    [(string=? ke "\b")             (backspace e)]
    
    [(or (string=? ke "left")
         (string=? ke "right"))      (arrow e ke)]
    
    [(or (string=? ke "\t")
         (string=? ke "\r"))               e]
    
    [(= (string-length ke) 1)  (if (ignore-ke? e ke)
                                   e
                                   (insert e ke))]
    
    [else                                       e]))

;; Editor KeyEvent -> Boolean
;; produces true if inserting ke will make rendered text too
;; wide for the canvas
(check-expect (ignore-ke? E4 "a") false)
(check-expect
 (ignore-ke? (make-editor "A really long text but I need to this!" 38) "a")
 true)

(define (ignore-ke? e ke)
  (> (image-width (render (insert e ke))) WIDTH))

;; Editor -> Editor
;; backspace functionality
(check-expect (backspace E1)
              (make-editor "" 0))
(check-expect (backspace (make-editor "abcde" 3))
              (make-editor "abde" 2))

(define (backspace e)
  (make-editor (string-delete (editor-text e) (sub1 (editor-index e)))
               (- (editor-index e) 1)))
               

;; Editor KeyEvent -> Editor
;; arrow key functionality
(check-expect (arrow E1 "right") E1)
(check-expect (arrow E1 "left") (make-editor " " 0))
(check-expect (arrow (make-editor "make-editor" 6) "left")
              (make-editor "make-editor" 5))
(check-expect (arrow (make-editor "make-editor" 6) "right")
              (make-editor "make-editor" 7))

(define (arrow e ke)
  (move-cursor e ke))

;; Editor KeyEvent -> Editor
;; controls cursor movement
;; stops the cursor moving right when at end of word
;; stops the cursor moving left at beginning of word
(check-expect (move-cursor (make-editor "start" 0) "left")
              (make-editor "start" 0))
(check-expect (move-cursor (make-editor "end" 3) "right")
              (make-editor "end" 3))
(check-expect (move-cursor (make-editor "okay" 3) "left")
              (make-editor "okay" 2))
(check-expect (move-cursor (make-editor "okay" 3) "right")
              (make-editor "okay" 4))

(define (move-cursor e ke)
  (if (string=? ke "left")
      (if (and (string=? ke "left") (> (editor-index e) 0))
          (make-editor (editor-text e) (sub1 (editor-index e)))
          e)
      (if (and (string=? ke "right")
               (< (editor-index e) (string-length (editor-text e))))
          (make-editor (editor-text e) (add1 (editor-index e)))
          e)))

;; Editor KeyEvent -> Editor
;; inserts ke into e's pre field
(check-expect (insert (make-editor "dwee" 4) "b")
              (make-editor "dweeb" 5))
(check-expect (insert (make-editor "youre" 3) "'")
              (make-editor "you're" 4))

(define (insert e ke)
  (make-editor (string-insert ke (editor-text e) (editor-index e))
               (add1 (editor-index e))))

;; String -> Image
;; constructs an editor with s as the pre field and
;; launces an interactive editor
(define (run s)
  (big-bang (make-editor s (string-length s))
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

; String Index -> String/1String
; removes the character at index i in the string
; given:
;    "bright" for str
;     4       for i
; expected:
;    "brigt"
(define (string-delete str i)
  (if (> (string-length str) 0)
      (string-append (substring str 0 i) (substring str (+ i 1)))
      str))