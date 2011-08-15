type expr =
  | Fcall of string * string list

type script = expr list
