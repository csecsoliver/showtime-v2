import Widget from require "lapis.html"
locales = require "libs/locales"
import Workshops, Participations, Invites from require "models"
import to_datetime_local from require "libs/time"
class WorkshopView extends Widget
    content: =>
        
        
        
        h1 locales.workshop_view
        p ->
            b locales.workshop_location .. ": "
            span (@workshop.location or "")
        p ->
            b locales.workshop_date .. ": "
            span os.date("%c", @workshop.date)
        p ->
            b locales.workshop_visibility .. ": "
            if @workshop.visibility == 0
                span locales.workshop_invite_only
            elseif @workshop.visibility == 1
                span locales.workshop_unlisted
            elseif @workshop.visibility == 2
                span locales.workshop_public
        p ->
            b locales.workshop_sponsor .. ": "
            span (@workshop.sponsor or "")
             
        if string.len(@workshop.extra_text or "") > 0 and @workshop.extra_text_visibility > 0
            if @workshop.extra_text_visibility == 1
                participations = @workshop.get_participations!
                for i in *participations
                    if i.user_id == @current_user_table.id
                        p @workshop.extra_text
                        break
            elseif @workshop.extra_text_visibility == 2
                p @workshop.extra_text
        
        h2 locales.participation
        participations = Participations\select "where user_id = ? and workshop_id = ? order by id", @current_user_table.id, @workshop.id
        element "table", ->
            thead ->
                tr ->
                    th locales.name
                    th locales.status
                    th locales.note
                    th ""
            tbody ->
                for participation in *participations
                    tr ->
                        td participation.name
                        td if participation.approved == 1 then locales.approved else locales.pending
                        td participation.notes
                        td ->
                            a href: "/wcp/" .. participation.id , locales.cancel_participation
        form action: "/ws/" .. @workshop.id, method: "POST", ->
            label for: "name", locales.part_name
            input type: "text", name: "name", id: "name", required: true
            label for: "notes", locales.part_notes
            textarea name: "notes", id: "notes"
            button type: "submit", locales.signup
        
        


        

            