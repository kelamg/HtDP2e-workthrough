;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex80) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; designing with structures

(define-struct movie (title director year))
#;
(define (fn-for-movie m)
  (... (movie-title    m)
       (movie-director m)
       (movie-year     m)))

;; =========================================

(define-struct pet (name number))
#;
(define (fn-for-pet p)
  (... (pet-name   p)
       (pet-number p)))

;;==========================================

(define-struct CD (artist title price))
#;
(define (fn-for-CD cd)
  (... (CD-artist cd)
       (CD-title  cd)
       (CD-price  cd)))

;; =========================================

(define-struct sweater (material size color))
#;
(define (fn-for-sweater s)
  (... (sweater-material s)
       (sweater-size     s)
       (sweater-color    s)))
  
        