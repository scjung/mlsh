type intl_func = {
  i_func : env -> value list -> env
}

and func =
  | Intl_func of intl_func

and value =
  | Int of int

and env = {
  prompt : string;
  funcs : (string * func) list;
  vars : (string * value) list;
  last_result : value
}

let intl_funcs = [
  ("exit", Intl_func {
    i_func = (fun env vs ->
      match env.last_result with
      | Int n -> exit n
    )
   })
]

let init_env = {
  prompt = "$ ";
  vars = [];
  last_result = Int 0;
  funcs = intl_funcs
}
