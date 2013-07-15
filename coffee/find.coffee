
# helpers

isKeyword = (char) ->
  char.match(/[\w\d\s\u4E00-\u9FA5]/)?

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

# main function

input = q('#key')
menu = q('#menu')

input.focus()

input.addEventListener 'input', ->
  collection = []
  menu.innerHTML = ''
  menu.style.visibility = 'hidden'
  wait = new Wait
  wait.task = ->
    collection.map (data) -> append menu, data
    menu.style.visibility = 'visible'

  wait.wait 'current'
  chrome.tabs.query {}, (tabs) ->
    ones = tabs.filter (tab) -> tab.title.match (fuzzy input.value)
    collection.push ones...
    wait.done 'current'

  wait.wait 'history'
  chrome.history.search text: input.value, (tabs) ->
    ones = tabs.filter (tab) -> tab.title.match (fuzzy input.value)
    collection.push ones...
    wait.done 'history'

  wait.wait 'bookmarks'
  chrome.bookmarks.search input.value, (tabs) ->
    ones = tabs.filter (tab) -> tab.title.match (fuzzy input.value)
    collection.push ones...
    wait.done 'bookmarks'

input.onkeydown = (event) ->
  if event.keyCode is 13
    selected = q('#menu').children[0]
    if selected?
      tabid = parseInt selected.children[1].getAttribute('data-tabid')
      chrome.tabs.update tabid, selected: yes
    # window.close()

# helpers for rendering

render = (data) ->
  # data has [title, url, id, icon]
  data.url = data.url.replace(/https?\:\/\//, '')
  """
  <div class='tab'>
    <div class='icon'>
      #{
        if data.icon?
          "<img src='#{data.icon}'>"
        else
          ''
      }
    </div>
    <div class='content' #{
      if data.id?
        "data-tabid='#{data.id}'"
      else
        ''
      }>
      <div class='title'>#{data.title}</div>
      <div class='url'>#{data.url}</div>
    </div>
  </div>
  """

append = (elem, data) ->
  elem.insertAdjacentHTML 'beforeend', (render data)