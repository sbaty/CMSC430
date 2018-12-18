/* 	Compiler Theory and Design
	Dr. Duane J. Jarc 
	Edited by Shafro Batyrov
	Date: 12.16.2018
	Desc:This file contains type definitions and the function
 	prototypes for the type checking functions
*/
typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, REAL_TYPE, BOOL_TYPE, EMPTY};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);
Types checkInteger(Types left, Types right);
Types checkIFThen(Types expression, Types left, Types right);
Types checkExpressions(Types expression, Types left, Types right);
