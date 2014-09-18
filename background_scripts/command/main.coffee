root = exports ? window


Command =

  # List commands request.
  getCommandsRequest: 'command.list'

  # Execute command request.
  executeCommandRequest: 'command.execute'

  # Defined commands map.
  definedCommandsMap: {}

  # Defined commands list.
  definedCommandsList: []

  init: ->
    Message.on @executeCommandRequest, (payloads, makeRes) =>
      {commands: commands, params: params} = payloads
      makeRes (@execute commands, params)

    Message.on @getCommandsRequest, (payloads, makeRes) =>
      makeRes @definedCommandsList
  
  define: (name, callback) ->
    if @has name
      idx = @definedCommandsList.lastIndexOf name
      @definedCommandsList[idx] = name
    else
      @definedCommandsList.push name
    
    @definedCommandsMap[name] = callback
    
    @

  get: (name) ->
    @definedCommandsMap[name]

  has: (name) ->
    @definedCommandsMap[name]?

  execute: (names, params) ->
    names = [names] unless names instanceof Array

    rv = null
    for name in names
      command = @get name
      # TODO handle error
      return null unless command?
      rv = params = command.apply params

    rv


root.Command = Command
