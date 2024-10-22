;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex200) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)
(require 2htdp/itunes)

; itunes export file from:
;    https://github.com/shuckster/iTunes-XML-parser-for-PHP
(define ITUNES-LOCATION "IO/itunes.xml")

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

(define LT1 (list T1))
(define LT2 (list T1 T2 T3))
(define LT3 (list T1 T2 T3 T4 T5))

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
