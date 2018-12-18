/* Compiler Theory and Design
   Dr. Duane J. Jarc 
   Edited by Shafro Batyrov
   Date: 12.2.2018
   Description: Define Parse tree grammar
   and syntactic analyzer
*/

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <math.h>
using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"
#include "stdlib.h"
#include <stdio.h>

int yylex();
void yyerror(const char* message);

Symbols<int> symbols;

int result;
double * params;
%}

%error-verbose

%union
{
	CharPtr iden;
	Operators oper;
	int value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL CASE TRUE FALSE
%token <oper> ADDOP MULOP RELOP OROP NOTOP REMOP EXPOP
%token ANDOP 
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token THEN WHEN 
%token  ELSE ENDCASE ENDIF IF OTHERS REAL 

%type <value> body statement_ statement reductions unary exponent expression binary relation term
	factor primary
%type <oper> operator


%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' | 
	FUNCTION IDENTIFIER RETURNS type ';' |
	error ';' ;	

optional_variable:
	optional_variable variable |
	error ';' |
	;

variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

parameters:
	parameter optional_parameter;

optional_parameter:
	optional_parameter ',' parameter |
	;
	
parameter:
	IDENTIFIER ':' type {symbols.insert($1, params[0]);} ;
	
type:
	INTEGER | 
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF 
	{if ($2 == true) {
             $$=$4;
         }
         else {
             $$=$6;
         }
     }
     ; /* |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE 	
	{$$ = $<value>4 == 1 ? 4 : 7;} ;

cases:
	cases case	
	{$$ = $<value>1 == 1 ? 1 : 2;} |
	%empty {$$ = <isnan>;};
case:
	case WHEN INT_LITERAL ARROW statement_ |
	;
*/
operator:
	ADDOP |
	RELOP |
	EXPOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

expression:
	expression OROP binary {$$ = $1 || $3;} |
	binary;
	
binary:
	binary ANDOP relation {$$ = $1 && $3;} |
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	factor REMOP exponent { $$=$1%$3; } |
	exponent ;

exponent:
	unary |
	unary  EXPOP exponent { $$=pow($1,$3); } ;
	
	
unary:
	NOTOP primary {$$ = $2;}|
	primary;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
    params = new double[argc - 1];
	for (int i = 1; i < argc; i++)
		params[i - 1] = atof(argv[i]); 
	 
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
