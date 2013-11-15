/** utf-8 */

%lex
%%

\s+                   /* skip whitespace */
"「"                 return "「"
"」"                 return "」"
"という関数"                 return "という関数"
"を定義する"                 return "を定義する"
"を定義して、"                 return "を定義して、"
"を引数に取り"                 return "を引数に取り"
"を返す"                 return "を返す"
"に代入"                 return "に代入"
"して、"                 return "して、"
"する"                 return "する"
"を"                 return "を"

"整数"               return '整数'
"int"                 return 'int'
"実数"               return '実数'
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
[^\+\-\*\/\>\<\^\!\%\(\)\{\};「」a-zA-Z0-9]+                     return 'ID'

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
    | compound_statement 'という関数' '「' ID '」' 'を定義する'
    | compound_statement 'という関数' '「' ID '」' 'を定義して、' fun_def
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
    | expr 'を返す'  
    | compound_statement 
    | if_statement        
    | while_statement 
    | expr ';'
    | expr 'して、'
    | expr 'する'
    ;

statements
    : /* empty */
    | statement statements
    | statement 'して、' statements
    ;

compound_statement
    : '{' var_decls statements '}'
    | '「' params 'を引数に取り' var_decls statements '」'
    | '「' var_decls statements '」'
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
    | '整数'
    | '実数'
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
    | eq_expr 'を' expr 'に代入'
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
