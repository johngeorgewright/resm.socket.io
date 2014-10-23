require! {
  chai
  sinon
  events: {EventEmitter}
  \sinon-chai
  \../src/Client
  \../src/Messenger
}

chai.use sinon-chai
{expect} = chai

suite \Client ->
  client = emitter = messenger = null

  setup ->
    emitter := new EventEmitter
    client := new Client emitter, \user \users

  suite \.create-messenger ->
    callback = messenger = null
    setup ->
      callback := sinon.spy!
      messenger := client.create-messenger \request \response \data callback
    test 'returns a messenger' ->
      expect messenger .to.be.instanceof Messenger
    test 'assigns the emitter to the messenger' ->
      expect messenger .to.have.property \emitter emitter
    test 'assigns the dispatch type to the messenger' ->
      expect messenger .to.have.property \dispatchType \request
    test 'assigns the response type to the messenger' ->
      expect messenger .to.have.property \responseType \response
    test 'assigns the data to the messenger' ->
      expect messenger .to.have.property \data \data
    test 'assigns the callback to the messenger' ->
      expect messenger .to.have.property \callback callback

  suite \dispatching ->
    callback = null
    setup ->
      callback := sinon.spy!
      messenger := dispatch: sinon.spy!
      sinon.stub client, \createMessenger .returns messenger

    suite \.list ->
      setup ->
        client.list callback, \data
      test 'creates a messenger' ->
        expect client.create-messenger .to.have.been.called-with-exactly 'list users' 'list of users' \data callback
      test 'dispatched the messenger' ->
        expect messenger.dispatch .to.have.been.called

    suite \.retrieve ->
      setup ->
        client.retrieve \data callback
      test 'creates a messenger' ->
        expect client.create-messenger .to.have.been.called-with-exactly 'retrieve user' 'user' \data callback
      test 'dispatched the messenger' ->
        expect messenger.dispatch .to.have.been.called

    suite \.update ->
      setup ->
        client.update \data \fn

      test 'creates a messenger' ->
        expect client.create-messenger .to.have.been.called-with-exactly 'update user' 'update user' \data \fn

      test 'dispatches the message' ->
        expect messenger.dispatch .to.have.been.called

    suite \.delete ->
      setup ->
        client.delete \data \fn

      test 'creates a messenger' ->
        expect client.create-messenger .to.have.been.called-with-exactly 'delete user' 'delete user' \data \fn

      test 'dispatches the message' ->
        expect messenger.dispatch .to.have.been.called

