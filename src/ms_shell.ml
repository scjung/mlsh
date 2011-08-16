open Batteries_uni

module Interpreter = Ms_interpreter
module Runtime     = Ms_runtime

let rec loop env =
  print_string env.Runtime.prompt;
  flush stdout;
  let l = read_line () in
  let script = Ms_parser.parse Ms_lexer.token (Lexing.from_string l) in
  loop (Interpreter.execute env script)

let start () =
  loop Runtime.init_env
