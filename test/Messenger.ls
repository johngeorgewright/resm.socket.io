require! {
  chai
  sinon
  events: {EventEmitter}
  \sinon-chai
  \../src/Messenger
  \../src/ProcessingError
  \../src/RequestError
}

chai.use sinon-chai
{expect} = chai

suite \Messenger ->

  messenger = emitter = callback = null

  setup ->
    emitter := new EventEmitter
    callback := sinon.spy!
    messenger := new Messenger emitter, \request \response \data callback

  suite \constructor ->
    test 'assigned an emitter' ->
      expect messenger .to.have.property \emitter emitter
    test 'assigned a dispatch type' ->
      expect messenger .to.have.property \dispatchType \request
    test 'assigned a response type' ->
      expect messenger .to.have.property \responseType \response
    test 'assigned data' ->
      expect messenger .to.have.property \data \data
    test 'assigned a callback' ->
      expect messenger .to.have.property \callback callback

  suite \.dispatch ->
    setup ->
      sinon.stub emitter, \once
      sinon.stub emitter, \emit
      messenger.dispatch!
    test 'is listening for processing errors' ->
      expect emitter.once .to.have.been.called-with 'processing error'
    test 'is listening for request errors' ->
      expect emitter.once .to.have.been.called-with 'request error'
    test 'is listening for responses' ->
      expect emitter.once .to.have.been.called-with \response
    test 'dispatched the request' ->
      expect emitter.emit .to.have.been.called-with-exactly \request \data

  suite \.remove-listeners ->
    setup ->
      sinon.stub emitter, \removeListener
      messenger.remove-listeners!
    test 'stops listening to the processing error' ->
      expect emitter.remove-listener .to.have.been.called-with 'processing error'
    test 'stops listening to the request error' ->
      expect emitter.remove-listener .to.have.been.called-with 'request error'
    test 'stops listening to the response' ->
      expect emitter.remove-listener .to.have.been.called-with \response

  suite 'successful response' ->
    setup ->
      messenger.dispatch!
      emitter.emit \response \mung
    test 'the callback is called with the response data' ->
      expect callback .to.have.been.called-with-exactly null, \mung

  suite 'processing error' ->
    setup ->
      messenger.dispatch!
      emitter.emit 'processing error' 100
    test 'the callback is called with an error object' ->
      expect callback.first-call.args.0 .to.be.instanceof ProcessingError
      expect callback.first-call.args.0 .to.have.property \code 100

  suite 'request error' ->
    setup ->
      messenger.dispatch!
      emitter.emit 'request error' 20
    test 'the callback is called with an error object' ->
      expect callback.first-call.args.0 .to.be.instanceof RequestError
      expect callback.first-call.args.0 .to.have.property \code 20

