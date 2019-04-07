
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
    popup.url = "index.html?windowId=#{from_win.id}"
    chrome.windows.create popup, (win) ->
      chrome.windows.update win.id, drawAttention: yes
      last_window_id = win.id

chrome.commands.onCommand.addListener (command) ->
  if command is "launch"
    openWindow()

chrome.extension.onMessage.addListener (req, sender, msg) ->
  console.log 'message:', req

chrome.browserAction.onClicked.addListener (tab) ->
  openWindow()
