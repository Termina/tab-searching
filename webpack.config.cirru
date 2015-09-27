
var
  fs $ require :fs
  webpack $ require :webpack

= module.exports $ {}
  :entry $ {}
    :vendor $ array
      , :webpack-dev-server/client?http://localhost:8080
      , :webpack/hot/dev-server
      , :react :immutable
    :main $ array :./src/main

  :output $ {}
    :path :build/
    :filename :[name].js
    :publicPath :http://localhost:8080/build/

  :resolve $ {}
    :extensions $ array :.js :.cirru :

  :module $ {}
    :loaders $ array
      {} (:test /\.cirru$) (:loader :react-hot!cirru-script) (:ignore /node_modules)
      {} (:test "/\.(png|jpg|gif)$") (:loader :url-loader)
      {} (:test /\.css$) $ :loader :style!css!autoprefixer
      {} (:test /\.json$) $ :loader :json

  :plugins $ array
    new webpack.optimize.CommonsChunkPlugin :vendor :vendor.js
