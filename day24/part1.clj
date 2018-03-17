(require '[clojure.edn :as edn])
(require '[clojure.string :as str])


(defn parse [[a b]]
  [(edn/read-string a)
   (edn/read-string b)])


(defn process [v]
  (into [] (comp (map #(str/split % #"/"))
                 (map parse))
            v))


(defn read-input [fname]
  (into #{} (->> fname
                 slurp
                 str/split-lines
                 process)))


(defn fit [from [a b]]
(cond (= from a) [a b b]
      (= from b) [a b a]
      :else nil))


(defn find-strongest [from components]
  (let [v (->> (map #(fit from %) components)
               (filter some?))]
    (cond
      (empty? v) 0
      :else (->> (map (fn [[a b c]] (+ a b (find-strongest c (disj components [a b])))) v)
                 (reduce max)))))


(prn (find-strongest 0 (read-input "input")))
