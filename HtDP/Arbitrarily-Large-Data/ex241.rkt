;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex241) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An NEList-of-temperatures is one of: 
; – (cons CTemperature '())
; – (cons CTemperature NEList-of-temperatures)
; interpretation non-empty lists of Celsius temperatures

; An NEList-of-Booleans is one of: 
; – (cons Boolean '())
; – (cons Boolean NEList-of-Booleans)
; interpretation non-empty lists of booleans

;; An [NEList-of TYPE] is one of:
;; - (cons TYPE '())
;; - (cons TYPE [NEList-of TYPE])
; interpretation non-empty lists of TYPE