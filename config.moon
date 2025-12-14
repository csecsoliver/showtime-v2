import config from require "lapis.config"

config "development", ->
  server "nginx"
  code_cache "off"
  num_workers "5" -- Why would anyone want more than 1 worker on one machine?
  sqlite ->
    database "showtime-v2.sqlite"
