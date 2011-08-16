open Batteries_uni
open Ms_ast

module Env = Ms_env

let exec_command s params =
  match Unix.fork () with
  | 0 ->
      Unix.handle_unix_error
        (fun () -> Unix.execvp s (Array.of_list (s :: params)))
        ()

  | pid -> snd (Unix.waitpid [] pid)

let exec_fcall env s params =
  let status = exec_command s params in
  match status with
  | Unix.WEXITED n  -> Env.({ env with last_result = Int n })
  | Unix.WSIGNALED _-> failwith "todo: WSIGNALED"
  | Unix.WSTOPPED _ -> failwith "todo: WSTOPPED"

let exec_expr env e =
  match e with
  | Fcall (s, params) -> exec_fcall env s params

let execute env es =
  List.fold_left exec_expr env es
