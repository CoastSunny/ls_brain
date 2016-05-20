

#include "EvaluateGraphAverageNearestNeighbourDegree.h"
#include <mex.h>

#include <string.h>
#include <math.h>
#include <vector>
#include <set>
#include <map>
#include <algorithm>


const mxArray*	pInputGraph	=	NULL;
const mxArray*	pNodeIDs	=	NULL; 

unsigned int	NumberOfNodes	=	0;

enum EDirection { dirNone = -1, dirDirect=0, dirInverse=1, dirBoth = 2 };
EDirection	   Direction	=	dirNone;

unsigned int	NumberOfLinksInGraph	=	0;

std::vector<unsigned int> NodeIDsVector;			// holds the IDs of the nodes to check.
std::vector<unsigned int> NodeDegree,InNodeDegree,OutNodeDegree;				// for each node in NodeIDsVector, holds it's degree (number of neighbours)
std::vector<unsigned int> TotalInNeighborsDegree,TotalOutNeighborsDegree;

typedef std::set<unsigned int> TNodesCollection;

std::multimap<unsigned int,unsigned int> Links; // nodes are keys, liks from (to) that node (depending on the direction) are the values,

char DummyStr[256];

//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	pInputGraph	=	NULL;
	pNodeIDs	=	NULL;

	if (nrhs <1 || nrhs > 3 ) { mexErrMsgTxt("One, two or three input arguments required."); }
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
	pNodeIDs	= (nrhs>=2) ? prhs[1] : NULL;
	
	// Direction: prhs[2]
	if (nrhs>=3) {
		if (!mxIsChar(prhs[2])) {	mexErrMsgTxt("\"Direction\" must be string: either \'direct\', \'inverse\' or \'both\'.");	}
		char strDirection[16];
		mxGetString(prhs[2],strDirection,16);
		_strlwr_s(strDirection,16);
		if (strcmp(strDirection,"direct")==0) {Direction=dirDirect; }
		else if (strcmp(strDirection,"inverse")==0) {Direction=dirInverse; }
		else if (strcmp(strDirection,"both")==0) {Direction=dirBoth; }
		else { mexErrMsgTxt("\"Direction\" must be string: either \'direct\', \'inverse\' or \'both\'.");	}
	}
	else { Direction=dirDirect; }

//sprintf(DummyStr,"%d ",Direction);
//mexWarnMsgTxt(DummyStr);

	NumberOfLinksInGraph = static_cast<unsigned int>(mxGetM(mxGetField(pInputGraph,0,"Data")));

}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const mxArray* const pData = mxGetField(pInputGraph,0,"Data"); 
	const double* const  DataPtr = mxGetPr(pData); 
	std::set<unsigned int> NodesSet;
	if (pNodeIDs && !mxIsEmpty(pNodeIDs)) {
		NumberOfNodes	=	static_cast<unsigned int>(mxGetNumberOfElements(prhs[1]));
		const double* p = mxGetPr(pNodeIDs);
		for (unsigned int i = 0; i < NumberOfNodes; ++i) {
			NodesSet.insert( (unsigned int)floor(p[i]+0.5) );
		}
	}
	else {		
		for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
			NodesSet.insert(static_cast<unsigned int>(floor(*(mxGetPr(pData)+i)+0.5) ));
			NodesSet.insert(static_cast<unsigned int>(floor(*(mxGetPr(pData)+i+NumberOfLinksInGraph) +0.5)));
		}
	}
	NodeIDsVector.assign(NodesSet.begin(),NodesSet.end());
	NumberOfNodes = static_cast<unsigned int>(NodeIDsVector.size());
	// create a list of links
	if (Direction == dirBoth || Direction == dirDirect) {
		for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
			Links.insert(std::multimap<unsigned int,unsigned int>::value_type( (unsigned int)floor( *(DataPtr+i) + 0.5),(unsigned int)floor( *(DataPtr+i+NumberOfLinksInGraph) + 0.5) ));
		}
	}
	if (Direction == dirBoth || Direction == dirInverse) {
		for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
			Links.insert(std::multimap<unsigned int,unsigned int>::value_type( (unsigned int)floor( *(DataPtr+i+NumberOfLinksInGraph) + 0.5),(unsigned int)floor( *(DataPtr+i) + 0.5) ));
		}
	}
	mxArray* lhs[1] = { NULL };
	mxArray* rhs[1] = { const_cast<mxArray*>(pInputGraph) };
	mexCallMATLAB(1,lhs,1,rhs,"GraphCountNodesDegree");
	InNodeDegree.resize(NumberOfNodes,0);
	OutNodeDegree.resize(NumberOfNodes,0);
	for (unsigned int i = 0; i < NumberOfNodes; ++i) {
		InNodeDegree[i] = static_cast<unsigned int>(floor(0.5+*(mxGetPr(lhs[0])+i+NumberOfNodes)));
		OutNodeDegree[i] = static_cast<unsigned int>(floor(0.5+*(mxGetPr(lhs[0])+i+2*NumberOfNodes)));
	}
	mxDestroyArray(lhs[0]); lhs[0] = NULL;
	TotalInNeighborsDegree.resize(NumberOfNodes,0);
	TotalOutNeighborsDegree.resize(NumberOfNodes,0);
	NodeDegree.resize(NumberOfNodes,0);
}

//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NumberOfNodes; ++CurrentNodeIndex) {		
		unsigned int NodeID = NodeIDsVector[CurrentNodeIndex];
		std::pair<std::multimap<unsigned int,unsigned int>::const_iterator,std::multimap<unsigned int,unsigned int>::const_iterator> Destinations = Links.equal_range(NodeID);
		std::set<unsigned int> NodeNeibors;
		for (std::multimap<unsigned int,unsigned int>::const_iterator It = Destinations.first; It != Destinations.second; ++It) {
			TotalInNeighborsDegree[CurrentNodeIndex] +=  InNodeDegree[It->second-1];
			TotalOutNeighborsDegree[CurrentNodeIndex] += OutNodeDegree[It->second-1];
			++NodeDegree[CurrentNodeIndex];
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chNodeIDs = "NodeIDs";
	const char* chNodeDegrees = "NodeDegree";
	const char* chNodeInDegrees = "NodeInDegree";
	const char* chNodeOutDegrees = "NodeOutDegree";
	const char* chNodeAverageNeiborsInDegree = "NodeAverageNeiborsInDegree";
	const char* chNodeAverageNeiborsOutDegree = "NodeAverageNeiborsOutDegree";
	const char* chAverageNeiborsInDegree = "AverageNeiborsInDegree";
	const char* chAverageNeiborsOutDegree = "AverageNeiborsOutDegree";
	const char* chDegree = "Degree";
	const char* chDegreeHistogram = "DegreeHistogram"; // number of nodes having this number of neighbours (when the specified direction is followed)

	
//sprintf_s(DummyStr,256,"12");
//mexWarnMsgTxt(DummyStr);

	const char* FieldNames[] = { chNodeIDs, chNodeDegrees, chNodeInDegrees, chNodeOutDegrees, chNodeAverageNeiborsInDegree, chNodeAverageNeiborsOutDegree, chAverageNeiborsInDegree, chAverageNeiborsOutDegree, chDegree,chDegreeHistogram};
	mxArray*		Result		=	mxCreateStructMatrix(1,1,10,FieldNames);
	plhs[0]						=	Result;

	mxSetField(Result,0,chNodeIDs,						mxCreateDoubleMatrix(	NumberOfNodes	, 1, mxREAL) );
	mxSetField(Result,0,chNodeDegrees,					mxCreateDoubleMatrix(	NumberOfNodes	, 1, mxREAL) );
	mxSetField(Result,0,chNodeInDegrees,				mxCreateDoubleMatrix(	NumberOfNodes	, 1, mxREAL) );
	mxSetField(Result,0,chNodeOutDegrees,				mxCreateDoubleMatrix(	NumberOfNodes	, 1, mxREAL) );
	mxSetField(Result,0,chNodeAverageNeiborsInDegree,	mxCreateDoubleMatrix(	NumberOfNodes	, 1, mxREAL) );
	mxSetField(Result,0,chNodeAverageNeiborsOutDegree,	mxCreateDoubleMatrix(	NumberOfNodes	, 1, mxREAL) );

	double* pNodeIDs						=	mxGetPr(mxGetField(Result,0,chNodeIDs ));
	double* pNodeDegrees					=	mxGetPr(mxGetField(Result,0,chNodeDegrees ));
	double* pNodeInDegrees					=	mxGetPr(mxGetField(Result,0,chNodeInDegrees ));
	double* pNodeOutDegrees					=	mxGetPr(mxGetField(Result,0,chNodeOutDegrees ));
	double* pNodeAverageNeiborsInDegree		=	mxGetPr(mxGetField(Result,0,chNodeAverageNeiborsInDegree ));
	double* pNodeAverageNeiborsOutDegree	=	mxGetPr(mxGetField(Result,0,chNodeAverageNeiborsOutDegree ));

//sprintf_s(DummyStr,256,"13");
//mexWarnMsgTxt(DummyStr);

	std::set<unsigned int> Degrees;
	for (unsigned int i = 0; i < NumberOfNodes; ++i) {
		pNodeIDs[i]					=	NodeIDsVector[i];
		pNodeInDegrees[i]			=	InNodeDegree[i];
		pNodeOutDegrees[i]			=	OutNodeDegree[i];
		pNodeDegrees[i]				=	NodeDegree[i];
		Degrees.insert(NodeDegree[i]);
		if (NodeDegree[i]) {			
			pNodeAverageNeiborsInDegree[i]	=	((double)TotalInNeighborsDegree[i])/pNodeDegrees[i];
			pNodeAverageNeiborsOutDegree[i]	=	((double)TotalOutNeighborsDegree[i])/pNodeDegrees[i];
		}
		else {
			pNodeAverageNeiborsInDegree[i]	=	0.0;
			pNodeAverageNeiborsOutDegree[i]	=	0.0;		
		}
	}

//sprintf_s(DummyStr,256,"14");
//mexWarnMsgTxt(DummyStr);

	mxSetField(Result,0,chAverageNeiborsInDegree,	mxCreateDoubleMatrix(	static_cast<int>(Degrees.size())	, 1, mxREAL) );
	mxSetField(Result,0,chAverageNeiborsOutDegree,	mxCreateDoubleMatrix(	static_cast<int>(Degrees.size())	, 1, mxREAL) );
	mxSetField(Result,0,chDegree,					mxCreateDoubleMatrix(	static_cast<int>(Degrees.size())	, 1, mxREAL) );
	mxSetField(Result,0,chDegreeHistogram,			mxCreateDoubleMatrix(	static_cast<int>(Degrees.size())	, 1, mxREAL) );

	double* pDegree						=	mxGetPr(mxGetField(Result,0,chDegree ));
	double* pDegreeHistogram			=	mxGetPr(mxGetField(Result,0,chDegreeHistogram ));
	double* pAverageNeiborsInDegree		=	mxGetPr(mxGetField(Result,0,chAverageNeiborsInDegree ));
	double* pAverageNeiborsOutDegree	=	mxGetPr(mxGetField(Result,0,chAverageNeiborsOutDegree ));

	std::vector<unsigned int> vDegrees(Degrees.begin(),Degrees.end());
	std::sort(vDegrees.begin(),vDegrees.end());
	
	for (unsigned int i = 0; i < vDegrees.size(); ++i) {
		pDegree[i] = vDegrees[i];
	}

//sprintf_s(DummyStr,256,"15");
//mexWarnMsgTxt(DummyStr);

	for (unsigned int i = 0; i < NumberOfNodes; ++i) {
		unsigned int Index =static_cast<unsigned int>( std::find(vDegrees.begin(),vDegrees.end(),NodeDegree[i])-vDegrees.begin());
		if (Index < vDegrees.size()) {
			++pDegreeHistogram[Index];	
			pAverageNeiborsInDegree[Index]	+= pNodeAverageNeiborsInDegree[i];
			pAverageNeiborsOutDegree[Index] += pNodeAverageNeiborsOutDegree[i];
		}
	}

//sprintf_s(DummyStr,256,"16");
//mexWarnMsgTxt(DummyStr);

	for (unsigned int i = 0; i < vDegrees.size(); ++i) {
		pAverageNeiborsInDegree[i]	= pAverageNeiborsInDegree[i]	/ pDegreeHistogram[i]; 
		pAverageNeiborsOutDegree[i] = pAverageNeiborsOutDegree[i]	/ pDegreeHistogram[i];
	}

//sprintf_s(DummyStr,256,"17");
//mexWarnMsgTxt(DummyStr);

	TotalInNeighborsDegree.clear();
	TotalOutNeighborsDegree.clear();
	OutNodeDegree.clear();
	InNodeDegree.clear();
	NodeIDsVector.clear();
	NodeDegree.clear();
	Links.clear();
}
//------------------------------------------------------------------------------------------------------------------
