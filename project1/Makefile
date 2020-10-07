GCC = @g++
LEX = @flex

lexer: lexer.c main.c
			$(GCC) lexer.c main.c -o lexer

lexer.c: lexer.l
			$(LEX) -o lexer.c lexer.l

clean:
				@-rm -f lexer.c lexer
.PHONY: clean