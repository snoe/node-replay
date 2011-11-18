config = 
    defaults:
        userAgent: 'RequestLogger'
        redisPort: 6379
        redisHost: 'localhost'
        channel: 'request_firehose'
        authPath: '/login/authenticate'
        authData:
            username: 'username'
            password: 'password'
             
    development: 
        clientRegex: /^[^\/]*\/([a-z]*)/            
        basePathRegex: /^(\/[a-z]*)/            
        path:
            regex: /^\/([a-z]*)\//
            replace: '/$1_replay/'

    production:
        clientRegex: /^([^\.]*)/            
        host:
            regex: /example\.com/       
            replace: 'replay_example.com'

module.exports = config
