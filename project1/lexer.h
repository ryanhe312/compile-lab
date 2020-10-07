#ifndef _LEXER_H_
#define _LEXER_H_

#define ERROR       0x0
#define KEYWORD     0x1
#define OPERATOR    0x2
#define DILIMITER   0x3

#define INTEGER     0xff1
#define REAL        0xff2
#define ID          0xff3
#define STRING      0xff4

#define ILLEGAL_CHAR        0xffff0
#define INVALID_INTEGER     0xffff1
#define ILLEGAL_REAL        0xffff2
#define ILLEGAL_ID          0xffff3
#define ILLEGAL_STRING      0xffff4
#define INVALID_STRING      0xffff5
#define UNTERMINATED_STRING 0xffff6
#define UNTERMINATED_COMMENT    0xffff7


#endif