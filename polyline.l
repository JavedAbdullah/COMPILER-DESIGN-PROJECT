%{
#include "y.tab.h"
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
[ \t]+      { /* skip whitespace */ }
\n          { return EOL; }
";"         { return SEMICOLON; }
"(";        { return LPAR; }
")";        { return RPAR; }
.           { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
