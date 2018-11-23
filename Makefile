all: zoomjoystrong.c lex.yy.c zoomjoystrong.tab.c
	gcc -o zjs zoomjoystrong.c lex.yy.c zoomjoystrong.tab.c -lSDL2 -lm

bison:
	bison -d zoomjoystrong.y

lex:
	flex zoomjoystrong.lex
