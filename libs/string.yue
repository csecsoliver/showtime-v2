ngx = require "ngx"

split = (s, re, flags="jo") ->
    s = s or ""
    out = {}
    it, err = ngx.re.gmatch s, re, flags
    return nil, err unless it
    while true
        m = it!
        break unless m
        table.insert out, m[0]
    out

{ :split }
