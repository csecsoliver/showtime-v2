lapis = require "lapis"
import Users, Sessiontokens from require "models" -- this is so stupid... I have to use lowercase here
log = require "libs/log"
class DashboardApp extends lapis.Application
    @before_filter =>
        unless @session.token
            return @write redirect_to: @url_for "login"
        token = Sessiontokens\find token: @session.token
        if token
            user = token\get_user!
            log user.email .." ".. token.expiry .." ".. os.time!
            if (user.id) and (token.expiry > os.time!)
                @current_user = user.email
                print "Current user: " .. @current_user
                return
        @write redirect_to: @url_for "login"
    ["dh": "/dh"]: =>
        render: "dashboard_home"

