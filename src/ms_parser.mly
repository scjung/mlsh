/*
(*
*)
*/

%{
  open Ms_ast
%}

%token NEWLINE LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE
%token IF FOR WHILE
%token EOF

%token <string> WORD
%token <string> DQUOTED_STRING

%start parse
%type <(Ms_ast.script)> parse
%%

parse:
  EOF        { [] }
| lines EOF  { $1 }
;

lines:
  line                { [$1] }
| line NEWLINE        { [$1] }
| line NEWLINE lines  { $1 :: $3 }
;

line:
  expr { $1 }
;

expr:
  WORD         { Fcall ($1, []) }
| WORD params  { Fcall ($1, $2) }
;

params:
  WORD         { [$1] }
| WORD params  { $1 :: $2 }
;
