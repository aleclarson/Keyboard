// Generated by CoffeeScript 1.12.4
var Event, KeyboardEventEmitter, capitalizeFirstLetter, eventNames;

KeyboardEventEmitter = require("KeyboardEventEmitter");

Event = require("Event");

capitalizeFirstLetter = function(string) {
  return string[0].toUpperCase() + string.slice(1);
};

eventNames = ["willShow", "didShow", "willHide", "didHide", "willChangeFrame"];

eventNames.forEach(function(eventName) {
  var event, nativeEvent, nativeListener, onAttach, onDetach;
  exports[eventName] = event = Event();
  nativeEvent = "keyboard" + capitalizeFirstLetter(eventName);
  nativeListener = null;
  onAttach = event._onAttach;
  event._onAttach = function() {
    onAttach.apply(this, arguments);
    if (this.listenerCount === 1) {
      nativeListener = KeyboardEventEmitter.addListener(nativeEvent, event.bindEmit());
    }
  };
  onDetach = event._onDetach;
  return event._onDetach = function() {
    onDetach.apply(this, arguments);
    if (this.listenerCount === 0) {
      nativeListener.remove();
      nativeListener = null;
    }
  };
});