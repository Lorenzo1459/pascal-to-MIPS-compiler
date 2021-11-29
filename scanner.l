
/* Flex output */
%option outfile="scanner.c"
/* Unused functions */
%option noyywrap
%option nounput
%option noinput
/* Auto increment variable yylineno every time a '\n' is read. */
%option yylineno

%{

void process_token(const char* tk) {
    printf("%d: %s -> %s\n", yylineno, yytext, tk);
}

%}

int_val     [0-9]+
real_val    [0-9]+"."[0-9]+
str_val     \"[^"]*\"

id [a-zA-Z_][a-zA-z0-9_]*

ignore      [ \t\n]+
comments    \{[^}]*\}

%%

{ignore}    { }
{comments}  { }

"begin"     { process_token("BEGIN"); }
"bool"      { process_token("BOOL"); }
"else"      { process_token("ELSE"); }
"end"       { process_token("END"); }
"false"     { process_token("FALSE"); }
"if"        { process_token("IF"); }
"int"       { process_token("INT"); }
"program"   { process_token("PROGRAM"); }
"read"      { process_token("READ"); }
"real"      { process_token("REAL"); }
"repeat"    { process_token("REPEAT"); }
"string"    { process_token("STRING"); }
"then"      { process_token("THEN"); }
"true"      { process_token("TRUE"); }
"until"     { process_token("UNTIL"); }
"var"       { process_token("VAR"); }
"write"     { process_token("WRITE"); }

"<=" { process_token("LOREQ"); }
">=" { process_token("MOREQ"); }
":=" { process_token("ASSIGN"); }
"+=" { process_token("PLUSEQ"); }
"-=" { process_token("MINUSEQ"); }
"/=" { process_token("DIVEQ"); }
"*=" { process_token("TIMESEQ"); }
"(*" { process_token("COMMENT1.1"); }
"*)" { process_token("COMMENT1.2"); }
"(." { process_token(""); } //????????
".)" { process_token(""); } //????????
"//" { process_token("COMMENTLINE"); }
"+" { process_token("PLUS"); }
"-" { process_token("MINUS"); }
"*" { process_token("TIMES"); }
"/" { process_token("DIV"); }
"=" { process_token("EQ"); }
">" { process_token("MT"); }
"<" { process_token("LT"); }
"[" { process_token("LEFT"); }
"." { process_token("DOT"); }
"," { process_token("COMMA"); }
"(" { process_token("LPAR"); }
")" { process_token("RPAR"); }
":" { process_token("2DOT"); }
"^" { process_token("EXP"); }
"@" { process_token("AT"); }
"{" { process_token("LKEY"); }
"}" { process_token("RKEY"); }
"$" { process_token("CIF"); }
"#" { process_token("HASHTAG"); }

{int_val}   { process_token("INT_VAL"); }
{real_val}  { process_token("REAL_VAL"); }
{str_val}   { process_token("STR_VAL"); }

{id}        { process_token("ID"); }

            /* Be sure to keep this as the last rule */
.           { printf("LEXICAL ERROR (%d): Unknown symbol %s\n", yylineno, yytext);
              exit(EXIT_FAILURE); }

%%
