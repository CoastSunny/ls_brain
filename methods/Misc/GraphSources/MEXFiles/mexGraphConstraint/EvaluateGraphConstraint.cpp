
#include "stdafx.h"
#include "EvaluateGraphConstraint.h"

#include <string.h>
#include <math.h>
#include <vector>
#include <set>
#include <map>
#include <algorithm>
#include "..\Utilities\Graph\TStaticGraph.h"
#include "..\Utilities\Graph\TStaticWeightedGraph.h"
#include "..\Utilities\DebugHelper\MLDebugHelper.h"

//const mxArray*	pInputGraph	=	NULL;
const mxArray*	pNodeIDs	=	NULL; 

unsigned int	NumberOfNodes	=	0;

unsigned int	NumberOfLinksInGraph	=	0;

std::vector<unsigned int> NodeIDsVector;			// holds the IDs of the nodes to check.
std::vector<unsigned int> NodeDegree;				// for each node in NodeIDsVector, holds it's degree (number of neighbours)
std::vector<unsigned int> NodeInterNeighboursLinks;	// for each node in NodeIDsVector, number of links between the neighbours of that node.


typedef std::vector<unsigned int> TNodesCollection;
typedef std::vector<double>       TNodesCollectionWeights;

//std::map<unsigned int,std::set<unsigned int> > Links; // nodes are keys, liks from (to) that node (depending on the direction) are the values,

unsigned int FindInterconnectedNodes(const TNodesCollection& Cluster );

char DummyStr[256];
TStaticWeightedGraph Graph;
TMLDebugHelper MLDebugHelper;
std::vector<double> Constraint;
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	//pInputGraph	=	NULL;
	pNodeIDs	=	NULL;

	if (nrhs <1 || nrhs > 3 ) { mexErrMsgTxt("One, two or three input arguments required."); }
	if (nlhs >1) {	mexErrMsgTxt("Up to one output arguments required.");	}

	pNodeIDs	= (nrhs>=2) ? prhs[1] : NULL;

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
	//std::vector<bool> NodesSet;
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
	Constraint.resize(NodeIDsVector.size(),0);
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NumberOfNodes; ++CurrentNodeIndex) {		
		unsigned int NodeID = NodeIDsVector[CurrentNodeIndex];
		if (NodeID<=Graph.GetMaxNodeID()) {
			const TNodesCollection& Cluster = Graph.Neighbours(NodeID);
			const TNodesCollectionWeights& ClusterWeights = Graph.Weights(NodeID);
			NodeDegree[CurrentNodeIndex] = static_cast<unsigned int>(Cluster.size());
			double CurrentConstraint = 0.0f;
			for (unsigned int j = 0; j < Cluster.size(); ++j) {
				double CountraintJ = ClusterWeights[j]; 
				const TNodesCollection& ClusterJ = Graph.Neighbours(Cluster[j]);
				const TNodesCollectionWeights& ClusterWeightsJ = Graph.Weights(Cluster[j]);
				for (unsigned int k =0; k < ClusterJ.size(); ++k) { // O(n^2). Can be O(n) if sorted. To sort: implement Sort function in GraphWeighted
					if (std::find(Cluster.begin(), Cluster.end(), ClusterJ[k])!=Cluster.end()) {
						CountraintJ += (ClusterWeights[j]*ClusterWeightsJ[k]);
					}
				}
				CurrentConstraint += (CountraintJ*CountraintJ); 
			}
			Constraint[CurrentNodeIndex] = CurrentConstraint;
		}
	}	
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chNodeIDs = "NodeIDs";
	const char* chNodeDegrees = "NodeDegrees";
	const char* chNodeConstraint = "NodeConstraint";
	
	const char* FieldNames[] = { chNodeIDs, chNodeDegrees, chNodeConstraint };
	mxArray*		Result		=	mxCreateStructMatrix(1,1,3,FieldNames);

	mxSetField(Result,0,chNodeIDs,mxCreateDoubleMatrix(	static_cast<int>(NodeIDsVector.size()), 1, mxREAL) );
	mxSetField(Result,0,chNodeDegrees,mxCreateDoubleMatrix(	static_cast<int>(NodeIDsVector.size()), 1, mxREAL) );
	mxSetField(Result,0,chNodeConstraint,mxCreateDoubleMatrix(	static_cast<int>(NodeIDsVector.size()), 1, mxREAL) );

	double* pNodeIDs =	mxGetPr(mxGetField(Result,0,chNodeIDs ));
	double* pNodeDegrees = mxGetPr(mxGetField(Result,0,chNodeDegrees ));
	double* pNodeConstraint = mxGetPr(mxGetField(Result,0,chNodeConstraint ));

	std::set<unsigned int> Degrees;
	for (unsigned int i = 0; i < NodeIDsVector.size(); ++i) {
		pNodeIDs[i] = NodeIDsVector[i];
		pNodeDegrees[i] = NodeDegree[i];
		pNodeConstraint[i] =Constraint[i];
	}
	plhs[0]=Result;

	Graph.Clear();
	NodeIDsVector.clear();
	NodeDegree.clear();
	NodeInterNeighboursLinks.clear();
	Constraint.clear();
}
//------------------------------------------------------------------------------------------------------------------

/* sprintf(DummyStr,"%d ",It->second);
mexWarnMsgTxt(DummyStr);*/