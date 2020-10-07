GCC = @g++
LEX = @flex
LEXER = ./lexer
DIR = ../tests

test: lexer
	@-rm -f ../tests/*.txt
	@for file in `ls $(DIR)`; do \
		$(LEXER) $(DIR)/$$file > $(DIR)/$$file.txt; \
	done

lexer: lexer.c main.c
	$(GCC) lexer.c main.c -o lexer

lexer.c: lexer.l
	$(LEX) -o lexer.c lexer.l

clean:
	@-rm -f lexer.c lexer
	@-rm -f ../tests/*.txt
.PHONY: clean test all