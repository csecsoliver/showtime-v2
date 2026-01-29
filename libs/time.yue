log = require "libs/log"
parse_datetime_local = (str) ->
    year, month, day, hour, min, sec = str\match "(%d+)-(%d+)-(%d+)T(%d+):(%d+):?(%d*)"
    os.time {
        year: tonumber year
        month: tonumber month
        day: tonumber day
        hour: tonumber hour
        min: tonumber min
        sec: sec != "" and tonumber(sec) or 0
    }

to_datetime_local = (timestamp) ->
    os.date "%Y-%m-%dT%H:%M", timestamp

{ :parse_datetime_local, :to_datetime_local }