
define (require, exports) ->
  Ractive = require "Ractive"
  cirru = require "cirru"
  c2m = require "c2m"

  listTmplText = require "text!cirru_list"
  cirru.parse.compact = yes
  listTmpl = c2m.render cirru.parse listTmplText
  # helpers

  detect_match = (data, piece) ->
    words = piece.split(" ")
    words.every (word) ->
      (data.indexOf word) >= 0

  q = (query) -> document.querySelector query

  # ractive part

  window.page_list = new Ractive
    el: q('#menu')
    template: listTmpl
    data:
      currentAt: 0
      list: []
      highlightSelected: (selected) ->
        if selected then "selected" else ""
      highlightCurrentAt: (currentAt, num) ->
        # console.log "currentAt: #{currentAt}, num: #{num}"
        if currentAt is num then "currentAt" else ""

  # cache

  chrome.tabs.query active: yes, (tabs) ->
    window.initialTab = tabs[0]

  # setup close event

  window.onbeforeunload = ->
    chrome.extension.sendMessage word: 'close', (res) ->
      console.log 'after close', res

  # main function

  input = q('#key')
  menu = q('#menu')

  find_text = (tab, text) ->
    text = text.toLowerCase()
    title = tab.title.toLowerCase()
    # console.log 'find in title:', tab.title, '::add::', text
    switch
      when (detect_match title, text) then yes
      when (detect_match tab.url, text) then yes
      else no

  suggest = (text) ->

    chrome.tabs.query {}, (tabs) ->
      list = []
      tabs.map (tab) ->
        if find_text tab, text
          if initialTab.id is tab.id
            list.unshift tab
          else if tab.title isnt 'Search Tabs'
            list.push tab
      page_list.set "list", list

      page_list.set "list", list
      gotoTab list[0].id if list[0]?
      page_list.set "currentAt", 0

  input.addEventListener 'input', -> 
    suggest input.value

  document.body.onkeydown = (event) ->
    if event.keyCode is 13
      window.close()

    else if event.keyCode is 40 # down arrow
      event.preventDefault()
      currentAt = page_list.data.currentAt
      length = page_list.data.list.length
      if (currentAt + 1) < length
        currentAt += 1
      page_list.set "currentAt", currentAt
      context = page_list.data.list[currentAt]
      gotoTab context.id

    else if event.keyCode is 38 # up arrow
      event.preventDefault()
      currentAt = page_list.data.currentAt
      if currentAt > 0
        currentAt -= 1
      page_list.set "currentAt", currentAt
      context = page_list.data.list[currentAt]
      gotoTab context.id

    else if event.keyCode is 39 # right
      console.log "right"

    else if event.keyCode is 37 # left
      event.preventDefault()
      currentAt = page_list.data.currentAt
      list = page_list.data.list
      the_tab = list[currentAt]
      list.splice currentAt, 1
      if currentAt >= list.length > 0
        currentAt -= 1
      page_list.set "currentAt", currentAt
      chrome.tabs.remove the_tab.id, ->
        curr_tab = page_list.data.list[currentAt]
        gotoTab curr_tab.id if curr_tab?

    else if event.keyCode is 27 # esc key
      chrome.extension.sendMessage word: 'log', data: initialTab
      if initialTab?
        gotoTab initialTab.id, ->
          window.close()

  gotoTab = (tabid, callback) ->
    # console.log "going to", tabid
    chrome.tabs.update tabid, selected: yes, ->
      callback?()
    q('.currentAt')?.scrollIntoViewIfNeeded?()

  # handle events

  page_list.on "select", (event) ->
    gotoTab event.context.id, ->
      window.close()

  # init main function

  input.focus()
  window.onblur = ->
    window.close()
  suggest ''