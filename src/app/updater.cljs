
(ns app.updater (:require [respo.cursor :refer [mutate]]))

(defn updater [store op op-data op-id op-time]
  (case op
    :states (update store :states (mutate op-data))
    :hydrate-storage op-data
    :query (assoc store :query op-data)
    :all-tabs (assoc store :tabs op-data)
    :initial-tab (assoc store :initial-tab-id op-data)
    :pointer (assoc store :pointer 0)
    :move-down (update store :pointer inc)
    :move-up (update store :pointer dec)
    (do (println "Unknown op:" op) store)))
