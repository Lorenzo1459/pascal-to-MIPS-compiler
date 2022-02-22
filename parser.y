
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
  INTEGER_VAL  
| REAL_VAL
| CHAR_VAL
| STRING_VAL
;

type-declaration-list:
  type-declaration-list type-define
| type-define
;

type-define: 
  ID {printf("%s\n", id_copy);} EQ type-declaration-define SEMI
;

type-declaration-define:
  simple-type  
| structured-type  
| recorde-type 
| set-type
;

structured-type:
  ARRAY LEFT simple-type RIGHT OF type-declaration-define
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
  name-list COMMA ID    {printf("NameList: %s\n", id_copy);guarda_var();}
| ID                    {printf("NameList: %s\n", id_copy);guarda_var();}
;


string-list-val:
  string-list-val COMMA INTEGER_VAL
| INTEGER_VAL
;

simple-type:
  INTEGER       { last_decl_type = INT_TYPE;  }
| REAL          { last_decl_type = REAL_TYPE; }
| CHAR          { last_decl_type = CHAR_TYPE; }
| STRING        { last_decl_type = STR_TYPE;  }   
| ID            { last_decl_type = INT_TYPE;  }
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
  ID {check_var();} ASSIGN expression
| ID {check_var();}  LEFT expression RIGHT ASSIGN expression
| ID {check_var();} DOT ID ASSIGN expression
;

proc-id-statement:
  ID
| ID LPAR list-args RPAR
;

if-statement:
  IF expression THEN statement else-statement
;

else-statement:
  ELSE statement
| %empty
;

repeat-statement:
  REPEAT statement-list UNTIL expression
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
  expression MOREQ expr
| expression MT expr
| expression LOREQ expr
| expression LT expr
| expression NOTEQ expr
| expression EQ expr
| expr
;

expr:
  expr PLUS term
| expr MINUS term
| expr OR term
| expr MOD term
| expr DIV term
| expr IN term
| term 
;

term:
  term TIMES factor
| term OVER factor
| term AND factor
| factor
;

factor:
  ID {check_var();}
| ID {check_var();} LPAR list-args RPAR
| constants 
| LPAR expression RPAR
| NOT factor
| MINUS factor
| ID {check_var();}  LEFT expression RIGHT
| ID {check_var();}  DOT ID
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

void check_assign(Type l, Type r) {
    if (l == CHAR_TYPE && r != CHAR_TYPE) type_error(":=", l, r);
    if (l == STR_TYPE  && r != STR_TYPE)  type_error(":=", l, r);
    if (l == INT_TYPE  && r != INT_TYPE)  type_error(":=", l, r);
    if (l == REAL_TYPE && !(r == INT_TYPE || r == REAL_TYPE)) type_error(":=", l, r);
}

void check_bool_expr(const char* cmd, Type t) {
    if (t != CHAR_TYPE) {
        printf("SEMANTIC ERROR (%d): conditional expression in '%s' is '%s' instead of '%s'.\n",
           yylineno, cmd, get_text(t), get_text(CHAR_TYPE));
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

    printf("\n\n");
    print_str_table(st); printf("\n\n");
    print_var_table(vt); printf("\n\n");

    free_str_table(st);
    free_var_table(vt);

    yylex_destroy();    // To avoid memory leaks within flex...
    return 0;
}
