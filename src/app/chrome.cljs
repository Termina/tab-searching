
(ns app.chrome )

(defn close! [] (.close js/window))

(defn query-tabs! [options cb]
  (-> js/chrome
      .-tabs
      (.query (clj->js options) (fn [tabs] (cb (js->clj tabs :keywordize-keys true))))))

(defn select-tab! [next-id]
  (.. js/chrome -tabs (update next-id (clj->js {:selected true}) (fn [] ))))
