open Batteries_uni
open Ms_ast

type value =
  | Int of int

type env = {
  vars : (string * value) list;
  last_result : value
}

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
  | Unix.WEXITED n  -> { env with last_result = Int n }
  | Unix.WSIGNALED _-> failwith "todo: WSIGNALED"
  | Unix.WSTOPPED _ -> failwith "todo: WSTOPPED"

let exec_expr env e =
  match e with
  | Fcall (s, params) -> exec_fcall env s params

let execute es =
  let _ =
    List.fold_left exec_expr { vars = []; last_result = Int 0 } es
  in
  ()

