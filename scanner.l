
/* Flex output */
%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput
/* Auto increment variable yylineno every time a '\n' is read. */
%option yylineno
%{
#include <stdio.h>
#define process_token(type) return type
%}

A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]


ignore      [ \t\n]+
comments    \{[^}]*\}

%%

{ignore}    { }
{comments}  { }
"//".* { }
\(\*(.|[\r\n])*?\*\) { }

{A}{B}{S}{O}{L}{U}{T}{E}                     { process_token(ABSOLUTE); }
{A}{N}{D}                                    { process_token(AND); }
{A}{R}{R}{A}{Y}                              { process_token(ARRAY); }
{A}{S}{M}                                    { process_token(ASM); }
{B}{E}{G}{I}{N}                              { process_token(BEGIN); }
{B}{R}{E}{A}{K}                              { process_token(BREAK); }
{C}{A}{S}{E}                                 { process_token(CASE); }
{C}{O}{N}{S}{T}                              { process_token(CONST); }
{C}{O}{N}{S}{T}{R}{U}{C}{T}{O}{R}            { process_token(CONSTRUCTOR); }
{C}{O}{N}{T}{I}{N}{U}{E}                     { process_token(CONTINUE); }
{D}{E}{S}{T}{R}{U}{C}{T}{O}{R}               { process_token(DESTRUCTOR); }
{D}{I}{V}                                    { process_token(DIV); }
{D}{O}                                       { process_token(DO); }
{D}{O}{W}{N}{T}{O}                           { process_token(DOWNTO); }
{E}{L}{S}{E}                                 { process_token(ELSE); }
{E}{N}{D}                                    { process_token(END); }
{F}{I}{L}{E}                                 { process_token(FILE); }
{F}{O}{R}                                    { process_token(FOR); }
{F}{U}{N}{C}{T}{I}{O}{N}                     { process_token(FUNCTION); }
{G}{O}{T}{O}                                 { process_token(GOTO); }
{I}{F}                                       { process_token(IF); }
{I}{M}{P}{L}{E}{M}{E}{N}{T}{A}{T}{I}{O}{N}   { process_token(IMPLEMENTATION); }
{I}{N}                                       { process_token(IN); }
{I}{N}{H}{E}{R}{I}{T}{E}{D}                  { process_token(INHERITED); }
{I}{N}{L}{I}{N}{E}                           { process_token(INLINE); }
{I}{N}{T}{E}{R}{F}{A}{C}{E}                  { process_token(INTERFACE); }
{L}{A}{B}{E}{L}                              { process_token(LABEL); }
{M}{O}{D}                                    { process_token(MOD); }
{N}{I}{L}                                    { process_token(NIL); }
{N}{O}{T}                                    { process_token(NOT); }
{O}{B}{J}{E}{C}{T}                           { process_token(OBJECT); }
{O}{F}                                       { process_token(OF); }
{O}{N}                                       { process_token(ON); }
{O}{P}{E}{R}{A}{T}{O}{R}                     { process_token(OPERATOR); }
{O}{R}                                       { process_token(OR); }
{P}{A}{C}{K}{E}{D}                           { process_token(PACKED); }
{P}{R}{O}{C}{E}{D}{U}{R}{E}                  { process_token(PROCEDURE); }
{P}{R}{O}{G}{R}{A}{M}                        { process_token(PROGRAM); }
{R}{E}{C}{O}{R}{D}                           { process_token(RECORD); }
{R}{E}{I}{N}{T}{R}{O}{D}{U}{C}{E}            { process_token(REINTRODUCE); }
{R}{E}{P}{E}{A}{T}                           { process_token(REPEAT); }
{S}{E}{L}{F}                                 { process_token(SELF); }
{S}{E}{T}                                    { process_token(SET); }
{S}{H}{L}                                    { process_token(SHL); }
{S}{H}{R}                                    { process_token(SHR); }
{S}{T}{R}{I}{N}{G}                           { process_token(STRING); }
{T}{H}{E}{N}                                 { process_token(THEN); }
{T}{O}                                       { process_token(TO); }
{T}{Y}{P}{E}                                 { process_token(TYPE); }
{U}{N}{I}{T}                                 { process_token(UNIT); }
{U}{N}{T}{I}{L}                              { process_token(UNTIL); }
{U}{S}{E}{S}                                 { process_token(USES); }
{V}{A}{R}                                    { process_token(VAR); }
{W}{H}{I}{L}{E}                              { process_token(WHILE); }
{W}{I}{T}{H}                                 { process_token(WITH); }
{X}{O}{R}                                    { process_token(XOR); }

"<=" { process_token(LOREQ); }
">=" { process_token(MOREQ); }
":=" { process_token(ASSIGN); }
"+=" { process_token(PLUSEQ); }
"-=" { process_token(MINUSEQ); }
"/=" { process_token(DIVEQ); }
"*=" { process_token(TIMESEQ); }
"(." { process_token(LPAR_DOT); } 
".)" { process_token(RPAR_DOT); } 
"+" { process_token(PLUS); }
"-" { process_token(MINUS); }
"*" { process_token(TIMES); }
"/" { process_token(DIV); }
"=" { process_token(EQ); }
">" { process_token(MT); }
"<" { process_token(LT); }
"[" { process_token(LEFT); }
"]" { process_token(RIGHT); }
"." { process_token(DOT); }
"," { process_token(COMMA); }
"(" { process_token(LPAR); }
")" { process_token(RPAR); }
":" { process_token(2DOT); }
"^" { process_token(EXP); }
"@" { process_token(AT); }
"{" { process_token(LKEY); }
"}" { process_token(RKEY); }
"$" { process_token(CIF); }
"#" { process_token(HASHTAG); }
";"	{ process_token(SEMI); }

[0-9]+ { printf("%d: %s -> INT_VAL\n", yylineno, yytext); }
[0-9]+"."[0-9]+ { printf("%d: %s -> REAL_VAL\n", yylineno, yytext); }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("%d: %s -> ID\n", yylineno, yytext); }


%%