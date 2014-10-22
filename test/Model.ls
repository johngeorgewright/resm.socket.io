require! {
  chai
  sinon
  events: {EventEmitter}
  \sinon-chai
  \../src/Model
  \../src/Messenger
}

chai.use sinon-chai
{expect} = chai

suite \Model ->
  model = emitter = null
  setup ->
    emitter := new EventEmitter
    model := new Model emitter, \user \users

  suite \constructor ->
    test 'assigned an emitter' ->
      expect model .to.have.property \emitter emitter
    test 'assigned the singular name' ->
      expect model .to.have.property \singular \user
    test 'assigned the plural name' ->
      expect model .to.have.property \plural \users
    test 'assigned action types' ->
      expect model .to.have.property \actionTypes
    test 'assigned a list action' ->
      expect model.action-types .to.have.property \list 'list users'
    test 'assigned a retrieve action' ->
      expect model.action-types .to.have.property \retrieve 'retrieve user'
    test 'assigned an update action' ->
      expect model.action-types .to.have.property \update 'update user'
    test 'assigned a delete action' ->
      expect model.action-types .to.have.property \delete 'delete user'
    test 'assigned response types' ->
      expect model .to.have.property \responseTypes
    test 'assigned a list response type' ->
      expect model.response-types .to.have.property \list 'list of users'
    test 'assigned a retireval response type' ->
      expect model.response-types .to.have.property \retrieve \user

  suite \.create-messenger ->
    messenger = callback = null
    setup ->
      callback := sinon.spy!
      messenger := model.create-messenger \request \response \data callback
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
    messenger = callback = null
    setup ->
      messenger := dispatch: sinon.spy!
      callback := sinon.spy!
      sinon.stub model, \createMessenger .returns messenger

    suite \.list ->
      setup ->
        model.list callback, \data
      test 'creates a messenger' ->
        expect model.create-messenger .to.have.been.called-with-exactly 'list users' 'list of users' \data callback
      test 'dispatched the messenger' ->
        expect messenger.dispatch .to.have.been.called

    suite \.retrieve ->
      setup ->
        model.retrieve \data callback
      test 'creates a messenger' ->
        expect model.create-messenger .to.have.been.called-with-exactly 'retrieve user' 'user' \data callback
      test 'dispatched the messenger' ->
        expect messenger.dispatch .to.have.been.called

