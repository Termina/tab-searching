

q = (query) -> document.querySelector query
input = q('#key')

input.focus()

input.addEventListener 'input', ->
  console.log 'find', input.value