import Widget from require "lapis.html"
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
                    h1 "ShowTime"
                    nav ->
                        ul ->
                            li -> 
                                a href: "/", "Homepage"
                            li -> 
                                a href: "/wl", "Workshops"
                            li -> 
                                a href: "/dh", "Dashboard"
                main ->
                    @content_for "inner"
                footer ->
                    p "© 2025 ShowTime"