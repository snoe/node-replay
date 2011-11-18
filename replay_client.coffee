
class ReplayClient
    constructor: (@urlRewrite, @rest) ->
        @authCookies = {}

    _authorized: (clientId) ->
        @authCookies[clientId]?

    _logIn: (request, clientId, callback) ->
        loginURL = @urlRewrite.loginURL(request)
        loginData = @urlRewrite.loginData()
            
        post = @rest.post loginURL, loginData
        post.on 'complete', (data, response) =>
            @authCookies[clientId] = response.headers['set-cookie']
            console.log " --> got cookie for:", clientId, @authCookies[clientId], "from", loginURL
            callback @authCookies[clientId]
        post.on 'error', (error) =>
            console.log "WTF", error

    _requestAuthCookie: (request, clientId, callback) ->
        if @_authorized(clientId)
            callback @authCookies[clientId]
        else
            @_logIn request, clientId, callback

    send: (request) -> 
        console.log "<--- Received: ", request['method'], request['path'], request['post']
        proxyURL = @urlRewrite.getURL request
        clientId = @urlRewrite.getClientId proxyURL 

        @_requestAuthCookie request, clientId, (cookie) =>
            method = request.method.toLowerCase()

            opts = @urlRewrite.getOptions cookie, request.post 

            pipe = @rest[method] proxyURL, opts
            pipe.on 'complete', (data, response) -> 
                console.log "---> Replayed: ", response.statusCode, method, proxyURL, "( length: #{JSON.stringify(data).length} )"
            pipe.on 'error', (error) -> 
                console.error "WTF", error

module.exports = ReplayClient

