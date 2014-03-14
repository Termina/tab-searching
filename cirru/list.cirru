
#app
  input#key
    :placeholder "Search in titles and urls..."
    :autocomplete off
    :v-model query
    :v-on "keydown: keyAction"
    :v-autofocus
  #menu
    .tab
      :v-repeat list
      :v-on "click: select($index)"
      :class "{{classActive(selected)}}"
      :class "{{classAt($index)}}"
      .title
        :v-model title
      .url
        :v-model url
      img.icon
        :src {{favIconUrl}}