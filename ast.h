#ifndef AST_H
#define AST_H

#include "types.h"

typedef enum {
    ASSIGN_NODE,
    EQ_NODE,
    BLOCK_NODE,
    BOOL_VAL_NODE,
    IF_NODE,
    INT_VAL_NODE,
    LT_NODE,
    MINUS_NODE,
    OVER_NODE,
    PLUS_NODE,
    MOREQ_NODE,
    MT_NODE,
    LOREQ_NODE,
    NOTEQ_NODE,
    OR_NODE,
    MOD_NODE,
    DIV_NODE,
    AND_NODE,
    NOT_NODE,
    PROGRAM_NODE,
    //READ_NODE,
    REAL_VAL_NODE,
    REPEAT_NODE,
    STR_VAL_NODE,
    TIMES_NODE,
    VAR_DECL_NODE,
    VAR_LIST_NODE,
    VAR_USE_NODE,
    //WRITE_NODE,

    LABEL_LIST_NODE,
    CONST_LIST_NODE,
    TYPE_LIST_NODE,
    BLOCK_HEAD_NODE,
    PROC_FUNC_LIST_NODE,

    B2I_NODE,   // Conversion of types.
    B2R_NODE,
    B2S_NODE,
    I2R_NODE,
    I2S_NODE,
    R2S_NODE
} NodeKind;

struct node; // Opaque structure to ensure encapsulation.

typedef struct node AST;

AST* new_node(NodeKind kind, int data, Type type);

void add_child(AST *parent, AST *child);
AST* get_child(AST *parent, int idx);

AST* new_subtree(NodeKind kind, Type type, int child_count, ...);

NodeKind get_kind(AST *node);
char* kind2str(NodeKind kind);

int get_data(AST *node);
void set_float_data(AST *node, float data);
float get_float_data(AST *node);

Type get_node_type(AST *node);
int get_child_count(AST *node);

void print_tree(AST *ast);
void print_dot(AST *ast);

void free_tree(AST *ast);

#endif
