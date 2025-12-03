lapis = require "lapis"

class extends lapis.Application
  layout: require "views.mainlayout"
  @include "applications.login"
  @include "applications.dashboard"
  "/": =>
    @type = "m"
    render: "index"
