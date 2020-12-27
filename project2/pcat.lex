%{
#include "pcat.h"
#include "string.h"
#include "yacc.h"

extern int row,col;
extern char*text;
int error=0;
#define YY_USER_ACTION yylloc.first_line = row; \
						   yylloc.last_line = row; \
  						   yylloc.first_column = col; \
  						   yylloc.last_column = col + yyleng - 1;
#define YY_USER_ACTION  {yylloc.first_line = row;yylloc.first_column = col;yylloc.last_line = row; \
                        yylloc.last_column = col + yyleng - 1;col += yyleng, error = 0;} 
#define YY_ERROR(x) {error = x; return ERROR;}
%}

%option noyywrap
%x COMMENT

LETTER      [a-zA-Z]
DIGIT       [0-9]
INTEGER     {DIGIT}+
REAL        {DIGIT}+"."{DIGIT}*
ID         [a-zA-Z][a-zA-Z0-9]*
STRING      \"[^\"\n\t]*\"       

%%

"(*" {
    BEGIN(COMMENT);
}  

<COMMENT>"*)" {
    BEGIN(INITIAL);
}

<COMMENT>\n {
    row++,col=1;
}

<COMMENT><<EOF>> {
    YY_ERROR(UNTERMINATED_COMMENT);
}

<COMMENT>. {
}

AND 		return AND;
ARRAY		return ARRAY;
BEGIN		return BEGINN;
BY			return BY;
DIV			return DIV;
DO			return DO;
ELSE		return ELSE;
ELSIF		return ELSIF;
END			return END;
EXIT		return EXIT;
FOR			return FOR;
IF			return IF;
IN 			return IN;
IS 			return IS;
LOOP		return LOOP;
MOD			return MOD;
NOT			return NOT;
OF			return OF;
OR			return OR;
OUT			return OUT;
PROCEDURE	return PROCEDURE;
PROGRAM		return PROGRAM;
READ		return READ;
RECORD		return RECORD;
RETURN 		return RETURN;
THEN		return THEN;
TO			return TO;
TYPE		return TYPE;
VAR			return VAR;
WHILE		return WHILE;
WRITE 		return WRITE;

:=      return ASSIGN;
\+      return PLUS;
\-      return MINUS;
\*      return MULTIPLY;
\/      return DIVIDE;
\<      return LT;
\<\=    return LET;
\>      return GT;
\>\=    return GET;
\=      return EQUAL;
\<\>    return NEQUAL;

\:      return COLON;
\;      return SEMICOLON;
\,      return COMMA;
\.      return DOT;
\(      return LPAREN;
\)      return RPAREN;
\[      return LBRACKET;
\]      return RBRACKET;
\{      return LBRACE;
\}      return RBRACE;
\[\<    return LABRACKET;
\>\]    return RABRACKET;
\\      return SLASH;

{ID} {
    if(yyleng>255)  
        YY_ERROR(ILLEGAL_ID);
  	return ID;
}
{INTEGER} {
    if (yyleng > 10 || (yyleng == 10 && (strcmp(yytext, "4294967295") > 0))) 
        YY_ERROR(INVALID_INTEGER);
    return INTEGER;
}
{REAL} {
    if (yyleng > 255) 
        YY_ERROR(ILLEGAL_REAL);
    return REAL;
}

{STRING} {
    if (yyleng - 2 > 255)   
        YY_ERROR(ILLEGAL_STRING);
	return STRING;
}
\"[^\"\n]*\" {
    YY_ERROR(INVALID_STRING);
}
\"[^\"\n]*\n {
    unput('\n');
    YY_ERROR(UNTERMINATED_STRING);
}
\"[^\"\n]* {
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

