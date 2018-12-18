/* Shafro Batyrov
	12/2/2018
	Project 3
	Code Description: This file contains function definitions for the evaluation functions
*/

typedef char* CharPtr;
enum Operators {LESS, ADD, SUBTRACT, DIVIDE, MULTIPLY, POWER, ARROW, GREATER, EQUAL, UNEQUAL, GR_EQUAL, LESS_EQUAL, REM, };

int evaluateReduction(Operators operator_, int head, int tail);
int evaluateRelational(int left, Operators operator_, int right);
int evaluateArithmetic(int left, Operators operator_, int right);

 