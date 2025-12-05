import Widget from require "lapis.html"
locales = require "libs/locales"
class DashWorkshopsNew extends Widget
    content: =>
        h1 locales.workshops_create_new
        form method: "post" , ->
            label for: "location", locales.workshop_location
            input type: "text", id: "location", name: "location"
            label for: "date", locales.workshop_date
            input type: "datetime-local", id: "date", name: "date", required: true

            label for: "open", locales.workshop_open
            element "select", id: "open", name: "open", ->
                element "option", value: "0", locales.workshop_invite_only
                element "option", value: "1", locales.workshop_unlisted
                element "option", value: "2", locales.workshop_public

            label for: "max_participants", locales.workshop_max_participants
            input type: "text", id: "max_participants", name: "max_participants", min: "1", value: "1"
            label for: "sponsor", locales.workshop_sponsor
            input type: "text", id: "sponsor", name: "sponsor"
            label for: "extra_text", locales.workshop_extra_text
            textarea id: "extra_text", name: "extra_text"

            label for: "extra_text_visibility", locales.workshop_extra_text_visibility
            element "select", id: "extra_text_visibility", name: "extra_text_visibility", ->
                element "option", value: "0", locales.workshop_extra_text_visibility_organizers_only
                element "option", value: "1", locales.workshop_extra_text_visibility_participants
                element "option", value: "2", locales.workshop_extra_text_visibility_everyone
            
            button type: "submit", locales.workshops_save

            