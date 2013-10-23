
define (require, exports) ->
  Ractive = require "Ractive"
  cirru = require "cirru"
  c2m = require "c2m"

  listTmplText = require "text!cirru_list"
  cirru.parse.compact = yes
  listTmpl = c2m.render cirru.parse listTmplText
  # helpers

  isKeyword = (char) -> char.match(/[\w\d\s\u4E00-\u9FA5]/)?

  fuzzy = (text) ->
    query = text.split('').filter(isKeyword).join('.*')
    new RegExp query, 'i'

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
        console.log "currentAt: #{currentAt}, num: #{num}"
        if currentAt is num then "currentAt" else ""

  # cache

  initialTab = undefined
  chrome.extension.onMessage.addListener (request) ->
    console.log "got extension request", request
    if request.type is "initial"
      initialTab = request.tab
  # setup close event

  window.onbeforeunload = ->
    chrome.extension.sendMessage word: 'close', (res) ->
      console.log 'after close', res

  # main function

  input = q('#key')
  menu = q('#menu')

  all_tabs = []
  chrome.tabs.query {}, (tabs) ->
    tabs.map (tab) ->
      if tab.title is 'Search Tabs'
        console.log 'hide', tab
      else if initialTab.id is tab.id
        all_tabs.unshift tab
        chrome.extension.sendMessage word: 'log', data: tab
      else
        all_tabs.push tab
    page_list.set "list", all_tabs

  suggest = (text) ->
    list = []

    addOne = (tab) ->
      if tab.url.match(/^http/)?
        urlList = list.map (tab) -> tab.url
        list.push tab unless tab.url in urlList

    all_tabs.filter((tab) -> tab.title.indexOf(text) >= 0).map(addOne)
    all_tabs.filter((tab) -> tab.url.indexOf(text) >= 0).map(addOne)
    all_tabs.filter((tab) -> tab.title.match(fuzzy text)?).map(addOne)
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
      currentAt = page_list.data.currentAt
      list = page_list.data.list
      the_tab = list[currentAt]
      list.splice currentAt, 1
      if currentAt >= list.length > 0
        currentAt -= 1
      page_list.set "currentAt", currentAt
      chrome.tabs.remove the_tab.id
      all_tabs = all_tabs.filter (tab) ->
        tab.id isnt the_tab.id

    else if event.keyCode is 27 # esc key
      chrome.extension.sendMessage word: 'log', data: initialTab
      if initialTab?
        gotoTab initialTab.id, ->
          window.close()

  gotoTab = (tabid, callback) ->
    console.log "going to", tabid
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
    # window.close()
  suggest ''