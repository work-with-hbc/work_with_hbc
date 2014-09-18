root = exports ? window


Message =

  # Event callbacks map.
  events: {}

  init: ->
    chrome.runtime.onMessage.addListener (req, sender, makeRes) =>
      {event: event, payloads: payloads} = req

      # TODO handle missing event
      if not @events[event]?
        console.log "Unable to find handler for event: #{event}"
        return

      console.debug "Handling event: #{event}"
      @events[event] payloads, makeRes

  send: (event, payloads, callback) ->
    message =
      event: event
      payloads: payloads
    chrome.runtime.sendMessage message, callback

  on: (event, action) ->
    @events[event] = action


root.Message = Message