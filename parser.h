/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_H_INCLUDED
# define YY_YY_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ABSOLUTE = 258,
    AND = 259,
    ARRAY = 260,
    ASM = 261,
    BEGIN_RW = 262,
    BREAK = 263,
    CASE = 264,
    CONST = 265,
    CONSTRUCTOR = 266,
    CONTINUE = 267,
    DESTRUCTOR = 268,
    DIV = 269,
    DO = 270,
    DOWNTO = 271,
    ELSE = 272,
    END = 273,
    FILE_W = 274,
    FOR = 275,
    FUNCTION = 276,
    GOTO = 277,
    IF = 278,
    IMPLEMENTATION = 279,
    IN = 280,
    INHERITED = 281,
    INLINE = 282,
    INTERFACE = 283,
    LABEL = 284,
    MOD = 285,
    NIL = 286,
    NOT = 287,
    OBJECT = 288,
    OF = 289,
    ON = 290,
    OPERATOR = 291,
    OR = 292,
    PACKED = 293,
    PROCEDURE = 294,
    PROGRAM = 295,
    RECORD = 296,
    REINTRODUCE = 297,
    REPEAT = 298,
    SELF = 299,
    SET = 300,
    SHL = 301,
    SHR = 302,
    THEN = 303,
    TO = 304,
    TYPE = 305,
    UNIT = 306,
    UNTIL = 307,
    USES = 308,
    VAR = 309,
    WHILE = 310,
    WITH = 311,
    XOR = 312,
    LOREQ = 313,
    MOREQ = 314,
    ASSIGN = 315,
    PLUSEQ = 316,
    MINUSEQ = 317,
    DIVEQ = 318,
    TIMESEQ = 319,
    LPAR_DOT = 320,
    RPAR_DOT = 321,
    PLUS = 322,
    NOTEQ = 323,
    MINUS = 324,
    TIMES = 325,
    OVER = 326,
    EQ = 327,
    MT = 328,
    LT = 329,
    EXP = 330,
    LEFT = 331,
    RIGHT = 332,
    DOT = 333,
    COMMA = 334,
    LPAR = 335,
    RPAR = 336,
    TWO_DOT = 337,
    AT = 338,
    LKEY = 339,
    RKEY = 340,
    CIF = 341,
    HASHTAG = 342,
    SEMI = 343,
    INTEGER = 344,
    REAL = 345,
    CHAR = 346,
    STRING = 347,
    ID = 348,
    INTEGER_VAL = 349,
    REAL_VAL = 350,
    CHAR_VAL = 351,
    STRING_VAL = 352
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef Type YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_H_INCLUDED  */
