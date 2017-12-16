(defn generator-a
  [value]
  (rem (* value 16807) 2147483647))


(defn generator-b
  [value]
  (rem (* value 48271) 2147483647))


(defn compare-bits
  [[a b]]
  (zero?
  (compare
    (bit-and a 0xffff)
    (bit-and b 0xffff))))


(defn judge-pairs
  []
  (map compare-bits
  (map vector
    (filter #(zero? (rem % 4)) (iterate generator-a 783))
    (filter #(zero? (rem % 8)) (iterate generator-b 325)))))


(defn count-matches
  [n]
  (count
  (filter true?
  (take n (judge-pairs)))))


(println (count-matches 5000000))
