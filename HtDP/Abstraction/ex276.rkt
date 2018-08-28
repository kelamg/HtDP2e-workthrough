;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex276) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)
(require 2htdp/itunes)

; itunes export file from:
;    https://github.com/asciamanna/iTunesLibraryParser
(define ITUNES-LOCATION "IO/itunes.xml")

; LTracks
; uncomment to run on .xml file
;(define itunes-tracks
;  (read-itunes-as-tracks ITUNES-LOCATION))

; the 2htdp/itunes library documentation, part 1: 
 
; An LTracks is one of:
; – '()
; – (cons Track LTracks)
 
;(define-struct track
;  [name artist album time track# added play# played])
;; A Track is a structure:
;;   (make-track String String String N N Date N Date)
;; interpretation An instance records in order: the track's 
;; title, its producing artist, to which album it belongs, 
;; its playing time in milliseconds, its position within the 
;; album, the date it was added, how often it has been 
;; played, and the date when it was last played
; 
;(define-struct date [year month day hour minute second])
;; A Date is a structure:
;;   (make-date N N N N N N)
;; interpretation An instance records six pieces of information:
;; the date's year, month (between 1 and 12 inclusive), 
;; day (between 1 and 31), hour (between 0 
;; and 23), minute (between 0 and 59), and 
;; second (also between 0 and 59).


(define AD1 (create-date 2017 11  3  1 55 34))
(define AD2 (create-date 2010  2 14 11 23  5))
(define AD3 (create-date 2011 12 19 23 50 42))
(define AD4 (create-date 2011 11 25 22 00 20))
(define AD5 (create-date 2012 10 22  9 59 55))
(define PD1 (create-date 2018  8 17  2 30 12))
(define PD2 (create-date 2015 12  5 15 47 58))
(define PD3 (create-date 2014  6 21 15 13 29))
(define PD4 (create-date 2017  3 30 17 45 22))
(define PD5 (create-date 2018  1  3  9  3 50))
(define PD6 (create-date 2018  8 17  2 22 56))
(define PD7 (create-date 2015 12  5 15 55 13))

(define T1
  (create-track "I Hope I Sleep Tonight" "DJ Seinfeld"
                "Time Spent Away From U" 4060 1 AD1 323 PD1))
(define T2
  (create-track "Beat It" "Michael Jackson" "Thriller"
                4180 5 AD2 123 PD2))
(define T3
  (create-track "Memory Lane" "Netsky" "UKF Drum & Bass 2010"
                5350 1 AD3 148 PD3))
(define T4
  (create-track
   "All of the Lights" "Kanye West" "My Beautiful Dark Twisted Fantasy"
   5000 5 AD4 93 PD4))
(define T5
  (create-track
   "Lose Yourself" "Eminem" "8 Mile: Music from and Inspired by the Motion Picture"
   5200 1 AD5 231 PD5))
(define T6
  (create-track "U" "DJ Seinfeld" "Time Spent Away From U"
                6080 9 AD1 351 PD6))
(define T7
  (create-track "Billie Jean" "Michael Jackson" "Thriller"
                4540 6 AD2 170 PD7))


(define LT1 (list T1))
(define LT2 (list T1 T2 T3))
(define LT3 (list T1 T2 T3 T4 T5))
(define LT4 (list T1 T2 T3 T4 T5 T6))
(define LT5 (list T1 T2 T3 T4 T5 T6 T7))

;; [X X -> Boolean] [Y -> X] X [List-of Y] -> [List-of Y]
;; abstract selection function
;; produces ONLY the members of l for which fn? produces true
;; when given a selector fn for each element of ly, and x
(check-expect
 (select = posn-x 10 (list (make-posn 34 59) (make-posn 10 43)))
 (list (make-posn 10 43)))

(define (select fn? fn x l)
  (local (; Y [List-of Y] -> [List-of Y]
          (define (process y ly)
            (if (fn? x (fn y)) (cons y ly) ly)))
    (foldr process '() l)))

;; LTracks -> List-of-strings
;; produces a list of all album tiles in lt
(check-expect (select-all-album-titles '()) '())
(check-expect
 (select-all-album-titles LT1)
 (list "Time Spent Away From U"))
(check-expect
 (select-all-album-titles LT2)
 (list "Time Spent Away From U" "Thriller" "UKF Drum & Bass 2010"))
(check-expect
 (select-all-album-titles LT3)
 (list "Time Spent Away From U" "Thriller"
       "UKF Drum & Bass 2010" "My Beautiful Dark Twisted Fantasy"
       "8 Mile: Music from and Inspired by the Motion Picture"))

(define (select-all-album-titles lt)
  (map track-album lt))

;; List-of-strings -> List-of-strings
;; constructs a list of strings that contains
;; every String in los exactly once
(check-expect (create-set '()) '())
(check-expect
 (create-set (list "a")) (list "a"))
(check-expect
 (create-set (list "a" "b" "a" "c"))
 (list "a" "b" "c"))
(check-expect
 (create-set (list "d" "d" "e" "e" "f" "f" "f"))
 (list "d" "e" "f"))

(define (create-set los)
  (cond
    [(empty? los) '()]
    [else
     (if (member? (first los) (rest los))
         (cons (first los)
               (create-set (remove-all (first los) (rest los))))
         (cons (first los) (create-set (rest los))))]))

;; LTracks -> List-of-strings
;; produces a list of unique album titles in lt
(check-expect (select-album-titles/unique '()) '())
(check-expect
 (select-album-titles/unique LT1)
 (list "Time Spent Away From U"))
(check-expect
 (select-album-titles/unique LT2)
 (list "Time Spent Away From U" "Thriller" "UKF Drum & Bass 2010"))
(check-expect
 (select-album-titles/unique LT3)
 (list "Time Spent Away From U" "Thriller"
       "UKF Drum & Bass 2010" "My Beautiful Dark Twisted Fantasy"
       "8 Mile: Music from and Inspired by the Motion Picture"))
(check-expect
 (select-album-titles/unique LT4)
 (list "Time Spent Away From U" "Thriller"
       "UKF Drum & Bass 2010" "My Beautiful Dark Twisted Fantasy"
       "8 Mile: Music from and Inspired by the Motion Picture"))

(define (select-album-titles/unique lt)
  (create-set (select-all-album-titles lt)))


;; String LTracks -> LTracks
;; extracts the list of tracks in album s
(check-expect (select-album "Thriller" '()) '())
(check-expect
 (select-album "Thriller" LT3) (list T2))
(check-expect
 (select-album "Family Portrait" LT4) '())
(check-expect
 (select-album "Time Spent Away From U" LT4)
 (list T1 T6))

(define (select-album s lt)
  (select string=? track-album s lt))

;; String Date LTracks -> LTracks
;; extracts the list of tracks in album s that have been played after d
(check-expect (select-album-date "Thriller" PD2 '()) '())
(check-expect
 (select-album-date "Thriller" PD2 LT3) '())
(check-expect
 (select-album-date "Family Portrait" PD2 LT3) '())
(check-expect
 (select-album-date "Thriller" PD3 LT3) (list T2))
(check-expect
 (select-album-date "Time Spent Away From U" PD1 LT4) '())
(check-expect
 (select-album-date "Time Spent Away From U" PD6 LT4)
 (list T1))
(check-expect
 (select-album-date "Time Spent Away From U" PD4 LT4)
 (list T1 T6))

(define (select-album-date s d lt)
  (local (; Date Date -> Boolean
          ; produces true if d1 < d2
          (define (date<? d1 d2)
            (< (date->seconds d1) (date->seconds d2)))

          ;; Date -> N
          ;; calculate number of seconds in a date
          (define (date->seconds d)
            (+ (* (date-year   d) 31557600)
               (* (date-month  d) 2629800)
               (* (date-day    d) 86400)
               (* (date-hour   d) 3600)
               (* (date-minute d) 60)
               (date-second d))))
    
    (select date<? track-played d (select-album s lt))))

;; LTracks -> List-of-LTracks
;; produces a list of list of tracks, one per album
(check-expect (select-albums '()) '())
(check-expect
 (select-albums LT1)
 (list (list T1)))
(check-expect
 (select-albums LT2)
 (list (list T1) (list T2) (list T3)))
(check-expect
 (select-albums LT4)
 (list (list T1 T6) (list T2) (list T3) (list T4) (list T5)))
(check-expect
 (select-albums LT5)
 (list (list T1 T6) (list T2 T7) (list T3) (list T4) (list T5)))

(define (select-albums lt)
  (local (; String -> [List-of LTracks]
          ; add this album's tracks to accumulated list l
          (define (combine s l)
            (cons (select-album s lt) l)))
    (foldr combine '() (select-album-titles/unique lt))))

