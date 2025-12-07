log = require "libs/log"
import password from require "env"
mime = require "mime"

-- SMTP client using OpenResty's cosocket API
smtp_send = (from_addr, to_addr, smtp_host, smtp_port, smtp_user, smtp_pass, subject, body) ->
    sock = ngx.socket.tcp!
    sock\settimeout(10000)
    
    ok, err = sock\connect(smtp_host, smtp_port)
    if not ok
        return nil, "connect failed: " .. tostring(err)
    
    -- Start TLS handshake for port 465 (implicit TLS)
    session, err = sock\sslhandshake(nil, smtp_host, false)
    if not session
        sock\close!
        return nil, "SSL handshake failed: " .. tostring(err)
    
    -- Helper to read SMTP response
    read_response = ->
        line, err = sock\receive("*l")
        if not line
            return nil, err
        -- Read continuation lines
        while line\sub(4, 4) == "-"
            next_line, err = sock\receive("*l")
            if not next_line
                return nil, err
            line = next_line
        code = tonumber(line\sub(1, 3))
        return code, line
    
    -- Helper to send command and check response
    send_cmd = (cmd, expected_code) ->
        if cmd
            sock\send(cmd .. "\r\n")
        code, resp = read_response!
        if not code
            return nil, resp
        if code != expected_code
            return nil, "expected #{expected_code}, got #{code}: #{resp}"
        return true
    
    -- SMTP conversation
    ok, err = send_cmd(nil, 220)  -- greeting
    if not ok
        sock\close!
        return nil, "greeting: " .. tostring(err)
    
    ok, err = send_cmd("EHLO localhost", 250)
    if not ok
        sock\close!
        return nil, "EHLO: " .. tostring(err)
    
    -- AUTH LOGIN
    ok, err = send_cmd("AUTH LOGIN", 334)
    if not ok
        sock\close!
        return nil, "AUTH LOGIN: " .. tostring(err)
    
    ok, err = send_cmd(mime.b64(smtp_user), 334)
    if not ok
        sock\close!
        return nil, "AUTH user: " .. tostring(err)
    
    ok, err = send_cmd(mime.b64(smtp_pass), 235)
    if not ok
        sock\close!
        return nil, "AUTH pass: " .. tostring(err)
    
    ok, err = send_cmd("MAIL FROM:<#{from_addr}>", 250)
    if not ok
        sock\close!
        return nil, "MAIL FROM: " .. tostring(err)
    
    ok, err = send_cmd("RCPT TO:<#{to_addr}>", 250)
    if not ok
        sock\close!
        return nil, "RCPT TO: " .. tostring(err)
    
    ok, err = send_cmd("DATA", 354)
    if not ok
        sock\close!
        return nil, "DATA: " .. tostring(err)
    
    -- Send email content
    date = os.date("!%a, %d %b %Y %H:%M:%S +0000")
    message = table.concat({
        "From: #{from_addr}",
        "To: #{to_addr}",
        "Subject: #{subject}",
        "Date: #{date}",
        "Content-Type: text/plain; charset=UTF-8",
        "",
        body,
        "."
    }, "\r\n")
    
    sock\send(message .. "\r\n")
    
    ok, err = send_cmd(nil, 250)
    if not ok
        sock\close!
        return nil, "after DATA: " .. tostring(err)
    
    send_cmd("QUIT", 221)
    sock\close!
    return true

send_mail = (address, subject, text) ->
    log "Mail to \"#{address}\" with subject: \"#{subject}\" and content: \"#{text}\""
    ngx.timer.at 0, ->
        ok, err = smtp_send(
            "showtime@olio.ovh",
            address,
            "smtp.purelymail.com",
            465,
            "showtime@olio.ovh",
            password,
            subject,
            text
        )
        if ok
            log "Email sent successfully to #{address}"
        else
            log "Email failed: #{err}"

{
    :send_mail
}