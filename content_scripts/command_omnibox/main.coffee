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
    'space' : 'getCommandDesc'

  init: (@keyboard) ->
    CommandProxy.init()

    @keyboard.bind 'alt+c', (e) =>
      @activate()

  activate: ->
    @showUI()
    @bindKeyboardEvents()

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
    command = @ui.getInput().trim()
    return unless command?

    CommandProxy.execute command

    @deactivate()

  getCommandDesc: ->
    commands = @parseCommand()
    return unless commands?

    @ui.resetDescList()
    for command in commands
      CommandProxy.help command.cmd, (cmd, desc) =>
        return unless desc?

        @ui.addDesc cmd, desc

  # Parse command and arguments from user input.
  parseCommand: ->
    CommandLexer.lex @ui.getInput()


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
          <ul class="wwh-hints wwh-reset"></ul>
        </div>
      </div>
      ''')
    @box.style.display = 'none'
    document.body.appendChild @box

    @input = document.querySelector("#wwh-command-omnibox input")
    @descList = document.querySelector('#wwh-command-omnibox ul')
    @descList.style.display = 'none'

  show: ->
    @box.style.display = 'block'
    @input.focus()

  hide: ->
    @box.style.display = 'none'
    @input.blur()

    @resetInput()
    @resetDescList()

  reset: ->
    @resetInput()
    @resetDescList()

  resetInput: ->
    return unless @input?
    @input.value = ''

  resetDescList: ->
    return unless @descList?
    @descList.innerHTML = ''

  setInput: (value) ->
    @input.value = value

  getInput: ->
    @input.value

  addDesc: (cmd, desc) ->
    desc = Utils.createElementFromHtml(
      """
      <li>
        <span class="wwh-hints-hl-keyword-command wwh-hints-hl">#{cmd}</span> #{desc}
      <li>
      """
    )
    @descList.appendChild desc

    @descList.style.display = 'block'

CommandProxy =

  # Commands list.
  commands: []

  # Ask for all commands.
  getCommandsRequest: 'command.list'

  # Get help message for a command.
  getCommandDescription: 'command.help'

  # Execute a command.
  executeCommandRequest: 'command.execute'

  init: ->
    Message.send @getCommandsRequest, {}, (commands) =>
      @commands = commands

  has: (name) ->
    (@commands.lastIndexOf name) != -1

  help: (name, cb) ->
    payload =
      command: name
    Message.send @getCommandDescription, payload, (result) ->
      Logger.debug "command help result: #{result}"

      cb name, result if result?

  execute: (command) ->
    Message.send @executeCommandRequest, command, (result) ->
      Logger.debug "command execute result: #{result}"

      if not result?
        result = "Unknown command: #{command}"
      HUD.activate result


root.CommandOmnibox = CommandOmnibox
