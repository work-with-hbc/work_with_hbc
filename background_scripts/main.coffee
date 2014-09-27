root = exports ? window

# Components Setup

Annie.init()
Alarm.init()
Notification.init()
Message.init()
Command.init()


# Commands

Command.define 'ping', ->
  Logger.info 'pong'


# set: pass params to next command.
#
# -> set alarm 5 minutes
# -> set (5 mintes) alaram
# -> alarm (5 minutes)
Command.define 'set', (params) -> params


# alarm: set an alarm.
#
# -> alarm 4 hours
Command.define 'alarm', (time) ->
  Alarm.set time, ->
    Notification.make 'Time is up!'
