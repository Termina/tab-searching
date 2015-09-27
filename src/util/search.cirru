
= exports.find $ \ (data query)
  ... query
    split ": "
    filter $ \ (piece)
      > (. (piece.trim) :length) 0
    some $ \ (piece)
      >= (data.indexOf piece) 0
