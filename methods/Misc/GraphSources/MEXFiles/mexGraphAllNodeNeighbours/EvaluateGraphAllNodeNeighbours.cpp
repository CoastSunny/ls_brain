
#include "EvaluateGraphAllNodeNeighbours.h"


#include <string.h>
#include <math.h>
#include <vector>
#include <set>
#include <map>
#include <algorithm>

#include "../Utilities/DebugHelper/MLDebugHelper.h"
TMLDebugHelper MLDebugHelper;

const mxArray*	pInputGraph	=	NULL;
const mxArray*	pNodeIDs	=	NULL; 

unsigned int	NumberOfNodes	=	0;

enum EDirection { dirNone = -1, dirDirect=0, dirInverse=1, dirBoth = 2 };
EDirection	   Direction	=	dirNone;

unsigned int	NumberOfLinksInGraph	=	0;

std::vector<unsigned int> NodeIDsVector;			// holds the IDs of the nodes to check.
//std::vector<unsigned int> NodeDegree;				// for each node in NodeIDsVector, holds it's degree (number of neighbours)
//std::vector<unsigned int> NodeInterNeighboursLinks;	// for each node in NodeIDsVector, number of links between the neighbours of that node.


typedef std::set<unsigned int> TNodesCollection;

std::map<unsigned int,std::set<unsigned int> > Links; // nodes are keys, liks from (to) that node (depending on the direction) are the values,
std::map<unsigned int /*Node ID*/, std::set<unsigned int> /*Neighbours*/> Neighbours;

//unsigned int FindInterconnectedNodes(const TNodesCollection& Cluster );

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
			NodesSet.insert(static_cast<unsigned int>(floor(*(mxGetPr(pData)+i))+0.5) );
			NodesSet.insert(static_cast<unsigned int>(floor(*(mxGetPr(pData)+i+NumberOfLinksInGraph)+0.5)) );
		}
	}
	NodeIDsVector.assign(NodesSet.begin(),NodesSet.end());
	NumberOfNodes = static_cast<unsigned int>(NodeIDsVector.size());

	// create a list of links
	Links.clear();
	if (Direction == dirBoth || Direction == dirDirect) {
		for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
			std::set<unsigned int>& CurrentSet = Links[(unsigned int)floor( *(DataPtr+i) + 0.5)];
			CurrentSet.insert((unsigned int)floor( *(DataPtr+i+NumberOfLinksInGraph) + 0.5) );
			//Links.insert(std::multimap<unsigned int,unsigned int>::value_type( (unsigned int)floor( *(DataPtr+i) + 0.5),(unsigned int)floor( *(DataPtr+i+NumberOfLinksInGraph) + 0.5) ));
		}
	}
	if (Direction == dirBoth || Direction == dirInverse) {
		for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
			std::set<unsigned int>& CurrentSet = Links[(unsigned int)floor( *(DataPtr+i+NumberOfLinksInGraph) + 0.5)];
			CurrentSet.insert((unsigned int)floor( *(DataPtr+i) + 0.5) );
//			Links.insert(std::multimap<unsigned int,unsigned int>::value_type( (unsigned int)floor( *(DataPtr+i+NumberOfLinksInGraph) + 0.5),(unsigned int)floor( *(DataPtr+i) + 0.5) ));
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	Neighbours.clear();
	bool Proceed;
	int i = 0;
	do {
		Proceed = false;
		MLDebugHelper << (unsigned int)(++i) << dbFlush;
		
		//for (std::vector<unsigned int>::const_iterator CurrNodeID =  NodeIDsVector.begin();CurrNodeID !=  NodeIDsVector.end(); ++CurrNodeID) {
		{ 
			for (int k = 0; k < 1; ++k) {
				std::vector<unsigned int>::const_iterator CurrNodeID =  NodeIDsVector.begin()+k;// &NodeIDsVector[k];
				std::set<unsigned int>& NodesCollection = Links[*CurrNodeID];
				unsigned int OldSize = static_cast<unsigned int>(NodesCollection.size());
				for (std::set<unsigned int>::const_iterator CurrNeighbour = NodesCollection.begin(); CurrNeighbour != NodesCollection.end(); ++CurrNeighbour) {
					NodesCollection.insert(Links[*CurrNeighbour].begin(),Links[*CurrNeighbour].end());
				}
				NodesCollection.erase(*CurrNodeID);
				if (NodesCollection.size()!=OldSize) {
					Proceed = true;
				}
			}
		}
		
	}  while(Proceed && i < 1);
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
}
//------------------------------------------------------------------------------------------------------------------
