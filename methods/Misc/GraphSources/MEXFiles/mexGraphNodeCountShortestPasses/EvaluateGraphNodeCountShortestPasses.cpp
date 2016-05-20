

#include "EvaluateGraphNodeCountShortestPasses.h"

#include <algorithm>
#include <list>

#include "../Utilities/DebugHelper/MLDebugHelper.h"
#include "../Utilities/Graph/TStaticGraph.h"

TStaticGraph Graph;
const mxArray*	pInputGraph	=	NULL;
std::vector<unsigned int> NodeIDs;

TMLDebugHelper MLDebugHelper;

std::vector< unsigned int>					Connectivity;
std::vector< std::vector<unsigned int>  >	ShortestPassesCounter;// For each node of the NodeIDs, holds a vector with a number of shortest passes of each length
std::set<unsigned int>						ConnectivitySpectr;
unsigned int								MaxDeapth = 0;	

//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs < 2 || nrhs > 3  ) { mexErrMsgTxt("Two or three input arguments required."); }
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
			NodeIDs[i] = static_cast<unsigned int>(pNodeIDs[i]);
		}
	}
	else {
		NodeIDs = Graph.GetAllNodesIDs();
	}
	Connectivity.assign(  Graph.GetNumberOfLinkedNodes(), 0 );
	ShortestPassesCounter.assign(  Graph.GetNumberOfLinkedNodes(), std::vector<unsigned int>() );
	ConnectivitySpectr.clear();
	MaxDeapth = 0;
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NodeIDs.size(); ++CurrentNodeIndex) { 
		unsigned int CurrentNodeID = NodeIDs[CurrentNodeIndex];
		std::vector<bool> IsConnected(Graph.GetNumberOfLinkedNodes(),false); // for each node in Graph, true if it is connected to the source.
		IsConnected[ NodeIDs[CurrentNodeIndex] ] = true;
		std::set<unsigned int>	Shell; // list of nodes, conencted at the current distance (if shortes pass is followed).
		std::list<unsigned int> NumberOfShortestPasses;	// holds the number of shortes passes of each length.
		Shell.insert(NodeIDs[CurrentNodeIndex]);
		unsigned int Deapth = 0;
		while (!Shell.empty()) { // continue untill shell is not empty
			++Deapth ;
			std::set<unsigned int> NextShell;
			for (std::set<unsigned int>::const_iterator CurShell = Shell.begin(); CurShell != Shell.end(); ++CurShell) {
				const std::vector<unsigned int>& NewNeighbours = Graph.Neighbours(*CurShell);
				for (std::vector<unsigned int>::const_iterator CurPotentialNeighbour = NewNeighbours.begin(); CurPotentialNeighbour != NewNeighbours.end(); ++CurPotentialNeighbour) {
					if (!IsConnected[*CurPotentialNeighbour]) { // found for the first time!
						NextShell.insert(*CurPotentialNeighbour);
						IsConnected[*CurPotentialNeighbour] = true;
					}
				}
			}
			Shell = NextShell;
			Connectivity[CurrentNodeIndex] += static_cast<unsigned int>(NextShell.size());
			NumberOfShortestPasses.push_back(static_cast<unsigned int>(NextShell.size()));
		}   // loop over shells - one per deapth.
		if (MaxDeapth < Deapth) MaxDeapth = Deapth;
		ConnectivitySpectr.insert(Connectivity[CurrentNodeIndex]);
		ShortestPassesCounter[CurrentNodeIndex].assign(NumberOfShortestPasses.begin(),NumberOfShortestPasses.end());
		// MLDebugHelper << "Index: " << CurrentNodeIndex << " Node: " << NodeIDs[CurrentNodeIndex] << " Connectivity: " << Connectivity[CurrentNodeIndex] <<  dbFlush;				
	} // CurrentNodeIndex
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chNodeIDs		= "NodeIDs";
	const char* chConnectivity	= "Connectivity";
	const char* chPassesCount	= "PassesCount";	// 
	const char* chHistogramX	= "HistogramX";
	const char* chHistogramY	= "HistogramY";

	const char* FieldNames[] = { chNodeIDs, chConnectivity, chPassesCount, chHistogramX, chHistogramY};
	mxArray*		Result		=	mxCreateStructMatrix(1,1,5,FieldNames);

	mxSetField(Result,0,chNodeIDs,mxCreateDoubleMatrix(	static_cast<int>(NodeIDs.size()), 1, mxREAL) );
	mxSetField(Result,0,chConnectivity,mxCreateDoubleMatrix(	static_cast<int>(NodeIDs.size()), 1, mxREAL) );
	mxSetField(Result,0,chPassesCount,mxCreateDoubleMatrix(	static_cast<int>(NodeIDs.size()), MaxDeapth, mxREAL) );
	mxSetField(Result,0,chHistogramX,mxCreateDoubleMatrix(	static_cast<int>(ConnectivitySpectr.size()) , 1, mxREAL) );
	mxSetField(Result,0,chHistogramY,mxCreateDoubleMatrix(	static_cast<int>(ConnectivitySpectr.size()) , 1, mxREAL) );

	double* pNodeIDs		= mxGetPr(mxGetField(Result,0,chNodeIDs ));
	double* pConnectivity	= mxGetPr(mxGetField(Result,0,chConnectivity ));
	double* pPassesCount	= mxGetPr(mxGetField(Result,0,chPassesCount ));
	double* pHistogramX		= mxGetPr(mxGetField(Result,0,chHistogramX ));
	double* pHistogramY		= mxGetPr(mxGetField(Result,0,chHistogramY ));  
	
	for (unsigned int i = 0; i < NodeIDs.size(); ++i) {
	  pNodeIDs[i]	= NodeIDs[i];
	  pConnectivity[i] = Connectivity[i];
	}
	unsigned int	j = 0; 
	for (std::set<unsigned int>::const_iterator It = ConnectivitySpectr.begin(); It != ConnectivitySpectr.end(); ++j, ++It) {
		pHistogramX[j] = *It;
	}
	for (unsigned int i = 0; i < Connectivity.size(); ++i) {
		const double* Location = std::find(pHistogramX,pHistogramX+ConnectivitySpectr.size(),Connectivity[i]);
		++pHistogramY[ Location -pHistogramX];
	}

	for (unsigned int i = 0; i < NodeIDs.size(); ++i) {
		const std::vector<unsigned int>& CurrentPasses = ShortestPassesCounter[i];
		for (unsigned int k = 0; k < CurrentPasses.size(); ++k) {
			pPassesCount[i + k*NodeIDs.size()] = CurrentPasses[k];
		}
		for (unsigned int k = static_cast<int>(CurrentPasses.size()); k < MaxDeapth; ++k) {
			pPassesCount[i + k*NodeIDs.size()] = 0;
		}
	}

	Connectivity.clear();
	NodeIDs.clear();
	ConnectivitySpectr.clear();
	Graph.Clear();
	ShortestPassesCounter.clear();
	plhs[0]=Result;
}
//------------------------------------------------------------------------------------------------------------------

