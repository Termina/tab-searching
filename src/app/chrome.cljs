
(ns app.chrome (:require [clojure.core.async :refer [go >! chan]]))

(defn chan-query-tabs [options]
  (let [<tabs (chan)]
    (-> js/chrome
        .-tabs
        (.query
         (clj->js options)
         (fn [tabs]
           (go
            (>!
             <tabs
             {:ok? true, :timeout? false, :data (js->clj tabs :keywordize-keys true)})))))
    <tabs))

(defn close! [] (.close js/window))

(defn query-tabs! [options cb]
  (-> js/chrome
      .-tabs
      (.query (clj->js options) (fn [tabs] (cb (js->clj tabs :keywordize-keys true))))))

(defn select-tab! [next-id]
  (.. js/chrome -tabs (update next-id (clj->js {:selected true}) (fn [] ))))
