
var
  Color $ require :color
  React $ require :react
  Immutable $ require :immutable

var
  search $ require :../util/search
  actions $ require :../actions

var
  Tab $ React.createFactory $ require :./tab

var
  ({}~ div input) React.DOM

var filterTab $ \ (tab query)
  cond (> query.length 0)
    or
      search.find (... tab (get :title) (toLowerCase)) (query.toLowerCase)
      search.find (... tab (get :url) (toLowerCase)) (query.toLowerCase)
    , true

var listHelper $ \ (result tabs query onClick index count)
  cond (is tabs.size 0) result
    listHelper
      result.push
        cond (filterTab (tabs.first) query)
          Tab $ {} (:tab (tabs.first)) (:onClick onClick)
            :key $ ... tabs (first) (get :id)
            :index count
            :isMatch true
          Tab $ {} (:tab (tabs.first)) (:onClick onClick)
            :key $ ... tabs (first) (get :id)
            :index count
            :isMatch false
      tabs.slice 1
      , query onClick
      + index 1
      cond
        filterTab (tabs.first) query
        + count 1
        , count

= module.exports $ React.createClass $ {}
  :displayName :app-finder

  :propTypes $ {}
    :initial React.PropTypes.number.isRequired
    :tabs $ . (React.PropTypes.instanceOf Immutable.List) :isRequired

  :getInitialState $ \ ()
    {}
      :pointer 0
      :query :

  :onChange $ \ (event)
    @setState $ {}
      :query event.target.value

  :onTabClick $ \ (tab index)
    console.log tab index

  :styleInput $ \ ()
    {}
      :lineHeight ":40px"
      :border :none
      :fontSize 16
      :padding ":0 10px"
      :outline :none
      :fontFamily ":Menlo, Consolas, monospace"
      :borderBottom $ + ":1px solid "
        ... (Color) (hsl 0 80 80) (hslString)

  :styleRoot $ \ ()
    {}
      :display :flex
      :flexDirection :column

  :styleList $ \ ()
    {}
      :position :relative
      :height $ * @props.tabs.size 55

  :render $ \ ()
    div ({} (:style $ @styleRoot))
      input $ {}
        :value @props.query
        :onChange @onChange
        :style (@styleInput)
      div ({} (:style $ @styleList))
        listHelper (Immutable.List) @props.tabs @state.query @onTabClick 0 0
