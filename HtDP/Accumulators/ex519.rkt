;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex519) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - Is it acceptable to impose the extra cost on cons for all programs
;;     to turn length into a constant-time function?

;; A - I don't think it would be acceptable based on the fact that while we
;;     are increasing the time for computation a bit, we are also increasing
;;     the memory required to store the accumulator data by 33%.
