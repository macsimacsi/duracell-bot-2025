const { environment } = require('@rails/webpacker')

// Add the following lines
const webpack = require("webpack")

// environment.plugins.append("Provide", new webpack.ProvidePlugin({
//     $: 'jquery',
//     jQuery: 'jquery',
//     Popper: ['popper.js', 'default']  // Not a typo, we're still using popper.js here
// }))
// End new addition

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
  })
)


module.exports = environment



