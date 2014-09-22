root = exports ? window

Logger =

  # Emit a log message.
  emit: (category, message) ->
    emitter = @getEmitter category

    emitter "[#{(new Date).toString()}][#{category}] #{message}"

  # Get log emitter from category.
  # TODO should output log file information in output.
  getEmitter: (category) ->
    switch category
      when 'debug' then console.trace.bind console
      when 'error' then console.trace.bind console
      else console.log.bind console

  debug: (message) ->
    @emit 'debug', message

  info: (message) ->
    @emit 'info', message

  error: (message) ->
    @emit 'error', message


root.Logger = Logger
