require! \./Model

class Server extends Model
  listener = (amend-data, fn, data)!-->
    amend-data data, fn

  responder: (type, response-type, fn)!->
    responder = (data)!~> @emitter.emit response-type, data
    @emitter.on type, listener(fn, responder)

  broadcaster: (type, fn)!->
    broadcaster = (data)!~> @emitter.io.emit type, data
    @emitter.on type, listener(fn, broadcaster)

  listing: (fn)!->
    @responder @action-types.list, @response-types.list, fn

  retrieving: (fn)!->
    @responder @action-types.retrieve, @response-types.retrieve, fn

  updating: (fn)->
    @broadcaster @action-types.update, fn

  deleting: (fn)->
    @broadcaster @action-types.delete, fn

