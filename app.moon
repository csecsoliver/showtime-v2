lapis = require "lapis"

class extends lapis.Application
  layout: require "views.mainlayout"

  "/": =>
    @type = "m"
    render: "index"
