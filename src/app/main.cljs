
(ns app.main
  (:require [respo.core :refer [render! clear-cache! realize-ssr!]]
            [app.comp.container :refer [comp-container]]
            [app.updater :refer [updater]]
            [app.schema :as schema]
            [reel.util :refer [listen-devtools!]]
            [reel.core :refer [reel-updater refresh-reel]]
            [reel.schema :as reel-schema]
            [cljs.reader :refer [read-string]]
            [app.config :as config]
            [cumulo-util.core :refer [repeat!]]
            [app.chrome :as chrome]
            [app.util :refer [index-of]]))

(defonce *reel
  (atom (-> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store))))

(defn dispatch! [op op-data]
  (when config/dev? (println "Dispatch:" op))
  (reset! *reel (reel-updater updater @*reel op op-data)))

(defn fetch-initial-tabs! []
  (chrome/query-tabs!
   {:windowType :normal}
   (fn [tabs]
     (chrome/query-tabs!
      {:active true, :status :complete}
      (fn [focus-tabs]
        (let [initial-id (get-in focus-tabs [0 :id])
              idx (index-of initial-id (map :id tabs))]
          (dispatch! :initial-tab initial-id)
          (dispatch! :query idx)
          (println "found tab" idx initial-id (map :id tabs)))))
     (dispatch! :all-tabs tabs))))

(def mount-target (.querySelector js/document ".app"))

(defn persist-storage! []
  (.setItem js/localStorage (:storage-key config/site) (pr-str (:store @*reel))))

(defn render-app! [renderer]
  (renderer mount-target (comp-container @*reel) #(dispatch! %1 %2)))

(def ssr? (some? (js/document.querySelector "meta.respo-ssr")))

(defn main! []
  (println "Running mode:" (if config/dev? "dev" "release"))
  (if ssr? (render-app! realize-ssr!))
  (render-app! render!)
  (add-watch *reel :changes (fn [] (render-app! render!)))
  (listen-devtools! "a" dispatch!)
  (.addEventListener js/window "beforeunload" persist-storage!)
  (repeat! 60 persist-storage!)
  (comment
   let
   ((raw (.getItem js/localStorage (:storage-key config/site))))
   (when (some? raw) (dispatch! :hydrate-storage (read-string raw))))
  (fetch-initial-tabs!)
  (.focus (.querySelector js/document ".query"))
  (println "App started."))

(defn reload! []
  (clear-cache!)
  (reset! *reel (refresh-reel @*reel schema/store updater))
  (println "Code updated."))
