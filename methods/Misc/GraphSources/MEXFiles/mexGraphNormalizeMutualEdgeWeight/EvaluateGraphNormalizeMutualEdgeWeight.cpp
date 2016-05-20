
#include "stdafx.h"
#include "EvaluateGraphNormalizeMutualEdgeWeight.h"

#include <string.h>
#include <math.h>
#include <vector>
#include <set>
#include <map>
#include <algorithm>
//#include "..\Utilities\Graph\TStaticGraph.h"
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
mxArray* pOutGraphLinks = NULL;

char DummyStr[256];
TStaticWeightedGraph Graph;
TMLDebugHelper MLDebugHelper;
std::vector<double> NormalizeMutualEdgeWeight;
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	//pInputGraph	=	NULL;
	pNodeIDs	=	NULL;

	if (nrhs!=1 ) { mexErrMsgTxt("One, two or three input arguments required."); }
	if (nlhs >1) {	mexErrMsgTxt("Up to one output arguments required.");	}

	NodeDegree.clear();
	NodeIDsVector.clear();
	NodeInterNeighboursLinks.clear();
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Assign(prhs[0],dirDirect);
	NumberOfLinksInGraph  = Graph.GetNumberOfLinks();
	std::vector< std::set<unsigned int> > OutGraph;
	OutGraph.resize(Graph.GetMaxNodeID()+1,std::set<unsigned int>());
	std::vector<unsigned int> NodeIDs = Graph.GetAllNodesIDs();
	for (unsigned int i = 1; i <= Graph.GetMaxNodeID(); ++i) {
		const std::vector<unsigned int>& Neighbours = Graph.Neighbours(i);
		for (std::vector<unsigned int>::const_iterator it = Neighbours.begin(); it!=Neighbours.end(); ++it) {
			OutGraph[i].insert(*it);
			OutGraph[*it].insert(i);
		}
	}
	unsigned int NumberOfLinks = 0;
	for (unsigned int i = 1; i < OutGraph.size(); ++i) { NumberOfLinks+=(unsigned int)OutGraph[i].size(); }

	pOutGraphLinks = mxCreateDoubleMatrix(NumberOfLinks,3,mxREAL);
	double* Ptr = mxGetPr(pOutGraphLinks);
	for (unsigned int i = 1; i < OutGraph.size(); ++i) {
		for (std::set<unsigned int>::const_iterator it = OutGraph[i].begin(); it != OutGraph[i].end(); ++it) {
			*Ptr = i;
			*(Ptr+NumberOfLinks) = *it;
			++Ptr;
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
double GetWeight(unsigned int Source, unsigned int Dest)
{
	if (Source == Dest) { return 0.0f; }
	const std::vector<unsigned int>& Neighbours = Graph.Neighbours(Source);
	const std::vector<double>& Weights	 = Graph.Weights(Source);
	for (unsigned int i = 0; i < Neighbours.size();  ++i) {
		if (Neighbours[i] == Dest) { return Weights[i]; }
	}
	return 0.0f;
}
double GetMutualWeight(unsigned int Source, unsigned int Dest)
{
	return (GetWeight(Source,Dest)+GetWeight(Dest,Source));
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	std::vector<double> TotalWeights(Graph.GetMaxNodeID()+1,0);
	unsigned int NumberOfLinks = (unsigned int)mxGetM(pOutGraphLinks);

	for (unsigned int i = 1; i <= Graph.GetMaxNodeID(); ++i) {
		const std::vector<double>& Weights		 = Graph.Weights(i);
		const std::vector<unsigned int>& Neighbours = Graph.Neighbours(i);
		for (unsigned int j = 0; j < Neighbours.size(); ++j) {
			TotalWeights[i]+= Weights[j];
			TotalWeights[ Neighbours[j] ]+= Weights[j];
		}
	}
	
	double* Links = mxGetPr(pOutGraphLinks);
	for (unsigned int i = 0; i < NumberOfLinks; ++i) {
		unsigned int Source = (unsigned int)(*(Links+i));
		unsigned int Dest = (unsigned int)(*(Links+i+NumberOfLinks));
		double Weight = GetMutualWeight(Source, Dest)/TotalWeights[Source];
		*(Links+i+2*NumberOfLinks) = Weight;
	}

}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	plhs[0] = pOutGraphLinks;

	Graph.Clear();
	NodeIDsVector.clear();
	NodeDegree.clear();
	NodeInterNeighboursLinks.clear();
	NormalizeMutualEdgeWeight.clear();
}
//------------------------------------------------------------------------------------------------------------------

/* sprintf(DummyStr,"%d ",It->second);
mexWarnMsgTxt(DummyStr);*/