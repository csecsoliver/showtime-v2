lapis = require "lapis"
import respond_to from require "lapis.application"
import Users, Sessiontokens, Workshops, Invites, Participations, Claimedinvites from require "models" -- this is so stupid... I have to use lowercase here
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
            claimed_invite = Claimedinvites\find workshop_id: @workshop.id, user_id: @current_user_table.id
            unless claimed_invite
                @write locales.invite_only
                return
        render: "workshop_view"

    ["workshop_signup": "/ws/:id"]: respond_to {
        GET: =>
            status: 405, "Method Not Allowed"
        POST: =>
            unless @params.name
                @write locales.error_message

            if #@params.name > 100
                @write locales.error_message
            if #@params.notes > 500
                @write locales.error_message
            @workshop = Workshops\find @params.id
            unless @workshop
                @write locales.not_found
            if #@workshop\get_participations! >= @workshop.max_participants and @workshop.max_participants != -1
                @write locales.workshop_full

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

    ["invite": "/i/:code"]: => -- the user goes to the path with the invite code and an invite gets created specifically for them
        invite = Invites\find code: @params.code
        if invite and invite.uses_left >= 1
            Claimedinvites\create {
                workshop_id: invite.workshop_id
                user_id: @current_user_table.id
            }
            invite\update {
                uses_left: invite.uses_left - 1
            }
            @write redirect_to: "/wv/" .. invite.workshop_id
        else if invite and invite.uses_left < 1
            if Claimedinvites\find workshop_id: invite.workshop_id, user_id: @current_user_table.id
                @write redirect_to: "/wv/" .. invite.workshop_id
            else
                @write locales.invite_only
        else
            @write locales.not_found
    


    
    

