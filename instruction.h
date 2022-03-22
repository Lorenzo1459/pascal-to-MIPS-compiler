#ifndef INSTRUCTION_H
#define INSTRUCTION_H

#define REGS_COUNT   32

#define INSTR_MEM_SIZE  4096
#define DATA_MEM_SIZE  4096

typedef enum {
  //HALT,
  //NOOP,

  //Operacoes aritmeticas
  add,    //$1 = $2 + $3 (signed)
  addu,   //$1 = $2 + $3 (unsigned)
  sub,    //$1 = $2 – $3 (signed)
  subu,   //$1 = $2 – $3 (unsigned)
  addi,   //$1 = $2 + CONST (signed)
  addiu,  //$1 = $2 + CONST (unsigned)
  mult,   //LO = (($1 * $2) << 32) >> 32;HI = ($1 * $2) >> 32;
  DIV,    //LO = $1 / $2     HI = $1 % $2

  //Transferencia de Dados
  lw,     //$1 = Memory[$2 + CONST]
  lh,     //$1 = Memory[$2 + CONST] (signed)
  lhu,    //$1 = Memory[$2 + CONST] (unsigned)
  lb,     //$1 = Memory[$2 + CONST] (signed)
  lbu,    //$1 = Memory[$2 + CONST] (unsigned)
  sw,     //Memory[$2 + CONST] = $1
  sh,     //Memory[$2 + CONST] = $1
  sb,     //Memory[$2 + CONST] = $1
  lui,    //	$1 = CONST << 16
  mfhi,   //$1 = HI
  mflo,   //$1 = LO
  mfcZ,   //$1 = Coprocessor[Z].ControlRegister[$2]
  mtcZ,   //Coprocessor[Z].ControlRegister[$2] = $1
  lwcZ,   //Coprocessor[Z].DataRegister[$1] = Memory[$2 + CONST]
  swcZ,   //Memory[$2 + CONST] = Coprocessor[Z].DataRegister[$1]

  //Operacoes logicas
  and,    //$1 = $2 & $3
  andi,   //$1 = $2 & CONST
  or,     //$1 = $2 | $3
  ori,    //$1 = $2 | CONST
  xor,    //$1 = $2 ^ $3
  nor,    //$1 = ~($2 | $3)
  slt,    //$1 = ($2 < $3)
  slti,   //$1 = ($2 < CONST)
  seq,    //
  sge,    //
  sgt,    //
  sle,    //
  sne,    //

  //Operacoes bit a bit
  sll,    //$1 = $2 << CONST
  srl,    //$1 = $2 >> CONST
  sra,    //$1 = $2 >> CONST + ((Σ 1 ATE CONST 2^(31-n))* $2 >> 31)
  
  //Desvio Condicional
  beq,    //if ($1 == $2) go to PC+4+CONST
  bne,    //if ($1 != $2) go to PC+4+CONST

  //Salto Condicional
  j,      //goto address CONST
  jr,     //goto address $1
  jal,    //$31 = PC + 4; goto CONST

  //Pseudo-Instrucoes
  la,     //
  li,     //
  bgt,    //
  blt,    //
  bge,    //
  ble,    //
  bgtu,   //
  bgtz,    //
  //SSTR,

  move,
  syscall

}OpCode;

static char* OpStr[] = {
    "add", "addu", "sub", "subu", "addi", "addiu", "mult", "div",
    "lw", "lh", "lhu", "lb", "lbu", "sw", "sh", "sb", "lui", "mfhi", "mflo", "mfcZ", "mtcZ", "lwcZ", "swcZ",
    "and", "andi", "or", "ori", "xor", "nor", "slt", "slti", "seq", "sge", "sgt", "sle", "sne",
    "sll", "srl", "sra",
    "beq", "bne",
    "j", "jr", "jal",
    "la", "li", "bgt", "blt", "bge", "ble", "bgtu", "bgtz",
    "move", "syscall"
};

static int OpCount[] = {
  3,  //add
  3,  //addu
  3,  //sub
  3,  //subu
  3,  //addi
  3,  //addiu
  3,  //mult
  3,  //div
  2,  //lw
  2,  //lh
  2,  //lhu
  2,  //lb
  2,  //lbu
  2,  //sw
  2,  //sh
  2,  //sb
  1,  //lui
  1,  //mfhi
  1,  //mflo
  2,  //mfcZ
  2,  //mtcZ
  2,  //lwcZ
  2,  //swcZ
  3,  //and
  2,  //andi
  3,  //or
  2,  //ori
  3,  //xor
  3,  //nor
  3,  //slt
  2,  //slti
  2,  //seq
  2,  //sge
  2,  //sgt
  2,  //sle
  2,  //sne
  2,  //sll
  2,  //srl
  2,  //sra
  2,  //beq
  2,  //bne
  0,  //j
  1,  //jr
  0,  //jal
  2,  //la
  2,  //li
  0,  //bgt
  0,  //blt
  0,  //bge
  0,  //ble
  0,  //bgtu
  0,  //bgtz
  2,  //move
  0,  //syscall
};


typedef struct {
  OpCode op;
  int o1;
  int o2;
  int o3;
  char os[100];
  int num_reg;
} Instr;

#endif
