;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex76) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; data universe

(define-struct movie (title producer year))
;; A Movie is a structure:
;;   (make-movie String String Integer)
;; interp. a movie, including its title, its producer
;; or production company and year of release

(define-struct person (name hair eyes phone))
;; A Person is a structure:
;;   (make-person String String String Integer
;; interp. a person, including details:
;;         the person's name, their hair colour, eye colour,
;;         and phone number represented as an integer value

(define-struct pet (name number))
;; A Pet is a structure:
;;   (make-pet (String Integer)
;; interp. a pet, including its name and number on tag

(define-struct CD (artist title price))
;; A CD is a structure:
;;   (make-CD String String Number)
;; interp. a CD is an album, including information on
;;         the name of the artist whose album it is,
;;         the title of the album, and its retail price

(define-struct sweater (material size producer))
;; A Sweater is a structure:
;;   (make-sweater String 1String/String String)
;; interp. a sweater is clothing, including information on
;;         the material it is made of, its size in 1String or String,
;;         and the maker of the sweater