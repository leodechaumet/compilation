%{
  open AST
%}

%token <float> NOMBRE
%token <bool> BOOL
%token <string> VAR

%token EGAL SUP_EGAL SUP NON PLUS MOINS FOIS DIV GPAREN DPAREN PT_VIRG VAR AFFECT END IF ELSE EOF
%left EGAL SUP SUP_EGAL
%left PLUS MOINS
%left FOIS DIV
%nonassoc UMOINS
%nonassoc NON

%type <AST.programme_a> main programme
%start main
%%
main:
    programme END                { $1 }
    | programme EOF                    { $1 }
    ;
expression:
    expression EGAL expression      { Egal($1, $3, (get_size_expression $1) + (get_size_expression $3) + 1)}
    | expression SUP expression     { Sup($1, $3, (get_size_expression $1) + (get_size_expression $3) + 1) }
    | expression SUP_EGAL expression { Sup_egal($1, $3, (get_size_expression $1) + (get_size_expression $3) + 1) }
    | expression PLUS expression    { Plus($1, $3, (get_size_expression $1) + (get_size_expression $3) + 1)}
    | expression MOINS expression   { Moins($1,$3, (get_size_expression $1) + (get_size_expression $3) + 1) }
    | expression FOIS expression    { Mult($1,$3, (get_size_expression $1) + (get_size_expression $3) + 1) }
    | expression DIV expression     { Div($1, $3, (get_size_expression $1) + (get_size_expression $3) + 1) }
    | GPAREN expression DPAREN      { $2 }
    | MOINS expression %prec UMOINS { Neg ($2, (get_size_expression $2) + 1) }
    | VAR PLUS PLUS                 { Incr $1 }
    | NON expression                { Non ($2, (get_size_expression $2) + 1) }
    | NOMBRE                        { Num $1 }
    | BOOL                          { Bool $1 }
    | VAR                           { Var $1 }
    ;
commande:
    VAR AFFECT expression PT_VIRG   { Affect($1, $3, (get_size_expression $3) + 1)}
    | IF GPAREN expression DPAREN commande ELSE commande { Ifelse($3, $5, $7, (get_size_expression $3)+(get_size_commande $5) + (get_size_commande $7)+2) }
    | expression PT_VIRG            { Cexpression ($1, (get_size_expression $1)) }
    ;
programme:
    commande programme              { NoeudProgramme($1, $2) }
    | commande                      { Pcommande $1 }
    ;
