#include  <stdlib.h>
#include  <stdio.h>
#include <string.h>
#include  "code.h"
#include  "instruction.h"
#include  "tables.h"

extern StrTable *st;
extern VarTable *vt;

Instr code[INSTR_MEM_SIZE];
int next_instr;

void emit(OpCode op, int o1, int o2, int o3, char* os, int num_reg) {
  code[next_instr].op = op;
  code[next_instr].o1 = o1;
  code[next_instr].o2 = o2;
  code[next_instr].o3 = o3;
  strcpy(code[next_instr].os, os);
  code[next_instr].num_reg = num_reg;
  next_instr++;
}

void emit_2(OpCode op, int o1, int o2, int o3, char* os, int num_reg) {
  code[next_instr].op = op;
  code[next_instr].o1 = o1;
  code[next_instr].o2 = o2;  
  code[next_instr].o3 = o3;
  strcpy(code[next_instr].os, os);
  code[next_instr].num_reg = num_reg;
  next_instr++;
}

#define emit0(op) \
  emit(op, 0, 0, 0, "0", 0)

#define emit1(op, o1) \
  emit(op, o1, 0, 0, "0", 0)

#define emit2(op, o1, o2, nr) \
  emit(op, o1, o2, 0, "0", nr)

#define emit2_string(op, o1, os) \
  emit_2(op, o1, 0, 0, os, 0)

#define emit3(op, o1, o2, o3) \
  emit(op, o1, o2, o3, "0", 0)

void backpatch_jump(int next_instr_address, int jump_address){
  code[next_instr_address].o1 = jump_address;
}

// void backpatch_branch(int next_instr_address, int offset) {
//   code[next_instr_address].o2 = offset;
// }

// ----------------------------------------------------------------------------
// Prints ---------------------------------------------------------------------

#define LINE_SIZE 80
#define MAX_STR_SIZE 128

void get_instruction_string(Instr instr, char *s) {
    OpCode op = instr.op;
    s += sprintf(s, "\t%s", OpStr[op]);
    int op_count = OpCount[op];
    if (op_count == 1) {
        sprintf(s, " %d", instr.o1);
    } else if (op_count == 2 && strcmp(instr.os, "0") != 0) {
        sprintf(s, " $%d, %s", instr.o1+5, instr.os);
    } else if (op_count == 2 && strcmp(instr.os, "0") == 0 && instr.num_reg == 0) {
        sprintf(s, " $%d, %d", instr.o1+5, instr.o2);
    } else if (op_count == 2 && strcmp(instr.os, "0") == 0 && instr.num_reg == 1) {
        sprintf(s, " $%d, ($%d)", instr.o1+5, instr.o2+5);
    } else if (op_count == 3) {
        sprintf(s, " $%d, $%d, $%d", instr.o1+5, instr.o2+5, instr.o3+5);
    }
}

void write_instruction(int addr) {
    Instr instr = code[addr];
    char instr_str[LINE_SIZE];
    get_instruction_string(instr, instr_str);
    printf("%s\n", instr_str);
}

void dump_program() {
    for (int addr = 0; addr < next_instr; addr++) {
        write_instruction(addr);
    }
}


// ----------------------------------------------------------------------------
// AST Traversal --------------------------------------------------------------

int int_regs_count;
int float_regs_count;

#define new_int_reg() \
    int_regs_count++

#define new_float_reg() \
    float_regs_count++

int rec_emit_code(AST *ast);
int current_addr;
int operacao;
// ----------------------------------------------------------------------------

int emit_assign(AST *ast) {
    //int addr = get_data(get_child(ast, 0));
    operacao = 0;
    int address = get_data(get_child(ast, 0));
    current_addr = address;
    char* name = get_name(vt, address);
    emit2_string(la, address, name);
    AST *r = get_child(ast, 1);
    rec_emit_code(r);
    if(operacao == 0){
        emit2(sw, address+1, address, 1);
    }else{
        emit2(lw, address+1, address, 1);
    }
    return -1; // This is not an expression, hence no value to return.
}

int emit_eq(AST *ast) {

    return -1;
}

int emit_block(AST* ast) {
  int size = get_child_count(ast);
  for (int i = 0; i < size; i++) {
      rec_emit_code(get_child(ast, i));
  }
  return -1;
}

int emit_if(AST *ast) {
    
    return -1; // This is not an expression, hence no value to return.
}

int emit_int_val(AST *ast) {
    int c = get_data(ast);
    emit2(li, current_addr+1, c, 0);
    return current_addr;
}

int emit_lt(AST *ast) {
    
    return -1;
}

int emit_mt(AST *ast) {
    
    return -1;
}

int emit_moreq(AST* ast) {

    return -1;
}


int emit_minus(AST *ast) {
  int y = get_data(get_child(ast, 0));
  int z = get_data(get_child(ast, 1));

  char* name = get_name(vt, y);
  char* name2 = get_name(vt, z);
  char* name3 = get_name(vt, current_addr);

  emit2_string(la, y, name);
  emit2_string(la, z, name2);
  emit2(lw, y, y, 1);
  emit2(lw, z, z, 1);
  emit3(sub, z, y, z);
  emit2_string(la, y, name3);
  emit2(sw, z, y, 1);
  emit2_string(la, y, name);
  emit2(sw, z, y, 1);

  operacao = 1;

  y = rec_emit_code(get_child(ast, 0));
  z = rec_emit_code(get_child(ast, 1));

  return current_addr;
}

int emit_over(AST *ast) {
  int y = get_data(get_child(ast, 0));
  int z = get_data(get_child(ast, 1));

  char* name = get_name(vt, y);
  char* name2 = get_name(vt, z);
  char* name3 = get_name(vt, current_addr);

  emit2_string(la, y, name);
  emit2_string(la, z, name2);
  emit2(lw, y, y, 1);
  emit2(lw, z, z, 1);
  emit3(dIv, z, y, z);
  emit2_string(la, y, name3);
  emit2(sw, z, y, 1);
  emit2_string(la, y, name);
  emit2(sw, z, y, 1);

  operacao = 1;

  y = rec_emit_code(get_child(ast, 0));
  z = rec_emit_code(get_child(ast, 1));

  return current_addr;
}

int emit_plus(AST *ast) {

    int y = get_data(get_child(ast, 0));
    int z = get_data(get_child(ast, 1));
        
    char* name = get_name(vt, y);
    char* name2 = get_name(vt, z);
    char* name3 = get_name(vt, current_addr);

    emit2_string(la, y, name);
    emit2_string(la, z, name2);
    emit2(lw, y, y, 1);
    emit2(lw, z, z, 1);
    emit3(add, z, y, z);
    emit2_string(la, y, name3);
    emit2(sw, z, y, 1);
    emit2_string(la, y, name);
    emit2(sw, z, y, 1);
    operacao = 1;

    y = rec_emit_code(get_child(ast, 0));
    z = rec_emit_code(get_child(ast, 1));

    return current_addr;
}

int emit_program(AST *ast) {
    rec_emit_code(get_child(ast, 0)); // var_list
    rec_emit_code(get_child(ast, 1)); // block
    return -1;  // This is not an expression, hence no value to return.
}

int emit_real_val(AST *ast) {

    return -1;
}

int emit_repeat(AST *ast) {

    return -1;  // This is not an expression, hence no value to return.
}

int emit_str_val(AST *ast) {

    return -1;
}

int emit_times(AST *ast) {

  int y = get_data(get_child(ast, 0));
  int z = get_data(get_child(ast, 1));

  char* name = get_name(vt, y);
  char* name2 = get_name(vt, z);
  char* name3 = get_name(vt, current_addr);

  emit2_string(la, y, name);
  emit2_string(la, z, name2);
  emit2(lw, y, y, 1);
  emit2(lw, z, z, 1);
  emit3(mul, z, y, z);
  emit2_string(la, y, name3);
  emit2(sw, z, y, 1);
  emit2_string(la, y, name);
  emit2(sw, z, y, 1);
  operacao = 1;

  y = rec_emit_code(get_child(ast, 0));
  z = rec_emit_code(get_child(ast, 1));

  return current_addr;
}

int emit_var_decl(AST *ast) {

    return -1;  // This is not an expression, hence no value to return.
}

int emit_var_list(AST *ast) {
    int size = get_child_count(ast);
    for (int i = 0; i < size; i++) {
        rec_emit_code(get_child(ast, i));
        AST * aux = get_child(ast, i);
        fprintf(stderr, "\t %s:  .word 0\n", get_name(vt, get_data(aux) ));
    }
    return -1;  // This is not an expression, hence no value to return.
}

int emit_labellist(AST *ast) {

    return -1;  // This is not an expression, hence no value to return.
}

int emit_constlist(AST *ast) {

    return -1;  // This is not an expression, hence no value to return.
}

int emit_typelist(AST *ast) {

    return -1;  // This is not an expression, hence no value to return.
}

int emit_blockhead(AST *ast) {
  printf(".data:\n");

  int table_size = get_str_table_size(st);
    for (int i = 0; i < table_size; i++) {
        printf("\t Str%d: .asciiz \"%s\"\n", i, get_string(st, i));
    }

  int size = get_child_count(ast);
  for (int i = 0; i < size; i++) {
      rec_emit_code(get_child(ast, i));
  }
  printf("\n.text:\n\n.globl main\n\nmain:\n");
  return -1;
}

int emit_procfunclist(AST *ast) {

    return -1;  // This is not an expression, hence no value to return.
}

int emit_var_use(AST *ast) {

    return -1;
}


int emit_i2r(AST* ast) {

    return -1;
}

int emit_i2s(AST* ast) {

    return -1;
}

int emit_r2s(AST* ast) {

    return -1;
}

int emit_noteq(AST* ast) {

  return -1; //mudar
}

int emit_or(AST* ast){

    return -1;
}

int emit_mod(AST* ast){

    return -1; //mudar
}

int emit_div(AST* ast){

    return -1; //mudar
}

int emit_and(AST* ast){

  return -1;
}

int emit_not(AST* ast){

  return -1;
}

int emit_write(AST *ast) {

    int address = get_data(get_child(ast, 0));
    AST* r = get_child(ast, 0);
    Type var_type = get_node_type(r);
    if (var_type == STR_TYPE){
        char buffer[100];
        snprintf(buffer, 100, "Str%d", address);
        emit2_string(la, address, buffer);
        emit2(la, -1, address, 1);
        emit2(li, -3, 4, 0);
        emit0(syscall);
    }else {
        char* name = get_name(vt, address);
        emit2_string(la, address, name);
        emit2(lw, -1, address, 1);
        emit2(li, -3, 1, 0);
        emit0(syscall);
    }
    return -1;  // This is not an expression, hence no value to return.
}

int rec_emit_code(AST *ast) {
    //printf("%d\n", get_kind(ast));
    switch(get_kind(ast)) {
        case ASSIGN_NODE:   return emit_assign(ast);
        case EQ_NODE:       return emit_eq(ast);
        case BLOCK_NODE:    return emit_block(ast);
        case IF_NODE:       return emit_if(ast);
        case INT_VAL_NODE:  return emit_int_val(ast);
        case LT_NODE:       return emit_lt(ast);
        case MT_NODE:       return emit_mt(ast);
        case MOREQ_NODE:    return emit_moreq(ast);
        case MINUS_NODE:    return emit_minus(ast);
        case OVER_NODE:     return emit_over(ast);
        case PLUS_NODE:     return emit_plus(ast);
        case PROGRAM_NODE:  return emit_program(ast);
        case REAL_VAL_NODE: return emit_real_val(ast);
        case REPEAT_NODE:   return emit_repeat(ast);
        case STR_VAL_NODE:  return emit_str_val(ast);
        case TIMES_NODE:    return emit_times(ast);
        case VAR_DECL_NODE: return emit_var_decl(ast);
        case VAR_LIST_NODE: return emit_var_list(ast);
        case VAR_USE_NODE:  return emit_var_use(ast);
        case NOTEQ_NODE:    return emit_noteq(ast);
        case OR_NODE:       return emit_or(ast);
        case MOD_NODE:      return emit_mod(ast);
        case DIV_NODE:      return emit_div(ast);
        case AND_NODE:      return emit_and(ast);
        case NOT_NODE:      return emit_not(ast);

        case LABEL_LIST_NODE:       return emit_labellist(ast);
        case CONST_LIST_NODE:       return emit_constlist(ast);
        case TYPE_LIST_NODE:        return emit_typelist(ast);
        case BLOCK_HEAD_NODE:       return emit_blockhead(ast);
        case PROC_FUNC_LIST_NODE:   return emit_procfunclist(ast);

        case I2R_NODE:      return emit_i2r(ast);
        case I2S_NODE:      return emit_i2s(ast);
        case R2S_NODE:      return emit_r2s(ast);

        case WRITE_NODE:    return emit_write(ast);

        default:
            fprintf(stderr, "Invalid kind: %s!\n", kind2str(get_kind(ast)));
            exit(EXIT_FAILURE);
    }
}

void emit_code(AST *ast) {
    next_instr = 0;
    int_regs_count = 0;
    float_regs_count = 0;
    rec_emit_code(ast);
    dump_program();
}
