config = require "lapis.config"
secret = require "secret.config"

config "development", ->
    port 8080
    code_cache "off"
    measure_performance true
    postgres ->
        user secret.dev.db.user
        password secret.dev.db.password
        database secret.dev.db.name

config "production", ->
    port 80
    code_cache "on"
    measure_performance false
    postgres ->
        user secret.prod.db.user
        password secret.prod.db.password
        database secret.prod.db.name
