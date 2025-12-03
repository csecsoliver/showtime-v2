import Widget from require "lapis.html"
locales = require "libs/locales"
class DashHome extends Widget
    content: =>
        p @current_user .. ", welcome to your dashboard!"