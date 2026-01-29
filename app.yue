lapis = require "lapis"
ngx = require "ngx"
hallofshame = require "libs/hallofshame"
csrf = require "libs/csrf"
import Sessiontokens from require "models"
class extends lapis.Application
    layout: require "views.mainlayout"
    
    @before_filter =>
        -- Apply CSRF protection to POST requests
        csrf_protect = csrf.csrf_middleware {
            exempt_paths: {"/l"} -- Exempt login route from CSRF validation
        }
        csrf_protect(@)
        
        -- Load user from session
        if @session.token
            token = Sessiontokens\find token: @session.token
            if token
                user = token\get_user!
                if (user.id) and (token.expiry > os.time!)
                    @current_user = user.email
                    @current_user_table = user
        
        -- Add CSRF token to template context
        csrf.add_csrf_to_context(@session, @)
        
        @type = "m"
    @include "applications.login"
    @include "applications.dashboard"
    @include "applications.workshops"
    @include "applications.admin"
    
    "/": =>
        render: "index"
    handle_404: =>
        hallofshame "Someone was naughty again!"
        hallofshame "Request for path: " .. @req.parsed_url.path.. " from IP: " .. (@req.headers["X-Forwarded-For"] or ngx.var.remote_addr)
        @req.headers["User-Agent"] and hallofshame "User-Agent: " .. @req.headers["User-Agent"]
        "404 Not Found"