require! {
  chai
  sinon
  events: {EventEmitter}
  \sinon-chai
  \../src/Server
  \../src/ProcessingError
  \../src/RequestError
}

chai.use sinon-chai
{expect} = chai

suite \Server ->
  server = callback = emitter = null
  setup ->
    callback := sinon.spy!
    emitter := new EventEmitter
    emitter.server = new EventEmitter
    sinon.stub emitter
    sinon.stub emitter.server
    server := new Server emitter, \record \records
  get-listener = ->
    emitter.on.first-call.args.1
  call-listener = (data = \some-data)!->
    listener = get-listener!
    listener data

  suite \.respond-to ->
    setup ->
      server.respond-to \request \response callback
      call-listener!
    test 'listens for a request' ->
      expect emitter.on .to.have.been.called-with \request
    test 'calls the callback with data' ->
      expect callback .to.have.been.called-with \some-data
    test 'calls the callback with a responder' ->
      expect callback.first-call.args.1 .to.be.a \function
    test 'calls the callback with a error handler' ->
      expect callback.first-call.args.2 .to.be.a \function
    test 'we can respond with different data' ->
      callback.call-arg-with 1 \new-data
      expect emitter.emit .to.have.been.called-with-exactly \response \new-data
    test 'we can respond with an error' ->
      err = new ProcessingError
      callback.call-arg-with 2 err
      expect emitter.emit .to.have.been.called-with-exactly 'processing error' err

  suite \.broadcast-when ->
    setup ->
      server.broadcast-when \action callback
      call-listener!
    test 'listens for a request' ->
      expect emitter.on .to.have.been.called-with \action
    test 'calls the callback with data' ->
      expect callback .to.have.been.called-with \some-data
    test 'calls the callback with a broadcaster' ->
      expect callback.first-call.args.1 .to.be.a \function
    test 'calls the callback with an error handler' ->
      expect callback.first-call.args.2 .to.be.a \function
    test 'we can broadcast with different data' ->
      callback.call-arg-with 1 \new-data
      expect emitter.server.emit .to.have.been.called-with-exactly \action \new-data
    test 'we can respond with an error' ->
      err = new RequestError
      callback.call-arg-with 2 err
      expect emitter.emit .to.have.been.called-with-exactly 'request error' err

  suite 'responding methods' ->
    responder = null
    setup ->
      responder := sinon.spy!
      sinon.stub server, \respondTo .returns responder
    test '.list' ->
      server.list callback
      expect server.respond-to .to.have.been.called-with-exactly 'list records'
      expect responder .to.have.been.called-with-exactly 'list of records' callback
    test '.retrieve' ->
      server.retrieve callback
      expect server.respond-to .to.have.been.called-with-exactly 'retrieve record'
      expect responder .to.have.been.called-with-exactly 'record' callback

  suite 'broadcast methods' ->
    setup ->
      sinon.stub server, \broadcastWhen
    test '.create' ->
      server.create callback
      expect server.broadcast-when .to.have.been.called-with-exactly 'create record' callback
    test '.update' ->
      server.update callback
      expect server.broadcast-when .to.have.been.called-with-exactly 'update record' callback
    test '.delete' ->
      server.delete callback
      expect server.broadcast-when .to.have.been.called-with-exactly 'delete record' callback

