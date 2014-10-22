(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// Generated by LiveScript 1.3.0
var Model, Client;
Model = require('./Model');
Client = (function(superclass){
  var dispatchBroadcastableAction, prototype = extend$((import$(Client, superclass).displayName = 'Client', Client), superclass).prototype, constructor = Client;
  dispatchBroadcastableAction = function(client, type, data, callback){
    var messenger;
    messenger = client.createMessenger(type, type, data, callback);
    return messenger.dispatch();
  };
  prototype.update = function(data, callback){
    callback == null && (callback = function(){});
    return dispatchBroadcastableAction(this, this.actionTypes.update, data, callback);
  };
  prototype['delete'] = function(data, callback){
    callback == null && (callback = function(){});
    return dispatchBroadcastableAction(this, this.actionTypes['delete'], data, callback);
  };
  function Client(){
    Client.superclass.apply(this, arguments);
  }
  return Client;
}(Model));
module.exports = Client;
function extend$(sub, sup){
  function fun(){} fun.prototype = (sub.superclass = sup).prototype;
  (sub.prototype = new fun).constructor = sub;
  if (typeof sup.extended == 'function') sup.extended(sub);
  return sub;
}
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}
},{"./Model":3}],2:[function(require,module,exports){
// Generated by LiveScript 1.3.0
var ProcessingError, RequestError, PROCESSING_ERROR, REQUEST_ERROR, Messenger;
ProcessingError = require('./ProcessingError');
RequestError = require('./RequestError');
PROCESSING_ERROR = 'processing error';
REQUEST_ERROR = 'request error';
Messenger = (function(){
  Messenger.displayName = 'Messenger';
  var listeners, prototype = Messenger.prototype, constructor = Messenger;
  listeners = function(messenger){
    return [[messenger.responseType, messenger.handleResponse], [PROCESSING_ERROR, messenger.handleProcessingError], [REQUEST_ERROR, messenger.handleRequestError]];
  };
  function Messenger(emitter, dispatchType, responseType, data, callback){
    this.emitter = emitter;
    this.dispatchType = dispatchType;
    this.responseType = responseType;
    this.data = data;
    this.callback = callback;
    this.handleRequestError = bind$(this, 'handleRequestError', prototype);
    this.handleProcessingError = bind$(this, 'handleProcessingError', prototype);
    this.handleResponse = bind$(this, 'handleResponse', prototype);
    this.removeListeners = bind$(this, 'removeListeners', prototype);
  }
  prototype.dispatch = function(){
    var i$, ref$, len$, type, message, ref1$;
    for (i$ = 0, len$ = (ref$ = [this.responseType, PROCESSING_ERROR, REQUEST_ERROR]).length; i$ < len$; ++i$) {
      type = ref$[i$];
      this.emitter.once(type, this.removeListeners);
    }
    for (i$ = 0, len$ = (ref$ = listeners(this)).length; i$ < len$; ++i$) {
      message = ref$[i$];
      (ref1$ = this.emitter).once.apply(ref1$, message);
    }
    this.emitter.emit(this.dispatchType, this.data);
  };
  prototype.removeListeners = function(){
    var i$, ref$, len$, listener, ref1$;
    for (i$ = 0, len$ = (ref$ = listeners(this)).length; i$ < len$; ++i$) {
      listener = ref$[i$];
      (ref1$ = this.emitter).removeListener.apply(ref1$, listener);
    }
  };
  prototype.handleResponse = function(data){
    this.callback(null, data);
  };
  prototype.handleProcessingError = function(code){
    var x$;
    x$ = new ProcessingError;
    x$.code = code;
    this.callback(x$);
  };
  prototype.handleRequestError = function(code){
    var x$;
    x$ = new RequestError;
    x$.code = code;
    this.callback(x$);
  };
  return Messenger;
}());
module.exports = Messenger;
function bind$(obj, key, target){
  return function(){ return (target || obj)[key].apply(obj, arguments) };
}
},{"./ProcessingError":4,"./RequestError":5}],3:[function(require,module,exports){
// Generated by LiveScript 1.3.0
var Messenger, Model;
Messenger = require('./Messenger');
Model = (function(){
  Model.displayName = 'Model';
  var prototype = Model.prototype, constructor = Model;
  function Model(emitter, singular, plural){
    this.emitter = emitter;
    this.singular = singular;
    this.plural = plural;
    this.actionTypes = {
      list: "list " + plural,
      retrieve: "retrieve " + singular,
      update: "update " + singular,
      'delete': "delete " + singular
    };
    this.responseTypes = {
      list: "list of " + plural,
      retrieve: singular
    };
  }
  prototype.createMessenger = function(dispatchType, responseType, data, callback){
    return new Messenger(this.emitter, dispatchType, responseType, data, callback);
  };
  prototype.list = function(callback, data){
    var messenger;
    messenger = this.createMessenger(this.actionTypes.list, this.responseTypes.list, data, callback);
    messenger.dispatch();
  };
  prototype.retrieve = function(data, callback){
    var messenger;
    messenger = this.createMessenger(this.actionTypes.retrieve, this.responseTypes.retrieve, data, callback);
    messenger.dispatch();
  };
  return Model;
}());
module.exports = Model;
},{"./Messenger":2}],4:[function(require,module,exports){
// Generated by LiveScript 1.3.0
var RESMProcessingError;
RESMProcessingError = (function(superclass){
  var prototype = extend$((import$(RESMProcessingError, superclass).displayName = 'RESMProcessingError', RESMProcessingError), superclass).prototype, constructor = RESMProcessingError;
  function RESMProcessingError(){
    RESMProcessingError.superclass.apply(this, arguments);
  }
  return RESMProcessingError;
}(Error));
module.exports = RESMProcessingError;
function extend$(sub, sup){
  function fun(){} fun.prototype = (sub.superclass = sup).prototype;
  (sub.prototype = new fun).constructor = sub;
  if (typeof sup.extended == 'function') sup.extended(sub);
  return sub;
}
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}
},{}],5:[function(require,module,exports){
// Generated by LiveScript 1.3.0
var RESMRequestError;
RESMRequestError = (function(superclass){
  var prototype = extend$((import$(RESMRequestError, superclass).displayName = 'RESMRequestError', RESMRequestError), superclass).prototype, constructor = RESMRequestError;
  function RESMRequestError(){
    RESMRequestError.superclass.apply(this, arguments);
  }
  return RESMRequestError;
}(Error));
module.exports = RESMRequestError;
function extend$(sub, sup){
  function fun(){} fun.prototype = (sub.superclass = sup).prototype;
  (sub.prototype = new fun).constructor = sub;
  if (typeof sup.extended == 'function') sup.extended(sub);
  return sub;
}
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}
},{}]},{},[1]);
