/* 	Compiler Theory and Design
	Duane J. Jarc 
	12/16/2018
	Shafro Batyrov
	Description:This file contains the bodies of the type checking functions
*/	

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
}
Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}
	if ((left == INT_TYPE && right == REAL_TYPE) || (left == REAL_TYPE && right == INT_TYPE))
	{
		appendError(GENERAL_SEMANTIC, "Illegal Narrowing Function Return");
		return MISMATCH;
	}
	return INT_TYPE;
}

Types checkExpressions(Types expression, Types left, Types right)
{
	if (expression != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Case Expression must be of Integer Type");
		return MISMATCH;
	}else
	{
	if (left != INT_TYPE || right != INT_TYPE)
		appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
		return MISMATCH;
	}
	
	return INT_TYPE;
}

Types checkInteger(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != INT_TYPE || right != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Integer Operands Required");
		return MISMATCH;
	}
	return INT_TYPE;
}

Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}
		return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}

Types checkIFThen(Types expression, Types left, Types right)
{
	if (expression != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "If Expression Must Be Boolean");
		return MISMATCH;
	} else
	{
		if (left != BOOL_TYPE || right !=BOOL_TYPE)
		{
			appendError(GENERAL_SEMANTIC, "If-Then Type Mismatch");
			return MISMATCH;
		}
			if ((left == INT_TYPE && right == REAL_TYPE) || (left == REAL_TYPE && right == INT_TYPE))
	{
		appendError(GENERAL_SEMANTIC, "Illegal Narrowing Function Return");
		return MISMATCH;
	}
	return INT_TYPE;
	}
	return BOOL_TYPE;
}

