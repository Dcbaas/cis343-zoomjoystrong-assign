all: zoomjoystrong.o lex.yy.o zoomjoystrong.tab.o
	clang -o zjs zoomjoystrong.o lex.yy.o zoomjoystrong.tab.o -lSDL2 -lm

zoomjoystrong.o: zoomjoystrong.c
lex.yy.o: lex.yy.c 
zoomjoystrong.tab.o: zoomjoystrong.tab.c

bison:
	bison -d zoomjoystrong.y

lex:
	flex zoomjoystrong.lex
