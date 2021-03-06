#include "stdio.h"
#include "lexer.h"

extern void yyset_in  ( FILE * _in_str  );
extern int yylex (void);
extern char* yytext;
extern int row,col,error,yyleng;

int main(int argc,char **argv){
    if(argc>1){
        yyset_in(fopen(argv[1],"r"));
    }
    else{
        yyset_in(stdin);
    }

    printf("ROW\tCOL\tTYPE\t\t\t\tTOKEN/ERROR MESSAGE\n");

    int index,cnt=0,err=0;
    while ((index=yylex())!=EOF){
        printf("%d\t%d\t",row,col-yyleng);
        switch(index){
            case KEYWORD:   printf("reserved keyword\t");break;
            case OPERATOR:  printf("operator\t\t\t");break;
            case DILIMITER: printf("dilimiter\t\t\t");break;
            case INTEGER:   printf("integer\t\t\t\t");break;
            case REAL:      printf("real\t\t\t\t");break;
            case ID:        printf("identifier\t\t\t");break;
            case STRING:    printf("string\t\t\t\t");break;

            default:     printf("error\t\t\t\t");break;
        }
        if(error) err++; else cnt++;
        switch(error){
            case INVALID_INTEGER:       puts("INVALID INTEGER: larger than (2^31 - 1)");break;
            case ILLEGAL_REAL:          puts("ILLEGAL REAL: overly long, more than 255 in length");break;
            case ILLEGAL_ID:            puts("ILLEGAL ID: overly long, more than 255 in length");break;
            case ILLEGAL_STRING:        puts("ILLEGAL STRING: overly long, more than 255 in length");break;
            case INVALID_STRING:        puts("INVALID STRING: including illegal char \\t");break;
            case UNTERMINATED_STRING:   puts("UNTERMINATED STRING: lacking of tag \"");break;
            case ILLEGAL_CHAR:          puts("ILLEGAL CHAR");break;
            case UNTERMINATED_COMMENT:  puts("UNTERMINATED COMMENT");break;

            default: printf("%s\n",yytext);break;
        }
        if(error == UNTERMINATED_COMMENT) break;
    }

    printf("TOTAL: %d tokens, %d errors.\n",cnt,err);

    return 0;
}