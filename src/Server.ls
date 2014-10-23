require! <[ ./Model ./ProcessingError ./RequestError ]>

class Server extends Model
  listener = (amend-data, emit, data)!-->
    amend-data data, emit

  error = (err)->


  respond-to: (type, response-type, fn)!~~>
    responder = (data)!~> @emitter.emit response-type, data
    @emitter.on type, listener(fn, responder)

  broadcast-when: (type, fn)!->
    broadcaster = (data)!~> @emitter.io.emit type, data
    @emitter.on type, listener(fn, broadcaster)

  listing: (fn)!->
    respond-with = @respond-to @action-types.list
    respond-with @response-types.list, fn

  retrieving: (fn)!->
    respond-with = @respond-to @action-types.retrieve
    respond-with @response-types.retrieve, fn

  creating: (fn)->
    @broadcast-when @action-types.create, fn

  updating: (fn)->
    @broadcast-when @action-types.update, fn

  deleting: (fn)->
    @broadcast-when @action-types.delete, fn

module.exports = Server

