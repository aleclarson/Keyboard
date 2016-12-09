
KeyboardEventEmitter = require "KeyboardEventEmitter"
Event = require "Event"

capitalizeFirstLetter = (string) ->
  string[0].toUpperCase() + string.slice 1

eventNames = ["willShow", "didShow", "willHide", "didHide", "willChangeFrame"]

eventNames.forEach (eventName) ->

  exports[eventName] = event = Event.sync()

  nativeEvent = "keyboard" + capitalizeFirstLetter eventName
  nativeListener = null

  onAttach = event._onAttach
  event._onAttach = ->
    onAttach.apply this, arguments
    if @listenerCount is 1
      nativeListener = KeyboardEventEmitter
        .addListener nativeEvent, event.emit
    return

  onDetach = event._onDetach
  event._onDetach = ->
    onDetach.apply this, arguments
    if @listenerCount is 0
      nativeListener.remove()
      nativeListener = null
    return
