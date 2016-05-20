

#include "EvaluateGraphFlowHierarchy.h"

#include <map>
#include <vector>
#include <set>
#include <math.h>

const mxArray*	pInputGraph	=	NULL;

unsigned int MaxDeapth  = 0;
unsigned int NumberOfNodes  = 0;
unsigned int NumberOfLinksInGraph = 0;

std::vector<unsigned int> Histogram;
std::map<unsigned int,std::set<unsigned int> > Links; // nodes are keys, liks from (to) that node (depending on the direction) are the values,
std::map< unsigned int /*NodeID*/,unsigned int /*score*/ > NodeScores;
std::set<unsigned int> Nodes; // holds the list of nodes.
bool DisplayDebugInfo = false;

#include "../Utilities/DebugHelper/MLDebugHelper.h"

TMLDebugHelper  MLDebugHelper;
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	pInputGraph	=	NULL;

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
	// Find Node IDs
	{
		mxArray *rhs[1];  rhs[0]  = const_cast<mxArray*>(prhs[0]);
		mxArray *lhs[1];
		mexCallMATLAB(1, lhs, 1, rhs, "GraphNodeIDs");
		for (const double* p = mxGetPr(lhs[0]); p < mxGetPr(lhs[0])+mxGetNumberOfElements(lhs[0]); ++p) {
			Nodes.insert((unsigned int) (*p));
		}
		mxDestroyArray(lhs[0]); lhs[0] = NULL;	
	}	
	NumberOfNodes  = static_cast<unsigned int>(Nodes.size());
	
	if (nrhs < 2 ||  mxIsInf(mxGetScalar(prhs[1])) || (mxGetScalar(prhs[1]) > NumberOfNodes) ){ 
		MaxDeapth = NumberOfNodes;
	}
	else {
		MaxDeapth = (unsigned int)(floor(0.5+mxGetScalar(prhs[1])));
	}	
	NumberOfLinksInGraph = static_cast<unsigned int>(mxGetM(mxGetField(pInputGraph,0,"Data")));
	if (nrhs>2) { DisplayDebugInfo = (mxGetScalar(prhs[2])>0.5); }
	else { DisplayDebugInfo = false; }

		
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const mxArray* const pData = mxGetField(pInputGraph,0,"Data"); 
	const double* const  DataPtr = mxGetPr(pData); 
	// create a list of links
	for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
		std::set<unsigned int>& CurrentSet = Links[(unsigned int)floor( *(DataPtr+i) + 0.5)];
		CurrentSet.insert((unsigned int)floor( *(DataPtr+i+NumberOfLinksInGraph) + 0.5) );
	}
	Histogram.resize(MaxDeapth+1,0);
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	
	unsigned int Deapth = 0;
	std::set<unsigned int> NodesToScan = Nodes;
	do {
		std::set<unsigned int> FoundAtThisDeapth;
		for (std::set<unsigned int>::const_iterator NodeID =  NodesToScan.begin();NodeID !=  NodesToScan.end(); ++NodeID) {
			bool NotInList = false;
			if (Links.find(*NodeID) != Links.end() ) {
				const std::set<unsigned int>& CurrentNeighbours =  Links[*NodeID];			
				for (std::set<unsigned int>::const_iterator CurrentNeighbour = CurrentNeighbours.begin(); !NotInList && CurrentNeighbour != CurrentNeighbours.end(); ++CurrentNeighbour ) {
					if (NodeScores.find(*CurrentNeighbour)==NodeScores.end()) {
						NotInList = true;
					}
				}
			}
			else { 
				if (DisplayDebugInfo) { MLDebugHelper <<	"Oups..."  <<  *NodeID << dbFlush; }
			}
			if ( NotInList == false ) {				
				FoundAtThisDeapth.insert(*NodeID);				
			}
		}
		Histogram[Deapth] =	 static_cast<unsigned int>(FoundAtThisDeapth.size());
		for (std::set<unsigned int>::const_iterator It = FoundAtThisDeapth.begin(); It != FoundAtThisDeapth.end(); ++It) {
			Links.erase(*It);
			NodeScores[*It] = Deapth;
			NodesToScan.erase(*It);
		}
		++Deapth;
	} while ( !NodesToScan.empty() && Histogram[Deapth-1]>0 && Deapth<=MaxDeapth);
	if (DisplayDebugInfo) { 
		MLDebugHelper <<	"Nodes Left=" << static_cast<unsigned int>(NodesToScan.size()) <<   ". Last Value= " <<  Histogram[Deapth-1] << " .Deapth=" << Deapth << dbFlush;
	}
	MaxDeapth = Deapth;
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chNodeIDs		= "NodeIDs";
	const char* chNodeScores	= "NodeScores";
	const char* chHist			= "Hist";
	const char* chk				= "k";
	const char* chAverage		= "Average";	
	
  	const char* FieldNames[] = { chNodeIDs, chNodeScores, chHist, chk, chAverage };
	mxArray*		Result		=	mxCreateStructMatrix(1,1,5,FieldNames);

	mxSetField(Result,0,chNodeIDs,mxCreateDoubleMatrix(	NumberOfNodes, 1, mxREAL) );
	mxSetField(Result,0,chNodeScores,mxCreateDoubleMatrix(	NumberOfNodes, 1, mxREAL) );
	mxSetField(Result,0,chHist,mxCreateDoubleMatrix(	MaxDeapth+1, 1, mxREAL) );
	mxSetField(Result,0,chk,mxCreateDoubleMatrix(	MaxDeapth+1, 1, mxREAL) );
	mxSetField(Result,0,chAverage,mxCreateDoubleScalar(0.0) );

	double* pNodeIDs	= mxGetPr(mxGetField(Result,0,chNodeIDs ));
	double* pNodeScores = mxGetPr(mxGetField(Result,0,chNodeScores ));
	double* pHist		= mxGetPr(mxGetField(Result,0,chHist ));
	double* pk			= mxGetPr(mxGetField(Result,0,chk ));
	double* pAverage	= mxGetPr(mxGetField(Result,0,chAverage ));
	unsigned int NodeIndex = 0;

	for (unsigned int i = 0; i <  MaxDeapth+1; ++i) {
		pk[i]= i;
	}
	unsigned int TotalFound = 0;
	unsigned int CurrentNodeIndex = 0;
	if (DisplayDebugInfo) { MLDebugHelper <<	"Number of scored nodes: " <<    static_cast<unsigned int>(NodeScores.size())  << dbFlush; }
	for (std::set<unsigned int>::const_iterator NodeID = Nodes.begin(); NodeID != Nodes.end(); ++NodeID,++CurrentNodeIndex ) {
		pNodeIDs[CurrentNodeIndex]		= *NodeID;
		if (NodeScores.find(*NodeID)!=NodeScores.end()) {
			pNodeScores[CurrentNodeIndex]	=  NodeScores[*NodeID];
			++pHist[NodeScores[*NodeID]];
			*pAverage +=  NodeScores[*NodeID];
			++TotalFound;
		}
		else {
			pNodeScores[CurrentNodeIndex]	=  mxGetNaN();
		}
	}
	*pAverage =	   (TotalFound>0) ?  *pAverage/TotalFound : mxGetNaN();

	plhs[0] = Result;
	Histogram.clear();
	Nodes.clear();
	Links.clear();
	NodeScores.clear();
}
//------------------------------------------------------------------------------------------------------------------
