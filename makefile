all: polyline

polyline: y.tab.c lex.yy.c
	gcc -o polyline y.tab.c lex.yy.c -ll -lm

y.tab.c: polyline.y
	yacc -d polyline.y

lex.yy.c: polyline.l
	lex polyline.l

clean:
	rm -f polyline y.tab.c y.tab.h lex.yy.c

.PHONY: all clean