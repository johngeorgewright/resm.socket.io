require! <[ ./ProcessingError ./RequestError ]>

const PROCESSING_ERROR = 'processing error'
const REQUEST_ERROR = 'request error'

class Messenger
  listeners = (messenger)->
    [
      [messenger.response-type, messenger.handle-response]
      [PROCESSING_ERROR, messenger.handle-processing-error]
      [REQUEST_ERROR, messenger.handle-request-error]
    ]

  (@emitter, @dispatch-type, @response-type, @data, @callback)->

  dispatch: !->
    for type in [@response-type, PROCESSING_ERROR, REQUEST_ERROR]
      @emitter.once type, @remove-listeners
    for message in listeners(@)
      @emitter.once ...message
    @emitter.emit @dispatch-type, @data

  remove-listeners: !~>
    for listener in listeners(@)
      @emitter.remove-listener ...listener

  handle-response: (data)!~>
    @callback null, data

  handle-processing-error: (code)!~>
    new ProcessingError
      ..code = code
      @callback ..

  handle-request-error: (code)!~>
    new RequestError
      ..code = code
      @callback ..

module.exports = Messenger

