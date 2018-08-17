;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |130|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A List-of-names is one of: 
; – '()
; – (cons String List-of-names)
; interpretation a list of invitees, by last name

(cons "Moriera"
      (cons "Messi"
            (cons "Ronaldo"
                  (cons "Henry"
                        (cons "Pele" '())))))

;; (cons "1" (cons "2" '())) is a List-of-names because as the data
;; definition says, "1" and "2" are both of atomic type String
;; and (cons "2" '()) is a list-of-names; as described by the second
;; line of the data definition, it is therefore a list of names

;; (cons 2 '()) is not a list-of-names because 2 is of atomic type
;; Number. As the data definition only includes Strings, it is not
;; a list-of-names