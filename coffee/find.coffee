
# helpers

isKeyword = (char) -> char.match(/[\w\d\s\u4E00-\u9FA5]/)?

fuzzy = (text) ->
  query = text.split('').filter(isKeyword).join('.*')
  new RegExp query, 'i'

q = (query) -> document.querySelector query

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
  list = []

  show_list = ->
    choice = []
    list.map (tab) ->
      if tab.title is 'Search Tabs' then console.log 'hide', tab
      else if tab.active
        initialTab = tab unless initialTab?
        choice.unshift tab
        chrome.extension.sendMessage word: 'log', data: tab
      else choice.push tab

    if choice[0]?
      menu.innerHTML = choice.map((data) -> render data).join('')
      first = menu.children[0]
      if first?
        first.id = 'choose'
        goto first
    else
      menu.innerHTML = '<div id="empty">:( no tab..</div>'

  addOne = (tab) ->
    if tab.url.match(/^http/)?
      urlList = list.map (tab) -> tab.url
      list.push tab unless tab.url in urlList

  chrome.tabs.query {}, (tabs) ->
    tabs.filter((tab) -> tab.title.indexOf(text) >= 0).map(addOne)
    tabs.filter((tab) -> tab.url.indexOf(text) >= 0).map(addOne)
    tabs.filter((tab) -> tab.title.match(fuzzy text)?).map(addOne)
    show_list()

next_action = null
delay = (t, f) -> setTimeout f, t
wait_to_do = (action) ->
  action() unless next_action?
  next_action = action
  if next_action?
    delay 200, ->
      next_action()
      next_action = null
      wait_to_do()

input.addEventListener 'input', -> 
  wait_to_do -> suggest input.value

input.onkeydown = (event) ->
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
      debugger
      window.close()

# helpers for rendering

render = (data) ->
  # data has [title, url, id, icon]
  # data.url = data.url.replace(/https?\:\/\//, '')
  img = (link) -> "<img src='#{link}' class='icon'>"
  """
  <div class='tab' #{if data.id? then "data-tabid='#{data.id}'" else '' }>
    <div class='content'>
      <div class='title'>#{data.title}</div>
      <div class='url'>#{data.url}</div>
    </div>
    #{ if data.favIconUrl? then (img data.favIconUrl) else '' }
  </div>
  """

gotoTab = (tabid) -> chrome.tabs.update tabid, selected: yes
goto = (elem) -> gotoTab (parseInt elem.getAttribute('data-tabid'))

# init main function

input.focus()
suggest ''