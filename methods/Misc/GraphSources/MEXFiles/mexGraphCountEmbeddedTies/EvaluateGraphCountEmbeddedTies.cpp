

#include "EvaluateGraphCountEmbeddedTies.h"

#include <string.h>
#include <math.h>
#include <vector>
#include <set>
#include <map>
#include <algorithm>
#include "../Utilities/Graph/TStaticGraph.h"
#include "../Utilities/DebugHelper/MLDebugHelper.h"


const mxArray*	pNodePairs	=	NULL; 
mxArray* pEmbeddedTiesCount = NULL;

char DummyStr[256];
TStaticGraph Graph;
TMLDebugHelper MLDebugHelper;
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	
	if (nrhs <2 || nrhs > 3 ) { mexErrMsgTxt("Two or three input arguments required."); }
	if (nlhs >2) {	mexErrMsgTxt("At most two output arguments required.");	}

	pNodePairs	= prhs[1];

	if (mxGetNumberOfElements(pNodePairs)>0 && mxGetN(pNodePairs)!=2) { mexErrMsgTxt("The parameter NodePairs must be a 2-column list of pairs");	}
//	NodeDegree.clear();
//	NodeIDsVector.clear();
//	NodeInterNeighboursLinks.clear();
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	
	if (nrhs>2 && !mxIsEmpty(prhs[2])) {// create a list of links	
		Graph.Assign(prhs[0],prhs[2]); // Graph with reversed directionality of links will be created.
	}
	else {  Graph.Assign(prhs[0],dirDirect); }
	Graph.SortNodes();
	pEmbeddedTiesCount = mxCreateDoubleMatrix(	static_cast<int>(mxGetM(pNodePairs)), 1, mxREAL);
}
//------------------------------------------------------------------------------------------------------------------
template<typename T> void DoPerformCalculations(const TStaticGraph& theGraph, const T* Sources, const T* Dests, unsigned int PairsCount,double* Results)
{
	for (unsigned int PairIndex = 0; PairIndex <PairsCount; ++PairIndex) {
		unsigned int Source = static_cast<unsigned int>(Sources[PairIndex]+0.5);
		unsigned int Dest = static_cast<unsigned int>(Dests[PairIndex]+0.5);
		if (Source>Graph.GetMaxNodeID() || Dest>Graph.GetMaxNodeID()) { Results[PairIndex] = 0; }
		else {
			if ( Graph.Neighbours(Source) < Graph.Neighbours(Dest)) { std::swap(Source,Dest); } // The degree of Source is never smaller than that of Dest
			const std::vector<unsigned int>& SourceFriends =  Graph.Neighbours( Source);
			const std::vector<unsigned int>& DestFriends =  Graph.Neighbours(Dest);
			unsigned int Counter = 0, iSource=0, iDest=0;
			while (iSource < SourceFriends.size() && iDest < DestFriends.size()) { 
				if (SourceFriends[iSource] < DestFriends[iDest]) {  ++iSource; }
				else if (SourceFriends[iSource] > DestFriends[iDest]) { ++iDest; }
				else { ++Counter;  ++iSource;  ++iDest; }
			}
			Results[PairIndex] = Counter;
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	if (mxIsInt8( pNodePairs)) { 
		DoPerformCalculations(Graph, (const char*)(mxGetPr(pNodePairs)),(const char*)(mxGetPr(pNodePairs))+mxGetM(pNodePairs),(unsigned int)mxGetM(pNodePairs),mxGetPr(pEmbeddedTiesCount));
	}
	else  if (mxIsInt16( pNodePairs)) { 
		DoPerformCalculations(Graph, (const short*)(mxGetPr(pNodePairs)),(const short*)(mxGetPr(pNodePairs))+mxGetM(pNodePairs),(unsigned int)mxGetM(pNodePairs),mxGetPr(pEmbeddedTiesCount));
	}
	else  if (mxIsInt32( pNodePairs)) { 
		DoPerformCalculations(Graph, (const int*)(mxGetPr(pNodePairs)),(const int*)(mxGetPr(pNodePairs))+mxGetM(pNodePairs),(unsigned int)mxGetM(pNodePairs),mxGetPr(pEmbeddedTiesCount));
	}
	else  if (mxIsInt64( pNodePairs)) { 
		DoPerformCalculations(Graph, (const _int64*)(mxGetPr(pNodePairs)),(const _int64*)(mxGetPr(pNodePairs))+mxGetM(pNodePairs),(unsigned int)mxGetM(pNodePairs),mxGetPr(pEmbeddedTiesCount));
	}
	else  if (mxIsDouble( pNodePairs)) { 
		DoPerformCalculations(Graph, mxGetPr(pNodePairs),mxGetPr(pNodePairs)+mxGetM(pNodePairs),(unsigned int)mxGetM(pNodePairs),mxGetPr(pEmbeddedTiesCount));
	}
	else { mexErrMsgTxt("Unsupported data type for NodePairs"); }
	
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	plhs[0]=pEmbeddedTiesCount;
	if (nlhs>1) { 
		plhs[1] = mxDuplicateArray(pNodePairs);
	}
	Graph.Clear();

	}
//------------------------------------------------------------------------------------------------------------------
