
%output "parser.c"          // File name of generated parser.
%defines "parser.h"         // Produces a 'parser.h'
%define parse.error verbose // Give proper messages when a syntax error is found.
%define parse.lac full      // Enable LAC to improve syntax error handling.

%{
#include <stdio.h>
#include <stdlib.h>
#include "types.h"
#include "tables.h"
#include "ast.h"
#include "parser.h"

int yylex(void);
int yylex_destroy(void);
void yyerror(char const *s);

AST* check_var();
AST* new_var(StrStack *p_st);
void guarda_var();
void guarda_var_unica();

AST* unify_bin_node(AST* l, AST* r,
                    NodeKind kind, const char* op, Unif (*unify)(Type,Type));

AST* check_assign(AST *l, AST *r);
AST* check_if_then(AST *e, AST *b);
AST* check_if_then_else(AST *e, AST *b1, AST *b2);
AST* check_repeat(AST *b, AST *e);

void check_bool_expr(const char* cmd, Type t);
AST* check_logical_op(AST*  l, AST*  r, NodeKind kind, const char* cmd);
AST* check_int_div_op(AST*  l, AST*  r, NodeKind kind, const char* cmd);
AST* check_not_op(AST* l, NodeKind kind, const char* cmd);
void check_assign_array(AST* l, AST* r);

extern char *yytext;
extern int yylineno;
extern char id_copy[64];

StrTable *st;
VarTable *vt;
StrStack *stk;
StrStack *stk_unica;

//int count = 0;

Type last_decl_type;
AST *root;
%}

%define api.value.type {AST*}

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
  PROGRAM ID SEMI block DOT  //{ root = new_subtree(PROGRAM_NODE, NO_TYPE, 1, $3); }
;

block:
  block-head block-body      { root = new_subtree(PROGRAM_NODE, NO_TYPE, 2, $1, $2); }
;

sub-block:
  block-head block-body      { $$ = new_subtree(BLOCK_NODE, NO_TYPE, 2, $1, $2); }
;

block-head:
  label-declaration 
  constant-declaration 
  type-declaration 
  variable-declaration 
  proc-and-func-declaration   { $$ = new_subtree(BLOCK_HEAD_NODE, NO_TYPE, 5, $1, $2, $3, $4, $5); }
;

block-body:
  compound-statement          { $$ = $1;}
;

label-declaration: 
  LABEL name-string-list SEMI     { $$ = $2;}
| %empty                          { $$ = new_subtree(LABEL_LIST_NODE, NO_TYPE, 0); }
;

constant-declaration:
  CONST constant-expression-list  { $$ = $2;}
| %empty                          { $$ = new_subtree(CONST_LIST_NODE, NO_TYPE, 0); }
;

type-declaration:
  TYPE type-declaration-list      { $$ = $2;}
| %empty                          { $$ = new_subtree(TYPE_LIST_NODE, NO_TYPE, 0); }
;

variable-declaration:
  VAR var-declaration-list        { $$ = $2; }
| %empty                          { $$ = new_subtree(VAR_LIST_NODE, NO_TYPE, 0); }
;

constant-expression-list:
  constant-expression-list ID EQ constants SEMI   { $$ = new_subtree(CONST_LIST_NODE, NO_TYPE, 2, $1, $4); }
| ID EQ constants SEMI                            { $$ = $3; }
;

constants:
  INTEGER_VAL    { $$ = $1; }
| REAL_VAL       { $$ = $1; }
| CHAR_VAL       { $$ = $1; }
| TRUE           { $$ = $1; }
| FALSE          { $$ = $1; }
| STRING_VAL     { $$ = $1; }
;

type-declaration-list:
  type-declaration-list type-define   { add_child($1, $2); $$ = $1; }
| type-define                         { $$ = new_subtree(TYPE_LIST_NODE, NO_TYPE, 1, $1); }
;

type-define: 
  ID EQ type-declaration-define SEMI  { $$ = new_subtree(TYPE_LIST_NODE, NO_TYPE, 1, $3); }
;

type-declaration-define:
  simple-type       {$$ = $1;}
| structured-type   {$$ = $1;}
| recorde-type      {$$ = $1;}
| set-type          {$$ = $1;}
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
  name-list          {$$ = $1;}
| string-list-val    {$$ = $1;}
;

name-list:
  name-list COMMA ID    {guarda_var(); $$ = $1;}
| ID                    {guarda_var(); $$ = $1; }
;

string-list-val:
  string-list-val COMMA INTEGER_VAL   {$$ = $1;}
| INTEGER_VAL                         {$$ = $1;}
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
  var-declaration-list var-define   { add_child($1, $2); $$ = $1; }
| var-define                        { $$ = new_subtree(VAR_LIST_NODE, NO_TYPE, 1, $1); }
;

var-define:
  name-list TWO_DOT type-declaration-define {$$ = new_var(stk);} SEMI { $$ = $4;}
;

proc-and-func-declaration:
  proc-and-func-declaration function-declaration-list
| proc-and-func-declaration procedure-declaration-list
| function-declaration-list
| procedure-declaration-list
| %empty                               { $$ = new_subtree(PROC_FUNC_LIST_NODE, NO_TYPE, 0); }
;

function-declaration-list:
  function-declare SEMI sub-block SEMI
;

function-declare:
  FUNCTION ID {guarda_var_unica();} parameters TWO_DOT simple-type {$$ = new_var(stk_unica);}
;

procedure-declaration-list:
  procedure-declare SEMI sub-block SEMI
;

procedure-declare:
  PROCEDURE ID {guarda_var_unica();} parameters {$$ = new_var(stk_unica);}
;

parameters:
  LPAR parameters-declare {$$ = new_var(stk);} RPAR
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
  BEGIN_RW statement-list END { $$ = $2; }
;

statement-list:
  statement-list statement SEMI { add_child($1, $2); $$ = $1; }
| statement SEMI                { $$ = new_subtree(BLOCK_NODE, NO_TYPE, 1, $1); }
;

label-statement:
  assign-statement     { $$ = $1; }
| proc-id-statement    { $$ = $1; }
| compound-statement   { $$ = $1; }
| if-statement         { $$ = $1; }
| repeat-statement     { $$ = $1; }
| while-statement      { $$ = $1; }
| for-statement        { $$ = $1; }
| case-statement       { $$ = $1; }
| goto-statement       { $$ = $1; }
;

statement:
  label-statement
| INTEGER_VAL TWO_DOT label-statement  
;

assign-statement:
  ID { $1 = check_var(); } ASSIGN expression                        { $$ = check_assign($1, $4); }
| ID { $1 = check_var(); } LEFT expression RIGHT ASSIGN expression  { check_assign_array($1, $7); }
| ID { $1 = check_var(); } DOT ID ASSIGN expression
;

proc-id-statement:
  ID
| ID LPAR list-args RPAR
;

if-statement:
  IF expression THEN statement                     { $$ = check_if_then($2, $4); }
| IF expression THEN statement ELSE statement      { $$ = check_if_then_else($2, $4, $6); }
;

repeat-statement:
  REPEAT statement-list UNTIL expression           { $$ = check_repeat($2, $4); }
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
  expression MOREQ expr   { $$ = unify_bin_node($1, $3, MOREQ_NODE, ">=", unify_comp); }
| expression MT expr      { $$ = unify_bin_node($1, $3, MT_NODE,    ">",  unify_comp); }
| expression LOREQ expr   { $$ = unify_bin_node($1, $3, LOREQ_NODE, "<=", unify_comp); }
| expression LT expr      { $$ = unify_bin_node($1, $3, LT_NODE,    "<",  unify_comp); }
| expression NOTEQ expr   { $$ = unify_bin_node($1, $3, NOTEQ_NODE, "<>", unify_comp); }
| expression EQ expr      { $$ = unify_bin_node($1, $3, EQ_NODE,    "=",  unify_comp); }
| expr
;

expr:
  expr PLUS term          { $$ = unify_bin_node($1, $3, PLUS_NODE,  "+", unify_plus); }
| expr MINUS term         { $$ = unify_bin_node($1, $3, MINUS_NODE, "-", unify_other_arith); }
| expr OR term            { $$ = check_logical_op($1, $3, OR_NODE, "OR"); }
| expr MOD term           { $$ = check_int_div_op($1, $3, MOD_NODE, "MOD"); }
| expr DIV term           { $$ = check_int_div_op($1, $3, DIV_NODE, "DIV"); }
| expr IN term
| term 
;

term:
  term TIMES factor        { $$ = unify_bin_node($1, $3, TIMES_NODE, "*", unify_other_arith); }
| term OVER factor         { $$ = unify_bin_node($1, $3, OVER_NODE,  "/", unify_other_arith); }
| term AND factor          { $$ = check_logical_op($1, $3, AND_NODE, "AND"); }
| factor
;

factor:
  ID { $$ = check_var(); }
| ID { $$ = check_var(); } LPAR list-args RPAR 
| constants 
| LPAR expression RPAR  { $$ = $2; }
| NOT factor   { $$ = check_not_op($2, NOT_NODE, "NOT");}
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

AST* check_var(){
    int idx = lookup_var(vt, id_copy);
    if (idx == -1) {
        printf("SEMANTIC ERROR (%d): variable '%s' was not declared.\n",
                yylineno, id_copy);
        exit(EXIT_FAILURE);
    }
    return new_node(VAR_USE_NODE, idx, get_type(vt, idx));
}

AST* new_var(StrStack *p_st) {
    int idx = lookup_var(vt, yytext);
    if (idx != -1) {
        printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d.\n",
                yylineno, yytext, get_line(vt, idx));
        exit(EXIT_FAILURE);
    }
    
    int cont = 0;
    int i = getSize(p_st);
    char * data;
    
    while(cont < i ){
       data = get_string_stack(p_st, cont);
       idx = add_var(vt, data, yylineno, last_decl_type);
       new_node(VAR_DECL_NODE, idx, last_decl_type);
       subSize(p_st);
       cont++;
    }
    return new_node(VAR_DECL_NODE, idx, last_decl_type);
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

void type_error(const char* op, Type t1, Type rt) {
    printf("SEMANTIC ERROR (%d): incompatible types for operator '%s', LHS is '%s' and RHS is '%s'.\n",
           yylineno, op, get_text(t1), get_text(rt));
    exit(EXIT_FAILURE);
}

AST* create_conv_node(Conv conv, AST *n) {
    switch(conv) {
        case B2I:  return new_subtree(B2I_NODE, INT_TYPE,  1, n);
        case B2R:  return new_subtree(B2R_NODE, REAL_TYPE, 1, n);
        case B2S:  return new_subtree(B2S_NODE, STR_TYPE,  1, n);
        case I2R:  return new_subtree(I2R_NODE, REAL_TYPE, 1, n);
        case I2S:  return new_subtree(I2S_NODE, STR_TYPE,  1, n);
        case R2S:  return new_subtree(R2S_NODE, STR_TYPE,  1, n);
        case NONE: return n;
        default:
            printf("INTERNAL ERROR: invalid conversion of types!\n");
            exit(EXIT_FAILURE);
    }
}

AST* unify_bin_node(AST* l, AST* r,
                    NodeKind kind, const char* op, Unif (*unify)(Type,Type)) {
    Type lt = get_node_type(l);
    Type rt = get_node_type(r);
    Unif unif = unify(lt, rt);
    if (unif.type == NO_TYPE) {
        type_error(op, lt, rt);
    }
    l = create_conv_node(unif.lc, l);
    r = create_conv_node(unif.rc, r);
    return new_subtree(kind, unif.type, 2, l, r);
}

AST* check_logical_op(AST*  l, AST*  r, NodeKind kind, const char* cmd) {
    Type lt = get_node_type(l);
    Type rt = get_node_type(r);
    if (lt == BOOL_TYPE && rt == BOOL_TYPE){
        return new_subtree(kind, BOOL_TYPE, 2, lt, rt);
    }
    printf("SEMANTIC ERROR (%d): logical expression for operator '%s', LHS is '%s' and RHS is '%s'.\n",
           yylineno, cmd, get_text(lt), get_text(rt));
    exit(EXIT_FAILURE);
}

AST* check_not_op(AST* l, NodeKind kind, const char* cmd){
    Type lt = get_node_type(l);
    if (lt == BOOL_TYPE){
      return new_subtree(kind, BOOL_TYPE, 1, lt);
    }
    printf("SEMANTIC ERROR (%d): expression '%s', is '%s' instead of '%s'.\n",
           yylineno, cmd, get_text(lt), get_text(BOOL_TYPE));
    exit(EXIT_FAILURE);
}

AST* check_int_div_op(AST*  l, AST*  r, NodeKind kind, const char* cmd) {
    Type lt = get_node_type(l);
    Type rt = get_node_type(r);
    if (lt == INT_TYPE && rt == INT_TYPE){
        return new_subtree(kind, INT_TYPE, 2, lt, rt);
    }
    printf("SEMANTIC ERROR (%d): logical expression for operator '%s', LHS is '%s' and RHS is '%s'.\n",
           yylineno, cmd, get_text(lt), get_text(rt));
    exit(EXIT_FAILURE);
}

AST* check_assign(AST *l, AST *r) {
    Type lt = get_node_type(l);
    Type rt = get_node_type(r);

    if (lt == BOOL_TYPE && rt != BOOL_TYPE) type_error(":=", lt, rt);
    if (lt == INT_TYPE  && rt != INT_TYPE)  type_error(":=", lt, rt);
    if (lt == STR_TYPE  && rt != STR_TYPE)  type_error(":=", lt, rt);
    if (lt == ARRAY_TYPE  && rt != ARRAY_TYPE)  type_error(":=", lt, rt);

    if (lt == REAL_TYPE) {
        if (rt == INT_TYPE) {
            r = create_conv_node(I2R, r);
        } else if (rt != REAL_TYPE) {
            type_error(":=", lt, rt);
        }
    }    
    return new_subtree(ASSIGN_NODE, NO_TYPE, 2, l, r); 
}

void check_assign_array(AST* l, AST* r) {
    Type lt = get_node_type(l);
    Type rt = get_node_type(r);
    if (lt == ARRAY_TYPE  && rt != INT_TYPE) {
        printf("SEMANTIC ERROR (%d): incompatible types for operator ':=', LHS is '%s (int)' and RHS is '%s'.\n",
           yylineno, get_text(lt), get_text(rt));
        exit(EXIT_FAILURE);
    }
}

AST* check_if_then(AST *e, AST *b) {
    check_bool_expr("if", get_node_type(e));
    return new_subtree(IF_NODE, NO_TYPE, 2, e, b);
}

AST* check_if_then_else(AST *e, AST *b1, AST *b2) {
    check_bool_expr("if", get_node_type(e));
    return new_subtree(IF_NODE, NO_TYPE, 3, e, b1, b2);
}

AST* check_repeat(AST *b, AST *e) {
    check_bool_expr("repeat", get_node_type(e));
    return new_subtree(REPEAT_NODE, NO_TYPE, 2, b, e);
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

    print_dot(root);
    
    free_str_table(st);
    free_var_table(vt);

    yylex_destroy();    // To avoid memory leaks within flex...
    
    return 0;
}
