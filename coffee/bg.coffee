
has_open_window = no
last_window_id = undefined

openWindow = ->
  popup =
    type: 'popup'
    url: 'index.html'
    left: 600
    width: 400
    height: 600
    focused: yes
  chrome.windows.create popup, (win) ->
    chrome.windows.update win.id, drawAttention: yes
    console.log 'saving last_window_id', 
    last_window_id = win.id

chrome.commands.onCommand.addListener (command) ->
  if command is "launch"
    console.log 'going to open a windows'
    console.info 'has_open_window', has_open_window
    console.info 'last_window_id', last_window_id
    if has_open_window
      if last_window_id?
        chrome.windows.update last_window_id, focused: yes
    else
      openWindow()
      has_open_window = yes

chrome.extension.onMessage.addListener (req, sender, msg) ->
  if req.word is 'close'
    console.log 'close'
    has_open_window = no
    last_window_id = null
  else if req.word is 'log'
    console.log 'log::', req.data

chrome.browserAction.onClicked.addListener (tab) ->
  openWindow()