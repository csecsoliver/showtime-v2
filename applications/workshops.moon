lapis = require "lapis"
import respond_to from require "lapis.application"
import Users, Sessiontokens, Workshops, Invites, Participations from require "models" -- this is so stupid... I have to use lowercase here
log = require "libs/log"
import parse_datetime_local from require "libs/time"
import escape from require "lapis.util"
locales = require "libs/locales"
class WorkshopApp extends lapis.Application
    @before_filter =>
        unless @current_user
            @referrer = @req.parsed_url.path
            @write redirect_to: (@url_for "login") .. "?referrer=" .. escape(@referrer)
            return
    ["view_workshop": "/wv/:id"]: =>
        @workshop = Workshops\find @params.id
        unless @workshop
            @write locales.not_found
            return
        if @workshop.visibility == 0
            invite = Invites\find workshop_id: @workshop.id, user_id: @current_user_table.id
            unless invite
                @write locales.invite_only
                return
        render: "workshop_view"

    ["workshop_signup": "/ws/:id"]: respond_to {
        GET: =>
            status: 405, "Method Not Allowed"
        POST: =>
            unless @params.name
                @write locales.error_message
            @workshop = Workshops\find @params.id
            unless @workshop
                @write locales.not_found
            if @workshop.visibility == 0
                invite = Invites\find workshop_id: @workshop.id, user_id: @current_user_table.id
                unless invite
                    @write locales.invite_only
            Participations\create {
                user_id: @current_user_table.id
                workshop_id: @workshop.id
                name: @params.name
                notes: @params.notes or ""
            }
            redirect_to: "/wv/" .. @workshop.id
    }
    ["workshop_cancel_participation": "/wcp/:part_id"]: respond_to {
        GET: =>
            status: 405, "Method Not Allowed"
        POST: =>
            participation = Participations\find @params.part_id
            unless participation
                @write locales.not_found
            id = participation.workshop_id
            participation\delete!
            redirect_to: "/wv/" .. id
    }

    ["workshops": "/wl"]: =>
        render: "workshops"
        


    
    

