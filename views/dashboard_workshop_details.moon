import Widget from require "lapis.html"
locales = require "libs/locales"
import Workshops, Participations, Users from require "models"
import to_datetime_local from require "libs/time"
import escape from require "lapis.html"
class DashWorkshopDetails extends Widget
    content: =>
        h1 locales.workshops_view_edit
        workshop = Workshops\find @id
        form method: "post" , ->
            csrf_field!
            label for: "location", locales.workshop_location
            input type: "text", id: "location", name: "location", value: workshop.location or "", maxlength: "200"
            label for: "date", locales.workshop_date
            input type: "datetime-local", id: "date", name: "date", required: true, value: to_datetime_local(workshop.date)
            label for: "visibility", locales.workshop_visibility
            
            log workshop.visibility
            log tostring((workshop.visibility == 2) or nil)
            element "select", id: "visibility", name: "visibility", ->
                element "option", value: "0", selected: (workshop.visibility == 0) or nil, locales.workshop_invite_only
                element "option", value: "1", selected: (workshop.visibility == 1) or nil, locales.workshop_unlisted
                element "option", value: "2", selected: (workshop.visibility == 2) or nil, locales.workshop_public



            label for: "max_participants", locales.workshop_max_participants
            input type: "text", id: "max_participants", name: "max_participants", min: "1", value: workshop.max_participants
            label for: "sponsor", locales.workshop_sponsor
            input type: "text", id: "sponsor", name: "sponsor", value: workshop.sponsor or "", maxlength: "200"
            
            label for: "extra_text_visibility", locales.workshop_extra_text_visibility
            log workshop.extra_text_visibility
            element "select", id: "extra_text_visibility", name: "extra_text_visibility", ->
                element "option", value: "0", locales.workshop_extra_text_visibility_organizers_only, selected: (workshop.extra_text_visibility == 0) and "selected" or nil
                element "option", value: "1", locales.workshop_extra_text_visibility_participants, selected: (workshop.extra_text_visibility == 1) and "selected" or nil
                element "option", value: "2", locales.workshop_extra_text_visibility_everyone, selected: (workshop.extra_text_visibility == 2) and "selected" or nil
            label for: "extra_text", locales.workshop_extra_text
            textarea id: "extra_text", name: "extra_text", value: workshop.extra_text or "", maxlength: "200"
            
            button type: "submit", locales.workshops_save

        h2 locales.participant_management
        participations = Participations\select "where workshop_id = ? order by id", @id
        element "table", ->
            thead ->
                tr ->
                    th locales.name
                    th locales.status
                    th locales.note
                    th locales.user
                    th locales.actions
            tbody ->
                for participation in *participations
                    tr ->
                        td escape(participation.name)
                        td if participation.approved == 1 then locales.approved else locales.pending
                        td escape(participation.notes)
                        td escape(participation\get_user!.email)
                        td ->
                            if participation.approved == 0
                                form action: "/dw/approve/" .. participation.id, method: "POST", ->
                                    input type: "hidden", name: "csrf_token", value: @csrf_token
                                    button type: "submit", locales.approve_participant
                                text " "
                            form action: "/dw/remove/" .. participation.id, method: "POST", onsubmit: "return confirm('" .. locales.remove_participant .. "?');", ->
                                input type: "hidden", name: "csrf_token", value: @csrf_token
                                button type: "submit", locales.remove_participant
        form action: "/dic/" .. workshop.id, method: "POST", ->
            input type: "hidden", name: "csrf_token", value: @csrf_token
            label for: "user", locales.invite_user
            input type: "text", id: "emails", name: "emails", placeholder: "email1; email2; email3"
            -- element "select", id: "user", name: "user", ->
            --     users = Users\select!
            --     for user in *users
            --         element "option", value: user.id, user.email 
            label for: "uses", locales.invite_uses
            input type: "number", id: "uses", name: "uses", value: "1", min: "1"

            button type: "submit", locales.create_invite
            