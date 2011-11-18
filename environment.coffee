config = require './config'
_ = require 'underscore'


get = (field, environment) ->
    environment ?= process.env.REPLAY_ENV || 'development'
    envconfig = _.extend {}, config.defaults, config[environment]
    envconfig[field]


exports.get = get
        
