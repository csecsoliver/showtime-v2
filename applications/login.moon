lapis = require "lapis"
import respond_to from require "lapis.application"
import EmailCodes, SessionTokens, Users from require "models"
uuid = require "lua-uuid"
argon2 = require "argon2"
import send_mail from require "libs/sendmail"

class LoginApp extends lapis.Application
    [login: "/l"]: respond_to {
        GET: => render: true
        POST: => 
            user = User\find(email: @params.email)
            unless user
                @error_message = "No such user"
                @write render: login
                return
            
            if @params.code != ""
                emailcode = EmailCodes\find code: @params.code
                if emailcode.code == @params.code
                    token = SessionTokens\create {
                        user_id: user.id
                        expiry: os.time!
                        token: tostring(uuid.new!)
                    }
                    @session.email = @params.email
                    @session.token = token.token
                
            elseif @params.password != ""
                if argon2.verify(user.passhash, @params.password)
                    token = SessionTokens\create {
                        user_id: Users\find(email: @params.email).id
                        expiry: os.time! + 360000
                        token: tostring(uuid.new!)
                    }
                    @session.email = @params.email
                    @session.token = token.token
                else
                    @error_message = "Wrong password"
                    @write render: "login"
            else
                math.randomseed os.time!
                user = Users\find(email: @params.email)
                unless user
                    user = Users\create {
                        email: @params.email
                    }
                EmailCodes\create {
                    user_id: user.id
                    code: math.random 312312323
                }
                @nextstep = "emailcode"
                @email = user.email
                @write render: "login"

                
                
    }