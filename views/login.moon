import Widget from require "lapis.html"
locales = require "libs/locales"
class IndexPage extends Widget
    content: =>
        form ->
            label for: "email", locales.email
            input type: "email", name: "email", id: "email", value: @email
            if @state = "password"
                label for: "password", locales.password
                input type: "password", name: "password", id: "password"
            elseif @state = "emailcode"
                label for: "code", locales.emailcode
                input type: "number", name: "code", id: "code"
            else
                label for: "emailoption", locales.emailoption
                input type: "radio", value: "email", name: "option", id: "emailoption"
                label for: "passwordoption", locales.passwordoption
                input type: "radio", value: "password", name: "option", id: "passwordoption"
            button type: "submit",  locales.login