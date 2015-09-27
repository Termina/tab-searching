
var
  Color $ require :color
  React $ require :react
  keycode $ require :keycode
  Immutable $ require :immutable

var
  search $ require :../util/search
  actions $ require :../actions

var
  bg $ require :../../images/abstract_lines_by_amst3l-d4tv0yw.png

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

var listHelper $ \ (result tabs query initial pointer onClick index count)
  cond (is tabs.size 0) result
    listHelper
      result.push
        cond (filterTab (tabs.first) query)
          Tab $ {} (:tab (tabs.first)) (:onClick onClick)
            :key $ ... tabs (first) (get :id)
            :index count
            :isMatch true
            :isInitial $ is (... tabs (first) (get :id)) initial
            :isPointed $ is count pointer
          Tab $ {} (:tab (tabs.first)) (:onClick onClick)
            :key $ ... tabs (first) (get :id)
            :index count
            :isMatch false
            :isInitial $ is (... tabs (first) (get :id)) initial
            :isPointed $ is count pointer
      tabs.slice 1
      , query initial pointer onClick
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

  :componentDidMount $ \ ()
    window.addEventListener :keydown @onWindowKeydown
    ... @refs.input (getDOMNode) (focus)

  :componentDidWillUnmount $ \ ()
    window.removeEventListener :keydown @onWindowKeydown

  :moveUp $ \ (event)
    event.preventDefault
    var newPointer $ - @state.pointer 1
    if (> @state.pointer 0) $ do
      @setState $ {}
        :pointer newPointer
      @switchTab newPointer
    , undefined

  :moveDown $ \ (event)
    event.preventDefault
    var limit $ ... @props.tabs
      filter $ \\ (tab)
        filterTab tab @state.query
      count
    var newPointer $ + @state.pointer 1
    if (< @state.pointer (- limit 1)) $ do
      @setState $ {}
        :pointer newPointer
      @switchTab newPointer
    , undefined

  :switchTab $ \ (pointer)
    console.log pointer
    var results $ @props.tabs.filter $ \\ (tab)
      filterTab tab @state.query
    var target $ results.get pointer
    if (? target) $ do
      actions.selectTab (target.get :id) $ \ ()
    , undefined

  :doEnter $ \ ()
    window.close

  :doEsc $ \ ()
    actions.selectTab @props.initial $ \ ()
      window.close

  :onWindowKeydown $ \ (event)
    switch (keycode event.keyCode)
      :up $ @moveUp event
      :down $ @moveDown event
      :enter $ @doEnter
      :esc $ @doEsc
    return undefined

  :onChange $ \ (event)
    @setState
      {}
        :query event.target.value
        :pointer 0
      \\ ()
        @switchTab 0

  :onTabClick $ \ (tab index)
    @setState $ {}
      :pointer index
    @switchTab index

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
      :backgroundImage $ + ":url(" bg ":)"
      :backgroundSize :contain
      :backgroundRepeat :no-repeat
      :backgroundPosition ":center center"
      :position :absolute
      :height :100%
      :width :100%

  :styleList $ \ ()
    {}
      :position :relative
      :height $ * @props.tabs.size 55
      :flex 1
      :overflow :auto

  :render $ \ ()
    div ({} (:style $ @styleRoot))
      input $ {}
        :ref :input
        :value @props.query
        :onChange @onChange
        :style (@styleInput)
      div ({} (:style $ @styleList))
        listHelper (Immutable.List) @props.tabs @state.query @props.initial
          , @state.pointer @onTabClick 0 0
