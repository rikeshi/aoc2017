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


(defn max-pair [[a b] [c d]]
  (cond
    (> a c) [a b]
    (> c a) [c d]
    (> b d) [a b]
    (> d b) [c d]
    :else [a b]))


(defn find-longest [from components]
  (->> components
       (map #(fit from %))
       (filter some?)
       (map (fn [[a b c]]
              (let [[l s] (find-longest c (disj components [a b]))]
                [(inc l) (+ a b s)])))
       (reduce max-pair [0,0])))


(prn (find-longest 0 (read-input "input")))
