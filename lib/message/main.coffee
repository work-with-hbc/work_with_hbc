root = exports ? window


Message =

  # Event callbacks map.
  events: {}

  init: ->
    chrome.runtime.onMessage.addListener (req, sender, makeRes) =>
      {event: event, payloads: payloads} = req

      # TODO handle missing event
      if not @has event
        Logger.error "unable to find handler for event: #{event}"
        return

      Logger.debug "handling event: #{event}"
      handler payloads, makeRes for handler in @events[event]

  has: (event) ->
    @events[event]?

  send: (event, payloads, callback) ->
    message =
      event: event
      payloads: payloads
    chrome.runtime.sendMessage message, callback

  on: (event, action) ->
    if not @has event
      @events[event] = []

    @events[event].push action


root.Message = Message
