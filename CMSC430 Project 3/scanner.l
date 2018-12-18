/* Shafro Batyrov
	12/2/2018
	Project 2
	Code Description: This file contains flex input file 
*/
%{
#include <string>

using namespace std;

#include "values.h"
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
real {digit}+[.]{digit}*([eE]?[+-]?{digit}+)?
%%

{ws}		{ ECHO;}
{comment}	{ ECHO; nextLine();}
{comment2}	{ECHO;nextLine();}
{line}		{ ECHO; nextLine();}
"=>"		{ECHO; yylval.oper = ARROW; return(ARROW); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"/="	{ ECHO; yylval.oper = UNEQUAL; return(RELOP); }
">="	{ ECHO; yylval.oper = GR_EQUAL; return(RELOP); }
"<="	{ ECHO; yylval.oper = LESS_EQUAL; return(RELOP); }
"+"     { ECHO; yylval.oper = ADD; return(ADDOP); }
"-"     { ECHO; yylval.oper = SUBTRACT; return(ADDOP); }  
"*"     { ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"     { ECHO; yylval.oper = DIVIDE; return(MULOP); }  
"**"	{ ECHO; yylval.oper = POWER; return(EXPOP); }  
"%"		{ ECHO; yylval.oper = REM; return(REMOP); } 
rem     {ECHO; return(REMOP);} 
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
true      { ECHO; yylval.value = TRUE; return(BOOL_LITERAL); } 
false     { ECHO; yylval.value = FALSE; return(BOOL_LITERAL); }
or    { ECHO; return(OROP); } 
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
not   { ECHO; return(NOTOP);} 
case		{ ECHO; return(CASE); }  
else		{ ECHO; return(ELSE); } 
endcase		{ ECHO; return(ENDCASE); } 
endif		{ ECHO; return(ENDIF); } 
if			{ ECHO; return(IF); } 
others		{ ECHO; return(OTHERS); } 
real		{ ECHO; return(REAL); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
and		{ ECHO; return(ANDOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
{real} { ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
