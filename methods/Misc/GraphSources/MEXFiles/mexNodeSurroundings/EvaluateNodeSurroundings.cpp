

#include "EvaluateNodeSurroundings.h"

#include <string.h>
#include <math.h>
#include <vector>
#include <set>
#include <list>
#include <map>
#include <algorithm>
#include "../Utilities/Graph/TStaticGraph.h"
#include "../Utilities/DebugHelper/MLDebugHelper.h"


const mxArray* pInputGraph	=	NULL;
const mxArray* NodeIDs		=	NULL;
unsigned int   Distance		=	0;
//enum EDirection { dirNone = -1, dirDirect=0, dirInverse=1, dirBoth = 2 };
EDirection	   Direction	=	dirNone;
unsigned int	NumberOfLinksInGraph	=	0;
unsigned int    NumberOfNodes = 0;
mxArray*		Result		=	NULL;


typedef std::set<unsigned int> TNodesCollection;
std::vector<unsigned int> vNodeIDs;

void	FindNeighbours(std::vector< std::vector<unsigned int> >& NodesAtDistance,unsigned int CurrentDistance,std::vector<bool>& VisitedNodes);
TStaticGraph Graph;
char DummyStr[256];
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Clear();
	vNodeIDs.clear();
	pInputGraph	=	NULL;
	NodeIDs		=	NULL;
	Distance		=	0;
	Direction	=	dirNone;
	NumberOfLinksInGraph	=	0;
	Result		=	NULL;

	if (nrhs < 3 || nrhs>4 ) {
		mexErrMsgTxt("Four input arguments required.");		
	}
	if (nlhs > 2) {
		mexErrMsgTxt("Up to two output arguments required.");		
	}
	pInputGraph	= prhs[0];
	
	mxArray *GraphType = mxCreateString("Graph");
	mxArray *ErrorMessage = mxCreateString("The input must be of the type \"Graph\". Please use ObjectCreateGraph function");	
	mxArray *rhs[3] = {const_cast<mxArray*>(pInputGraph), GraphType, ErrorMessage};
	mxArray *lhs[1];
	mexCallMATLAB(0, lhs, 3, rhs, "ObjectIsType");
	mxDestroyArray(GraphType);		GraphType		=	NULL;
	mxDestroyArray(ErrorMessage);	ErrorMessage	=	NULL;

	// NodeIDs:		prhs[1]
	if (!mxIsEmpty(prhs[1])) { 
		if (!mxIsDouble(prhs[1])) { mexErrMsgTxt("\"NodeIDs\" must be numerical");	}
		NodeIDs			=	prhs[1];
	}
	else { NodeIDs			= NULL; }

	// Distance: 	prhs[2]
	if (! mxIsDouble(prhs[2]) || mxGetNumberOfElements(prhs[2])!=1) {	mexErrMsgTxt("\"Distance\" must be scalar");	}
	Distance = (unsigned int)floor(mxGetScalar(prhs[2])+0.5);
	if (!Distance) { mexErrMsgTxt("\"Distance\" must be positive!");	}
	// Direction: prhs[3]
	if (nrhs>3) {
		if (!mxIsChar(prhs[3])) {	mexErrMsgTxt("\"Direction\" must be string: either \'direct\' or \'inverse\'.");	}
		char strDirection[16];
		mxGetString(prhs[3],strDirection,16);
		_strlwr_s(strDirection,16);
		if (strcmp(strDirection,"direct")==0) {Direction=dirDirect; }
		else if (strcmp(strDirection,"inverse")==0) {Direction=dirInverse; }
		else { mexErrMsgTxt("\"Direction\" must be string: either \'direct\' or \'inverse\'.");	}
	}
	else { Direction=dirDirect; }

	NumberOfLinksInGraph = static_cast<unsigned int>(mxGetM(mxGetField(pInputGraph,0,"Data")));
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs>3 && !mxIsEmpty(prhs[3])) {// create a list of links	
		Graph.Assign(prhs[0],prhs[3],true); // Graph with reversed directionality of links will be created.
	}
	else {  Graph.Assign(prhs[0],dirDirect,true); }
	NumberOfNodes = Graph.GetNumberOfLinkedNodes();
	NumberOfLinksInGraph = Graph.GetNumberOfLinks();
	if (NodeIDs==NULL)  {  vNodeIDs = Graph.GetAllNodesIDs();}
	else {
		vNodeIDs.reserve(  mxGetNumberOfElements(NodeIDs));
		for (double *CurrentNodeID = mxGetPr(NodeIDs); CurrentNodeID < mxGetPr(NodeIDs) + mxGetNumberOfElements(NodeIDs); ++CurrentNodeID) {
			vNodeIDs.push_back((unsigned int)floor(*CurrentNodeID+0.5));
		}
	}

	// create a list of links
	/*const double* const  DataPtr = mxGetPr(mxGetField(pInputGraph,0,"Data")); 
	unsigned int SourceShift = (Direction==dirDirect) ? 0 : NumberOfLinksInGraph;
	unsigned int DestinationShift = (Direction==dirDirect) ? NumberOfLinksInGraph : 0;

	for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
		Links.insert(std::multimap<unsigned int,unsigned int>::value_type( (unsigned int)floor( *(DataPtr+i+SourceShift) + 0.5),(unsigned int)floor( *(DataPtr+i+DestinationShift) + 0.5) ));
	}*/
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	
	//if (vNodeIDs.size>=1) {
		Result = mxCreateCellArray(mxGetNumberOfDimensions(NodeIDs),mxGetDimensions(NodeIDs));
	//}
	std::vector<bool> VisitedNodes(Graph.GetMaxNodeID()+1);
	for (std::vector<unsigned int>::const_iterator NodesIt = vNodeIDs.begin(); NodesIt != vNodeIDs.end(); ++NodesIt) {
		unsigned int CurrentNodeID  = *NodesIt;
		VisitedNodes.assign(Graph.GetMaxNodeID()+1,0);
		std::vector< std::vector<unsigned int> > NodesAtDistance(Distance+1);
		NodesAtDistance[0].push_back(CurrentNodeID);
		FindNeighbours(NodesAtDistance,1,VisitedNodes);

		//std::set<unsigned int> VisitedSet, CompleteResultSet;
			
		
		// remove neighbouts encountered on the way.
		mwSize CellArrayDims[2]; CellArrayDims[0] = Distance+1; CellArrayDims[1] = 1;
		mxArray* CurrentResult =  mxCreateCellArray(2,CellArrayDims);
		for (unsigned int Level = 0; Level <= Distance && NodesAtDistance[Level].size()>0; ++Level) {
			mxArray* CurrentNeighbours = mxCreateNumericMatrix((int)NodesAtDistance[Level].size(),1,mxINT32_CLASS,mxREAL);
			unsigned int* ResPtr = (unsigned int*)mxGetPr(CurrentNeighbours);
			std::copy(NodesAtDistance[Level].begin(),NodesAtDistance[Level].end(),ResPtr);
			/*
			for (std::set<unsigned int>::const_iterator It = NodesAtDistance[Level].begin();It !=NodesAtDistance[Level].end(); ++It,++ResPtr) {
				*ResPtr = *It;
			}*/
			mxSetCell(CurrentResult,Level,CurrentNeighbours);
		}
		// store results in mxArray
		if (!Result) { Result = CurrentResult; }
		else { mxSetCell(Result,(int)(NodesIt - vNodeIDs.begin()),CurrentResult); }		
	}
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Clear();
	vNodeIDs.clear();
	plhs[0]=Result;
	if (nlhs>1) {
		int NDims = (int)mxGetNumberOfDimensions(Result)+1;
		std::vector<int> Dims((int)mxGetDimensions(Result),(int)(mxGetDimensions(Result)+mxGetNumberOfDimensions(Result)));	
		Dims.push_back(Distance+1);
		int NFactor = 1;
		for (unsigned int i = 0; i < Dims.size(); ++i) {
			if (Dims[i]==1) { Dims.erase(Dims.begin()+i);	}
			if (i != Dims.size()-1) {	NFactor = NFactor * Dims[i]; }
		}
		mwSize *pDims = new mwSize[Dims.size()];
		for (unsigned int i = 0; i < Dims.size(); ++i) { pDims[i] = (mwSize)Dims[i]; }
		plhs[1] = mxCreateNumericArray((int)Dims.size(),pDims,mxDOUBLE_CLASS ,mxREAL);	
		delete pDims; pDims = NULL;
		double *pNNeighbours = mxGetPr(plhs[1]);
		for (unsigned int i = 0; i < mxGetNumberOfElements(Result); ++i) {
			const mxArray* CurrentNode = mxGetCell(Result,i);
			if (CurrentNode) {
				for (unsigned int j = 0; j < mxGetNumberOfElements(CurrentNode); ++j) {
					if (mxGetCell(CurrentNode,j)) {
						pNNeighbours[i + j*NFactor] = (double)mxGetNumberOfElements(mxGetCell(CurrentNode,j));
	sprintf_s(DummyStr,256,"%d i = %d j=%d  i + j*NFactor=%d",mxGetNumberOfElements(mxGetCell(CurrentNode,j)),i,j,i + j*NFactor);
	mexWarnMsgTxt(DummyStr);
					}
				}			
			}
			
		}		
	}
}
//------------------------------------------------------------------------------------------------------------------

void	FindNeighbours(std::vector< std::vector<unsigned int> >& NodesAtDistance,unsigned int CurrentDistance,std::vector<bool>& VisitedNodes)
{
	if (CurrentDistance>Distance || CurrentDistance==0) { return; }	
	static std::vector<unsigned int> NewLayer;	
	NewLayer.clear();
	NewLayer.reserve(Graph.GetMaxNodeID()+1);
	for (std::vector<unsigned int>::const_iterator itCurrentNodeID= NodesAtDistance[CurrentDistance-1].begin(); itCurrentNodeID!= NodesAtDistance[CurrentDistance-1].end(); ++itCurrentNodeID) {
		const std::vector<unsigned int>& Destinations = Graph.Neighbours(*itCurrentNodeID);	
		for (std::vector<unsigned int>::const_iterator itCurrentNeighbour = Destinations.begin(); itCurrentNeighbour != Destinations.end(); ++itCurrentNeighbour) {
			if (!VisitedNodes[*itCurrentNeighbour]) {
				VisitedNodes[*itCurrentNeighbour]=true;
				NewLayer.push_back(*itCurrentNeighbour);
				//NodesAtDistance[CurrentDistance].push_back(*itCurrentNeighbour);
			}
		}
	}
	NodesAtDistance[CurrentDistance] = NewLayer;
	if (CurrentDistance<Distance) {
		FindNeighbours(NodesAtDistance,CurrentDistance+1,VisitedNodes);
	}	
}
//------------------------------------------------------------------------------------------------------------------
/* sprintf(DummyStr,"%d ",It->second);
mexWarnMsgTxt(DummyStr);*/