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

val init_env : env
