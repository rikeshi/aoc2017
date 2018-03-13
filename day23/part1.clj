(require '[clojure.edn :as edn])
(require '[clojure.string :as str])


(defn parse-arg [a]
  (if (re-matches #"-?\d+" a)
      (edn/read-string a)
      (keyword a)))

(defn parse-inst [[op x y]]
  [(keyword op)
   (parse-arg x)
   (parse-arg y)])

(defn process [v]
  (into [] (comp (map #(str/split % #"\s+"))
                 (map parse-inst))
            v))

(defn load-input [fname]
  (->> fname
    slurp
    str/split-lines
    process))


(defn set-op [x y pc regs]
  [(assoc-in regs [x] (if (keyword? y) (get regs y) y))
   (inc pc)])

(defn sub-op [x y pc regs]
  [(update-in regs [x] - (if (keyword? y) (get regs y) y))
   (inc pc)])

(defn mul-op [x y pc regs]
  [(update-in regs [x] * (if (keyword? y) (get regs y) y))
   (inc pc)])

(defn jnz-op [x y pc regs]
  [regs
   (if-not (zero? (if (keyword? x) (get regs x) x))
           (+ pc (if (keyword? y) (get regs y) y))
           (inc pc))])


;; a-h registers; start with value 0
(def regs {:a 0 :b 0 :c 0 :d 0 :e 0 :f 0 :g 0 :h 0})
(def ops {:set set-op :sub sub-op :mul mul-op :jnz jnz-op})
(def pc 0)


(def input (load-input "input"))
;; convert keywords to functions
(def input (map (fn [[op x y]] [(get ops op) x y]) input))


(def mul-count 0)
(def running true)
(while running
  (do (try (def inst (nth input pc))
           (let [[op x y] inst]
              (def mul-count (if (= op mul-op)
                                 (inc mul-count) mul-count))
              (def rvec (op x y pc regs))
              (def regs (nth rvec 0))
              (def pc (nth rvec 1)))
           (catch java.lang.IndexOutOfBoundsException e
                  (def running false)))))


(prn mul-count)
