require! {
  chai
  sinon
  \sinon-chai
  \../src/Client
}

chai.use sinon-chai
{expect} = chai

suite \Client ->
  client = messenger = null

  setup ->
    client := new Client {} \singular \plural
    messenger := dispatch: sinon.spy!
    sinon.stub client, \createMessenger .returns messenger

  <[ \createMessenger list retrieve ]>.for-each (method)->
    test "inherits the \"#method\" method" ->
      expect client .to.have.property method
      expect client[method] .to.be.a \function

  suite \.update ->
    setup ->
      client.update \data \fn

    test 'creates a messenger' ->
      expect client.create-messenger .to.have.been.called-with-exactly 'update singular' 'update singular' \data \fn

    test 'dispatches the message' ->
      expect messenger.dispatch .to.have.been.called

  suite \.delete ->
    setup ->
      client.delete \data \fn

    test 'creates a messenger' ->
      expect client.create-messenger .to.have.been.called-with-exactly 'delete singular' 'delete singular' \data \fn

    test 'dispatches the message' ->
      expect messenger.dispatch .to.have.been.called

