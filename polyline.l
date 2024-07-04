%{
#include "y.tab.h"

int var_n = 0;
%}

%%
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
-           { return '-'; }
sim0            { return SIM0; }
simx            { return SIMX; }
simy            { return SIMY; }
isOpen          { return ISOPEN; }
close           { return CLOSE; }
len             {return LEN;}
q               {return QUIT;}
"="             { return ASSIGN; }
"+"             { return PLUS; }
[ \t]+      { /* skip whitespace */ }
\n          { return EOL; }
";"         { return SEMICOLON; }
"(";        { return LPAR; }
")";        { return RPAR; }
[a-zA-Z_][a-zA-Z0-9_]* {
                    int tmp = 0;
                    for(int i = 0; yytext[i]!= '\0' ; i++){
                        tmp+=yytext[i];
                    }
                    yylval = tmp;

                    return VARIABLE;
            }
.           { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
