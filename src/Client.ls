require! <[ ./Model ./Messenger ]>

class Client extends Model
  dispatch-broadcastable-action = (client, type, data, callback)->
    messenger = client.create-messenger type, type, data, callback
    messenger.dispatch!

  create-messenger: (dispatch-type, response-type, data, callback)->
    new Messenger @emitter, dispatch-type, response-type, data, callback

  list: (callback, data)!->
    messenger = @create-messenger @action-types.list, @response-types.list, data, callback
    messenger.dispatch!

  retrieve: (data, callback)!->
    messenger = @create-messenger @action-types.retrieve, @response-types.retrieve, data, callback
    messenger.dispatch!

  create: (data, callback)->
    if callback
      dispatch-broadcastable-action this, @action-types.create, data, callback
    else
      callback = data
      @emitter.on @action-types.create, callback

  update: (data, callback)->
    if callback
      dispatch-broadcastable-action this, @action-types.update, data, callback
    else
      callback = data
      @emitter.on @action-types.update, callback

  delete: (data, callback)->
    if callback
      dispatch-broadcastable-action this, @action-types.delete, data, callback
    else
      callback = data
      @emitter.on @action-types.delete, callback

module.exports = Client

