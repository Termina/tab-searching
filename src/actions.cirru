
var
  recorder $ require :actions-recorder

= exports.fetchInitial $ \ ()
  chrome.tabs.query ({} (:active true) (:status :complete)) $ \ (tabs)
    recorder.dispatch :fetch-initial (. tabs 0)

= exports.fetchTabs $ \ ()
  chrome.tabs.query ({} (:windowType :normal)) $ \ (tabs)
    recorder.dispatch :fetch-tabs tabs

= exports.closeTab $ \ (tabId)
  recorder.dispatch :close-tab tabId

= exports.selectTab $ \ (tabId callback)
  chrome.tabs.update tabId ({} (:selected true)) callback
