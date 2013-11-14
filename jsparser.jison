%lex
%%

\s+                   /* skip whitespace */
"int"                 return 'int'
"float"               return 'float'
"continue"                 return 'continue'
"return"               return 'return'
"if"                 return 'if'
"else"                 return 'else'
"elsif"                 return 'elseif'
"while"               return 'while'
"for"                 return 'for'
"break"                 return 'break'
"continue"                 return 'continue'
[a-zA-Z_][0-9a-zA-Z_]* return 'ID'
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
","                   return ','
"*"                   return '*'
"=="                  return '=='
"!="                  return '!='
">="                  return '>='
"<="                  return '<='
"="                  return '='
">"                  return '>'
"<"                  return '<'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"!"                   return '!'
"%"                   return '%'
"("                   return '('
")"                   return ')'
"{"                   return '{'
"}"                   return '}'
";"                   return ';'
"PI"                  return 'PI'
"E"                   return 'E'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */


%left '==' '!='
%left '<' '>' '<=' '>='
%left '+' '-'
%left '*' '/' '%'
%left '^'
%left UMINUS UPLUS

%start program

%% /* language grammar */

program
    : fun_defs EOF
    ;

fun_defs
    : /* empty */
    | fun_def fun_defs;

fun_def
    : type_expression ID '(' ')' compound_statement {$$ = new Fundef($1, $2, $3, $4)}
    | type_expression ID '(' params ')' compound_statement {$$ = new Fundef($1, $2, $3, $4)}
    ;

params
    : param 
    | params ',' param;

param
    : type_expression ID
    ;

statement
    : ';'
    | 'continue' ';'     
    | 'break' ';'         
    | 'return' expr ';'  
    | compound_statement 
    | if_statement        
    | while_statement 
    | expr ';'
    ;

statements
    : /* empty */
    | statement statements
    ;

compound_statement
    : '{' var_decls statements '}'
    ;

var_decls
    : /* empty */
    | var_decl var_decls
    ;

var_decl
    : type_expression ID ';'
    ;

type_expression
    : 'int'
    | 'float'
    ;

if_statement
    : if '(' expr ')' statement elseifs 'else' statement 
    ;

elseifs
    : /* empty */
    | elseif  '(' expr ')'  statement elseifs
    ; 

while_statement
    : while '(' expr ')' statement
    ;

/** ---------------------------------- */

expr
    : eq_expr '=' expr
    | eq_expr
    ;

eq_expr
    : rel_expr (eq_opr) eq_expr
    | rel_expr
    ;
eq_opr : '==' | '!=' ;

rel_expr
    : add_expr rel_opr rel_expr
    | add_expr
    ;

rel_opr : '<' | '>' | '<=' | '>=';

add_expr
    : mul_expr add_opr add_expr
    | mul_expr
    ;

add_opr : '+' | '-';

mul_expr
    : unary_expr mul_opr mul_expr
    | unary_expr
    ;

mul_opr : '*' | '/' | '%';

unary_expr
    : NUMBER
    | '(' expr ')'
    | ID
    | ID '('  ')'
    | ID '(' argument_expression_list ')'
    | unary_opr unary_expr
    ; 

unary_opr: '+' | '-' | '!';

argument_expression_list
    : expr
    | expr ',' argument_expression_list
    ;
