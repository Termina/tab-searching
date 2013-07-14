
document.body.onkeydown = (event) ->
  if event.keyCode is 192
    if event.ctrlKey
      chrome.runtime.sendMessage {word: 'open'}, (res) ->
        console.log res