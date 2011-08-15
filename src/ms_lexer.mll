{

open Batteries_uni
open Ms_parser

let error msg = prerr_endline msg; exit 1

(*********************************************************************)
(* keyword *)

let keyword_table =
  let keywords = [
    ("if",    IF);
    ("for",   FOR);
    ("while", WHILE);
  ] in
  let tbl = Hashtbl.create (List.length keywords) in
  List.iter (fun (k, t) -> Hashtbl.add tbl k t) keywords;
  tbl

let find_keyword = Hashtbl.find keyword_table


(*********************************************************************)
(* string buffer *)

let buf = Buffer.create 256

let clear_buf () = Buffer.clear buf

let buf_contents () = Buffer.contents buf

let add_char_to_buf = Buffer.add_char buf

}

let blank    = [' ' '\008' '\009' '\011' '\013']
let newline   = '\010'

let word = [^' ' '\008' '\009' '\011' '\013' '\010']+

(*********************************************************************)
(* rules *)

rule token = parse
    blank+      { token lexbuf }
  | newline     { NEWLINE }

  | "("  { LPAREN }
  | ")"  { RPAREN }
  | "["  { LBRACK }
  | "]"  { RBRACK }
  | "{"  { LBRACE }
  | "}"  { RBRACE }

  | "#"  { comment lexbuf }

  | "\"" {
      clear_buf ();
      string lexbuf;
      let s = buf_contents () in
      DQUOTED_STRING s
    }

  | word {
      let s = Lexing.lexeme lexbuf in
      try
        let token = find_keyword s in
        token
      with
      | Not_found -> WORD s
    }

  | eof { EOF }

  | _ {
      let s = Lexing.lexeme lexbuf in
      error ("Illegal character:" ^ s)
    }

and comment = parse
    newline    { token lexbuf }
  | _          { comment lexbuf }
  | eof        { EOF }

and string = parse
    "\\\"" {
      add_char_to_buf '\\'; add_char_to_buf '"';
      string lexbuf
    }
  | '"'    { () }
  | '\n'   { error ("Illegal character: '\\n' in string")}
  | eof    { error ("Unterminated string") }
  | "\\\\" {
      add_char_to_buf '\\';
      string lexbuf
    }
  | _ as c {
      add_char_to_buf c;
      string lexbuf
    }
