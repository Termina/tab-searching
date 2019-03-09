
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
            [respo-composer.core :refer [render-markup extract-templates]]
            [shadow.resource :refer [inline]]
            [cljs.reader :refer [read-string]]
            [cumulo-util.core :refer [id! unix-time!]]
            [app.updater :refer [model-updater]]
            [respo.comp.inspect :refer [comp-inspect]]))

(defcomp
 comp-container
 (reel)
 (let [store (:store reel)
       states (:states store)
       model (:model store)
       templates (extract-templates (read-string (inline "composer.edn")))]
   (div
    {}
    (render-markup
     (get templates "container")
     {:data model, :templates templates, :level 1}
     (fn [d! op props op-data]
       (println "Action" op props (pr-str op-data))
       (d! :model (model-updater model op props op-data (id!) (unix-time!)))))
    (when dev? (comp-inspect "model" model {}))
    (when dev? (cursor-> :reel comp-reel states reel {})))))
