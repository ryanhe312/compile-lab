%{
#include "lexer.h"
#include "string.h"

int row=1,col=1,error=0;

#define YY_USER_ACTION  col += yyleng, error = 0; 
#define YY_ERROR(x) {error = x; return ERROR;}
%}

%option nounput
%option noyywrap

LETTER      [A-Za-z]
DIGIT       [0-9]
INTEGER     {DIGIT}+
REAL        {DIGIT}+"."{DIGIT}*
ID          {LETTER}({DIGIT}|{LETTER})*
STRING      \"[^\n\t\"]+\"       

%%

AND     |
ARRAY   |
BEGIN   |
BY      |
DIV     |
DO      |
ELSE    |
ELSIF   |
END     |
EXIT    |
FOR     |
IF      |
IN      |
IS      |
LOOP    |
MOD     |
NOT     |
OF      |
OR      |
OUT     |
PROCEDURE |
PROGRAM |
READ    |
RECORD  |
RETURN  |
THEN    |
TO      |
TYPE    |
VAR     |
WHILE   |
WRITE   return KEYWORD;

:=      |
\+      |
\-      |
\*      |
\/      |
\<      |
\<\=    |
\>      |
\>\=    |
\=      |
\<\>    return OPERATOR;

\:      |
\;      |
\,      |
\.      |
\(      |
\)      |
\[      |
\]      |
\{      |
\}      |
\[\<    |
\>\]    |
\\      return DILIMITER;


{INTEGER} {
    if (yyleng > 10 || (yyleng == 10 && (strcmp(yytext, "4294967295") > 0))) YY_ERROR(INVALID_INTEGER);
    return INTEGER;
}
{REAL} {
    if (yyleng > 255) YY_ERROR(ILLEGAL_REAL);
    return REAL;
}
{ID} {
    if(yyleng>255)  YY_ERROR(ILLEGAL_ID);
  	return ID;
}
{STRING} {
    if (yyleng - 2 > 255)   YY_ERROR(ILLEGAL_STRING);
	return STRING;
}
\"[^\"]+\" {
    YY_ERROR(INVALID_STRING);
}
\"[^\"]* {
    YY_ERROR(UNTERMINATED_STRING);
}


<<EOF>> {
    return EOF;
}
\n  {
    row++,col=1;
}
[ \t]+  {
    
}
. { 
	YY_ERROR(ILLEGAL_CHAR);
}

%%

