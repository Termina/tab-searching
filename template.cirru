
var
  stir $ require :stir-template
  ({}~ html head title meta link script body div) stir

var
  style $ stir.createFactory :style

= module.exports $ \ (data)
  return $ stir.render
    stir.doctype
    html null
      head null
        title null ":Tab Searching"
        meta $ {} (:charset :utf-8)
        link $ {} (:rel :icon)
          :href :pic/tab-searching.png
        script $ {} (:src data.vendor) (:defer true)
        script $ {} (:src data.main) (:defer true)
        style null ":body * {box-sizing: border-box;}"
      body ({} (:style ":margin: 0;"))
