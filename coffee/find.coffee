
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

  page_list = new Ractive
    el: q('#menu')
    template: listTmpl
    data:
      list: []

  # cache

  initialTab = undefined

  # setup close event

  window.onbeforeunload = ->
    chrome.extension.sendMessage word: 'close', (res) ->
      console.log 'after close', res

  # main function

  input = q('#key')
  menu = q('#menu')

  suggest = (text) ->
    list = page_list.data.list = []

    show_list = ->
      choice = []
      list.map (tab) ->
        if tab.title is 'Search Tabs' then console.log 'hide', tab
        else if tab.active
          initialTab = tab unless initialTab?
          choice.unshift tab
          chrome.extension.sendMessage word: 'log', data: tab
        else choice.push tab
      page_list.update "list"

    addOne = (tab) ->
      if tab.url.match(/^http/)?
        urlList = list.map (tab) -> tab.url
        list.push tab unless tab.url in urlList

    chrome.tabs.query {}, (tabs) ->
      tabs.filter((tab) -> tab.title.indexOf(text) >= 0).map(addOne)
      tabs.filter((tab) -> tab.url.indexOf(text) >= 0).map(addOne)
      tabs.filter((tab) -> tab.title.match(fuzzy text)?).map(addOne)
      show_list()

  input.addEventListener 'input', -> 
    suggest input.value

  document.body.onkeydown = (event) ->
    if event.keyCode is 13
      selected = q('#choose')
      window.close()
    else if event.keyCode is 40 # down arrow
      nextTab = q('#choose').nextElementSibling
      if nextTab?
        q('#choose').id = ''
        nextTab.id = 'choose'
        nextTab.scrollIntoViewIfNeeded()
        goto nextTab
    else if event.keyCode is 38 # up arrow
      lastTab = q('#choose').previousElementSibling
      if lastTab?
        q('#choose').id = ''
        lastTab.id = 'choose'
        lastTab.scrollIntoViewIfNeeded()
        goto lastTab
    else if event.keyCode is 27 # esc key
      chrome.extension.sendMessage word: 'log', data: initialTab
      if initialTab?
        gotoTab initialTab.id
        window.close()

  gotoTab = (tabid) -> chrome.tabs.update tabid, selected: yes
  goto = (elem) -> gotoTab (parseInt elem.getAttribute('data-tabid'))

  # init main function

  input.focus()
  suggest ''