lapis = require "lapis"
ngx = require "ngx"
hallofshame = require "libs/hallofshame"
import Sessiontokens from require "models"
class extends lapis.Application
    layout: require "views.mainlayout"
    @before_filter =>
        if @session.token
            token = Sessiontokens\find token: @session.token
            if token
                user = token\get_user!
                if (user.id) and (token.expiry > os.time!)
                    @current_user = user.email
                    @current_user_table = user
        @type = "m"
    @include "applications.login"
    @include "applications.dashboard"
    @include "applications.workshops"
    
    "/": =>
        render: "index"
    handle_404: =>
        hallofshame "Someone was naughty again!"
        hallofshame "Request for path: " .. @req.parsed_url.path.. " from IP: " .. (@req.headers["X-Forwarded-For"] or ngx.var.remote_addr)
        @req.headers["User-Agent"] and hallofshame "User-Agent: " .. @req.headers["User-Agent"]
        "404 Not Found"