import Widget from require "lapis.html"
locales = require "libs/locales"
class IndexPage extends Widget
    content: =>
        p locales.welcome
        h2 locales.readme
        a href: "https://github.com/csecsoliver/showtime-v2", "Link"