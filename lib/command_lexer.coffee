# # Command Lexer
#
# Lexer for command input.
#
# It will lex the input likes:
#
#   ping 'foobar' | reverse
#
# into:
#
# ```
# [
#   {
#     "cmd": "ping",
#     "args": "foobar"
#   },
#   {
#     "cmd": "reverse",
#     "args": null
#   }
# ]
# ```

root = exports ? window


CommandLexer =

  pipeSeparator: '|'

  lex: (input) ->
    commands = (input.trim().split @pipeSeparator).filter (i) -> i?

    @lexCommand command for command in commands

  lexCommand: (command) ->
    command = command.trim().split /[ \t]+/
    cmd = command.shift()
    args = command.join ' '

    lexed =
      cmd: cmd
      args: args


root.CommandLexer = CommandLexer
