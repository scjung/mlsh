open Batteries_uni

let usage () =
  prerr_endline ("usage: " ^ Filename.basename Sys.argv.(0) ^ " <script> [arg ...]")

let parse inp =
  Ms_parser.parse Ms_lexer.token (Lexing.from_input inp)

let execute ast =
  Ms_interpreter.execute ast

let _ =
  if Array.length Sys.argv < 2 then (usage (); exit 1);
  let inp = File.open_in Sys.argv.(1) in
  let ast = parse inp in
  execute ast

