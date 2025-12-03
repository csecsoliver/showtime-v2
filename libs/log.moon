log = (message) ->
    io.open("application.log", "a")\write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n")\close!
    return
log