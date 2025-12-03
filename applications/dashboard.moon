lapis = require "lapis"
import Users, Sessiontokens from require "models" -- this is so stupid... I have to use lowercase here

class DashboardApp extends lapis.Application
    @before_filter =>
        unless @session.token
            return @write redirect_to: @url_for "login"
        token = Sessiontokens\find token: @session.token
        if token
            user = token\get_user!
            if (user) and (token.expiry > os.time!)
                @current_user = user.email
                return
        @write redirect_to: @url_for "login"
    ["dh": "/dh"]: =>
        render: "dashboard_home"

