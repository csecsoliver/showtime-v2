lapis = require "lapis"
import respond_to from require "lapis.application"
db = require "lapis.db"
log = require "libs/log"
JSON = require "JSON"
class DashboardApp extends lapis.Application
    @before_filter =>
        unless @current_user
            @write status: 404, "hell nah"
        unless @current_user_table.role >= 99
            @write status: 404, "hell nah"
            
    ["admin": "/hmmthisshouldnotbeaccessed"]: respond_to {
        GET: =>
            render: "admin"
        POST: =>
            @output_table = db.query @params.query
            @output = JSON\encode_pretty(@output_table, nil, { pretty: true, align_keys: false, array_newline: true, indent: "|   " })
            render: "admin"
    }   