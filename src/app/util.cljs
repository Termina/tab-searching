
(ns app.util )

(defn index-of
  ([x ys] (index-of 0 x ys))
  ([idx x ys] (if (empty? ys) nil (if (= x (first ys)) idx (recur (inc idx) x (rest ys))))))
