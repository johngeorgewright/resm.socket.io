resm.socket.io
==============

A RESM layer for Socket.io.

**Currently in beta**

Creating Servers
----------------

The NPM module includes all files, but is essentially there for your socket.io server.

```js
var RESM = require('resm.socket.io'),
    ProcessingError = require('resm.socket.io/RequestError'),
    app = require('express')(),
    http = require('http').Server(app),
    io = require('socket.io')(http);

io.on('connection', function (socket) {
  var users = new RESM(socket, 'user', 'users');

  users.listing(function (query, respond, error) {
    respond([
      {id: 1, name: 'A user'},
      {id: 2, name: 'Another user'}
    ]);
  });

  users.retrieving(function (id, respond, error) {
    var user = {id:1, name:'A user'};
    respond(user);
  });

  users.deleting(function (id, broadcast, error) {
    error new RequestError(23);
  });

  users.updating(...);
});
```

Creating Clients
----------------

Using bower will install the just the client library.

```html
<html>
  <head>
    <title>Test</title>
  </head>
  <body>
    <ui id="user-list"></ul>
    <script src="/bower_components/jquery/dist/jquery.min.js"></script>
    <script src="/socket.io/socket.io.js"></script>
    <script src="/bower_components/resm.socket.io/dist/resm.soccket.io.min.js"></script>
    <script src="/users.js"></script>
  </body>
</html>
```

```js
// users.js
var socket = io(),
    users = new RESM(socket);

function displayUsers(users) {
  var list = $('#user-list');
  $.forEach(users, function (user) {
    var item = $('<li>');
    item.text(user.name);
    list.append(item);
  });
}

users.list(displayUsers);
```
