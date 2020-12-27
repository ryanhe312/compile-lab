#ifndef __SYNTAX_TREE_H__
#define __SYNTAX_TREE_H__

#include "malloc.h"
#include "yacc.h"
//#include "pcat.tab.h"

extern int format;

struct synTreeNode;

typedef enum {Tstart,Tbody,Tprogram,Tdeclaration,Tdecl_list, Tvar_decl_list,Tvar_declaration,Tstatement_list,Tstatement,
    Tlvalue,Tltype,Texpression,Tidentifier,Tidentifier_list,Toperator,Tinteger,Tnumber,Treal,Tparameter_list,Texpression_list,
    Tstring,Tlvalue_list,Tprocedure_declaration,Tprocedure_decl_list,Tprocedure_name,Ttype_declaration,Ttype_decl_list,Ttype_name,
    Ttype_body,Tcomponent,Tcomponent_list,Tcomponent_name,Tcomponent_assign_list,Tcomponent_assign,Ttype_init_list,Tcondition,
    Telif_list,Telif,Telse,Tif,Tlink_list,Tloop_range,Trange,Tstep,Tfrom,Tto,Targ,Targ_decl_list,Targ_list,Treturn_type,Targ_name,
    Texit} Node_type;

static char* type_name[] ={
    "start","body","program","declaration","decl_list", "var_decl_list","var_declaration","statement_list","statement",
    "lvalue","ltype","expression","identifier","identifier_list","operator","integer","number","real","parameter_list",
    "expression_list","string","lvalue_list","procedure_declaration","procedure_decl_list","procedure_name","type_declaration",
    "type_decl_list","type_name","type_body","component","component_list","component_name","component_assign_list","component_assign",
    "type_init_list","condition","elif_list","elif","else","if","link_list","loop_range","range","Tstep","from","to","arg","arg_decl_list",
    "arg_list","return_type","arg_name","exit"
};

typedef struct synTreeNode{
    Node_type type;
    union{
        char* str;
        int integer;
        double real;
        char* val;
    }value;
    struct synTreeNode* children;
    struct synTreeNode* next;
    YYLTYPE* loc;
}synTreeNode;

synTreeNode* create_node(Node_type type,char* var,YYLTYPE *yylloc);
void add_child(synTreeNode*root,synTreeNode*node);
void add_children(synTreeNode*root,synTreeNode*node);
void printTree(int i,synTreeNode*root);
void reverse_children(synTreeNode*node);
#endif




