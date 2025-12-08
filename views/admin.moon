import Widget from require "lapis.html"
locales = require "libs/locales"
class AdminPage extends Widget
    content: =>
        if @output
            p @output
        form method: "POST", ->
            input type: "text", name: "query"
            button type: "submit"