
"#list :num"
  div.tab
    :on-click select
    :class "{{ highlightSelected(selected) }}"
    :class "{{ highlightCurrentAt(currentAt, num) }}"
    div.content
      div.title
        = {{title}}
      div.url
        = {{url}}
    img.icon
      :src {{favIconUrl}}