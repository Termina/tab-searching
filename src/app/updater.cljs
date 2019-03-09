
(ns app.updater (:require [respo.cursor :refer [mutate]]))

(defn model-updater [model op props op-data op-id op-time]
  (case op
    :input (let [text (:text op-data)] (assoc model :input text))
    :submit
      (-> model
          (assoc :input "")
          (update :records (fn [records] (conj records (:input model)))))
    :remove
      (update
       model
       :records
       (fn [records] (->> records (filter (fn [x] (not= x op-data))) vec)))
    (do (println "Unknown op:" op) model)))

(defn updater [store op op-data op-id op-time]
  (case op
    :states (update store :states (mutate op-data))
    :content (assoc store :content op-data)
    :hydrate-storage op-data
    :model (assoc store :model op-data)
    store))
