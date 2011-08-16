open Batteries_uni

module Interpreter = Ms_interpreter
module Runtime     = Ms_runtime
module Shell       = Ms_shell

let usage () =
  prerr_endline ("usage: " ^ Filename.basename Sys.argv.(0) ^ " [script] [arg ...]")

let parse inp =
  Ms_parser.parse Ms_lexer.token (Lexing.from_input inp)

let execute script =
  let _ =
    Interpreter.execute
      Runtime.init_env
      script
  in
  ()

let _ =
  if Array.length Sys.argv = 1 then
    Shell.start ()
  else
    let inp = File.open_in Sys.argv.(1) in
    let ast = parse inp in
    execute ast
