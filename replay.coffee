redis = require 'redis'
rest = require 'restler'

env = require './environment'
URLRewrite = require './url_rewrite'
ReplayClient = require './replay_client'

urlRewrite = new URLRewrite(env)
replay = new ReplayClient(urlRewrite, rest)

subClient = redis.createClient env.get('redisPort'), env.get('redisHost')
subClient.subscribe env.get('channel') 

subClient.on "message", (channel, message) -> 
    request = JSON.parse message
    agent = request.server_info['HTTP_USER_AGENT']

    if agent != env.get('userAgent')
        replay.send request


