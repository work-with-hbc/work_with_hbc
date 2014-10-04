# # Logger
#
# Log all executed command to annie.

root = exports ? window

CommandLogger =

  isSetup: false
  commandRecordsKey: 'work-with-hbc-commands-history'

  init: (command) ->
    Message.on command.executeCommandRequest, (input, makeRes) =>
      @log input

  log: (input) ->
    if not @isSetup
      @setup()
    
    record =
      command: input
      time: (new Date).toString()

    Annie.thing.pushThingToList @commandRecordsKey, record, (id) ->
      Logger.debug 'commands history synced'

  setup: ->
    createRecords = @createRecords.bind @
    Annie.thing.getList @commandRecordsKey, createRecords, createRecords
    @isSetup = true

  createRecords: (value) ->
    return if value?

    created = -> Logger.debug 'commands history created'
    failed = -> Logger.error 'commands history create failed'
    Annie.thing.storeListWithId @commandRecordsKey, [], created, failed


root.CommandLogger = CommandLogger
