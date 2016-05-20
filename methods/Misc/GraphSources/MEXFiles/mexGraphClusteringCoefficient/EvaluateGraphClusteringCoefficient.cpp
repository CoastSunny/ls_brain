

#include "EvaluateGraphClusteringCoefficient.h"

#include <string.h>
#include <math.h>
#include <vector>
#include <set>
#include <map>
#include <algorithm>
#include "../Utilities/Graph/TStaticGraph.h"
#include "../Utilities/DebugHelper/MLDebugHelper.h"

//const mxArray*	pInputGraph	=	NULL;
const mxArray*	pNodeIDs	=	NULL; 

unsigned int	NumberOfNodes	=	0;

unsigned int	NumberOfLinksInGraph	=	0;

std::vector<unsigned int> NodeIDsVector;			// holds the IDs of the nodes to check.
std::vector<unsigned int> NodeDegree;				// for each node in NodeIDsVector, holds it's degree (number of neighbours)
std::vector<unsigned int> NodeInterNeighboursLinks;	// for each node in NodeIDsVector, number of links between the neighbours of that node.


typedef std::vector<unsigned int> TNodesCollection;

//std::map<unsigned int,std::set<unsigned int> > Links; // nodes are keys, liks from (to) that node (depending on the direction) are the values,

unsigned int FindInterconnectedNodes(const TNodesCollection& Cluster );

char DummyStr[256];
TStaticGraph Graph;
TMLDebugHelper MLDebugHelper;
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	//pInputGraph	=	NULL;
	pNodeIDs	=	NULL;

	if (nrhs <1 || nrhs > 3 ) { mexErrMsgTxt("One, two or three input arguments required."); }
	if (nlhs >1) {	mexErrMsgTxt("Up to one output arguments required.");	}
	
	if (nrhs<2 || mxIsEmpty(prhs[1])) { pNodeIDs = NULL;	}
	else if (!mxIsDouble(prhs[1])) {mexErrMsgTxt("Second parameter must be vector of doubles or empty"); }
	else { 	pNodeIDs	= prhs[1]; }

	NodeDegree.clear();
	NodeIDsVector.clear();
	NodeInterNeighboursLinks.clear();
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	if (nrhs>2 && !mxIsEmpty(prhs[2])) {// create a list of links	
		Graph.Assign(prhs[0],prhs[2]); // Graph with reversed directionality of links will be created.
	}
	else {  Graph.Assign(prhs[0],dirDirect); }
	NumberOfLinksInGraph  = Graph.GetNumberOfLinks();

	//const mxArray* const pData = mxGetField(pInputGraph,0,"Data"); 
	//const double* const  DataPtr = mxGetPr(pData); 
	std::vector<bool> NodesSet;
	if (pNodeIDs && !mxIsEmpty(pNodeIDs)) {
		NumberOfNodes	=	static_cast<unsigned int>(mxGetNumberOfElements(prhs[1]));
		NodeIDsVector.reserve(NumberOfNodes);
		const double* p = mxGetPr(pNodeIDs);
		for (unsigned int i = 0; i < NumberOfNodes; ++i) {
			NodeIDsVector.push_back( (unsigned int)floor(p[i]+0.5));
		}		
	}
	else {		
		NodeIDsVector = Graph.GetAllNodesIDs();
	}
	NumberOfNodes = static_cast<unsigned int>(NodeIDsVector.size());
	
	NodeDegree.resize(NodeIDsVector.size(),0);
	NodeInterNeighboursLinks.resize(NodeIDsVector.size(),0);
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NumberOfNodes; ++CurrentNodeIndex) {		
		unsigned int NodeID = NodeIDsVector[CurrentNodeIndex];
		if (NodeID<=Graph.GetMaxNodeID()) {
			const TNodesCollection& Cluster = Graph.Neighbours(NodeID);
			NodeDegree[CurrentNodeIndex] = static_cast<unsigned int>(Cluster.size());
			if (Cluster.size()>1) {
				NodeInterNeighboursLinks[CurrentNodeIndex] = FindInterconnectedNodes(Cluster);
			}		
		}
	}	
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chNodeIDs = "NodeIDs";
	const char* chNodeDegrees = "NodeDegrees";
	const char* chNodeNeighboursLinks = "NodeNeighboursLinks";
	const char* chNodeClusteringCoefficient = "NodeClusteringCoefficient";
	const char* chCk = "Ck";
	const char* chk	 = "k";
	const char* chC = "C";
	const char* chCave = "Cave";

	const char* FieldNames[] = { chNodeIDs, chNodeDegrees, chNodeNeighboursLinks, chNodeClusteringCoefficient, chCk, chk, chC,chCave };
	mxArray*		Result		=	mxCreateStructMatrix(1,1,8,FieldNames);

	mxSetField(Result,0,chNodeIDs,mxCreateDoubleMatrix(	static_cast<int>(NodeIDsVector.size()), 1, mxREAL) );
	mxSetField(Result,0,chNodeDegrees,mxCreateDoubleMatrix(	static_cast<int>(NodeIDsVector.size()), 1, mxREAL) );
	mxSetField(Result,0,chNodeNeighboursLinks,mxCreateDoubleMatrix(	static_cast<int>(NodeIDsVector.size()), 1, mxREAL) );
	mxSetField(Result,0,chNodeClusteringCoefficient,mxCreateDoubleMatrix(	static_cast<int>(NodeIDsVector.size()), 1, mxREAL) );

	double* pNodeIDs =	mxGetPr(mxGetField(Result,0,chNodeIDs ));
	double* pNodeDegrees = mxGetPr(mxGetField(Result,0,chNodeDegrees ));
	double* pNodeNeighboursLinks = mxGetPr(mxGetField(Result,0,chNodeNeighboursLinks ));
	double* pNodeClusteringCoefficient = mxGetPr(mxGetField(Result,0,chNodeClusteringCoefficient ));

	std::set<unsigned int> Degrees;
	double AverageCC = 0.0;
	for (unsigned int i = 0; i < NodeIDsVector.size(); ++i) {
		pNodeIDs[i] = NodeIDsVector[i];
		pNodeDegrees[i] = NodeDegree[i];
		Degrees.insert(NodeDegree[i]);
		pNodeNeighboursLinks[i] = NodeInterNeighboursLinks[i];		
		if (pNodeDegrees[i]>1) {
			pNodeClusteringCoefficient[i] = pNodeNeighboursLinks[i]/(pNodeDegrees[i]*(pNodeDegrees[i]-1));
		}
		else {	pNodeClusteringCoefficient[i] = 0;	} // Nodes with 0 degree are also counted when <Ck> is computed!!!
		AverageCC+=pNodeClusteringCoefficient[i];
	}
	if (NodeIDsVector.size()>0) {  mxSetField(Result,0,chCave,mxCreateDoubleScalar(AverageCC/NodeIDsVector.size()) ); }
	else  { mxSetField(Result,0,chCave,mxCreateDoubleScalar( mxGetNaN()) ); }

	mxSetField(Result,0,chCk,mxCreateDoubleMatrix(	static_cast<int>(Degrees.size()), 1, mxREAL) );
	mxSetField(Result,0,chk,mxCreateDoubleMatrix(	static_cast<int>(Degrees.size()), 1, mxREAL) );
	mxSetField(Result,0,chC,mxCreateDoubleScalar(0.0) );
	
	
	
	double* pCk  = mxGetPr(mxGetField(Result,0,chCk ));
	double* pk  = mxGetPr(mxGetField(Result,0,chk ));
	double* pC   = mxGetPr(mxGetField(Result,0,chC ));

	memset(pCk,0,sizeof(double)*Degrees.size());
	memset(pk,0,sizeof(double)*Degrees.size());

	std::vector<unsigned int> DegreesVector(Degrees.begin(),Degrees.end());
	std::sort(DegreesVector.begin(),DegreesVector.end());
	std::vector<unsigned int> NodeDegreeHistogram(Degrees.size(),0);
	unsigned int NumberOfNodesToComputeAverage = 0;
	for (unsigned int i = 0; i < NodeIDsVector.size(); ++i) {		
		if (NodeDegree[i]>1 && pNodeClusteringCoefficient[i]!= mxGetNaN()) {
			unsigned int Index = static_cast<unsigned int>(std::find(DegreesVector.begin(),DegreesVector.end(),NodeDegree[i])-DegreesVector.begin());
			if (Index < DegreesVector.size()) {
				++NodeDegreeHistogram[Index];
				pCk[Index] += pNodeClusteringCoefficient[i];
                *pC += pNodeClusteringCoefficient[i];
				++NumberOfNodesToComputeAverage;
			}
		}
	}
	if (NumberOfNodesToComputeAverage) {	*pC = *pC/NumberOfNodesToComputeAverage; }
	for (unsigned int i = 0; i < Degrees.size(); ++i) {
		if (NodeDegreeHistogram[i]) {
			pCk[i] = pCk[i]/(double)NodeDegreeHistogram[i];
			pk[i] = DegreesVector[i];
		}
	}
	plhs[0]=Result;

	Graph.Clear();
	NodeIDsVector.clear();
	NodeDegree.clear();
	NodeInterNeighboursLinks.clear();	
}
//------------------------------------------------------------------------------------------------------------------
// The function receives the list of nodes (Cluster).
// InterconnectedNodes holds the links within the cluster in the specified Direction.
// The function returns the number of the in-cluster links (InterconnectedNodes.size())
unsigned int FindInterconnectedNodes(const TNodesCollection& Cluster )
{
	unsigned int NumberOfInterconnectedNodes = 0;	
	for (TNodesCollection::const_iterator CurrentNode = Cluster.begin(); CurrentNode != Cluster.end(); ++CurrentNode) {
		const TNodesCollection& NodeNeibors = Graph.Neighbours(*CurrentNode);
		//std::set_intersection( NodeNeibors.begin(),NodeNeibors.end(), Cluster.begin(), Cluster.end(),InterconnectedNodes.end() );
		for (TNodesCollection::const_iterator It1 = Cluster.begin(), It2 = NodeNeibors.begin(); It1 != Cluster.end() && It2 != NodeNeibors.end(); ) {
			if (*It1==*It2) { ++NumberOfInterconnectedNodes; ++It1; ++It2; }
			else if (*It1 < *It2) { ++It1; }
			else { ++It2; }
		}
	}
	return NumberOfInterconnectedNodes;
}
//------------------------------------------------------------------------------------------------------------------
/* sprintf(DummyStr,"%d ",It->second);
mexWarnMsgTxt(DummyStr);*/