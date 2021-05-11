(*fichier lexeur.mll *)
{
	open Parseur
	exception Eof
	exception TokenInconu
}
rule token = parse
		[' ' '\t' '\n'] 			{ token lexbuf }
		| "//"(_#'\n')*   { token lexbuf }
		| "/*"((_#'*')|('*'+(_#['/' '*'])))*'*'+'/'   { token lexbuf }
		| ';'                      			 { PT_VIRG }
		| ['0'-'9']+('e''-'?['0'-'9']+)? as lexem					{ NOMBRE(float_of_string lexem) }
		| (['0'-'9']+'.'['0'-'9']*|['0'-'9']*'.'['0'-'9']+)('e''-'?['0'-'9']+)?	as lexem		{ NOMBRE(float_of_string lexem) }
		| "True" | "False" as lexem         {  BOOL(bool_of_string (String.lowercase_ascii lexem)) }
		| "=="     { EGAL }
		| ">="      { SUP_EGAL }
		| '!'       { NON }
		| '>'       { SUP }
		| "&&"      { AND }
		| "||"      { OR }
		| '+' 			 			{ PLUS }
		| '-' 						{ MOINS }
		| '*' 						{ FOIS }
		| '/'							{ DIV }
		| '(' 						{ GPAREN }
		| ')'						{ DPAREN }
		| ['a'-'z'](['a'-'z'] | ['A'-'Z'] | '_' | ['0'-'9'])* as lexem  { VAR(lexem) }
		| '='           { AFFECT }
		| "END"         { END }
		| "If"          { IF }
		| '{'           { GACC }
		| '}'           { DACC }
		| "Else"        { ELSE}
		| "Do"          { DO }
		| "While"       { WHILE }
		| eof 					{ EOF }
		| _ 						{ raise TokenInconu }
