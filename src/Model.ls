require! \./Messenger

class Model
  (@emitter, @singular, @plural)->
    @action-types =
      list: "list #{plural}"
      create: "create #{singular}"
      retrieve: "retrieve #{singular}"
      update: "update #{singular}"
      delete: "delete #{singular}"
    @response-types =
      list: "list of #{plural}"
      retrieve: singular

  create-messenger: (dispatch-type, response-type, data, callback)->
    new Messenger @emitter, dispatch-type, response-type, data, callback

  list: (callback, data)!->
    messenger = @create-messenger @action-types.list, @response-types.list, data, callback
    messenger.dispatch!

  retrieve: (data, callback)!->
    messenger = @create-messenger @action-types.retrieve, @response-types.retrieve, data, callback
    messenger.dispatch!

module.exports = Model

