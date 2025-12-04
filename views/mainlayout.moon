import Widget from require "lapis.html"
locales = require "libs/locales"
class MainLayout extends Widget
    content: =>
        raw "<!DOCTYPE HTML>"
        html lang: "en", ->
            head ->
                meta charset: "UTF-8"
                meta name: "viewport", content: "width=device-width, initial-scale=1.0"


                title @page_title or "ShowTime"
                
                if @type == "f"
                    link rel: "stylesheet", href: "/static/pico.classless.fuchsia.min.css"
                else if @type == "m"
                    link rel: "stylesheet", href: "/static/pico.classless.green.min.css"
                else
                    link rel: "stylesheet", href: "/static/pico.classless.min.css"

                link rel: "stylesheet", href: "/static/styles.css"
            body ->
                header ->
                    h1 locales.site_name
                    nav ->
                        ul ->
                            li -> 
                                a href: "/", locales.homepage
                            li -> 
                                a href: "/wl", locales.workshops
                            li -> 
                                a href: "/dh", locales.dashboard
                            if @current_user
                                li ->
                                    span locales.current_user .. @current_user
                            else
                                li ->
                                    a href: "/l", locales.login
                main ->
                    @content_for "inner"
                footer ->
                    p "© 2025 ShowTime"