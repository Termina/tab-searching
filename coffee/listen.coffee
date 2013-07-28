
document.body.onkeydown = (event) ->
  if event.keyCode is 192
    if event.ctrlKey
      chrome.extension.sendMessage word: 'open', (res) ->
        console.log res