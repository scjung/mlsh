open Batteries_uni

module Interpreter = Ms_interpreter
module Env         = Ms_env

let rec loop env =
  print_string env.Env.prompt;
  flush stdout;
  let l = read_line () in
  let script = Ms_parser.parse Ms_lexer.token (Lexing.from_string l) in
  loop (Interpreter.execute env script)

let start () =
  loop Env.({ prompt = "$ "; vars = []; last_result = Int 0 })
