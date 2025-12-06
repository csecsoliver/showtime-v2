import Widget from require "lapis.html"
locales = require "libs/locales"
import Workshops, Users from require "models"
class DashHome extends Widget
    content: =>
        p @current_user .. ", welcome to your dashboard!"
        div id: "dash-workshop-list" , ->
            h2 locales.workshops
            p locales.workshops_description
            element "table", ->
                thead ->
                    tr ->
                        th locales.workshop_location
                        th locales.workshop_date
                        th ""
                tbody ->
                    user = Users\find email: @current_user
                    workshops = user\get_workshops!
                    for workshop in *workshops
                        tr ->
                            td workshop.location
                            td os.date("%x %X", workshop.date)
                            td ->
                                a href: "/dw/" .. workshop.id , locales.workshops_view_edit
            a href: "/dw/new", locales.workshops_create_new