root = exports ? window

# ## Components Setup

Annie.init()
Alarm.init()
Notification.init()
Message.init()
Command.init()


# ## Commands

# ping: ping pong
#
# -> ping pong
Command.define 'ping', 'you said ping I said pong', (args) -> (input) ->
  msg = [input, args].filter (x) -> x? and x != ''

  if msg.length == 0
    msg = 'pong'
  else
    msg = msg.join ' '
  
  Logger.info msg
  
  msg


# alarm: set an alarm.
#
# -> alarm 4 hours
Command.define 'alarm', 'notify me after some moments', (time) ->
  (input) ->
    console.log time
    Alarm.set time, ->
      Notification.make 'Time is up!'
    
    'Alarm scheduled!'
