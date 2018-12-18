/*	Compiler Theory and Design
	Dr. Duane J. Jarc 
	Edited by Shafro Batyrov
	Date: 12.16.2018
	Desc: This file contains the function prototypes for the functions that produce the 
	compilation listing
*/
enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

