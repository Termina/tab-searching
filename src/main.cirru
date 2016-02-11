
var
  React $ require :react
  recorder $ require :actions-recorder
  Immutable $ require :immutable

var
  schema $ require :./schema
  actions $ require :./actions
  updater $ require :./updater

actions.fetchInitial
actions.fetchTabs

var
  Page $ React.createFactory $ require :./app/page

recorder.setup $ {}
  :records (Immutable.List)
  :initial schema.store
  :inProduction false
  :updater updater

var render $ \ (store core)
  console.log (store.toJS)
  React.render (Page $ {} (:store store) (:core core)) document.body

recorder.request render
recorder.subscribe render

= window.onblur $ \ ()
  window.close
