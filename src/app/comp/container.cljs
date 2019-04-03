
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
            [fuzzy-filter.core :refer [parse-by-letter]]))

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
       model (transform-data store)
       length (count (:tabs model))]
   (div
    {}
    (render-markup
     (get templates "container")
     {:data model, :templates templates, :level 1}
     (fn [d! op param options]
       (when dev? (comment println "Action" op param (pr-str options)))
       (case op
         :query (do (d! :query (:value options)) (d! :pointer 0))
         :keydown
           (let [event (:event options)]
             (case (.-key event)
               "ArrowDown" (when (not (>= (:pointer model) (dec length))) (d! :move-down nil))
               "ArrowUp" (when (pos? (:pointer model)) (d! :move-up nil))
               (do)))
         (do (println "Unknown op:" op)))))
    (when dev? (comp-inspect "Store" store {}))
    (when dev? (cursor-> :reel comp-reel states reel {})))))
