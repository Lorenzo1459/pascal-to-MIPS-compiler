
all: bison flex gcc
	@echo "Done."

bison: parser.y
	bison parser.y

flex: scanner.l
	flex scanner.l

gcc: scanner.c parser.c tables.c types.c ast.c
	gcc -Wall -Wconversion -o trabcp3 scanner.c parser.c tables.c types.c ast.c code.c

clean:
	@rm -f *.o *.output scanner.c parser.h parser.c *.dot *.pdf trabcp3
