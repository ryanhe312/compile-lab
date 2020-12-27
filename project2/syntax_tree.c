#include"syntax_tree.h"
#include"stdlib.h"
#include"string.h"

void add_child(synTreeNode*root,synTreeNode*node){
    
    if (!node)
        return;
    synTreeNode* child = root->children;
    if (!child){
        root->children = node;
    }else{
        while(child && child->next){
            child = child->next;
        }
        child->next = node;
    }
}

void add_children(synTreeNode*root,synTreeNode*node){
    if (!node)
        return;
    synTreeNode* child = root->children;
    if (!child){
        root->children = node;
    }else{
        while(child && child->next){
            child = child->next;
        }
        child->next = node->children;
    }

}
synTreeNode* create_node(Node_type type,char* var,YYLTYPE *yylloc){
    char *temp=(char*)malloc(strlen(var));
    strcpy(temp,var);
    synTreeNode* node = (synTreeNode*)malloc(sizeof(synTreeNode));
    //printf("%d %s\n",type,var);
    node->type = type;
    switch (type){
        case Tinteger:
            node->value.integer= atoi(temp);
            break;
        case Treal:
            node->value.real = atof(temp);
            break;
        default:
            node->value.str = temp;
    }
    if(yylloc){
        node->loc = (YYLTYPE*)malloc(sizeof(YYLTYPE));
    node->loc->first_line = yylloc->first_line;
    node->loc->last_line = yylloc->last_line;
    node->loc->first_column = yylloc->first_column;
    node->loc->last_column = yylloc->last_column;
    }
    return node;

}

void printTree(int i,synTreeNode*root){
    synTreeNode*cur =root;
    if (!cur) return;
    for (int j=0;j<i;++j)
        printf("   ");
    switch (cur->type){
        case Tinteger:
            printf("%s %d ",type_name[cur->type],cur->value.integer);
            if (cur->loc){
                printf("loc:(%d,%d)~(%d,%d)\n",cur->loc->first_line,cur->loc->first_column,
                                            cur->loc->last_line,cur->loc->last_column);
            }else{
                printf("\n");
            }
            break;
        case Treal:
            printf("%s %f ",type_name[cur->type],cur->value.real);
            if (cur->loc){
                printf("loc:(%d,%d)~(%d,%d)\n",cur->loc->first_line,cur->loc->first_column,
                                            cur->loc->last_line,cur->loc->last_column);
            }else{
                printf("\n");
            }
            break;
        default:
            printf("%s %s ",type_name[cur->type],cur->value.str);
            if (cur->loc){
                printf("loc:(%d,%d)~(%d,%d)\n",cur->loc->first_line,cur->loc->first_column,
                                            cur->loc->last_line,cur->loc->last_column);
            }else{
                printf("\n");
            }
           
    }
    synTreeNode* child = cur->children;

    while(child ){
        printTree(i+1,child);
        child = child->next;
    }
    
}

void reverse_children(synTreeNode*node){
    //printf("%s\n",type_name[node->type]);
    if (!node || !node->children || !node->children->next)
        return;
    int len=1;
    synTreeNode*pre = node->children;
    synTreeNode* cur = pre->next;
    synTreeNode* end = cur;
    while (end && end->next){
        end = end->next;
        len+=1;
    } 
    

    while(cur!=end){
        pre->next = cur->next;
        cur->next =NULL;
        synTreeNode* endnxt = end->next;
        end->next = cur;
        cur->next = endnxt;
        cur = pre->next;
    }

}

