compile: scanner.o parser.o listing.o
	g++ -o compile scanner.o parser.o listing.o
	
scanner.o: scanner.c listing.h tokens.h
	g++ -c scanner.c

scanner.c: scanner.l
	flex scanner.l
	mv lex.yy.c scanner.c

parser.o: parser.c listing.h 
	g++ -c parser.c

parser.c tokens.h: parser.y
	bison -d -v parser.y
	mv parser.tab.c parser.c
	mv parser.tab.h tokens.h

listing.o: listing.cc listing.h
	g++ -c listing.cc