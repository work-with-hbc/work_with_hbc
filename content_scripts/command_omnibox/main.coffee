root = exports ? window


CommandOmnibox =

  # Keyboard events binder.
  keyboard: null

  # Omnibox UI provider.
  ui: null

  # Keyboard event keys.
  keyboardEventKeys:
    'esc'   : 'deactivate'
    'enter' : 'executeCommand'
    'space' : 'splitCommand'

  # Commands sequence.
  commands: []

  init: (@keyboard) ->
    CommandProxy.init()

    @keyboard.bind 'alt+c', (e) =>
      @activate()

  activate: ->
    @showUI()
    @bindKeyboardEvents()
    @resetCommands()

  deactivate: ->
    @hideUI()
    @unbindKeyboardEvents()

  showUI: ->
    @ui = new OminiboxUI unless @ui?
    @ui.show()

  hideUI: ->
    @ui.hide() if @ui?

  bindKeyboardEvents: ->
    for key, handler of @keyboardEventKeys
      @keyboard.bind key, @[handler].bind @

  unbindKeyboardEvents: ->
    @keyboard.unbind key for key, _ of @keyboardEventKeys

  executeCommand: ->
    # Check remains input.
    @parseCommand()

    CommandProxy.execute @commands, @ui.getInput().trim()

    @resetCommands()

    @deactivate()

  splitCommand: (e) ->
    if @parseCommand()
      # TODO remove white space (should be able to stop space press event)
      e.stopPropagation()
      true

  resetCommands: ->
    @commands = []
    @ui.setInput ''

  # Parse sub command from input value.
  # Returns new command when found.
  parseCommand: ->
    parts = @ui.getInput().trim().split ' '

    return unless CommandProxy.has parts[0]

    command = parts.pop()
    @commands.push command
    @ui.setInput (parts.join ' ').trim()

    command


class OminiboxUI

  # Box dom element.
  box: null

  # Input box dom element.
  input: null

  # Completion list dom element.
  completionList: null

  constructor: ->
    @initDom()

  initDom: ->
    @box = Utils.createElementFromHtml(
      '''
      <div class="wwh-overlay">
        <div id="wwh-command-omnibox" class="wwh-reset">
          <div class="wwh-reset wwh-search">
              <input type="text" class="wwh-reset mousetrap">
          </div>
        </div>
      </div>
      ''')
    @box.style.display = 'none'
    document.body.appendChild(@box)

    @input = document.querySelector("#wwh-command-omnibox input")
    # @completionList = document.querySelector('#command-omnibox ul')
    # @completionList.style.display = 'none'

  show: ->
    @box.style.display = 'block'
    @input.focus()

  hide: ->
    @box.style.display = 'none'
    @input.blur()

  resetInput: ->
    @input.value = ''

  setInput: (value) ->
    @input.value = value

  getInput: ->
    @input.value


CommandProxy =

  # Commands list.
  commands: []

  # Ask for all commands.
  getCommandsRequest: 'command.list'

  # Execute a command.
  executeCommandRequest: 'command.execute'

  init: ->
    Message.send @getCommandsRequest, {}, (commands) =>
      @commands = commands

  has: (name) ->
    (@commands.lastIndexOf name) != -1

  execute: (commands, params) ->
    payload =
      commands: commands
      params: params
    Message.send @executeCommandRequest, payload, (result) ->
      console.debug "command execute result: #{result}"

      if not result?
        result = "Unknown command: #{payload.commands} #{payload.params}"
      HUD.activate result


root.CommandOmnibox = CommandOmnibox
