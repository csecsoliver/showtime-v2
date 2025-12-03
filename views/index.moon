import Widget from require "lapis.html"
locales = require "libs/locales"
class IndexPage extends Widget
    content: =>
        p locales.welcome