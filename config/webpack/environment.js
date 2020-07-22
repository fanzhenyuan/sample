const { environment } = require('@rails/webpacker')

//为了在应用中使用 jQuery，我们要编辑 Webpack 的环境文件
const webpack = require('webpack') 
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({ 
    $: 'jquery/src/jquery', 
    jQuery: 'jquery/src/jquery'
  }) 
)

module.exports = environment
