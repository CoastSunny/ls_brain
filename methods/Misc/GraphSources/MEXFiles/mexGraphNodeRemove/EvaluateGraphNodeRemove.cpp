
#include "EvaluateGraphNodeRemove.h"
#include "../Utilities/DebugHelper/MLDebugHelper.h"

#include <set>
#include <math.h>
//------------------------------------------------------------------------------------------------------------------
const mxArray*	pInputGraph		=	NULL;
mxArray*		pOutputGraph	=	NULL;
const mxArray*	pNodeIDs		=	NULL; 

unsigned int	NumberOfLinksInGraph	=	0;

std::set<unsigned int> NodesCollection;
std::set<unsigned int> LinksIndecesToRemove;
TMLDebugHelper  MLDebugHelper;



//------------------------------------------------------------------------------------------------------------------
const mxArray* GetIndexValues(const mxArray* Graph);
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	pInputGraph	=	NULL;
	pNodeIDs	=	NULL;

	if (nrhs <2  ) { mexErrMsgTxt("Two input arguments required."); }
	if (nlhs >1) {	mexErrMsgTxt("Up to one output arguments required.");	}
	pInputGraph	= prhs[0];	
	{
		mxArray *GraphType = mxCreateString("Graph");	
		mxArray *ErrorMessage = mxCreateString("The input must be of the type \"Graph\". Please use ObjectCreateGraph function");	
		mxArray *rhs[3] = {const_cast<mxArray*>(pInputGraph), GraphType, ErrorMessage};
		mxArray *lhs[1];
		mexCallMATLAB(0, lhs, 3, rhs, "ObjectIsType");
		mxDestroyArray(GraphType);		GraphType		=	NULL;
		mxDestroyArray(ErrorMessage);	ErrorMessage	=	NULL;
	}
	// NodeIDs:		prhs[1]
	pNodeIDs	= prhs[1];
	

//sprintf(DummyStr,"%d ",Direction);
//mexWarnMsgTxt(DummyStr);

	NumberOfLinksInGraph = static_cast<unsigned int>(mxGetM(mxGetField(pInputGraph,0,"Data")));

}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	const mxArray* const pData = mxGetField(pInputGraph,0,"Data"); 
	const double* const  DataPtr = mxGetPr(pData); 
	
	NodesCollection.clear();

	if (pNodeIDs && !mxIsEmpty(pNodeIDs)) {
		unsigned int NumberOfNodes	=	static_cast<unsigned int>(mxGetNumberOfElements(prhs[1]));
		const double* p = mxGetPr(pNodeIDs);
		for (unsigned int i = 0; i < NumberOfNodes; ++i) {
			NodesCollection.insert( (unsigned int)floor(p[i]+0.5) );
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	const mxArray* const pData = mxGetField(pInputGraph,0,"Data"); 
	const double* const  DataPtr = mxGetPr(pData); 
	LinksIndecesToRemove.clear();
	for (unsigned int i = 0; i <  NumberOfLinksInGraph; ++i) {
		if (NodesCollection.find((unsigned int)DataPtr[i])!=NodesCollection.end() || NodesCollection.find((unsigned int)DataPtr[i+NumberOfLinksInGraph])!=NodesCollection.end()) {
			LinksIndecesToRemove.insert(i);
		}
	}	
	unsigned int NumberOfLinksInNewGraph  =	  static_cast<unsigned int>(NumberOfLinksInGraph-LinksIndecesToRemove.size());
	mxArray* pNewGraph = mxCreateDoubleMatrix(NumberOfLinksInNewGraph,3,mxREAL);
	double* pNewGraphPtr = mxGetPr(pNewGraph); 
	for (unsigned int i = 0, j = 0; j < NumberOfLinksInGraph && i < NumberOfLinksInNewGraph; ++j) {
		if (LinksIndecesToRemove.find(j)==LinksIndecesToRemove.end()) {
			pNewGraphPtr[i]								= DataPtr[j];
			pNewGraphPtr[i+NumberOfLinksInNewGraph]		= DataPtr[j+NumberOfLinksInGraph];
			pNewGraphPtr[i+2*NumberOfLinksInNewGraph]	= DataPtr[j+2*NumberOfLinksInGraph];
			++i;
		}
	}
	pOutputGraph = mxDuplicateArray(pInputGraph);
	mxDestroyArray( mxGetField(pOutputGraph,0,"Data") );
	mxSetField(pOutputGraph,0,"Data",pNewGraph);

}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	NodesCollection.clear();
	LinksIndecesToRemove.clear();
	plhs[0] = pOutputGraph;
}
//------------------------------------------------------------------------------------------------------------------
const mxArray* GetIndexValues(const mxArray* Graph)
{
	const mxArray* Result = NULL;
	if (mxGetFieldNumber(Graph,"Index")!=-1) {
		const mxArray* pIndex =	mxGetField(Graph,0,"Index"); 
		if	(mxGetFieldNumber(pIndex,"Values")!=-1)	{
			Result = mxGetField(pIndex,0,"Values"); 		
		}
	}
	return Result;
}
//------------------------------------------------------------------------------------------------------------------