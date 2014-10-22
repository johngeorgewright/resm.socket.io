require! {
  chai
  sinon
  events: {EventEmitter}
  \sinon-chai
  \../src/Server
}

chai.use sinon-chai
{expect} = chai

suite \Server ->
  server = callback = emitter = null
  get-listener = ->
    emitter.on.first-call.args.1
  setup ->
    callback := sinon.spy!
    emitter := new EventEmitter
    emitter.io = new EventEmitter
    sinon.stub emitter
    sinon.stub emitter.io
    server := new Server emitter, \record \records

  suite \.respond-to ->
    setup ->
      server.respond-to \request \response callback
    test 'listens for a request' ->
      expect emitter.on .to.have.been.called-with \request
    test 'calls the callback on a request with data and a responder' ->
      listener = get-listener!
      listener \some-data
      expect callback .to.have.been.called-with \some-data
      expect callback.first-call.args.1 .to.be.a \function
    test 'we can respond with different data' ->
      listener = get-listener!
      listener \some-data
      callback.call-arg-with 1 \new-data
      expect emitter.emit .to.have.been.called-with-exactly \response \new-data

  suite \.broadcast-when ->
    setup ->
      server.broadcast-when \action callback
    test 'listens for a request' ->
      expect emitter.on .to.have.been.called-with \action
    test 'calls the callback on a request with data and a broadcaster' ->
      listener = get-listener!
      listener \some-data
      expect callback .to.have.been.called-with \some-data
      expect callback.first-call.args.1 .to.be.a \function
    test 'we can broadcast with different data' ->
      listener = get-listener!
      listener \some-data
      callback.call-arg-with 1 \new-data
      expect emitter.io.emit .to.have.been.called-with-exactly \action \new-data

