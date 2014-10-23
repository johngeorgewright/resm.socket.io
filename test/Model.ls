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

