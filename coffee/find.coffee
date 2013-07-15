
# helpers

isKeyword = (char) -> char.match(/[\w\d\s\u4E00-\u9FA5]/)?

fuzzy = (text) ->
  query = text.split('').filter(isKeyword).join('.{0,8}')
  new RegExp query, 'i'

q = (query) -> document.querySelector query

class Wait
  constructor: -> @tasks = {}
  wait: (key) -> @tasks[key] = yes
  done: (key) ->
    delete @tasks[key]
    if Object.keys(@tasks).length is 0
      @task?()

time = -> (new Date).getTime()

# cache

timeCache = 0
initialTab = undefined
thisTab = undefined
# chrome.tabs.getCurrent (tab) -> thisTab = tab

# main function

input = q('#key')
menu = q('#menu')

input.focus()

suggest = (text) ->
  newTime = time()
  if (newTime - timeCache) < 400 then return
  timeCache = newTime

  # begin logic

  list = []

  wait = new Wait
  menuHtml = ''
  wait.task = ->
    choice = []
    list.map (tab) ->
      if tab.title is '@_@'
        console.log 'hide it'
      else if tab.active
        choice.unshift tab
        initialTab = tab
      else
        choice.push tab

    if choice[0]?
      choice.map (data) -> menuHtml += render data
      menu.innerHTML = menuHtml
      first = menu.children[0]
      if first?
        first.id = 'choose'
        goto first
    else if text is 'hope you like it'
      menu.innerHTML = '<div id="empty">:) hope you like it..</div>'
    else
      menu.innerHTML = '<div id="empty">:( no tab..</div>'

  addOne = (tab) ->
    urlList = list.map (tab) -> tab.url
    list.push tab unless tab.url in urlList

  wait.wait 'title'
  chrome.tabs.query {}, (tabs) ->
    ones = tabs.filter (tab) -> tab.title.indexOf(text) >= 0
    ones.map addOne
    wait.done 'title'

  wait.wait 'url'
  chrome.tabs.query {}, (tabs) ->
    ones = tabs.filter (tab) -> tab.url.indexOf(text) >= 0
    ones.map addOne
    wait.done 'url'

  # I disabled history searching for Chrome did it better

  # wait.wait 'history'
  # chrome.history.search text: text, (tabs) ->
  #   tabs.map addOne
  #   wait.done 'history'

  # wait.wait 'bookmarks'
  # chrome.bookmarks.search text, (tabs) ->
  #   tabs.map addOne
  #   wait.done 'bookmarks'

input.addEventListener 'input', -> suggest input.value

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
  else if event.keyCode is 27
    if initialTab?
      gotoTab initialTab.id
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

suggest ''