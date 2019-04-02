
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
            [clojure.string :as string]))

(defn transform-data [store]
  (-> store
      (update
       :tabs
       (fn [tabs] (->> tabs (map (fn [tab] (assoc tab :icon (:favIconUrl tab)))) (vec))))))

(defcomp
 comp-container
 (reel)
 (println "rendering")
 (let [store (:store reel)
       states (:states store)
       templates (extract-templates (read-string (inline "composer.edn")))]
   (div
    {}
    (render-markup
     (get templates "container")
     {:data (transform-data store), :templates templates, :level 1}
     (fn [d! op param options]
       (when dev? (println "Action" op param (pr-str options)))
       (case op
         :input (d! :input (:value options))
         :submit (when-not (string/blank? (:input store)) (d! :submit nil))
         :remove (d! :remove param)
         (do (println "Unknown op:" op)))))
    (when dev? (comp-inspect "Store" store {}))
    (when dev? (cursor-> :reel comp-reel states reel {})))))
