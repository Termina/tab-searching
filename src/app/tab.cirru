
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
    :isInitial React.PropTypes.bool.isRequired
    :isPointed React.PropTypes.bool.isRequired

  :onClick $ \ ()
    @props.onClick @props.tab @props.index

  :styleRoot $ \ ()
    ...
      Immutable.fromJS $ {}
        :padding 10
        :display :flex
        :flexDirection :row
        :position :absolute
        :transitionProperty ":top, opacity, font-size"
        :transitionDuration ":300ms"
        :width ":100%"
        :cursor :pointer
        :backgroundColor $ ... (Color) (hsl 0 100 100 0.8) (hslString)
      merge $ cond @props.isMatch
        Immutable.fromJS $ {}
          :top $ * @props.index 55
          :opacity 1
        Immutable.fromJS $ {}
          :top 0
          :opacity 0
      merge $ cond @props.isInitial
        Immutable.fromJS $ {}
          :backgroundColor $ ... (Color) (hsl 240 80 95 0.8) (hslString)
        Immutable.fromJS $ {}
      merge $ cond @props.isPointed
        Immutable.fromJS $ {}
          :fontWeight :bold
        Immutable.fromJS $ {}
      toJS

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
    div ({} (:style $ @styleRoot) (:onClick @onClick))
      div ({} (:style $ @styleIcon))
      div ({} (:style $ @styleText))
        div ({} (:style $ @styleTitle))
          @props.tab.get :title
        div ({} (:style $ @styleUrl))
          @props.tab.get :url
