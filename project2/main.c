#include "stdio.h"
#include "syntax_tree.h"
extern void yyset_in  ( FILE * _in_str  );
extern int yyparse();
extern int yylex (void);
extern char* yytext;
extern int row,col,error,yyleng;

int row = 1,col=1;
char text[100];
int main(int argc,char **argv){
    if(argc>1){
        yyset_in(fopen(argv[1],"r"));
    }
    else{
        yyset_in(stdin);
    }

    yyparse();


    return 0;
}