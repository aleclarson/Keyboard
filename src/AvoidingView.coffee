
{Style} = require "react-validators"

LayoutAnimation = require "LayoutAnimation"
ReactComponent = require "modx/lib/Component"
parseOptions = require "parseOptions"
Platform = require "Platform"
OneOf = require "OneOf"
View = require "modx/lib/View"

Keyboard = require "./Keyboard"

type = ReactComponent "KeyboardAvoidingView"

type.defineValues

  _frame: null

type.defineAnimatedValues

  bottom: 0

type.defineBoundMethods

  _onKeyboardChange: (event) ->
    {duration, easing, endCoordinates} = event
    height = @_relativeKeyboardHeight endCoordinates

    if duration and easing
      type = LayoutAnimation.Types[easing] or "keyboard"
      LayoutAnimation.configureNext {duration, update: {duration, type}}

    @bottom.set height
    return

  _onLayout: (event) ->
    @_frame = event.nativeEvent.layout
    return

type.defineListeners ->
  if Platform.OS is "ios"
    Keyboard.willChangeFrame @_onKeyboardChange
  else
    Keyboard.didHide @_onKeyboardChange
    Keyboard.didShow @_onKeyboardChange
  return

#
# Prototype
#

type.defineMethods

  _relativeKeyboardHeight: (keyboardFrame) ->
    return 0 unless keyboardFrame and @frame
    y1 = Math.max @frame.y, keyboardFrame.screenY - @props.keyboardVerticalOffset
    y2 = Math.min @frame.y + @frame.height, keyboardFrame.screenY + keyboardFrame.height - @props.keyboardVerticalOffset
    return Math.max y2 - y1, 0

#
# Rendering
#

type.defineProps
  contentContainerStyle: Style
  verticalOffset: Number.withDefault 0

type.render ->
  viewProps = parseOptions View, @props, {key: "propTypes"}
  return View
    mixins: [viewProps]
    onLayout: @_onLayout
    children: View
      style: [@props.contentContainerStyle, {@bottom}]
      children: @props.children

module.exports = type.build()
