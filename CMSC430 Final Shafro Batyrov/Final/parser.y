/* Compiler Theory and Design
   Dr. Duane J. Jarc 
   Edited by Shafro Batyrov
   Date: 12.16.2018
   Desc: Define Parse tree grammar
   and syntactic analyzer
   */
%{

#include <string>
#include <vector>
#include <map>

using namespace std;


#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

%}

%error-verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL NOTOP CASE CASES TRUE FALSE ELSE ENDIF IF
%token ADDOP MULOP RELOP ANDOP EXPOP OROP  REMOP
%token ARROW THEN WHEN 
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS 
%token REDUCE RETURNS ENDCASE  OTHERS REAL
%type <type> type statement statement_ reductions expression binary exponent unary relation term
	factor primary

%%

function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' | 
	FUNCTION IDENTIFIER RETURNS type ';' |
	error ';' ;

optional_variable:
	optional_variable variable |
	error ';' |
	;

variable:	
	IDENTIFIER ':' type IS statement_ 
		{checkAssignment($3, $5, "Variable Initialization");
		{if (symbols.find($1, $3)) appendError(DUPLICATE_IDENTIFIER, $1);
		symbols.insert($1, $3);} };

parameters:
	parameter optional_parameter;

optional_parameter:
	optional_parameter ',' parameter |
	;

parameter:
	IDENTIFIER ':' type {symbols.insert($1, $3);} ;
	
type:
	INTEGER {$$ = INT_TYPE;} |
	REAL {$$ = REAL_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = checkIFThen($$, $4, $6);} |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE {$$=checkExpression($4,$7);} ;

operator:
	ADDOP |
	MULOP ;
	
cases:
	cases case {$$=checkExpression($1,$2);} |
	{$$=EMPTY;}	;
	
case:
	case WHEN INT_LITERAL ARROW statement_ {if (symbols.find($-2, $2)) {$$=$4;}else{ $$=EMPTY;}};|
	;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;

expression:
	expression OROP binary {$$ = checkLogical($1, $3);} |
	binary;
	
binary:
	binary ANDOP relation {$$ = checkLogical($1, $3);} |
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP primary  {$$ = checkArithmetic($1, $3);} |
	factor REMOP exponent {$$ = checkInteger($1, $3);} |
	exponent ;

exponent:
	unary |
	unary  EXPOP exponent {$$ = checkArithmetic($1,$3);};

unary:
	NOTOP primary {$$ = $2;}|
	primary;	

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | REAL_LITERAL |	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
