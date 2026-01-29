log = (message) ->
    f = io.open("application.log", "a")
    f\write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. tostring(message) .. "\n")
    f\close!
    return
log