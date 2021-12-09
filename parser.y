
%output "parser.c"          // File name of generated parser.
%defines "parser.h"         // Produces a 'parser.h'
%define parse.error verbose // Give proper messages when a syntax error is found.
%define parse.lac full      // Enable LAC to improve syntax error handling.

%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.h"

int yylex(void);
int yylex_destroy(void);
void yyerror(char const *s);

extern char *yytext;
extern int yylineno;
%}


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
//%left EQ LT
//%left PLUS MINUS
//%left TIMES OVER

// Start symbol for the grammar.
%start program

%%

program:
  PROGRAM ID SEMI block DOT
;

block:
  block-head block-body
;

block-head:
  label-declaration constant-declaration type-declaration variable-declaration proc-and-func-declaration
;

block-body:
  BEGIN_RW statement-list END
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
  ID EQ type-declaration-define SEMI
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
  name-list COMMA ID
| ID
;


string-list-val:
  string-list-val COMMA INTEGER_VAL
| INTEGER_VAL
;

simple-type:
  INTEGER
| REAL
| CHAR
| STRING
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
  name-list TWO_DOT type-declaration-define SEMI
;

proc-and-func-declaration:
  proc-and-func-declaration function-declaration-list
| proc-and-func-declaration procedure-declaration-list
| function-declaration-list
| procedure-declaration-list
| %empty
;

function-declaration-list:
  function-declare SEMI block SEMI
;

function-declare:
  FUNCTION ID parameters TWO_DOT simple-type
;

procedure-declaration-list:
  procedure-declare SEMI block SEMI
;

procedure-declare:
  PROCEDURE ID parameters
;

parameters:
  LPAR parameters-declare RPAR
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

statement-list:
  statement-list statement SEMI
| statement SEMI
;

statement:
  INTEGER_VAL TWO_DOT label-statement
| label-statement
;

label-statement:
  assign-statement
| proc-id-statement
| BEGIN_RW statement-list END
| if-statement
| repeat-statement
| while-statement
| for-statement
| case-statement
| goto-statement
;

assign-statement:
  ID ASSIGN expression
| ID LEFT expression RIGHT ASSIGN expression
| ID DOT ID ASSIGN expression
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
  DOWNTO
| TO
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
  ID
| ID LPAR list-args RPAR
| constants
| LPAR expression RPAR
| NOT factor
| MINUS factor
| ID LEFT expression RIGHT
| ID DOT ID
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

int main() {
    yyparse();
    printf("PARSE SUCCESSFUL!\n");
    yylex_destroy();    // To avoid memory leaks within flex...
    return 0;
}
