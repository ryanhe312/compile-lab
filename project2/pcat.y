%{
#include <iostream>
using namespace std;

extern int row;
extern int col;

#include "lex.c"
#include "syntax_tree.h"
#include "string.h"
void yyerror ( char* s ) {
  printf("*** %s (row: %d, col: %d, token: %s)\n",
         s, row, col-strlen(yytext),yytext);
};
%}



%union {
    struct synTreeNode* Node;
}



%token AND ARRAY BEGINN BY DIV DO ELSE ELSIF END EXIT FOR IF IN IS LOOP MOD NOT OF OR OUT
 PROCEDURE PROGRAM READ RECORD RETURN THEN TO TYPE VAR WHILE WRITE ASSIGN PLUS MINUS MULTIPLY
 DIVIDE LT LET GT GET EQUAL NEQUAL COLON SEMICOLON COMMA DOT LPAREN RPAREN LBRACKET RBRACKET 
 LBRACE RBRACE LABRACKET RABRACKET SLASH INTEGER REAL ID STRING ERROR EOL 

%type <Node> start
%type <Node> program
%type <Node> body
%type <Node> decl_list
%type <Node> declaration
%type <Node> var_decl_list
%type <Node> var_declaration
%type <Node> statement
%type <Node> statement_list
%type <Node> lvalue
%type <Node> ltype
%type <Node> expression
%type <Node> identifier
%type <Node> identifier_list
%type <Node> operator
%type <Node> number
%type <Node> parameter_list
%type <Node> expression_list
%type <Node> string
%type <Node> lvalue_list
%type <Node> procedure_declaration
%type <Node> procedure_decl_list
%type <Node> procedure_name
%type <Node> type_declaration
%type <Node> type_decl_list
%type <Node> type_name
%type <Node> type_body
%type <Node> component
%type <Node> component_list
%type <Node> component_name
%type <Node> component_assign_list
%type <Node> component_assign
%type <Node> type_init_list
%type <Node> condition
%type <Node> elif_list
%type <Node> elif
%type <Node> else
%type <Node> if
%type <Node> link_list
%type <Node> loop_range
%type <Node> step
%type <Node> range
%type <Node> from
%type <Node> to
%type <Node> arg
%type <Node> arg_decl_list
%type <Node> arg_list
%type <Node> return_type
%type <Node> arg_name
%left       AND OR 
%left       EQUAL NEQUAL
%left       GET GT LET LT
%left       PLUS MINUS
%left       MULTIPLY DIVIDE 
%nonassoc   LABRACKET

%%
start:
       program   {$$ = create_node(Tstart,"", &@$);}
      | statement END {$$ = create_node(Tstart,"", &@$);add_child($$,$1);}
      ;

program: 
      PROGRAM IS body SEMICOLON     {$$ = create_node(Tprogram,"", &@$);add_child($$,$3);printTree(0,$$);}
      ;

body:
      decl_list BEGINN statement_list END  {$$ = create_node(Tbody,"", &@$);add_child($$,$1);add_child($$,$3);}
      ;

decl_list:
       declaration decl_list {printf("decl_list1\n");$$ = create_node(Tdecl_list,"", &@$);add_child($$,$1);add_children($$,$2);}
      | {printf("decl_list2\n");$$ = NULL;}
      ;

declaration:
      VAR var_decl_list {$$ =create_node(Tdeclaration,"", &@$);add_child($$,$2);}
      | PROCEDURE procedure_decl_list { $$ =create_node(Tdeclaration,"", &@$);add_child($$,$2);}
      | TYPE type_decl_list {$$ =create_node(Tdeclaration,"", &@$);add_child($$,$2);}
      | {$$=NULL;}
      ;
var_decl_list:
      var_declaration var_decl_list {$$=create_node(Tvar_decl_list,"", &@$);add_child($$,$1);add_children($$,$2);}
      | {$$=NULL;}
      ;

var_declaration:
      lvalue_list COLON type_name ASSIGN expression SEMICOLON
                  {$$=create_node(Tvar_declaration,"", &@$);add_child($$,$1);add_child($$,$3);add_child($$,$5);}
      ;

procedure_decl_list:
      procedure_declaration procedure_decl_list {$$=create_node(Tprocedure_decl_list,"", &@$);add_child($$,$1);add_children($$,$2);}
      | {$$=NULL;}
      ;

procedure_declaration:
      procedure_name LPAREN arg_list RPAREN return_type IS body SEMICOLON {$$=create_node(Tprocedure_declaration,"", &@$);
                                                                              add_child($$,$1);add_child($$,$3);add_child($$,$5);add_child($$,$7);}
      ;

arg_list:
      arg arg_decl_list {$$ = create_node(Targ_list,"", &@$);add_child($$,$1);add_children($$,$2);reverse_children($$);}
      | { $$ =NULL;} 

arg_decl_list:
      arg_decl_list SEMICOLON arg { $$ = create_node(Targ_decl_list,"", &@$);add_child($$,$3);add_children($$,$1);}
      | { $$ =NULL;} 
      ;

arg:
      arg_name COLON type_name { $$ = create_node(Targ,"", &@$); add_child($$,$1);add_child($$,$3);}
      ;

arg_name:
      identifier {$$=create_node(Targ_name,"", &@$);add_child($$,$1);}
      ;

return_type:
      COLON type_name { $$ = create_node(Treturn_type,"", &@$); add_child($$,$2); }
      | { $$ = NULL;}

procedure_name:
      identifier {$$=create_node(Tprocedure_name,"", &@$);add_child($$,$1);}
      ;

type_decl_list:
      type_declaration type_decl_list {$$=create_node(Ttype_decl_list,"", &@$);add_child($$,$1);add_children($$,$2);}
      | {$$=NULL;}
      ;

type_declaration:
      type_name IS type_body SEMICOLON {$$=create_node(Ttype_declaration,"", &@$);add_child($$,$1);add_child($$,$3);}
      ;

type_name:
      identifier {$$=create_node(Ttype_name,"", &@$);add_child($$,$1);}
      ;

type_body:
      RECORD component_list END {$$=create_node(Ttype_body,"", &@$);add_child($$,$2);}
      ;

component_list:
      component_list component {$$=create_node(Tcomponent_list,"", &@$);add_child($$,$2);add_children($$,$1);}
      | {$$ =NULL; }
      ;

component:
      component_name COLON type_name SEMICOLON {$$=create_node(Tcomponent,"", &@$);add_child($$,$1);add_child($$,$3);}
      ;

component_name:
      identifier {$$=create_node(Tcomponent_name,"", &@$);add_child($$,$1);}
      ;

ltype:
      identifier {$$=create_node(Tltype,"", &@$);add_child($$,$1);}
      ;
      
lvalue_list:
      identifier identifier_list {$$=create_node(Tlvalue_list,"", &@$);add_child($$,$1);add_children($$,$2);reverse_children($$);}
      ;
      
lvalue:
      identifier link_list {$$=create_node(Tlvalue,"", &@$);add_child($$,$1); add_children($$,$2);reverse_children($$);}
      ;

link_list:
      link_list DOT identifier {$$=create_node(Tlink_list,"", &@$);add_child($$,$3);
                                   add_child($$,create_node(Toperator,".", &@$));add_children($$,$1);}
      | { $$ = NULL;}
      ;
identifier:
      ID {$$=create_node(Tidentifier,yytext, NULL);}
      ;

identifier_list:
      identifier_list COMMA identifier {$$=create_node(Tidentifier_list,"", &@$);add_child($$,$3);add_children($$,$1);}
      | {$$=NULL;}
      ;


expression:
      STRING {$$ = create_node(Texpression,"", &@$); add_child($$,create_node(Tstring,yytext, NULL));YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, $$->loc);}
      | procedure_name LPAREN parameter_list RPAREN { $$ = create_node(Texpression,"PROCEDURE", &@$);add_child($$,$1);}
      | type_name LBRACE type_init_list RBRACE {$$ = create_node(Texpression,"", &@$);add_child($$,$1);add_child($$,$3);}
      
      | number {$$ = create_node(Texpression,"", &@$);add_child($$,$1);}
      | lvalue {$$ = create_node(Texpression,"", &@$); add_child($$,$1);}
      | MINUS number {$$ = create_node(Texpression,"", &@$);add_child($$,create_node(Toperator,"-", &@$));add_child($$,$2);}
      | MINUS lvalue {$$ = create_node(Texpression,"", &@$);add_child($$,create_node(Toperator,"-", &@$));add_child($$,$2);}
      | expression PLUS expression {$$ = create_node(Texpression,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"+", &@$));add_child($$,$3);}
      | expression MINUS expression {$$ = create_node(Texpression,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"-", &@$));add_child($$,$3);}
      | expression MULTIPLY expression {$$ = create_node(Texpression,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"*", &@$));add_child($$,$3);}
      | expression DIVIDE expression {$$ = create_node(Texpression,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"/", &@$));add_child($$,$3);}
      | LPAREN expression RPAREN  {$$ = create_node(Texpression,"", &@$);add_child($$,$2);
                                   }
      | MINUS LPAREN expression RPAREN  {$$ = create_node(Texpression,"", &@$);add_child($$,create_node(Toperator,"-", &@$));
                                    add_child($$,$3);}
      ;

type_init_list:
      component_assign component_assign_list {$$ = create_node(Ttype_init_list,"", &@$);add_child($$,$1);add_children($$,$2);reverse_children($$);}
      ;

component_assign_list:
      component_assign_list SEMICOLON component_assign {$$ = create_node(Tcomponent_assign_list,"", &@$);add_child($$,$3);add_children($$,$1);}
      | {$$ = NULL;}
      ;

component_assign:
      component_name ASSIGN expression {$$ = create_node(Tcomponent_assign,"", &@$);add_child($$,$1);add_child($$,$3);}
      ;

number:
      INTEGER {$$=create_node(Tinteger,yytext, NULL);}
      | REAL {$$=create_node(Treal,yytext, NULL);}
      ;

statement_list:
      statement statement_list {$$ = create_node(Tstatement_list,"", &@$);add_child($$,$1);add_children($$,$2);}
      | {$$ = NULL;}
      ;

statement:
      WRITE LPAREN parameter_list RPAREN SEMICOLON { $$ = create_node(Tstatement,"WRITE", &@$);add_child($$,$3);}
      | READ LPAREN parameter_list RPAREN SEMICOLON { $$ = create_node(Tstatement,"READ", &@$);add_child($$,$3);}
      | lvalue ASSIGN expression SEMICOLON { $$ = create_node(Tstatement,"ASSIGN", &@$);add_child($$,$1);add_child($$,$3);}
      | IF if elif_list else END SEMICOLON { $$ = create_node(Tstatement,"CONDITION", &@$); add_child($$,$2);
                                                               add_child($$,$3);add_child($$,$4);}
      | procedure_name LPAREN parameter_list RPAREN SEMICOLON { $$ = create_node(Tstatement,"CALL PROCEDURE", &@$);add_child($$,$1);}
      | FOR loop_range DO statement_list END SEMICOLON {$$ = create_node(Tstatement,"FOR LOOP", &@$);add_child($$,$2);add_child($$,$4);}
      | RETURN expression SEMICOLON { $$ = create_node(Tstatement,"RETURN", &@$); add_child($$,$2);}
      | LOOP statement_list END SEMICOLON {$$ = create_node(Tstatement,"LOOP", &@$); add_child($$,$2);}
      | EXIT SEMICOLON { $$ =create_node(Tstatement,"", &@$);add_child($$,create_node(Texit,"", &@$));}
      ;

loop_range:
      lvalue ASSIGN range {$$ = create_node(Tloop_range,"", &@$);add_child($$,$1);add_child($$,$3);}
      ;

range:
      expression TO expression step {$$ = create_node(Trange,"", &@$);add_child($$,$1);add_child($$,$3);add_child($$,$4);}
      ;

step:
      BY expression {$$ = create_node(Tstep,"", &@$);add_child($$,$2);}
      | { $$ =NULL;}
      ;


condition:
      expression { $$ = create_node(Tcondition,"", &@$);add_child($$,$1);}
      | condition AND condition {$$ = create_node(Tcondition,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"AND", &@$));add_child($$,$3);}
      | condition OR condition {$$ = create_node(Tcondition,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"OR", &@$));add_child($$,$3);}
      | condition EQUAL condition {$$ = create_node(Tcondition,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"=", &@$));add_child($$,$3);}
      | condition NEQUAL condition {$$ = create_node(Tcondition,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"<>", &@$));add_child($$,$3);}
      | condition GET condition {$$ = create_node(Tcondition,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,">=", &@$));add_child($$,$3);}
      | condition GT condition {$$ = create_node(Tcondition,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,">", &@$));add_child($$,$3);}
      | condition LT condition {$$ = create_node(Tcondition,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"<", &@$));add_child($$,$3);}
      | condition  LET condition {$$ = create_node(Tcondition,"", &@$);add_child($$,$1);
                                   add_child($$,create_node(Toperator,"<=", &@$));add_child($$,$3);}
      ;

if:
      condition THEN statement_list {$$ = create_node(Tif,"", &@$); add_child($$,$1);
                                                                  add_child($$,$3);}
      ;

elif_list:
      elif elif_list {$$ = create_node(Telif_list,"", &@$);add_child($$,$1);add_children($$,$2);}
      | {$$=NULL;}
      ;

elif:
      ELSIF condition THEN statement_list {$$ = create_node(Telif,"", &@$); add_child($$,$2);
                                                                  add_child($$,$4);}
      ;

else:
      ELSE statement_list { $$ = create_node(Telse,"", &@$);add_child($$,$2);}
      | { $$ =NULL; }
      ;

parameter_list:   
      expression expression_list {$$ = create_node(Tparameter_list,"", &@$);add_child($$,$1);add_children($$,$2);reverse_children($$);}
      | { $$ = NULL; }
      ;

expression_list:
      expression_list COMMA expression { $$ = create_node(Texpression_list,"", &@$);add_child($$,$3);add_children($$,$1);}
      | { $$ = NULL; }
      ;

%%
