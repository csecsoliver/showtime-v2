import Widget from require "lapis.html"
locales = require "libs/locales"
import Workshops from require "models"
import to_datetime_local from require "libs/time"
class DashWorkshopsNew extends Widget
    content: =>
        h1 locales.workshops_view
        form method: "post" , ->
            workshop = Workshops\find @id
            label for: "location", locales.workshop_location
            input type: "text", id: "location", name: "location", value: workshop.location
            label for: "date", locales.workshop_date
            input type: "datetime-local", id: "date", name: "date", required: true, value: to_datetime_local(workshop.time)
            input type: "checkbox", id: "open", name: "open", value: if workshop.open then "on" else ""
            label for: "open", locales.workshop_open
            br!
            br!
            label for: "max_participants", locales.workshop_max_participants
            input type: "text", id: "max_participants", name: "max_participants", min: "1", value: workshop.max_participants
            label for: "sponsor", locales.workshop_sponsor
            input type: "text", id: "sponsor", name: "sponsor", value: workshop.sponsor
            
            label for: "extra_text_visibility", locales.workshop_extra_text_visibility
            element "select", id: "extra_text_visibility", name: "extra_text_visibility", ->
                element "option", value: "0", locales.workshop_extra_text_visibility_organizers_only, selected: (workshop.extra_text_visibility == 0)
                element "option", value: "1", locales.workshop_extra_text_visibility_participants, selected: (workshop.extra_text_visibility == 1)
                element "option", value: "2", locales.workshop_extra_text_visibility_everyone, selected: (workshop.extra_text_visibility == 2)
            label for: "extra_text", locales.workshop_extra_text
            textarea id: "extra_text", name: "extra_text", value: workshop.extra_text
            
            button type: "submit", locales.workshops_save

            