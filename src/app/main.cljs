
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
            [app.util :refer [index-of]]
            [app.work :as work]
            ["url-parse" :as url-parse]))

(defonce *reel
  (atom (-> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store))))

(def *tab-id (atom nil))

(defn dispatch! [op op-data]
  (when config/dev? (println "Dispatch:" op))
  (reset! *reel (reel-updater updater @*reel op op-data)))

(defn fetch-initial-tabs! []
  (let [url-obj (url-parse js/location.href true)
        window-id (js/parseInt (.. url-obj -query -windowId))]
    (chrome/query-tabs!
     {:windowType :normal, :windowId window-id}
     (fn [tabs]
       (chrome/query-tabs!
        {:active true, :windowId window-id}
        (fn [focus-tabs]
          (let [initial-id (get-in focus-tabs [0 :id])
                idx (index-of initial-id (map :id tabs))]
            (dispatch! :initial-tab initial-id)
            (println "found tab" idx initial-id (map :id tabs)))))
       (dispatch! :all-tabs tabs)))))

(def mount-target (.querySelector js/document ".app"))

(defn persist-storage! []
  (.setItem js/localStorage (:storage-key config/site) (pr-str (:store @*reel))))

(defn render-app! [renderer]
  (let [model (work/get-view-model (:store @*reel))]
    (renderer mount-target (comp-container @*reel model work/on-action!) #(dispatch! %1 %2))
    (let [active-tab (get (:tabs model) (:pointer model)), tab-id (:id active-tab)]
      (when (not= tab-id @*tab-id)
        (reset! *tab-id (:id active-tab))
        (chrome/select-tab! tab-id)))))

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
