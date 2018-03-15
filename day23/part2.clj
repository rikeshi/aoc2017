;;
;; The program sets B to a value and C to B plus some amount.
;; It then runs in a loop, adding a small amount to B every iteration.
;; The program exits when B == C.
;;
;; H is possibly incremented once every iteration of the program.
;; This increment only happens if F is set to 0.
;; Whether F is set to 0 depends in turn on the values of D and E.
;;
;; Every iteration F starts out at 1, and both D and E start at 2.
;; F is set to 0 only if E * D == B.
;; E increments in a loop until is is equal to B.
;; When this condition is met D increments by 1 and E is reset to 2.
;; This then repeats until D is eventually also equal to B.
;;
;; Every time E is incremented, E * D == B is checked.
;; If its true then F is set to 0 and H will be incremented.
;; Since both D and E cover all values between 2 and B,
;; the only way D * E would never be equal to B
;; is if B would be a prime number, which cannot be formed
;; by the multiplication of two numbers smaller than it.
;; So to calculate the final value of H we have to find out
;; how many values in the interval [B, C] are primes.
;; Then subract this number from the total number of iterations.
;;


;; AKS primality test
(defn prime? [n]
  (cond
    (= 2 n) true
    (= 3 n) true
    (= 0 (rem n 2)) false
    (= 0 (rem n 3)) false
    :else (loop [i 5 w 2]
            (cond
              (= 0 (rem n i)) false
              (> (* i i) n) true
              :else (recur (+ i w) (- 6 w))))))


(defn count-composites [b c]
  (count
    (filter false?
      ;; in my input B is incremented by 17 each iteration
      (map prime? (range b (inc c) 17)))))

;; my input's initial B and C values
(def b (- (* 81 100) -100000))
(def c (- b -17000))


(prn (count-composites b c))
