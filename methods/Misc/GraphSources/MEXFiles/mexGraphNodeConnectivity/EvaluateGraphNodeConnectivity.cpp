

#include "EvaluateGraphNodeConnectivity.h"

#include <algorithm>
#include <math.h>

#include "../Utilities/DebugHelper/MLDebugHelper.h"
#include "../Utilities/Graph/TStaticGraph.h"

TStaticGraph Graph;
const mxArray*	pInputGraph	=	NULL;
std::vector<unsigned int> NodeIDs;

TMLDebugHelper MLDebugHelper;

std::vector<unsigned int>	Connectivity; // number of nodes linked to each of the NodeIDs
std::set<unsigned int>		ConnectivitySpectr;
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs < 2 || nrhs > 3  ) { mexErrMsgTxt("Two or three input arguments required."); }
	if (nlhs > 1	) {	mexErrMsgTxt("Up to 1 output argument allowed.");	}
	pInputGraph	= prhs[0];	
	
	// SourceNodeNumber = static_cast<unsigned int>(floor(0.5+mxGetScalar(prhs[1])));

	// NumberOfLinksInGraph = mxGetM(mxGetField(pInputGraph,0,"Data"));
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
	Connectivity.assign(  NodeIDs.size(), 0 );
	ConnectivitySpectr.clear();
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	
	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NodeIDs.size(); ++CurrentNodeIndex) { 
		unsigned int CurrentNodeID = NodeIDs[CurrentNodeIndex];
		std::vector<bool> IsConnected(Graph.GetNumberOfLinkedNodes()+1,false); // for each node in Graph, true if it is connected to the source.
		IsConnected[ NodeIDs[CurrentNodeIndex] ] = true;
		std::set<unsigned int> Shell; // list of nodes, conencted at the current distance (if shortes pass is followed).
//MLDebugHelper << "Index: " << CurrentNodeIndex << " Node: " << NodeIDs[CurrentNodeIndex] << " Connectivity: " << Connectivity[CurrentNodeIndex] <<  dbFlush;
		Shell.insert(NodeIDs[CurrentNodeIndex]);
		unsigned int Deapth = 0;
		while (!Shell.empty()) { // continue untill shell is not empty
			++Deapth ;
			std::set<unsigned int> NextShell;
			for (std::set<unsigned int>::const_iterator CurShell = Shell.begin(); CurShell != Shell.end(); ++CurShell) {
//				MLDebugHelper << "Shell Size: " << Shell.size() << " Shell Item:  " << *CurShell  <<  " Vector Size" << Graph.VectorSize() << dbFlush;
				if (*CurShell <= Graph.GetNumberOfLinkedNodes()) {
					const std::vector<unsigned int>& NewNeighbours = Graph.Neighbours(*CurShell);
//					MLDebugHelper << "Neighbours : " << NewNeighbours .size()   <<  dbFlush;
					for (std::vector<unsigned int>::const_iterator CurPotentialNeighbour = NewNeighbours.begin(); CurPotentialNeighbour != NewNeighbours.end(); ++CurPotentialNeighbour) {
						if (!IsConnected[*CurPotentialNeighbour]) { // found for the first time!
							NextShell.insert(*CurPotentialNeighbour);
							IsConnected[*CurPotentialNeighbour] = true;
						}
					}
				}
			}
			Shell = NextShell;
			Connectivity[CurrentNodeIndex] += (unsigned int)NextShell.size();  			
		}   // loop over shells - one per deapth.
		ConnectivitySpectr.insert(Connectivity[CurrentNodeIndex]);
		// MLDebugHelper << "Index: " << CurrentNodeIndex << " Node: " << NodeIDs[CurrentNodeIndex] << " Connectivity: " << Connectivity[CurrentNodeIndex] <<  dbFlush;				
	} // CurrentNodeIndex
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chNodeIDs		= "NodeIDs";
	const char* chConnectivity	= "Connectivity";
	const char* chHistogramX	= "HistogramX";
	const char* chHistogramY	= "HistogramY";

	const char* FieldNames[] = { chNodeIDs, chConnectivity, chHistogramX, chHistogramY};
	mxArray*		Result		=	mxCreateStructMatrix(1,1,4,FieldNames);

	mxSetField(Result,0,chNodeIDs,mxCreateDoubleMatrix(			(int)NodeIDs.size(), 1, mxREAL) );
	mxSetField(Result,0,chConnectivity,mxCreateDoubleMatrix(	(int)NodeIDs.size(), 1, mxREAL) );
	mxSetField(Result,0,chHistogramX,mxCreateDoubleMatrix(		(int)ConnectivitySpectr.size() , 1, mxREAL) );
	mxSetField(Result,0,chHistogramY,mxCreateDoubleMatrix(		(int)ConnectivitySpectr.size() , 1, mxREAL) );

	double* pNodeIDs		= mxGetPr(mxGetField(Result,0,chNodeIDs ));
	double* pConnectivity	= mxGetPr(mxGetField(Result,0,chConnectivity ));
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
	Connectivity.clear();
	NodeIDs.clear();
	ConnectivitySpectr.clear();
	Graph.Clear();

	plhs[0]=Result;
}
//------------------------------------------------------------------------------------------------------------------

