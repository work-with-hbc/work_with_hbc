should = require 'should'
{Command: Command} = require '../background_scripts/command/main'

describe 'Command', ->

  beforeEach ->
    Command.reset()

  describe 'define', ->
    it 'should return Command after definine a command', ->
      rv = Command.define 'ping', 'ping command', ->
        -> console.log 'pong'

      rv.should.be.ok
      rv.should.have.property 'define'

  describe 'help', ->
    it 'should return command description', ->
      command = 'ping'
      description = 'ping command'
      Command.define command, description, ->

      (Command.help command).should.be.exactly description

    it 'should return null for unknown command', ->
      should(Command.help 'foobar').not.be.ok

  describe 'list', ->
    it 'should return list of defined commands', ->
      definedCmds = []
      for i in [1..10]
        cmd = "ping#{i}"
        Command.define cmd
        definedCmds.push cmd

      Command.list().should.be.eql definedCmds

  describe 'execute', ->
    it 'should not execute for undefined command', ->
      should(Command.execute 'foobar test').not.ok

    it 'should run expected command', (done) ->
      cmd = 'ping'
      cmdArgs = 'ok'
      
      Command.define cmd, 'ping pong', (args) ->
        (input) ->
          args.should.be.exactly cmdArgs
          should(input).not.be.ok
          
          done()

      Command.execute "#{cmd} #{cmdArgs}"

    it 'should run piped commands', (done) ->
      cmdArgs = 'test'

      Command.define 'ping1', 'ping pong', (args) ->
        (input) ->
          args.should.be.exactly cmdArgs
          should(input).not.be.ok

          cmdArgs

      Command.define 'ping2', 'ping pong', (args) ->
        (input) ->
          console.log 'here'
          should(args).not.be.ok
          input.should.be.exactly cmdArgs

          done()

      Command.execute "ping1 #{cmdArgs} | ping2"
