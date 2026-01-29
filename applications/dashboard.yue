lapis = require "lapis"
import respond_to from require "lapis.application"
import Users, Workshops, Participations, Invites from require "models" -- this is so stupid... I have to use lowercase here
log = require "libs/log"
import parse_datetime_local from require "libs/time"
import escape from require "lapis.util"
locales = require "libs/locales"
import hrt from require "libs/random"
import send_mail from require "libs/sendmail"
import escape from require "lapis.html"
import split from require "libs/string"
ngx = require "ngx"
class DashboardApp extends lapis.Application
    @before_filter =>
        unless @current_user
            @referrer = @req.parsed_url.path
            @write redirect_to: (@url_for "login") .. "?referrer=" .. escape(@referrer)
            return
        unless @current_user_table.role >= 20
            -- log @current_user_table.role
            @write locales.no_permission
    ["dh": "/dh"]: =>
        render: "dashboard_home"
    ["new_workshop": "/dw/new"]: respond_to {
        GET: =>
            render: "dashboard_workshops_new"
        POST: =>
            location = @params.location
            date = parse_datetime_local @params.date
            user = Users\find email: @current_user
            visibility = @params.visibility
            max_participants = tonumber @params.max_participants or -1
            sponsor = @params.sponsor or "none"
            extra_text = @params.extra_text or ""
            extra_text_visibility = tonumber @params.extra_text_visibility or 0
            workshop = Workshops\create {
                user_id: user.id
                location: location
                date: date
                visibility: visibility
                max_participants: max_participants
                sponsor: sponsor
                extra_text: extra_text
                extra_text_visibility: extra_text_visibility
                created_at: os.time!
            }
            @write redirect_to: (@url_for "dashboard_workshop_details", id: workshop.id)
    }
    ["dashboard_workshop_details": "/dw/:id"]: respond_to {
        GET: =>
            @id = @params.id
            workshop = Workshops\find @params.id
            if workshop and workshop.user_id == @current_user_table.id
                @write render: "dashboard_workshop_details"
            else
                @write locales.no_permission
        POST: =>
            workshop = Workshops\find @params.id
            if workshop and workshop.user_id == @current_user_table.id
                workshop\update {
                    location: @params.location
                    date: parse_datetime_local @params.date
                    visibility: @params.visibility
                    max_participants: tonumber @params.max_participants or -1
                    sponsor: @params.sponsor or "none"
                    extra_text: @params.extra_text or ""
                    extra_text_visibility: tonumber @params.extra_text_visibility or 0
                }
                @write redirect_to: "/dw/" .. workshop.id
            else
                @write locales.no_permission
    }
    
    ["approve_participant": "/dw/approve/:part_id"]: respond_to {
        GET: =>
            status: 405, "Method Not Allowed"
        POST: =>
            participation = Participations\find @params.part_id
            if participation
                workshop = Workshops\find participation.workshop_id
                if workshop and workshop.user_id == @current_user_table.id
                    participation\update approved: 1
                    @write redirect_to: "/dw/" .. workshop.id
                else
                    @write locales.no_permission
            else
                @write locales.not_found
    }
    
    ["remove_participant": "/dw/remove/:part_id"]: respond_to {
        GET: =>
            status: 405, "Method Not Allowed"
        POST: =>
            participation = Participations\find @params.part_id
            if participation
                workshop = Workshops\find participation.workshop_id
                if workshop and workshop.user_id == @current_user_table.id
                    participation\delete!
                    @write redirect_to: "/dw/" .. workshop.id
                else
                    @write locales.no_permission
            else
                @write locales.not_found
    }
    ["create_invite": "/dic/:id"]: respond_to {
        GET: =>
            status: 405, "Method Not Allowed"
        POST: =>
            workshop = Workshops\find @params.id
            if workshop and workshop.user_id == @current_user_table.id
                invite_code = hrt 16
                
                invite = Invites\create { -- this is a generic invite, not tied to users yet, 
                    workshop_id: workshop.id
                    code: invite_code
                    uses_left: tonumber(@params.uses) or 1
                }
                emails = @params.emails
                email_validator = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
                emails_list = split emails, "[^;\\s]+", "jo"
                
                if emails_list
                    location = escape(workshop.location or "")
                    for email in *emails_list
                        -- log email .. "<<<"
                        if email != "" and ngx.re.match(email, email_validator, "jo")

                            send_mail(
                                email,
                                locales.workshop_invite_subject,
                                "#{locales.invited_to_workshop} #{location}.

#{locales.use_code_to_sign_up} #{@req.parsed_url.scheme}://#{@req.parsed_url.host}/i/#{invite.code}"
                            )
                
                @write redirect_to: "/dw/" .. workshop.id
            else
                @write locales.no_permission
    }
