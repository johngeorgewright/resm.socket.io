require! \./Model

class Client extends Model
  dispatch-broadcastable-action = (client, type, data, callback)->
    messenger = client.messenger type, type, data, callback
    messenger.dispatch!

  update: (data, callback = ->)->
    dispatch-broadcastable-action this, @action-types.update, data, callback

  delete: (data, callback = ->)->
    dispatch-broadcastable-action this, @action-types.delete, data, callback

module.exports = Client

