root = exports ? window

Alarm =

  # Alarm name prefix.
  namePrefix: 'work_with_hbc_alarm_'

  # Alarm callback.
  callbacks: {}
  
  init: ->
    @clearCallbacks()
    
    chrome.alarms.onAlarm.addListener (alarm) =>
      console.debug "alarm wake up: #{alarm.name}"
      @executeCallback alarm.name

  set: (after, callback) ->
    alarmName = @generateName()
    alarmInfo =
      # Datetime to ms.
      when: (Date.parse after).getTime()

    Date.parse after - Date.parse 'now'
    @setCallback alarmName, callback
    
    chrome.alarms.create alarmName, alarmInfo

  clearCallbacks: -> @callbacks = {}

  setCallback: (name, callback) ->
    @callbacks[name] = callback

  executeCallback: (name) ->
    return unless @callbacks[name]?

    @callbacks[name]()

  generateName: ->
    "#{@namePrefix}#{Date.now()}"


root.Alarm = Alarm
