
(ns app.comp.container
  (:require [hsl.core :refer [hsl]]
            [respo-ui.core :as ui]
            [respo.core
             :refer
             [defcomp cursor-> action-> mutation-> <> div button textarea span]]
            [respo.comp.space :refer [=<]]
            [reel.comp.reel :refer [comp-reel]]
            [respo-md.comp.md :refer [comp-md]]
            [app.config :refer [dev?]]
            [composer.core :refer [render-markup extract-templates]]
            [shadow.resource :refer [inline]]
            [cljs.reader :refer [read-string]]
            [cumulo-util.core :refer [id! unix-time!]]
            [respo.comp.inspect :refer [comp-inspect]]
            [clojure.string :as string]
            [fuzzy-filter.core :refer [parse-by-letter]]
            [app.chrome :as chrome]
            [app.util :refer [index-of]]))

(defn on-action [d! op param options model]
  (let [length (count (:tabs model)), initial-id (:initial-tab-id model)]
    (case op
      :query (do (d! :query (:value options)) (d! :pointer 0))
      :keydown
        (let [event (:event options), pointer (:pointer model)]
          (case (.-key event)
            "ArrowDown"
              (when (not (>= pointer (dec length)))
                (d! :pointer (inc pointer))
                (chrome/select-tab! (get-in model [:tabs (inc pointer) :id])))
            "ArrowUp"
              (when (pos? pointer)
                (d! :pointer (dec pointer))
                (chrome/select-tab! (get-in model [:tabs (dec pointer) :id])))
            "Enter" (when (= 13 (.-keyCode event)) (chrome/close!))
            "Escape" (do (chrome/select-tab! initial-id) (chrome/close!))
            (do (println (.-key event)))))
      :click
        (let [idx (index-of param (map :id (:tabs model)))]
          (d! :pointer idx)
          (chrome/select-tab! (get-in model [:tabs idx :id])))
      (do (println "Unknown op:" op)))))

(defn transform-data [store]
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
                (map-indexed
                 (fn [idx tab]
                   (-> tab
                       (assoc
                        :icon
                        (or (:favIconUrl tab) "http://cdn.tiye.me/logo/pudica.png"))
                       (assoc :highlighted? (= pointer idx)))))
                (vec)))))))

(defcomp
 comp-container
 (reel)
 (let [store (:store reel)
       states (:states store)
       templates (extract-templates (read-string (inline "composer.edn")))
       model (transform-data store)]
   (div
    {}
    (render-markup
     (get templates "container")
     {:data model, :templates templates, :level 1}
     (fn [d! op param options]
       (when dev? (comment println "Action" op param (pr-str options)))
       (on-action d! op param options model)))
    (when dev? (comp-inspect "Store" store {:bottom 20}))
    (when dev? (cursor-> :reel comp-reel states reel {})))))
