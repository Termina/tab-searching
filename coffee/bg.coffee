
chrome.runtime.onMessage.addListener (req, sender, msg) ->
  if req.word is 'open'
    chrome.windows.create type: 'popup', url: 'build/select.html'