lapis = require "lapis"
import Users, Sessiontokens from require "models" -- this is so stupid... I have to use lowercase here
log = require "libs/log"
import escape from require "lapis.util"
class DashboardApp extends lapis.Application
    @before_filter =>
        unless @current_user
            @referrer = @req.parsed_url.path
            @write redirect_to: (@url_for "login") .. "?referrer=" .. escape(@referrer)
            return
    ["dh": "/dh"]: =>
        render: "dashboard_home"

