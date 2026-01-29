import Widget from require "lapis.html"
locales = require "libs/locales"
import Workshops, Participations from require "models"
import to_datetime_local from require "libs/time"
class WorkshopList extends Widget
    content: =>
        h1 locales.workshops
        workshops = Workshops\select "order by date asc"
        element "table", ->
            thead ->
                tr ->
                    th locales.workshop_location
                    th locales.workshop_date
                    th ""
            tbody ->
                for workshop in *workshops
                    if workshop.visibility == 2 or Participations\find workshop_id: workshop.id, user_id: @current_user_table.id or Invites\find workshop_id: workshop.id, user_id: @current_user_table.id
                        tr ->
                            td workshop.location
                            td os.date("%c", workshop.date)
                            td ->
                                a href: "/wv/" .. workshop.id , locales.workshop_view 
        


        

            