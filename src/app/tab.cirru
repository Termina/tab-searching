
var
  Color $ require :color
  React $ require :react
  Immutable $ require :immutable

var
  ({}~ div) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-tab

  :propTypes $ {}
    :tab $ . (React.PropTypes.instanceOf Immutable.Map) :isRequired
    :onClick React.PropTypes.func.isRequired
    :index React.PropTypes.number.isRequired
    :isMatch React.PropTypes.bool.isRequired

  :styleRoot $ \ ()
    cond @props.isMatch
      {}
        :padding 10
        :display :flex
        :flexDirection :row
        :top $ * @props.index 55
        :position :absolute
        :transitionProperty ":top, opacity"
        :transitionDuration ":300ms"
        :opacity 1
      {}
        :padding 10
        :display :flex
        :flexDirection :row
        :top $ * @props.index 55
        :position :absolute
        :transitionProperty ":top, opacity"
        :transitionDuration ":300ms"
        :opacity 0

  :styleText $ \ ()
    {}
      :flex 1

  :styleTitle $ \ ()
    {}
      :fontFamily ":Verdana, Helvetica, sans-serif"
      :whiteSpace :nowrap
      :fontSize 14
      :flex 1
      :overflow :hidden
      :textOverflow :ellipsis

  :styleUrl $ \ ()
    {}
      :fontSize 12
      :whiteSpace :nowrap
      :color $ ... (Color) (hsl 120 20 80) (hslString)
      :width 300
      :overflow :hidden
      :textOverflow :ellipsis

  :styleIcon $ \ ()
    {}
      :backgroundImage $ + ":url(" (@props.tab.get :favIconUrl) ":)"
      :backgroundSize :cover
      :height 20
      :width 20
      :marginRight 10

  :render $ \ ()
    div ({} (:style $ @styleRoot))
      div ({} (:style $ @styleIcon))
      div ({} (:style $ @styleText))
        div ({} (:style $ @styleTitle))
          @props.tab.get :title
        div ({} (:style $ @styleUrl))
          @props.tab.get :url
