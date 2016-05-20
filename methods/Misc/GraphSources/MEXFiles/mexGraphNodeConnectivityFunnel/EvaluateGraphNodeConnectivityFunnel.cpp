

#include "EvaluateGraphNodeConnectivityFunnel.h"

#include <algorithm>
#include <numeric>

#include <list>
#include <map>
#include <queue>
#include <math.h>

#include "../Utilities/DebugHelper/MLDebugHelper.h"
#include "../Utilities/Graph/TStaticGraph.h"

TStaticGraph Graph;
const mxArray*	pInputGraph	=	NULL;
std::vector<unsigned int> NodeIDs;
unsigned int SourceNode = 0;

TMLDebugHelper MLDebugHelper;

std::vector< std::list<unsigned int> >	Connectivity; // for each node, lists  number of nodes linked to it at each distance.
//std::set<unsigned int>					ConnectivitySpectr;	 
std::map<unsigned int,unsigned int>			ConnectivitySpectr;


//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs < 1 || nrhs > 3  ) { mexErrMsgTxt("Two or three input arguments required."); }
	if (nlhs > 1	) {	mexErrMsgTxt("Up to 1 output argument allowed.");	}
	pInputGraph	= prhs[0];	
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
 	// create a list of links	
	if (nrhs>2) {
		Graph.Assign(pInputGraph,prhs[2]);
	}
	else {  Graph.Assign(pInputGraph,dirDirect); }

	if (nrhs>1 && !mxIsEmpty(prhs[1])) 	{
		NodeIDs.resize( mxGetNumberOfElements(prhs[1]), 0);
		const double* pNodeIDs = mxGetPr(prhs[1]);
		for (unsigned int i = 0; i < mxGetNumberOfElements(prhs[1]); ++i) {
			NodeIDs[i] = (unsigned int)floor(pNodeIDs[i]+0.5);
		}
		//std::copy( mxGetPr(prhs[1]),mxGetPr(prhs[1])+mxGetNumberOfElements(prhs[1]),NodeIDs.begin());
	}
	else {
		NodeIDs = Graph.GetAllNodesIDs();
	}
	// Connectivity.assign(  Graph.GetNumberOfLinkedNodes(), 0 );
	Connectivity.assign(  NodeIDs.size(), std::list<unsigned int>() );
	ConnectivitySpectr.clear();
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	bool *IsVisited = new bool[Graph.GetNumberOfLinkedNodes()+1];
	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NodeIDs.size(); ++CurrentNodeIndex) { 
		::memset(IsVisited,0,sizeof(bool)*(Graph.GetNumberOfLinkedNodes()+1));
		unsigned int CurrentNodeID = NodeIDs[CurrentNodeIndex];
		std::queue<unsigned int> QueueOfNeighbours;
		std::list<unsigned int> ListOfNeighbourCounts;
		
		IsVisited[CurrentNodeID] = true;
		QueueOfNeighbours.push(CurrentNodeID);
		ListOfNeighbourCounts.push_back(1);
		unsigned int TotalNumberOfNodes  = ListOfNeighbourCounts.back();
		do {
			unsigned int NextLevelSize = 0; // number of new encountered nodes at the next level.
			for (unsigned int i = 0; i < ListOfNeighbourCounts.back(); ++i) {
				const std::vector<unsigned int>& Neighbours = Graph.Neighbours(QueueOfNeighbours.front());
				QueueOfNeighbours.pop();
				for (std::vector<unsigned int>::const_iterator it = Neighbours.begin(); it != Neighbours.end(); ++it) {
					if (!IsVisited[*it]) {
						IsVisited[*it] = true;
						QueueOfNeighbours.push(*it);
						++NextLevelSize;						
					}
				}
			}
			ListOfNeighbourCounts.push_back(NextLevelSize);
			TotalNumberOfNodes += NextLevelSize;
		} while (!QueueOfNeighbours.empty());
		Connectivity[CurrentNodeIndex] = ListOfNeighbourCounts;
		++ConnectivitySpectr[TotalNumberOfNodes];	
	} // CurrentNodeIndex
	delete IsVisited;
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chNodeIDs				= "NodeIDs";
	const char* chConnectivity			= "Connectivity"; 
	const char* chConnectivityFunnel	= "ConnectivityFunnel";
	const char* chHistogramX			= "HistogramX";
	const char* chHistogramY			= "HistogramY";

	const char* FieldNames[] = { chNodeIDs, chConnectivity, chConnectivityFunnel, chHistogramX, chHistogramY};
	mxArray*		Result		=	mxCreateStructMatrix(1,1,5,FieldNames);

	mxSetField(Result,0,chNodeIDs,mxCreateDoubleMatrix(			(int)NodeIDs.size(), 1, mxREAL) );
	mxSetField(Result,0,chConnectivity,mxCreateDoubleMatrix(	(int)NodeIDs.size(), 1, mxREAL) );
	mxSetField(Result,0,chConnectivityFunnel,mxCreateCellMatrix((int)NodeIDs.size(), 1) );
	mxSetField(Result,0,chHistogramX,mxCreateDoubleMatrix(		(int)ConnectivitySpectr.size() , 1, mxREAL) );
	mxSetField(Result,0,chHistogramY,mxCreateDoubleMatrix(		(int)ConnectivitySpectr.size() , 1, mxREAL) );

	
	double* pNodeIDs			= mxGetPr(mxGetField(Result,0,chNodeIDs ));
	double* pConnectivity		= mxGetPr(mxGetField(Result,0,chConnectivity ));
	//double* pConnectivityFunnel	= mxGetPr(mxGetField(Result,0,chConnectivityFunnel ));
	double* pHistogramX			= mxGetPr(mxGetField(Result,0,chHistogramX ));
	double* pHistogramY			= mxGetPr(mxGetField(Result,0,chHistogramY ));  

	
	for (unsigned int i = 0; i < NodeIDs.size(); ++i) {
	
	  pNodeIDs[i]	= NodeIDs[i];
	  pConnectivity[i] = std::accumulate(Connectivity[i].begin(),Connectivity[i].end(),0);
	  
	  mxArray* NewNeighboursCount  = mxCreateDoubleMatrix((unsigned int)Connectivity[i].size(),1,mxREAL);	  
     // MLDebugHelper << "Size " << (int)mxGetNumberOfNodes(NewNeighboursCount) << dbFlush;
	  double* pNewNeighboursCount = mxGetPr(NewNeighboursCount);
	  for (std::list<unsigned int>::const_iterator It = Connectivity[i].begin(); It != Connectivity[i].end();++It,++pNewNeighboursCount) {	  
		  *pNewNeighboursCount = *It;
	  }
//	 MLDebugHelper <<  i << "  " << mxGetNumberOfElements(mxGetField(Result,0,chConnectivityFunnel)) << dbFlush;
     mxSetCell( mxGetField(Result,0,chConnectivityFunnel ), i, NewNeighboursCount);	  
	}
	unsigned int	j = 0; 
	for (std::map<unsigned int,unsigned int>::const_iterator It = ConnectivitySpectr.begin(); It != ConnectivitySpectr.end(); ++j, ++It) {
		 pHistogramX[j] = It->first;
		 pHistogramY[j]  = It->second;
	}
	Connectivity.clear();
	NodeIDs.clear();
	ConnectivitySpectr.clear();
	Graph.Clear();

	plhs[0]=Result;
}
//------------------------------------------------------------------------------------------------------------------
