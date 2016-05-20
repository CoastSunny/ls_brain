


#include "TBasicGraph.h"
//----------------------------------------------------------------------------------
void StringToLower(char* Str) 
{
	if (Str) {
		while (*Str) {
			if ( *Str>='A' && *Str<='Z' ) { *Str += ('a'-'A'); }
			++Str;
		}
	}
}
//----------------------------------------------------------------------------------
void TBasicGraph::SetDir(EDirection value,bool Inverse)
{ 
	if (Inverse && value==dirDirect) {
		value = dirInverse;
	}
	else if (Inverse && value==dirInverse) { 
		value = dirDirect;
	}
	FDir	=	value; 
}
//----------------------------------------------------------------------------------
void		TBasicGraph::CheckIfGraph(const mxArray*	pInputGraph)
{
		mxArray *GraphType = mxCreateString("Graph");	
		mxArray *ErrorMessage = mxCreateString("The input must be of the type \"Graph\". Please use ObjectCreateGraph function");	
		mxArray *rhs[3] = {const_cast<mxArray*>(pInputGraph), GraphType, ErrorMessage};
		mxArray *lhs[1];
		mexCallMATLAB(0, lhs, 3, rhs, "ObjectIsType");
		mxDestroyArray(GraphType);		GraphType		=	NULL;
		mxDestroyArray(ErrorMessage);	ErrorMessage	=	NULL;
}
//----------------------------------------------------------------------------------
EDirection	TBasicGraph::GetDirection(const mxArray*	Direction)
{
		EDirection	 TheDirection;
		if (!mxIsChar(Direction)) {	mexErrMsgTxt("\"Direction\" must be string: either \'direct\' or \'inverse\' or \'both\'.");	}
		char strDirection[16];
		mxGetString(Direction,strDirection,16);
		StringToLower(strDirection);
		if (strcmp(strDirection,"direct")==0)			{TheDirection = dirDirect; }
		else if (strcmp(strDirection,"inverse")==0)		{TheDirection = dirInverse; }
		else if (strcmp(strDirection,"both")==0)		{TheDirection = dirBoth; }
		else { 
				char Str[256];
				sprintf_s(Str,256,"\"Direction\" must be string: either \'direct\' or \'inverse\' or \'both\'.Got: %s",strDirection);
				mexErrMsgTxt( Str);	
		}
		return TheDirection;
}
//----------------------------------------------------------------------------------
void TBasicGraph::Clear()
{
	FNumberOfLinkedNodes	=	0;
	FNumberOfLinks			=	0;
	// FDir					=	dirDirect;
}
//----------------------------------------------------------------------------------