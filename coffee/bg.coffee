
has_open_window = no
last_window_id = undefined
popup =
  type: 'popup'
  url: 'index.html'
  focused: yes
  width: 400

openWindow = ->
  chrome.windows.getCurrent (from_win) ->
    popup.left = from_win.width - popup.width + from_win.left
    popup.top = from_win.top
    popup.height = from_win.height - 24
    chrome.windows.create popup, (win) ->
      chrome.windows.update win.id, drawAttention: yes
      last_window_id = win.id
      tab = tabs[0]
      console.log "tab:", tab

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