/* 	Compiler Theory and Design
	Duane J. Jarc 
	12/16/2018
	Shafro Batyrov
	Description: This file contains flex input file */

%{
#include <string>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment	\-\-.*\n
comment2	\/\/.*\n 
line		[\n]
id		[A-Za-z](_?[A-Za-z0-9])* 
digit [0-9]
int -?{digit}+
punc		[\(\),:;.]
REAL_LITERAL {digit}+\.{digit}*([Ee][+-]?{digit}+)? 
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{comment2}	{ECHO;nextLine();}
{line}		{ ECHO; nextLine();}
"=>"		{ ECHO; return(ARROW); }
"="|"/="|"<"|">"|">="|"<="		{ ECHO; return(RELOP); } 
"+"|"-"		{ ECHO; return(ADDOP); }  
"*"|"/"		{ ECHO; return(MULOP); }  
"**"		{ ECHO; return(EXPOP); } 
rem			{ECHO; return(REMOP); }
true      { ECHO; return(BOOL_LITERAL); } 
false     { ECHO; return(BOOL_LITERAL); } 
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
or    { ECHO; return(OROP); } 
not   { ECHO; return(NOTOP);} 
case		{ ECHO; return(CASE); }  
else		{ ECHO; return(ELSE); } 
endcase		{ ECHO; return(ENDCASE); } 
endif		{ ECHO; return(ENDIF); } 
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
end		{ ECHO; return(END); }
if			{ ECHO; return(IF); } 
others		{ ECHO; return(OTHERS); } 
real		{ ECHO; return(REAL); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
{REAL_LITERAL} { ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
