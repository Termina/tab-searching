
Vue = require 'vue'

# helper

detect_match = (data, piece) ->
  words = piece.split(" ")
  words.every (word) ->
    (data.indexOf word) >= 0

q = (query) -> document.querySelector query

find_text = (tab, text) ->
  text = text.toLowerCase()
  title = tab.title.toLowerCase()
  # console.log 'find in title:', tab.title, '::add::', text
  switch
    when (detect_match title, text) then yes
    when (detect_match tab.url, text) then yes
    else no

gotoTab = (tabid, callback) ->
  # console.log "going to", tabid
  chrome.tabs.update tabid, selected: yes, ->
    callback?()
  q('.currentAt')?.scrollIntoViewIfNeeded?()

# ractive part

vm = new Vue
  el: '#app'
  data:
    at: 0
    query: ''
  computed:
    list: ->
      console.log 'change list'
      @suggest @query
  methods:
    select: (index) ->
      gotoTab @list[index].id
    classActive: (selected) ->
      if selected then "selected" else ""
    classAt: (index) ->
      # console.log "currentAt: #{currentAt}, num: #{num}"
      if @at is index then "focus-at" else ""

    confirmTab: ->
      console.log 'confirmTab'

    upTab: ->
      if (@at + 1) < @list.length
        @at += 1
      context = @list[@at]
      gotoTab context.id

    downTab: ->    
      if @at > 0
        @at -= 1
      context = @list[@at]
      gotoTab context.id

    keyAction: (event) ->
      switch event.keyCode
        when 40 then @downTab.bind(@)()
        when 38 then @upTab.bind(@)()
        when 37 then @removeTab.bind(@)()
        when 27 then @cancelTab.bind(@)()
        when 13 then @confirmTab.bind(@)()

    removeTab: ->
      @list.splice @at, 1
      if @at >= @list.length > 0
        @at -= 1
      chrome.tabs.remove @list[@at].id, =>
        curr_tab = @list[@at]
        gotoTab curr_tab.id if curr_tab?

    cancelTab: ->
      chrome.extension.sendMessage word: 'log', data: initialTab
      if initialTab?
        gotoTab initialTab.id, ->
          window.close()

    suggest: ->
      list = []
      chrome.tabs.query windowType: 'normal', (tabs) =>
        tabs.forEach (tab) =>
          if find_text tab, @query
            if initialTab.id is tab.id
              list.unshift tab
            else if tab.title isnt 'Search Tabs'
              list.push tab
        gotoTab list[0].id if list[0]?
      list

# cache

chrome.tabs.query active: yes, (tabs) ->
  window.initialTab = tabs[0]

# setup close event

window.onbeforeunload = ->
  chrome.extension.sendMessage word: 'close', (res) ->
    console.log 'after close', res

window.onblur = ->
  # window.close()