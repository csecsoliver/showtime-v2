lapis = require "lapis"
import respond_to from require "lapis.application"
import Users, Sessiontokens, Workshops from require "models" -- this is so stupid... I have to use lowercase here
log = require "libs/log"
import parse_datetime_local from require "libs/time"
import escape from require "lapis.util"
class DashboardApp extends lapis.Application
    @before_filter =>
        unless @current_user
            @referrer = @req.parsed_url.path
            @write redirect_to: (@url_for "login") .. "?referrer=" .. escape(@referrer)
            return
    ["dh": "/dh"]: =>
        render: "dashboard_home"
    ["new_workshop": "/dw/new"]: respond_to {
        GET: =>
            render: "dashboard_workshops_new"
        POST: =>
            location = @params.location
            date = parse_datetime_local @params.date
            user = Users\find email: @current_user
            open = @params.open == "on"
            max_participants = tonumber @params.max_participants or -1
            sponsor = @params.sponsor or "none"
            extra_text = @params.extra_text or ""
            extra_text_visibility = tonumber @params.extra_text_visibility or 0
            workshop = Workshops\create {
                user_id: user.id
                location: location
                date: date
                open: open
                max_participants: max_participants
                sponsor: sponsor
                extra_text: extra_text
                extra_text_visibility: extra_text_visibility
                created_at: os.time!
            }
            @write redirect_to: (@url_for "workshop_detail", id: workshop.id)
    }
    ["workshop_details": "/dw/:id"]: =>
        @id = @params.id
        render: "dashboard_workshop_details"

