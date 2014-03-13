doctype
html
  head
    title
      = "Tab Searching"
    meta
      :charset utf-8
    link
      :rel stylesheet
      :href css/menu.css
    script
      :defer
      :src build/build.js
  body
    @partial list.cirru