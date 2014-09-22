child_process = require "child_process"

spawn = (procName, opts, silent=false) ->
  proc = child_process.spawn procName, opts
  unless silent
    proc.stdout.on 'data', (data) -> process.stdout.write data
    proc.stderr.on 'data', (data) -> process.stderr.write data
  proc

task 'build', 'compile all coffeescript files to javascript', ->
  coffee = spawn 'coffee', ['-c', __dirname]
  coffee.on 'exit', (returnCode) -> process.exit returnCode

task 'autobuild', 'continually rebuild coffescript files', ->
  coffee = spawn 'coffee', ['-cw', __dirname]

task 'test', 'run test with mocha', ->
  mocha = spawn './node_modules/mocha/bin/mocha'
