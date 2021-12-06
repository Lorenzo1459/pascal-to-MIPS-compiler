%output "parser.c"
%defines "parser.h"

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
%token BEGIN
%token BREAK
%token CASE
%token CONST
%token CONSTRUCTOR
%token CONTINUE
%token DESTRUCTOR
%token DIV
%token DOWNTO
%token ELSE
%token END
%token FILE
%token FOR
%token FUNCTION
%token GOTO 
%token IF
%token IMPLEMENTATION
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
%token OPERATOR%token PACKED
%token PROCEDURE
%token PROGRAM
%token RECORD
%token REINTRODUCE
%token REPEAT
%token SELF
%token SET
%token SHL
%token SHR
%token STRING
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
%token DIV
%token EQ
%token MT
%token LPAR_DOT%token LEFT
%token RIGHT
%token DOT
%token COMMA
%token LPAR
%token RPAR
%token 2DOT
%token EXP
%token AT 
%token LKEY
%token RKEY
%token CIF
%token HASHTAG
%token SEMI