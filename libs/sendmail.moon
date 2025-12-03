log = require "libs/log"
send_mail = (address, subject, text) ->
    log "Mail to \"#{address}\" with subject: \"#{subject}\" and content: \"#{text}\""
        
{
    :send_mail
}