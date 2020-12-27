GCC = @g++
LEX = @flex
YACC = @bison

main: main.c syntax_tree.c yacc.o
			$(GCC) main.c syntax_tree.c yacc.o -o main

yacc.o: yacc.c
			$(GCC) -c yacc.c

yacc.c: pcat.y lex.c
			$(YACC) -o yacc.c -d pcat.y

lex.c: pcat.lex
			$(LEX) -o lex.c pcat.lex

clean:
				@-rm -f *.o *~ lex.c yacc.c yacc.h main
.PHONY: clean
