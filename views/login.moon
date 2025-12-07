import Widget from require "lapis.html"
locales = require "libs/locales"
log = require "libs/log"
class IndexPage extends Widget
    content: =>
        form method: "post", ->
            if @error_message
                p @error_message
            input type: "hidden", name: "referrer", value: @referrer
            label for: "email", locales.email
            input type: "email", name: "email", id: "email", value: @email, readonly: if @nextstep then "readonly" else nil
            br!
            if @nextstep == "password"
                label for: "password", locales.password
                input type: "password", name: "password", id: "password", required: true
            elseif @nextstep == "emailcode"
                label for: "code", locales.emailcode
                input type: "text", name: "code", id: "code", required: true
            else
                input type: "radio", value: "email", name: "option", id: "emailoption", checked: true
                label for: "emailoption", locales.emailoption
                br!
                input type: "radio", value: "password", name: "option", id: "passwordoption"
                label for: "passwordoption", locales.passwordoption
                br!
            br!
            button type: "submit",  locales.login