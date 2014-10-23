require! <[ ./Model ./ProcessingError ./RequestError ]>

class Server extends Model
  listener = (amend-data, emit, errorer, data)!-->
    amend-data data, emit, errorer

  errorEmitter = (emitter, err)!-->
    if err instanceof ProcessingError
      emitter.emit 'processing error', err
    else if err instanceof RequestError
      emitter.emit 'request error', err
    else
      throw new Error 'Can only respond with a ProcessingError or a RequestError'
    emitter.emit 'error', err

  respond-to: (type, response-type, fn)!~~>
    responder = (data)!~> @emitter.emit response-type, data
    callback = listener fn, responder, errorEmitter(@emitter)
    @emitter.on type, callback

  broadcast-when: (type, fn)!->
    broadcaster = (data)!~> @emitter.io.emit type, data
    callback = listener fn, broadcaster, errorEmitter(@emitter)
    @emitter.on type, callback

  listing: (fn)!->
    respond-with = @respond-to @action-types.list
    respond-with @response-types.list, fn

  retrieving: (fn)!->
    respond-with = @respond-to @action-types.retrieve
    respond-with @response-types.retrieve, fn

  creating: (fn)!->
    @broadcast-when @action-types.create, fn

  updating: (fn)!->
    @broadcast-when @action-types.update, fn

  deleting: (fn)!->
    @broadcast-when @action-types.delete, fn

module.exports = Server

