
chrome.runtime.onMessage.addListener (req, sender, msg) ->
  if req.word is 'open'
    popup =
      type: 'popup'
      url: 'build/select.html'
      left: 600
      width: 400
      height: 600
    chrome.windows.create popup