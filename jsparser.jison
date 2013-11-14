%lex
%%

\s+                   /* skip whitespace */
"int"                 return 'int'
"float"               return 'float'
"continue"                 return 'continue'
"return"               return 'return'
[a-zA-Z_][0-9a-zA-Z_]* return 'ID'
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
","                   return ','
"*"                   return '*'
"=="                  return '=='
"!="                  return '!='
">="                  return '>='
"<="                  return '<='
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
    : fun_def* EOF
    ;

fun_def
    : type_expression ID '(' ')' compound_statement
    ;

params
    : (type_expression ID ',')+ type_expression ID
    ;

statement
    : ';'
    | 'continue' ';'
    | 'break' ';'
    | 'return' expr ';'
    | compound_statement
    | if_statement
    | while_statement
    | expression ';'
    ;

compound_statement
    : '{' var_decl* statement* '}'
    ;

var_decl
    : type_expression ID ';'
    ;

type_expression
    : 'int'
    | 'float'
    ;

if_statemnt
    : if '(' expression ')' statement ( else statement )?
    ;

while_statement
    : while '(' expression ')' statement
    ;

/** ---------------------------------- */

expr
    : ID '=' eq_expr
    ;

eq_expr
    : expr ('==' | '!=') expr
    | expr ('<' | '>' | '<=' | '>=') expr
    | expr ( '+' | '-' ) expr
    | expr ('*' | '/' | '%') expr
    | NUMBER
    | ID ( '(' argument_expression_list ')' )?
    | ('+' | '-' | '!') expr
    ; 

argument_expression_list
    : expr ( ',' expr )*
    ;
