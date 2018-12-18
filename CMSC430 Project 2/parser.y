/* Compiler Theory and Design
   Dr. Duane J. Jarc 
   Edited by Shafro Batyrov
   Date: 11.25.2018
   Desc: Define Parse tree grammar
   and syntactic analyzer
   */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%error-verbose

%token IDENTIFIER
%token INT_LITERAL REAL_LITERAL BOOL_LITERAL
%token ADDOP MULOP RELOP ANDOP EXPOP OROP NOTOP REMOP
%token ARROW THEN WHEN 
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS 
%token REDUCE RETURNS CASE ELSE ENDCASE ENDIF IF OTHERS REAL

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
	IDENTIFIER ':' type IS statement_ ;

parameters:
	parameter optional_parameter;

optional_parameter:
	optional_parameter ',' parameter |
	;

parameter:
	IDENTIFIER ':' type;
type:
	INTEGER | 
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF |
	CASE expression IS case OTHERS ARROW statement_ ENDCASE ;


operator:
	ADDOP |
	MULOP ;

case:
	case WHEN INT_LITERAL ARROW statement_ |
	;

reductions:
	reductions statement_ |
	;
	
expression:
	expression OROP binary |
	binary;

binary:
	binary ANDOP relation |
	relation ;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP exponent |
	factor REMOP exponent |
	exponent ;

exponent:
	exponent EXPOP unary |
	exponent '(' unary ')' |
	unary;

unary:
	NOTOP primary |
	primary;

primary:
	'(' expression ')' |
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER ;
    
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
