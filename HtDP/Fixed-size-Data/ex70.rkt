;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex70) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; structure laws

(define-struct centry (name home office cell))
;; (centry-name    (make-centry n0 h0 o0 c0)) == n0
;; (centry-home    (make-centry n0 h0 o0 c0)) == h0
;; (centry-office  (make-centry n0 h0 o0 c0)) == o0
;; (centry-cell    (make-centry n0 h0 o0 c0)) == c0

(define-struct phone  (area number))
;; (phone-area     (make-phone a0 n0)) == a0
;; (phone-number   (make-phone a0 n0)) == n0

(check-expect 
 (phone-area
  (centry-office
   (make-centry "Shriram Fisler"
                (make-phone 207 "363-2421")
                (make-phone 101 "776-1099")
                (make-phone 208 "112-9981"))))
 101)