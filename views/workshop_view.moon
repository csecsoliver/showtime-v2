import Widget from require "lapis.html"
locales = require "libs/locales"
import Workshops, Participations from require "models"
import to_datetime_local from require "libs/time"
class WorkshopView extends Widget
    content: =>
        h1 locales.workshop_view
        p ->
            b locales.workshop_location .. ": "
            span @workshop.location
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
        if string.len(@workshop.extra_text) > 0 and @workshop.extra_text_visibility > 0
            if @workshop.extra_text_visibility == 1
                participations = @workshop.get_participations!
                for i in *participations
                    if i.user_id == @current_user_table.id
                        p @workshop.extra_text
                        break
            elseif @workshop_extra_text_visibility
                p @workshop.extra_text
        
        


        

            