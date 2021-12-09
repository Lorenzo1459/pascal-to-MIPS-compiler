
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
  label-declaration constant-declaration type-declaration variable-declaration proc-and-func-declaration
;

label-declaration: 

;

constant-declaration:
  CONST constant-expression-list
|
;

type-declaration:
  TYPE type-declaration-list
| 
;

variable-declaration:

;

proc-and-func-declaration:

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

name-list:
  name-list COMMA ID
| ID
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
