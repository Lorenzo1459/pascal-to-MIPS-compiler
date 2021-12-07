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
%token DO
%token DOWNTO
%token ELSE
%token END
%token FILE
%token FOR
%token FUNCTION
%token GOTO 
%token IF
%token IMPLEMENTATION
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

%token INT 
%token REAL
%token BOOL 
%token STRING 

%token LOREQ
%token MOREQ
%token ASSIGN
%token PLUSEQ
%token MINUSEQ
%token DIVEQ
%token TIMESEQ
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
%token TW0_DOT
%token LKEY
%token RKEY
%token SEMI

%token <bool_type> BOOL
%token <int_type> INT
%token <float_type> REAL 
%token <id_type> ID 
%token <str_type> STR 


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

%start program

%%

program:
    PROGRAM ID PROGRAM_HEADING SEMI block
;

PROGRAM_HEADING:
    LPAR ID_LIST SEMI RPAR
;

ID_LIST:
    ID
|    ID_LIST COMMA ID
;

block:
    block1
|    label_declaration SEMI block1
;

block1:
    block2
|    constant_declaration SEMI block2
;

block2:
    block3
|   type_declaration SEMI block3
;

block3:
    block4
|   variable_declaration SEMI block4
;

block4:
    block5
|   proc_and_func_declaration SEMI block5
;

block5:
    begin statement_list END
;

label_declaration:
    LABEL UNSIGNED_INT
|    label_declaration COMMA UNSIGNED_INT
;

constant_declaration:
    CONST ID EQ CONST
|   constant_declaration SEMI ID EQ CONST
;

type_declaration:
    TYPE ID EQ TYPE
|   type_declaration SEMI ID EQ TYPE
;

variable_declaration:
    VAR variable_id_list EQ TYPE
|   variable_declaration SEMI variable_id_list EQ TYPE
;

variable_id_list:
    ID
|   variable_id_list COMMA ID
;

constant:
    INT
|   REAL
|   STRING
|   constid
|   PLUS constid
;

type:
    simple_type
|   structured_type
|   EXP typeid
;

simple_type:
    LPAR ID_LIST LPAR
|   CONST ... CONST
|   typeid
;

structured_type;
    ARRAY LEFT index_list RIGHT OF TYPE
|   RECORD field_list END
|   SET OF simple_type
|   FILE OF TYPE
|   PACKED structured_type
;

index_list:
    simple_type
|   index_list COMMA simple_type
;

field_list:
    fixed_part
|   fixed_part SEMI variant_part
|   variant_part
;

fixed_part:
    record_field
|   fixed_part SEMI record_field
;

record_field:
    empty
|   fieldid_list TW0_DOT TYPE
;

fieldid_list:
    ID
|   fieldid_list COMMA ID
;

variant_part:
    CASE tag_field OF variant_list
;

tag_field:
    typeid 
|   ID TW0_DOT typeid
;

variant_list:
    variant
|   variant_list SEMI variant
;

variant:
    empty
|   case_label_list TW0_DOT LPAR field_list RPAR
;

case_label_list:
    CONST
|   case_label_list COMMA CONST
;

proc_and_func_declaration:
    proc_or_func
|   proc_and_func_declaration SEMI proc_or_func
;

proc_or_func:
    PROCEDURE ID parameters SEMI block_or_forward
|   FUNCTION ID parameters TW0_DOT typeid SEMI block_or_forward
;

block_or_forward:
    block
|   forward
;

parameters:
    LPAR formal_parameter_list RPAR
;

formal_parameter_list:
    formal_parameter_section
|   formal_parameter_list SEMI formal_parameter_section
;

formal_parameter_section:
    parameterid_list TW0_DOT typeid
|   VAR parameterid_list TW0_DOT typeid
|   PROCEDURE id parameters
|   FUNCTION ID parameters TW0_DOT typeid
;

parameterid_list:
    ID
|   parameterid_list SEMI statement
;

statement:
    empty
|   VAR ASSIGN expression
|   BEGIN statement_list END
|   IF expression THEN statement
|   IF expression THEN statement ELSE statement
|   CASE expression OF case_list END
|   WHILE expression DO statement
|   REPEAT statement_list UNTIL expression
|   FOR varid ASSIGN for_list DO statement
|   procid
|   procid LPAR expression_list RPAR
|   GOTO LABEL
|   WITH record_variable_list DO statement
|   LABEL statement
;

variable:
    ID
|   variable LEFT subscript_list RIGHT
|   variable DOT fieldid
|   variable EXP
;

subscript_list:
    expression
|   subscript_list COMMA expression
;

case_list:
    case_label_list TW0_DOT statement
|   case_list SEMI case_label_list TW0_DOT statement
;

for_list:
    expression TO expression
|   expression DOWNTO expression
;

expression_list:
    expression
|   expression_list COMMA expression
;

label:
    UNSIGNED_INT
;

record_variable_list:
    VAR
|   record_variable_list COMMA VAR
;  

expression:
    expression relational_op additive_expression
|   additive_expression
;

relational_op:
    LT LOREQ EQ MOREQ MT
;

additive_expression:
    additive_expression additive_op multiplicative_expression
|   multiplicative_expression
;

additive_op:
    PLUS MINUS OR
;

multiplicative_expression:
    multiplicative_expression multiplicative_op unary_expression
|   unary_expression
;

multiplicative_op:
    TIMES OVER DIV MOD AND
;

unary_expression:
    unary_op unary_expression
|   primary_expression
;

unary_op:
    PLUS MINUS NOT
;

primary_expression:
    VAR
|   UNSIGNED_INT
|   UNSIGNED_REAL   
|   STRING
|   NIL
|   funcid LPAR expression_list RPAR
|   LEFT element_list RIGHT
|   LPAR expression RPAR
;

element_list:
    empty
|   element
|   element_list COMMA element
;

element:
    expression
|   expression ... expression
;

constid:
    ID
;

typeid:
    ID
;

funcid:
    ID
;

fieldid:
    ID
;

varid:
    ID
;

empty:
;

%%