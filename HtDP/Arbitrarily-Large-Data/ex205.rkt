;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex205) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)
(require 2htdp/itunes)

; itunes export file from:
;    https://github.com/asciamanna/iTunesLibraryParser
(define ITUNES-LOCATION "IO/itunes.xml")

; LLists
; uncomment to run on .xml file
;(define list-tracks
;  (read-itunes-as-lists ITUNES-LOCATION))

; the 2htdp/itunes library documentation, part 2: 
 
; An LLists is one of:
; – '()
; – (cons LAssoc LLists)
 
; An LAssoc is one of: 
; – '()
; – (cons Association LAssoc)
; 
; An Association is a list of two items: 
;   (cons String (cons BSDN '()))
 
; A BSDN is one of: 
; – Boolean
; – Number
; – String
; – Date

;; Helpers for creating associations

;; BDSN (String) -> Association
;; produce a name association
(define (create-title s)
  (list "name" s))

;; BDSN (String) -> Association
;; produce an artist association
(define (create-artist s)
  (list "artist" s))

;; BDSN (String) -> Association
;; produce an album title association
(define (create-album s)
  (list "album" s))

;; BDSN (Number) -> Association
;; produce a track duration association
(define (create-time n)
  (list "time" n))

;; BDSN (Number) -> Association
;; produce a track number association
(define (create-track# n)
  (list "track#" n))

;; BDSN (Date) -> Association
;; produce a date added association
(define (create-added d)
  (list "added" d))

;; BDSN (Number) -> Association
;; produce a play count association
(define (create-play# n)
  (list "play#" n))

;; BDSN (Date) -> Association
;; produce a last played association
(define (create-played d)
  (list "played" d))

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

;; A Track is LAssoc
(define A1
  (list (create-title  "I Hope I Sleep Tonight")
        (create-artist "DJ Seinfeld")
        (create-album  "Time Spent Away From U")
        (create-time   4060)
        (create-track# 1)
        (create-added  AD1)
        (create-play#  323)
        (create-played PD1)))
(define A2
  (list (create-title  "Beat It")
        (create-artist "Michael Jackson")
        (create-album  "Thriller")
        (create-time   4180)
        (create-track# 5)
        (create-added  AD2)
        (create-play#  123)
        (create-played PD2)))
(define A3
  (list (create-title  "Memory Lane")
        (create-artist "Netsky")
        (create-album  "UKF Drum & Bass 2010")
        (create-time   5350)
        (create-track# 1)
        (create-added  AD3)
        (create-play#  148)
        (create-played PD3)))
(define A4
  (list (create-title  "All of the Lights")
        (create-artist "Kanye West")
        (create-album  "My Beautiful Dark Twisted Fantasy")
        (create-time   5000)
        (create-track# 5)
        (create-added  AD4)
        (create-play#  93)
        (create-played PD4)))
(define A5
  (list (create-title  "Lose Yourself")
        (create-artist "Eminem")
        (create-album  "8 Mile: Music from and Inspired by the Motion Picture")
        (create-time   5200)
        (create-track# 1)
        (create-added  AD5)
        (create-play#  231)
        (create-played PD5)))
(define A6
  (list (create-title  "U")
        (create-artist "DJ Seinfeld")
        (create-album  "Time Spent Away From U")
        (create-time   6080)
        (create-track# 9)
        (create-added  AD1)
        (create-play#  351)
        (create-played PD6)))
(define A7
  (list (create-title  "Billie Jean")
        (create-artist "Michael Jackson")
        (create-album  "Thriller")
        (create-time   4540)
        (create-track# 6)
        (create-added  AD2)
        (create-play#  170)
        (create-played PD7)))

;; LLists
(define LL1 (list A1))
(define LL2 (list A1 A2 A3))
(define LL3 (list A1 A2 A3 A4 A5))
(define LL4 (list A1 A2 A3 A4 A5 A6))
(define LL5 (list A1 A2 A3 A4 A5 A6 A7))


