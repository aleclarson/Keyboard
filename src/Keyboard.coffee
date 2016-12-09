
KeyboardEventEmitter = require "KeyboardEventEmitter"
Event = require "Event"
hook = require "hook"

capitalizeFirstLetter = (string) ->
  string[0].toUpperCase() + string.slice 1

eventNames = ["willShow", "didShow", "willHide", "didHide", "willChangeFrame"]

eventNames.forEach (eventName) ->

  exports[eventName] = event = Event.sync()

  nativeEvent = "keyboard" + capitalizeFirstLetter eventName
  nativeListener = null

  hook event, "_onAttach", (onAttach) ->
    onAttach()
    if @listenerCount is 1
      nativeListener = KeyboardEventEmitter
        .addListener nativeEvent, event.emit
    return

  hook event, "_onDetach", (onDetach) ->
    onDetach()
    if @listenerCount is 0
      nativeListener.remove()
      nativeListener = null
    return
