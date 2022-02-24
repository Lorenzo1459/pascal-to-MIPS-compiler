
%output "parser.c"          // File name of generated parser.
%defines "parser.h"         // Produces a 'parser.h'
%define parse.error verbose // Give proper messages when a syntax error is found.
%define parse.lac full      // Enable LAC to improve syntax error handling.

%{
#include <stdio.h>
#include <stdlib.h>
#include "types.h"
#include "tables.h"
#include "parser.h"

int yylex(void);
int yylex_destroy(void);
void yyerror(char const *s);

Type check_var();
void new_var(StrStack *p_st);
void guarda_var();
void guarda_var_unica();

Type unify_bin_op(Type l, Type r,
                  const char* op, Type (*unify)(Type,Type));

void check_assign(Type l, Type r);
void check_bool_expr(const char* cmd, Type t);
Type check_logical_op(Type l, Type r, const char* cmd);
Type check_int_div_op(Type l, Type r, const char* cmd);
Type check_not_op(Type l, const char* cmd);
void check_assign_array(Type l, Type r);

extern char *yytext;
extern int yylineno;
extern char id_copy[64];

StrTable *st;
VarTable *vt;
StrStack *stk;
StrStack *stk_unica;

int count = 0;

Type last_decl_type;
%}

%define api.value.type {Type}

%token ABSOLUTE
%token AND
%token ARRAY
%token ASM
%token BEGIN_RW
%token BREAK
%token BOOLEAN
%token CASE
%token CONST
%token CONSTRUCTOR
%token CONTINUE
%token DESTRUCTOR
%token DIV
%token DO
%token DOWNTO
%token ELSE
%token END
%token FILE_W
%token FOR
%token FUNCTION
%token GOTO 
%token IF
%token IMPLEMENTATION
%token IN
%token INHERITED
%token INLINE
%token INTERFACE
%token LABEL
%token MOD
%token NIL
%token NOT
%token OBJECT
%token OF
%token ON
%token OPERATOR
%token OR
%token PACKED
%token PROCEDURE
%token PROGRAM
%token RECORD
%token REINTRODUCE
%token REPEAT
%token SELF
%token SET
%token SHL
%token SHR
%token THEN
%token TO
%token TYPE
%token UNIT
%token UNTIL
%token USES
%token VAR
%token WHILE
%token WITH
%token XOR

%token LOREQ
%token MOREQ
%token ASSIGN
%token PLUSEQ
%token MINUSEQ
%token DIVEQ
%token TIMESEQ
%token LPAR_DOT
%token RPAR_DOT
%token PLUS
%token NOTEQ
%token MINUS
%token TIMES
%token OVER
%token EQ
%token MT
%token LT
%token EXP
%token LEFT
%token RIGHT
%token DOT
%token COMMA
%token LPAR
%token RPAR
%token TWO_DOT
%token AT
%token LKEY
%token RKEY
%token CIF
%token HASHTAG
%token SEMI

%token INTEGER
%token REAL
%token CHAR
%token STRING
%token ID

%token INTEGER_VAL
%token REAL_VAL
%token CHAR_VAL
%token TRUE
%token FALSE
%token STRING_VAL

// Precedence of operators.
// All operators are left associative.
// Higher line number == higher precedence.
%left EQ LT MT
%left PLUS MINUS
%left TIMES OVER

// Start symbol for the grammar.
%start program

%%

program:
  PROGRAM ID SEMI block DOT
;

block:
  block-head block-body
;

sub-block:
  block-head block-body
;

block-head:
  label-declaration constant-declaration type-declaration variable-declaration proc-and-func-declaration
;

block-body:
  compound-statement
;

label-declaration: 
  LABEL name-string-list SEMI
| %empty
;

constant-declaration:
  CONST constant-expression-list
| %empty
;

type-declaration:
  TYPE type-declaration-list
| %empty
;

variable-declaration:
  VAR var-declaration-list
| %empty
;

constant-expression-list:
  constant-expression-list ID EQ constants SEMI
| ID EQ constants SEMI
;

constants:
  INTEGER_VAL    { $$ = INT_TYPE;  }
| REAL_VAL       { $$ = REAL_TYPE; }
| CHAR_VAL       { $$ = STR_TYPE;  }
| TRUE           { $$ = BOOL_TYPE; }
| FALSE          { $$ = BOOL_TYPE; }
| STRING_VAL     { $$ = STR_TYPE;  }
;

type-declaration-list:
  type-declaration-list type-define
| type-define
;

type-define: 
  ID EQ type-declaration-define SEMI
;

type-declaration-define:
  simple-type  
| structured-type  
| recorde-type 
| set-type
;

structured-type:
  ARRAY LEFT simple-type RIGHT OF type-declaration-define { last_decl_type = ARRAY_TYPE;  }
;

recorde-type:
  RECORD record-declaration-list END
;

record-declaration-list:
  record-declaration-list record-declare
| record-declare
;

record-declare:
  name-list TWO_DOT type-declaration-define SEMI
;

set-type:
  SET OF simple-type
;

name-string-list:
  name-list
| string-list-val
;

name-list:
  name-list COMMA ID    {guarda_var();}
| ID                    {guarda_var();}
;


string-list-val:
  string-list-val COMMA INTEGER_VAL
| INTEGER_VAL
;

simple-type:
  INTEGER       { last_decl_type = INT_TYPE;  }
| REAL          { last_decl_type = REAL_TYPE; }
| CHAR          { last_decl_type = STR_TYPE;  }
| STRING        { last_decl_type = STR_TYPE;  }
| BOOLEAN       { last_decl_type = BOOL_TYPE; }
| ID            
| LPAR name-list RPAR
| constants DOT DOT constants
| MINUS constants DOT DOT constants
| MINUS constants DOT DOT MINUS constants
| ID DOT DOT ID
;

var-declaration-list:
  var-declaration-list var-define
| var-define
;

var-define:
  name-list TWO_DOT type-declaration-define {new_var(stk);} SEMI
;

proc-and-func-declaration:
  proc-and-func-declaration function-declaration-list
| proc-and-func-declaration procedure-declaration-list
| function-declaration-list
| procedure-declaration-list
| %empty
;

function-declaration-list:
  function-declare SEMI sub-block SEMI
;

function-declare:
  FUNCTION ID {guarda_var_unica();} parameters TWO_DOT simple-type {new_var(stk_unica);}
;

procedure-declaration-list:
  procedure-declare SEMI sub-block SEMI
;

procedure-declare:
  PROCEDURE ID {guarda_var_unica();} parameters {new_var(stk_unica);}
;

parameters:
  LPAR parameters-declare {new_var(stk);} RPAR
| %empty
;

parameters-declare:
  parameters-declare SEMI parameters-type-declare 
| parameters-type-declare 
;

parameters-type-declare:
  parameters-var-list TWO_DOT simple-type 
;

parameters-var-list:
  VAR name-list 
| name-list 
;

compound-statement:
  BEGIN_RW statement-list END
;

statement-list:
  statement-list  statement SEMI 
| statement SEMI 
;

label-statement:
  assign-statement 
| proc-id-statement
| compound-statement
| if-statement
| repeat-statement
| while-statement
| for-statement
| case-statement
| goto-statement
;

statement:
  label-statement
| INTEGER_VAL TWO_DOT label-statement  
;

assign-statement:
  ID { $1 = check_var(); } ASSIGN expression                        { check_assign($1, $4); }
| ID { $1 = check_var(); } LEFT expression RIGHT ASSIGN expression  { check_assign_array($1, $7); }
| ID { $1 = check_var(); } DOT ID ASSIGN expression
;

proc-id-statement:
  ID
| ID LPAR list-args RPAR
;

if-statement:
  IF expression THEN statement else-statement  { check_bool_expr("if", $2); }
;

else-statement:
  ELSE statement
| %empty
;

repeat-statement:
  REPEAT statement-list UNTIL expression  { check_bool_expr("repeat", $4); }
;

while-statement:
  WHILE expression DO statement
;

for-statement:
  FOR ID ASSIGN expression direction-define expression DO statement
;

direction-define:
  TO
| DOWNTO
;

case-statement:
  CASE expression OF case-declaration-list END
;

case-declaration-list:
  case-declaration-list case-define
| case-define
;

case-define:
  constants TWO_DOT statement SEMI
| ID TWO_DOT statement SEMI
;

goto-statement:
  GOTO INTEGER_VAL
;

expression:
  expression MOREQ expr   { $$ = unify_bin_op($1, $3, ">=", unify_comp); }
| expression MT expr      { $$ = unify_bin_op($1, $3, ">", unify_comp); }
| expression LOREQ expr   { $$ = unify_bin_op($1, $3, "<=", unify_comp); }
| expression LT expr      { $$ = unify_bin_op($1, $3, "<", unify_comp); }
| expression NOTEQ expr   { $$ = unify_bin_op($1, $3, "<>", unify_comp); }
| expression EQ expr      { $$ = unify_bin_op($1, $3, "=", unify_comp); }
| expr
;

expr:
  expr PLUS term          { $$ = unify_bin_op($1, $3, "+", unify_plus); }
| expr MINUS term         { $$ = unify_bin_op($1, $3, "-", unify_other_arith); }
| expr OR term            { $$ = check_logical_op($1, $3, "OR"); }
| expr MOD term           { $$ = check_int_div_op($1, $3, "MOD"); }
| expr DIV term           { $$ = check_int_div_op($1, $3, "DIV"); }
| expr IN term
| term 
;

term:
  term TIMES factor        { $$ = unify_bin_op($1, $3, "*", unify_other_arith); }
| term OVER factor         { $$ = unify_bin_op($1, $3, "/", unify_other_arith); }
| term AND factor          { $$ = check_logical_op($1, $3, "AND"); }
| factor
;

factor:
  ID { $$ = check_var(); }
| ID { $$ = check_var(); } LPAR list-args RPAR 
| constants 
| LPAR expression RPAR  { $$ = $2; }
| NOT factor   {$$ = check_not_op($2, "NOT");}
| ID { $$ = check_var(); }  LEFT expression RIGHT
| ID { $$ = check_var(); }  DOT ID
;

list-args:
  list-args COMMA expression 
| expression 
;


%%

// Primitive error handling.
void yyerror (char const *s) {
    printf("SYNTAX ERROR (%d): %s\n", yylineno, s);
    exit(EXIT_FAILURE);
}

Type check_var() {
    int idx = lookup_var(vt, id_copy);
    if (idx == -1) {
        printf("SEMANTIC ERROR (%d): variable '%s' was not declared.\n",
                yylineno, id_copy);
        exit(EXIT_FAILURE);
    }
    return get_type(vt, idx);
}

void new_var(StrStack *p_st) {
    int idx = lookup_var(vt, yytext);
    if (idx != -1) {
        printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d.\n",
                yylineno, yytext, get_line(vt, idx));
        exit(EXIT_FAILURE);
    }
    
    int cont = 0;
    int i = getSize(p_st);
    char * data;
    while(cont < i){
       data = get_string_stack(p_st, cont);
       add_var(vt, data, yylineno, last_decl_type);
       subSize(p_st);
       cont++;
    }
}

void guarda_var(){
     int idx = lookup_var(vt, id_copy);
     if (idx != -1) {
        printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d.\n",
                yylineno, id_copy, get_line(vt, idx));
        exit(EXIT_FAILURE);
    }
    add_string_stack(stk, id_copy);
}

void guarda_var_unica(){
    int idx = lookup_var(vt, id_copy);
     if (idx != -1) {
        printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d.\n",
                yylineno, id_copy, get_line(vt, idx));
        exit(EXIT_FAILURE);
    }
    add_string_stack(stk_unica, id_copy);
}


// ----------------------------------------------------------------------------

// Type checking and inference.

void type_error(const char* op, Type t1, Type t2) {
    printf("SEMANTIC ERROR (%d): incompatible types for operator '%s', LHS is '%s' and RHS is '%s'.\n",
           yylineno, op, get_text(t1), get_text(t2));
    exit(EXIT_FAILURE);
}

Type unify_bin_op(Type l, Type r,
                  const char* op, Type (*unify)(Type,Type)) {
    Type unif = unify(l, r);
    if (unif == NO_TYPE) {
        type_error(op, l, r);
    }
    return unif;
}

Type check_logical_op(Type l, Type r, const char* cmd) {
    if (l == BOOL_TYPE && r == BOOL_TYPE){
        return BOOL_TYPE;
    }
    printf("SEMANTIC ERROR (%d): logical expression for operator '%s', LHS is '%s' and RHS is '%s'.\n",
           yylineno, cmd, get_text(l), get_text(r));
    exit(EXIT_FAILURE);
}

Type check_not_op(Type l, const char* cmd){
    if (l == BOOL_TYPE){
      return BOOL_TYPE;
    }
    printf("SEMANTIC ERROR (%d): expression '%s', is '%s' instead of '%s'.\n",
           yylineno, cmd, get_text(l), get_text(BOOL_TYPE));
    exit(EXIT_FAILURE);
}

Type check_int_div_op(Type l, Type r, const char* cmd) {
    if (l == INT_TYPE && r == INT_TYPE){
        return INT_TYPE;
    }
    printf("SEMANTIC ERROR (%d): integer division expression for operator '%s', LHS is '%s' and RHS is '%s'.\n",
           yylineno, cmd, get_text(l), get_text(r));
    exit(EXIT_FAILURE);   
}

void check_assign(Type l, Type r) {
    if (l == BOOL_TYPE && r != BOOL_TYPE) type_error(":=", l, r);
    if (l == STR_TYPE  && r != STR_TYPE)  type_error(":=", l, r);
    if (l == INT_TYPE  && r != INT_TYPE)  type_error(":=", l, r);
    if (l == REAL_TYPE && !(r == INT_TYPE || r == REAL_TYPE)) type_error(":=", l, r);
    if (l == ARRAY_TYPE  && r != ARRAY_TYPE)  type_error(":=", l, r);
}

void check_assign_array(Type l, Type r) {
    if (l == ARRAY_TYPE  && r != INT_TYPE) {
        printf("SEMANTIC ERROR (%d): incompatible types for operator ':=', LHS is '%s (int)' and RHS is '%s'.\n",
           yylineno, get_text(l), get_text(r));
        exit(EXIT_FAILURE);
    }
}

void check_bool_expr(const char* cmd, Type t) {
    if (t != BOOL_TYPE) {
        printf("SEMANTIC ERROR (%d): conditional expression in '%s' is '%s' instead of '%s'.\n",
           yylineno, cmd, get_text(t), get_text(BOOL_TYPE));
        exit(EXIT_FAILURE);
    }
}

int main() {
    stk = create_str_stack();
    stk_unica = create_str_stack();
    st = create_str_table();
    vt = create_var_table();

    yyparse();
    printf("PARSE SUCCESSFUL!\n");
    free_str_stack(stk);
    free_str_stack(stk_unica);

    printf("\n\n");
    print_str_table(st); printf("\n\n");
    print_var_table(vt); printf("\n\n");

    free_str_table(st);
    free_var_table(vt);

    yylex_destroy();    // To avoid memory leaks within flex...
    return 0;
}
