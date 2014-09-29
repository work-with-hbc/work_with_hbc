root = exports ? window


HUD =

  # Heads-up display UI provider.
  ui: null

  # Display time in milliseconds.
  hideDelayMS: 2500

  # Keyboard binding manager.
  keyboard: null

  # Keyboard event keys.
  keyboardEventKeys:
    'esc': 'deactivate'

  init: (@keyboard) ->

  activate: (message, hideDelayMS) ->
    @showUI message
    @bindKeyboardEvents()

    hideDelayMS = @hideDelayMS unless hideDelayMS?
    setTimeout (=> @deactivate()), hideDelayMS

  deactivate: ->
    @hideUI()
    @unbindKeyboardEvents()

  showUI: (message) ->
    @ui = new HUDUI unless @ui?
    @ui.show message

  hideUI: ->
    @ui.hide() if @ui?

  bindKeyboardEvents: ->
    for key, handler of @keyboardEventKeys
      @keyboard.bind key, @[handler].bind @

  unbindKeyboardEvents: ->
    @keyboard.unbind key for key, _ of @keyboardEventKeys


class HUDUI

  # Box dom element.
  box: null

  # Message content element.
  message: null

  constructor: ->
    @initDom()

  initDom: ->
    @box = Utils.createElementFromHtml(
      '''
      <div id="HUD" class="wwh-reset">
      </div>
      '''
    )
    @box.style.display = 'none'
    document.body.appendChild(@box)

  show: (message) ->
    @box.style.display = 'block'
    @box.innerHTML = message

  hide: ->
    @box.style.display = 'none'


root.HUD = HUD
