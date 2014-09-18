root = exports ? window

Message.init()
Command.init()


Command.define 'ping', ->
  console.log 'pong'
