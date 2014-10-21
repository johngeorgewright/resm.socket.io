require! <[ ./ProcessingError ./RequestError ]>

const PROCESSING_ERROR = 'processing error'
const REQUEST_ERROR = 'request error'

class Messenger
  (@emitter, @dispatch-type, @response-type, @data, @callback)->

  dispatch: !->
    for type in [@response-type, PROCESSING_ERROR, REQUEST_ERROR]
      @emitter.once it, @remove-listeners
    messages =
      * [@response-type, @handle-response]
      * [PROCESSING_ERROR, @handle-processing-error]
      * [REQUEST_ERROR, @handle-request-error]
    for message in messages
      @emitter.once ...message

  remove-listeners: !~>
    listeners =
      * [@response-type, @handle-response]
      * [PROCESSING_ERROR, @handle-processing-error]
      * [REQUEST_ERROR, @handle-request-error]
    for listener in listeners
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
      @callback err

module.exports = Messenger

