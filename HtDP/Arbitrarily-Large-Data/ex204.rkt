;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex204) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

;; LTracks -> N
;; produces the total amount of playing time (in milliseconds) of lt
(check-expect (total-time '()) 0)
(check-expect (total-time LT1) (track-time T1))
(check-expect
 (total-time LT2)
 (+ (track-time T1) (track-time T2) (track-time T3)))
(check-expect
 (total-time LT3)
  (+ (track-time T1) (track-time T2)
     (track-time T3) (track-time T4) (track-time T5)))

(define (total-time lt)
  (cond
    [(empty? lt) 0]
    [else (+ (track-time (first lt))
             (total-time (rest lt)))]))

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
  (cond
    [(empty? lt) '()]
    [else
     (cons (track-album (first lt))
           (select-all-album-titles (rest lt)))]))

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
  (create-set
   (cond
     [(empty? lt) '()]
     [else 
      (cons (track-album (first lt))
            (select-album-titles/unique (rest lt)))])))

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
  (cond
    [(empty? lt) '()]
    [else
     (if (string=? s (track-album (first lt)))
         (cons (first lt) (select-album s (rest lt)))
         (select-album s (rest lt)))]))

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

(define (select-album-date s d lt)
  (select-album-date-proper d (select-album s lt)))

;; Date LTracks -> LTracks
;; extracts the tracks from lt played after d
(define (select-album-date-proper d lt)
  (cond
    [(empty? lt) '()]
    [else
     (if (date<? d (track-played (first lt)))
         (cons (first lt)
               (select-album-date-proper d (rest lt)))
         (select-album-date-proper d (rest lt)))]))

;; Date Date -> Boolean
;; produces true if d1 < d2
(check-expect (date<? PD1 PD1) #f)
(check-expect (date<? PD1 PD2) #f)
(check-expect (date<? PD2 PD1) #t)
(check-expect (date<? PD3 PD2) #t)
(check-expect
 (date<? PD1 (create-date 2018 8 17 2 30 13)) #t)

(define (date<? d1 d2)
  (< (date->seconds d1) (date->seconds d2)))

;; Date -> N
;; calculate number of seconds in a date
(check-expect
 (date->seconds (create-date 0 0 1 1 1 1))
 (+ 86400 3600 60 1))
(check-expect
 (date->seconds (create-date 1 1 1 1 1 1))
 (+ 31557600 2629800 86400 3600 60 1))

(define (date->seconds d)
  (+ (* (date-year   d) 31557600)
     (* (date-month  d) 2629800)
     (* (date-day    d) 86400)
     (* (date-hour   d) 3600)
     (* (date-minute d) 60)
     (date-second d)))

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
  (select-albums-proper (select-album-titles/unique lt) lt))

;; List-of-strings LTracks -> List-of-LTracks
;; produces a list of LTracks from a list of unique album strings los
(check-expect
 (select-albums-proper
  (list "Time Spent Away From U") LT3)
 (list (list T1)))
(check-expect
 (select-albums-proper
  (list "Time Spent Away From U") LT5)
 (list (list T1 T6)))
(check-expect
 (select-albums-proper
  (list "Time Spent Away From U" "Thriller") LT5)
 (list (list T1 T6) (list T2 T7)))

(define (select-albums-proper los lt)
  (cond
    [(empty? los) '()]
    [else
     (cons (select-album (first los) lt)
           (select-albums-proper (rest los) lt))]))
