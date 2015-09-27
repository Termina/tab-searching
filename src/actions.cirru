
var
  recorder $ require :actions-recorder

= exports.search $ \ (query)
  recorder.dispatch :search query

= exports.fetchInitial $ \ ()
  chrome.tabs.query ({} (:active true) (:status :complete)) $ \ (tabs)
    recorder.dispatch :fetch-initial (. tabs 0)

= exports.fetchTabs $ \ ()
  chrome.tabs.query ({} (:windowType :normal)) $ \ (tabs)
    recorder.dispatch :fetch-tabs tabs

= exports.moveUp $ \ ()
  recorder.dispatch :move-up

= exports.moveDown $ \ ()
  recorder.dispatch :move-down

= exports.closeTab $ \ (tabId)
  recorder.dispatch :close-tab tabId

= exports.selectTab $ \ (tabId)
  recorder.dispatch :select-tab tabId
