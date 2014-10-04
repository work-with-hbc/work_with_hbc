# # Command
#
# Command omnibox commands collector.
#
# ## Define a command
#
# ```
# Command.define 'ping', 'ping pong', (params) ->
#   (input) ->
#     console.log "pong: #{params}"
# ```
#
# - **params**: are what user type aftert the command in the ominibox.
#
#   > ping foo bar
#
#   and params will be `foo` and `bar`
#
# - **input**: are the context when the command runs. See pipeline belows.
#
# ## Pipeline
#
# You can chain command with `|`:
#
#   > calc 1 + 1 | ping
#
# And when `ping` runs, it will got the result from `calc` as input.
#
# ## Execute
#
# ```
# Command.execute 'calc 1 + 1'
# ```
#
# If the input string cannot be executed, it will return `null`.
#
# ## Get list of available commands
#
# ```
# Command.list()
# ```
#
# ## Get help description of a command
#
# ```
# Command.help('ping')
# ```
#
# ## Reset all set commands
#
# ```
# Command.reset()
# ```

# FIXME remove tricky import
if window?
  root = window
  CommandLexer = window.CommandLexer
else
  root = exports
  {CommandLexer: CommandLexer} = require '../../lib/command_lexer'


Command =

  # List commands request.
  getCommandsRequest: 'command.list'

  # Get help message for a command.
  getCommandDescription: 'command.help'

  # Execute command request.
  executeCommandRequest: 'command.execute'

  # Defined commands map.
  definedCommandsMap: {}

  # Defined commands list.
  definedCommandsList: []

  init: ->
    Message.on @executeCommandRequest, (input, makeRes) =>
      makeRes @execute input

    Message.on @getCommandDescription, (payloads, makeRes) =>
      {command: command} = payloads
      makeRes @help command

    Message.on @getCommandsRequest, (payloads, makeRes) =>
      makeRes @definedCommandsList

    @reset()
  
  define: (name, desc, callbackBuilder) ->
    if @has name
      idx = @definedCommandsList.lastIndexOf name
      @definedCommandsList[idx] = name
    else
      @definedCommandsList.push name
    
    @definedCommandsMap[name] =
      callbackBuilder: callbackBuilder
      description: desc
    
    @

  help: (name) ->
    return null unless @has name
    
    @definedCommandsMap[name].description

  reset: ->
    @definedCommandsList = []
    @definedCommandsMap = {}

  list: ->
    @definedCommandsList

  execute: (input) ->
    cmds = CommandLexer.lex input

    # Ensure we got all commands.
    for command in cmds
      return unless @has command.cmd

    input = null
    for command in cmds
      cb = @definedCommandsMap[command.cmd].callbackBuilder command.args
      input = cb input

    input

  has: (name) ->
    @definedCommandsMap[name]?


root.Command = Command
