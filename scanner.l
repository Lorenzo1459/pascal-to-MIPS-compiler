%option yylineno
%{
    #include <stdio.h>
    void process_token(const char* tk) {
    printf("%d: %s -> %s\n", yylineno, yytext, tk);
}
%}

%%
"absolute"   { process_token("ABSOLUTE"); }
"and"   { process_token("AND"); }
"array"   { process_token("ARRAY"); }
"asm"   { process_token("ASM"); }
"begin"   { process_token("BEGIN"); }
"break"   { process_token("BREAK"); }
"case"   { process_token("CASE"); }
"const"   { process_token("CONST"); }
"constructor"   { process_token("CONSTRUCTOR"); }
"continue"   { process_token("CONTINUE"); }
"destructor"   { process_token("DESTRUCTOR"); }
"div"   { process_token("DIV"); }
"do"   { process_token("DO"); }
"downto"   { process_token("DOWNTO"); }
"else"   { process_token("ELSE"); }
"end"   { process_token("END"); }
"file"   { process_token("FILE"); }
"for"   { process_token("FOR"); }
"function"   { process_token("FUNCTIN"); }
"goto"   { process_token("GOTO"); }
"if"   { process_token("IF"); }
"implementation"   { process_token("IMPLEMENTATION"); }
"in"   { process_token("IN"); }
"inherited"   { process_token("INHERITED"); }
"inline"   { process_token("INLINE"); }
"interface"   { process_token("INTERFACE"); }
"label"   { process_token("LABEL"); }
"mod"   { process_token("MOD"); }
"nil"   { process_token("NIL"); }
"not"   { process_token("NOT"); }
"object"   { process_token("OBJECT"); }
"of"   { process_token("OF"); }
"on"   { process_token("ON"); }
"operator"   { process_token("OPERATOR"); }
"or"   { process_token("OR"); }
"packed"   { process_token("PACKED"); }
"procedure"   { process_token("PROCEDURE"); }
"program"   { process_token("PROGRAM"); }
"record"   { process_token("RECORD"); }
"reintroduce"   { process_token("REINTRODUCE"); }
"repeat"   { process_token("REPEAT"); }
"self"   { process_token("SELF"); }
"set"   { process_token("SET"); }
"shl"   { process_token("SHL"); }
"shr"   { process_token("SHR"); }
"string"   { process_token("STRING"); }
"then"   { process_token("THEN"); }
"to"   { process_token("TO"); }
"type"   { process_token("TYPE"); }
"unit"   { process_token("UNIT"); }
"until"   { process_token("UNTIL"); }
"uses"   { process_token("USES"); }
"var"   { process_token("VAR"); }
"while"   { process_token("WHILE"); }
"with"   { process_token("WITH"); }
"xor"   { process_token("XOR"); }








":="   { process_token("ASSIGN"); }
"="   { process_token("EQ"); }
"<"   { process_token("LT"); }
"+"   { process_token("PLUS"); }
"-"   { process_token("MINUS"); }
"*"   { process_token("TIMES"); }
"/"   { printf("%d: / -> OVER\n", yylineno); }
"("   { printf("%d: ( -> LPAR\n", yylineno); }
")"   { printf("%d: ) -> RPAR\n", yylineno); }
";"   { printf("%d: ; -> SEMI\n", yylineno); }

[1-9][0-9]* | 0 { printf("%d: %s -> INT_VAL\n", yylineno, yytext); }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("%d: %s -> ID\n", yylineno, yytext); }
(\"[^\"]*\") { printf("%d: %s -> STR_VAL\n", yylineno, yytext); }
\{[^\}]*\} {  }
(\n|.) {  }
%%