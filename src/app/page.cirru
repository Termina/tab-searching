
var
  React $ require :react
  Immutable $ require :immutable

var
  actions $ require :../actions

var
  Finder $ React.createFactory $ require :./finder

var
  ({}~ div) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-page

  :propTypes $ {}
    :store $ . (React.PropTypes.instanceOf Immutable.Map) :isRequired
    :core React.PropTypes.object.isRequired

  :styleRoot $ \ ()
    {}
      :fontFamily ":Hiragino Sans GB, Microsoft Yahei"

  :render $ \ ()
    div ({} (:style $ @styleRoot))
      Finder $ {} (:tabs $ @props.store.get :tabs)
        :initial $ @props.store.get :initial
