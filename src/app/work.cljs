
(ns app.work
  (:require [app.config :refer [dev?]]
            [cumulo-util.core :refer [id! unix-time!]]
            [respo.comp.inspect :refer [comp-inspect]]
            [clojure.string :as string]
            [fuzzy-filter.core :refer [parse-by-letter]]
            [app.chrome :as chrome]
            [app.util :refer [index-of]]))

(defn get-view-model [store]
  (let [query (or (:query store) ""), pointer (or (:pointer store) 0)]
    (-> store
        (update
         :tabs
         (fn [tabs]
           (->> tabs
                (filter
                 (fn [tab]
                   (or (:matches?
                        (parse-by-letter
                         (string/lower-case (:title tab))
                         (string/lower-case query)))
                       (:matches?
                        (parse-by-letter
                         (string/lower-case (:url tab))
                         (string/lower-case query))))))
                (sort-by
                 (fn [tab]
                   (min
                    (or (string/index-of (:title tab) query) 1000)
                    (or (string/index-of
                         (string/replace (:url tab) (re-pattern "https?://") "")
                         query)
                        1000))))
                (map-indexed
                 (fn [idx tab]
                   (-> tab
                       (assoc
                        :icon
                        (or (:favIconUrl tab) "http://cdn.tiye.me/logo/pudica.png"))
                       (assoc :highlighted? (= pointer idx))
                       (assoc :previous? (= (:initial-tab-id store) (:id tab))))))
                (vec)))))))

(defn on-action! [d! op param options model]
  (let [length (count (:tabs model)), initial-id (:initial-tab-id model)]
    (case op
      :query (do (d! :query (:value options)) (d! :pointer 0))
      :keydown
        (let [event (:event options), pointer (:pointer model)]
          (case (.-key event)
            "ArrowDown" (when (not (>= pointer (dec length))) (d! :pointer (inc pointer)))
            "ArrowUp" (when (pos? pointer) (d! :pointer (dec pointer)))
            "Enter" (when (= 13 (.-keyCode event)) (chrome/close!))
            "Escape" (do (chrome/select-tab! initial-id) (chrome/close!))
            (do (println (.-key event)))))
      :click
        (let [idx (index-of param (map :id (:tabs model)))]
          (d! :pointer idx)
          (chrome/select-tab! (get-in model [:tabs idx :id])))
      (do (println "Unknown op:" op)))))
