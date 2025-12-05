lapis = require "lapis"
import respond_to from require "lapis.application"
import Users, Sessiontokens, Workshops, Invites from require "models" -- this is so stupid... I have to use lowercase here
log = require "libs/log"
import parse_datetime_local from require "libs/time"
import escape from require "lapis.util"
locales = require "libs/locales"
class DashboardApp extends lapis.Application
    @before_filter =>
        unless @current_user
            @referrer = @req.parsed_url.path
            @write redirect_to: (@url_for "login") .. "?referrer=" .. escape(@referrer)
            return
    ["view_workshop": "/wv/:id"]: =>
        workshop = Workshops\find @params.i
        unless workshop
            @write locales.not_found
        if workshop.open == 0
            invite = Invites\find workshop_id: workshop.id, user_id: @current_user_table.id
            unless invite
                @write locales.invite_only

        @workshop = workshop
        


    
    

