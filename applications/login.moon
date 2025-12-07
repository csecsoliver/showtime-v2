lapis = require "lapis"
import respond_to from require "lapis.application"
import Emailcodes, Sessiontokens, Users from require "models"
uuid = require "lua-uuid"
argon2 = require "argon2"
import send_mail from require "libs/sendmail"
log = require "libs/log"

class LoginApp extends lapis.Application
    [login: "/l"]: respond_to {
        GET: =>
            @referrer = @params.referrer
            render: true
        POST: => 
            @referrer = @params.referrer
            if @params.code
                emailcode = Emailcodes\find code: @params.code
                user = Users\find email: @params.email
                -- wow this was insecure af before
                if emailcode and emailcode.code == @params.code and emailcode.user_id == user.id
                    token = Sessiontokens\create {
                        user_id: emailcode.user_id
                        expiry: os.time! + 360000
                        token: tostring(uuid.new!)
                    }
                    @session.email = @params.email
                    @session.token = token.token
                    referrer = "/"
                    if @params.referrer and @params.referrer\match("^/[^/]")
                        referrer = @params.referrer
                    emailcode\delete!
                    @write redirect_to: (referrer)
                else
                    @error_message = "Wrong code"
                    @nextstep = "emailcode"
                    @email = @params.email
                    @write render: "login"
            elseif @params.password
                user = Users\find(email: @params.email)
                if argon2.verify(user.passhash, @params.password)
                    token = Sessiontokens\create {
                        user_id: user.id
                        expiry: os.time! + 360000
                        token: tostring(uuid.new!)
                    }
                    @session.email = @params.email
                    @session.token = token.token
                    referrer = "/"
                    if @params.referrer and @params.referrer\match("^/[^/]")
                        referrer = @params.referrer
                    @write redirect_to: (referrer)
                else
                    @error_message = "Wrong password"
                    @write render: "login"
            elseif @params.option == "email"
                math.randomseed os.time!
                user = Users\find(email: @params.email)
                unless user
                    user = Users\create {
                        email: @params.email
                        role: 99
                    }
                    log user.role
                    
                emailcode = Emailcodes\create {
                    user_id: user.id
                    code: math.random 312312323
                }
                send_mail(
                    @params.email,
                    "Your login code",
                    "Your login code is: " .. tostring(emailcode.code)
                )
                @nextstep = "emailcode"
                @email = user.email
                @write render: "login"
            elseif @params.option == "password"
                @nextstep = "password"
                @email = @params.email
                @write render: "login"
            else
                @error_message = "Invalid option"
                @write render: "login"
                
                
    }