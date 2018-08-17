;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex103) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; zoo animals

(define-struct vol (length width height))
;; A Volume is a structure:
;;   (make-vol Number Number Number)
;; interp. the volume of an object (dimensions in cm cubed)

(define VOL1 (make-vol 10 20 30))
(define VOL2 (make-vol 200 100 50))
#;
(define (fn-for-vol v)
  (... (vol-length v)
       (vol-width  v)
       (vol-height v)))

(define-struct spider (legs vol))
;; A Spider is a structure:
;;   (make-spider Integer Volume)
;; interp. a spider has a number of remaining legs
;;         and the volume of its thorax (in cm cubed)

(define S1 (make-spider 8 (make-vol 10 10 7)))
#;
(define (fn-for-spider s)
  (... (spider-legs s)
       (spider-vol s)))

;; An Elephant is a Volume
;; interp. the volume of an elephant

(define E1 (make-vol 200 120 250))

(define-struct boa (length girth))
;; A BoaConstrictor is a structure:
;;   (make-boa Number Number)
;; interp. a boa has a length and a girth

(define B1 (make-boa 400 30))
#;
(define (fn-for-boa b)
  (... (boa-length b)
       (boa-girth  b)))

(define-struct armadillo (tongue-length length vol))
;; An Armadillo is a structure:
;;    (make-armadillo Number Volume)
;; interp. an armadillo has a length,
;;         a tongue length and
;;         the volume of its body (in cm cubed)

(define A1 (make-armadillo 30 1400 (make-vol 200 75 50)))
#;
(define (fn-for-armadillo a)
  (... (armadillo-tongue-length a)
       (armadillo-length a)
       (armadillo-volume a)))

;; Cage is a Volume
;; interp. the volume of a cage used to transport a zoo animal

;; ZooAnimal is one of:
;;  - Spider
;;  - Elephant
;;  - Boa
;;  - Armadillo
;; interp. a zoo animal
#;
(define (fn-for-zooanimal za)
  (cond
    [(spider? za)    (fn-for-spider    za)]
    [(boa? za)       (fn-for-boa       za)]
    [(armadillo? za) (fn-for-armadillo za)]
    [else
     (... za)]))

;; ZooAnimal Cage -> Boolean
;; determines whether the cage's volume c
;; is large enough for the zoo animal za
(check-expect (fits? S1 VOL1)  true)
(check-expect (fits? E1 VOL1) false)
(check-expect (fits? B1 VOL1)  true)
(check-expect (fits? A1 VOL1) false)
(check-expect (fits? A1 VOL2)  true)
(check-expect (fits? E1 VOL2) false)

(define (fits? za c)
  (cond
    [(spider? za)    (< (spider->volume za) (volume c))]
    [(boa? za)       (< (boa->volume  za) (volume c))]
    [(armadillo? za) (< (armadillo->volume za) (volume c))]
    [else
     (< (volume za) (volume c))]))

;; Volume -> Number
;; converts a volume structure into its numerical equivalent
(check-expect (volume VOL1) 6000)

(define (volume v)
  (* (vol-length v)
     (vol-width  v)
     (vol-height v)))

;; Spider -> Number
;; produces the volume of a spider
(check-expect (spider->volume S1) 700)
              
(define (spider->volume s)
  (volume (spider-vol s)))

;; Boa -> Number
;; produces the volume of a boa, a boa can coil up
(check-expect (boa->volume B1) 2400)
              
(define (boa->volume b)
  (* (/ (boa-length b) (/ (boa-girth b)
                          (round (inexact->exact pi))))
     (* (boa-girth b) 2)))

;; Armadillo -> Number
;; produces the volume of an armadillo
(check-expect (armadillo->volume A1) 750000)

(define (armadillo->volume a)
  (volume (armadillo-vol a)))
