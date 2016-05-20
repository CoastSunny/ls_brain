
#include "EvaluateGraphConnectedComponents.h"

#include <Windows.h>

#include <string.h>
#include <math.h>
#include <vector>
#include <numeric>
#include <list>
#include <set>
#include <map>
#include <queue>
#include <algorithm>

#include "../Utilities/DebugHelper/MLDebugHelper.h"

const mxArray*	pInputGraph	=	NULL;

unsigned int	NumberOfLinksInGraph	=	0;

typedef std::set<unsigned int> TNodesCollection;

//std::vector<unsigned int> NodesList; // List of nodes which are yet not processed.
std::vector<bool> NodesList; // List of nodes which are yet not processed.

typedef std::vector<std::vector<unsigned int> > TGraph;
TGraph Links,LinksT; // nodes are keys, liks from (to) that node (depending on the direction) are the values,

// Defines connected components - each indexed cluster lists nodes belonging to it.
typedef std::map<unsigned int /*DFS Deapth */, std::set<unsigned int> /*NodeIDs*/> TDFSResult;
unsigned int MaxNodeIndex  = 0;
std::vector< std::set<unsigned int> > Components;

char DummyStr[256];
TMLDebugHelper MLDebugHelper;
//------------------------------------------------------------------------------------------------------------------
struct DFS_Data {
	enum ENodeScanStatus : char {
		White,
		Grey,
		Black
	};
	DFS_Data() 
	{ 
		DiscoveryTime  = 0;
		FinishTime = 0;
		Predecessor = 0;
		Status = White;
		FinishTimeOrder = 0;
	}
	unsigned int	DiscoveryTime;
	unsigned int	FinishTime;
	unsigned int	Predecessor;
	unsigned int    FinishTimeOrder;
	ENodeScanStatus Status;
};

unsigned int DFS(const TGraph& Graph,std::vector<DFS_Data>& GraphData,const std::vector<bool>& Nodes,const std::vector<unsigned int>& ScanOrder);
void FindComponents(const std::vector<DFS_Data>& GraphData,std::vector< std::set<unsigned int> >& Components);
//------------------------------------------------------------------------------------------------------------------
void TriggerCounter(const char* Text = NULL)
{
	static unsigned int StartTime = 0;
	if (Text!=NULL) {
		int ElapsedTime = GetTickCount()-StartTime;
		int Secs = ElapsedTime/1000; int mSecs = ElapsedTime-Secs*1000;
		MLDebugHelper << Text  <<  Secs << '.' << mSecs << "sec";
		MLDebugHelper.Flush();
	}
	StartTime = GetTickCount();
}

void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{

	Components.clear();
	pInputGraph	=	NULL;

	if (nrhs !=1 ) { mexErrMsgTxt("One input arguments required."); }
	if (nlhs > 1) {	mexErrMsgTxt("Af most one output arguments allowed.");	}
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
		
	NumberOfLinksInGraph = static_cast<unsigned int>(mxGetM(mxGetField(pInputGraph,0,"Data")));
	Links.clear();
	LinksT.clear();

	/*	itoa(StartClock,DummyStr,10);
mexCallMATLAB(0, NULL, 1,mxCreateString(DummyStr),"disp");
	 mxArray *prhs[], const char *command_name); */
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	// create a list of links	 
	const mxArray* const pData = mxGetField(pInputGraph,0,"Data"); 
	const double*   DataPtr = mxGetPr(pData); 
	unsigned int DestinationShift = NumberOfLinksInGraph;

	std::vector<unsigned int> NetworkData(NumberOfLinksInGraph*2,0);
	for (unsigned int i = 0; i < NumberOfLinksInGraph*2; ++i) 
	{
		NetworkData[i] = (unsigned int)floor(DataPtr[i]+0.5);
	}
	MaxNodeIndex = *std::max_element(NetworkData.begin(),NetworkData.end());
#pragma region List of nodes
/*	std::vector<bool> EncounteredNodes(MaxNodeIndex+1,false);
	for (std::vector<unsigned int>::const_iterator it = NetworkData.begin(); it!=NetworkData.end(); ++it) {
		EncounteredNodes[*it] = true;
	}
	unsigned int NumberOfUniqueNodes = std::accumulate(EncounteredNodes.begin(),EncounteredNodes.end(),(unsigned int)0);

	NodesList.reserve(NumberOfUniqueNodes);
	for (unsigned int i = 0; i < EncounteredNodes.size(); ++i) {
		if (EncounteredNodes[i]) { NodesList.push_back(i); }
	}
	*/
	NodesList.clear();
	NodesList.resize(MaxNodeIndex+1,0);
	for (std::vector<unsigned int>::const_iterator it = NetworkData.begin(); it!=NetworkData.end(); ++it) {
		NodesList[*it] = true;
	}
#pragma endregion
	// build histogram
	std::vector<unsigned int> Histogram(MaxNodeIndex+1,0);
	//for (std::vector<unsigned int>::const_iterator it = NetworkData.begin(); it !=NetworkData.begin()+NumberOfLinksInGraph; ++it) {
	for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
		++Histogram[NetworkData[i]];
	}
	// allocate memory:
	if (Links.max_size()<MaxNodeIndex+1) { mexErrMsgTxt("Vector exceeds Maximal Size");	}
	Links.resize(MaxNodeIndex+1, std::vector<unsigned int>()); 
	for (unsigned int i = 0; i <= MaxNodeIndex ; ++i) {
		Links[i].reserve(Histogram[i]);
	}
	// populate Graph
	for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
		Links[NetworkData[i]].push_back(NetworkData[i+DestinationShift]);
	}	

	// build histogram
	for (std::vector<unsigned int>::iterator  It = Histogram.begin();It != Histogram.end(); ++It) { 
		*It = 0; 
	}
	for (unsigned int i = NumberOfLinksInGraph; i < 2*NumberOfLinksInGraph; ++i) {
		++Histogram[NetworkData[i]];
	}
	// allocate memory:
	if (LinksT.max_size()<MaxNodeIndex+1) { mexErrMsgTxt("Vector exceeds Maximal Size");	}
	LinksT.resize(MaxNodeIndex+1, std::vector<unsigned int>()); 
	for (unsigned int i = 0; i <= MaxNodeIndex ; ++i) {
		LinksT[i].reserve(Histogram[i]);
	}
	// populate Graph
	for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
		LinksT[NetworkData[i+DestinationShift]].push_back(NetworkData[i] );
	}	
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	std::vector<DFS_Data> GraphData(MaxNodeIndex+1);
	std::vector<unsigned int> ScanOrder;
	if (ScanOrder.max_size()<MaxNodeIndex) { mexErrMsgTxt("Vector exceeds Maximal Size");	}
	ScanOrder.reserve(MaxNodeIndex);
	for (unsigned int i = 1; i <=  MaxNodeIndex; ++i) { ScanOrder.push_back(i); }
	unsigned int ScanTime = DFS(Links,GraphData,NodesList,ScanOrder);
	for (unsigned int i = 1; i <= MaxNodeIndex; ++i) {
		ScanOrder[ ScanTime-GraphData[i].FinishTimeOrder ] = i;
	}
	GraphData = std::vector<DFS_Data>(MaxNodeIndex+1);
	DFS(LinksT,GraphData,NodesList,ScanOrder);
	FindComponents(GraphData,Components);
}

//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	mxArray*		Result		=	 mxCreateCellMatrix((int)Components.size(), 1);	
	for (unsigned int ClusterIndex = 0,CurrentComponentIndex=0;  ClusterIndex < Components.size(); ++ClusterIndex) {
			mxArray* NewCluster = mxCreateDoubleMatrix((int)Components[ClusterIndex].size() ,1 , mxREAL); 
			double* Ptr = mxGetPr(NewCluster);
			for (std::set<unsigned int>::const_iterator It = Components[ClusterIndex].begin(); It != Components[ClusterIndex].end(); ++It,++Ptr) {
				*Ptr = *It;
			}
			mxSetCell(Result,CurrentComponentIndex,NewCluster);
			++CurrentComponentIndex;
	}
	plhs[0]=Result;
	NodesList.clear();
	Links.clear();
	LinksT.clear();	
	Components.clear();
} 
//------------------------------------------------------------------------------------------------------------------
void DFS_Visit(const TGraph& Graph,std::vector<DFS_Data>& GraphData, unsigned int SourceNode,unsigned int& time,unsigned int& FinishTimeOrder);
unsigned int DFS(const TGraph& Graph,std::vector<DFS_Data>& GraphData,const std::vector<bool>& Nodes,const std::vector<unsigned int>& ScanOrder)
{
	unsigned int time = 0;
	unsigned int FinishTimeOrder = 0;
	for (unsigned int i = 1; i < GraphData.size(); ++i) { // notice: node #0 is never used. Node IDs start from 1
		if (GraphData[i].Status == DFS_Data::White && Nodes[i]) {
			DFS_Visit(Graph,GraphData,i,time,FinishTimeOrder);	
		}
	}
	return FinishTimeOrder;
}
//------------------------------------------------------------------------------------------------------------------

void DFS_Visit(const TGraph& Graph,std::vector<DFS_Data>& GraphData, unsigned int SourceNode,unsigned int& time,unsigned int& FinishTimeOrder)
{ 
	GraphData[SourceNode].Status		=	DFS_Data::Grey;
	GraphData[SourceNode].DiscoveryTime =	++time;
	const std::vector<unsigned int>& Neighbours = Graph[SourceNode];	

	for (std::vector<unsigned int>::const_iterator It = Neighbours.begin();It != Neighbours.end(); ++It) {
		if (GraphData[*It].Status == DFS_Data::White) {
			GraphData[*It].Predecessor = SourceNode;
			DFS_Visit(Graph,GraphData,*It,time,FinishTimeOrder);
		}
	}
	GraphData[SourceNode].Status		=	DFS_Data::Black;
	GraphData[SourceNode].FinishTime	=	++time;
	GraphData[SourceNode].FinishTimeOrder = ++FinishTimeOrder;
}
//------------------------------------------------------------------------------------------------------------------
unsigned int FindComponents(const std::vector<DFS_Data>& GraphData,std::vector<unsigned int>& NodeComponent,unsigned int& MaxComponentNumber,unsigned int SourceNode);
//------------------------------------------------------------------------------------------------------------------
void FindComponents(const std::vector<DFS_Data>& GraphData,std::vector< std::set<unsigned int> >& Components)
{
	std::vector<unsigned int> NodeComponent(MaxNodeIndex+1,0);
	unsigned int MaxComponentNumber = 0;
	for (unsigned int i = 1; i<=MaxNodeIndex; ++i) {
		if (NodeComponent[i]==0) {
			FindComponents(GraphData,NodeComponent,MaxComponentNumber,i);
		}
	}
	std::vector<unsigned int> ComponentSizesHistogram(MaxComponentNumber,0);
	for (unsigned int i = 1; i<=MaxNodeIndex; ++i) {
		++ComponentSizesHistogram[NodeComponent[i]-1];
	}
	unsigned int NumberOfValidComponents = 0;
	for (unsigned int i = 0; i < MaxComponentNumber; ++i) {
		if (ComponentSizesHistogram[i]>1) { ++NumberOfValidComponents; }
	}

	std::vector<unsigned int> ValidComponents;
	ValidComponents.reserve(NumberOfValidComponents);
	for (unsigned int i = 0; i < MaxComponentNumber; ++i) {
		if (ComponentSizesHistogram[i]>1) {
			ValidComponents.push_back(i+1);
		}
	}
	std::set<unsigned int> ValidComponentsSet(ValidComponents.begin(),ValidComponents.end());
	Components = std::vector< std::set<unsigned int> >(ValidComponents.size(), std::set<unsigned int>());
	for (unsigned int i = 1; i<=MaxNodeIndex; ++i) {
		if (ValidComponentsSet.find(NodeComponent[i])!=ValidComponentsSet.end()) {
			std::vector<unsigned int>::const_iterator ComponentIndex = std::find(ValidComponents.begin(),ValidComponents.end(),NodeComponent[i]);
			Components[ ComponentIndex-ValidComponents.begin()].insert(i);
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
unsigned int FindComponents(const std::vector<DFS_Data>& GraphData,std::vector<unsigned int>& NodeComponent,unsigned int& MaxComponentNumber,unsigned int SourceNode)
{
	if (NodeComponent[SourceNode]==0) {
		if (GraphData[SourceNode].Predecessor == 0) {
			NodeComponent[SourceNode] = ++MaxComponentNumber;
		}
		else {
			NodeComponent[SourceNode] = FindComponents(GraphData,NodeComponent,MaxComponentNumber,GraphData[SourceNode].Predecessor);
		}
	}
	return NodeComponent[SourceNode];
}
//------------------------------------------------------------------------------------------------------------------