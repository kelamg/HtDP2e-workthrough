;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex129) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; BSL Lists

(cons "Mercury"
      (cons "Venus"
            (cons "Earth"
                  (cons "Mars"
                        (cons "Jupiter"
                              (cons "Saturn"
                                    (cons "Uranus"
                                          (cons "Neptune" '()))))))))

;; ======================================================================

(cons "Steak"
      (cons "French Fries"
            (cons "Beans"
                  (cons "Bread"
                        (cons "Water"
                              (cons "Brie Cheese"
                                    (cons "Ice cream" '())))))))

;; ======================================================================

(cons "red"
      (cons "orange"
            (cons "yellow"
                  (cons "green"
                        (cons "blue"
                              (cons "indigo"
                                    (cons "violet"
                                          (cons "white" '()))))))))

;; Second box is better because it is easier to pick out the first item
;; from the list