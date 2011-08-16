type value =
  | Int of int

type t = {
  prompt : string;
  vars : (string * value) list;
  last_result : value
}
