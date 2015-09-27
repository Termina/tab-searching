
= exports.find $ \ (data query)
  ... query
    split ": "
    filter $ \ (piece)
      > (. (piece.trim) :length) 0
    every $ \ (piece)
      >= (data.indexOf piece) 0
