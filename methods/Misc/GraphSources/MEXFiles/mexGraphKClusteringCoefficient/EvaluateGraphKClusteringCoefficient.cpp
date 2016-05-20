

#include "EvaluateGraphKClusteringCoefficient.h"

#include <string.h>
#include <math.h>
#include <vector>
#include <list>
#include <set>
#include <map>
#include <algorithm>
#include "../Utilities/Graph/TStaticGraph.h"
#include "../Utilities/DebugHelper/MLDebugHelper.h"

//const mxArray*	pInputGraph	=	NULL;
const mxArray*	pNodeIDs	=	NULL; 

unsigned int	NumberOfNodes	=	0;

unsigned int	NumberOfLinksInGraph	=	0;
const char*		KCCDataFieldNames[] = { "NodeID","R","NodesIn","NodesAt","NodesOut","LinksIn","LinksAt","LinksOut","CCIn","CCAt","CCOut" };
unsigned int	KCCDataFieldNamesCount = 11;

std::vector<unsigned int> NodeIDsVector;			// holds the IDs of the nodes to check.
std::vector<unsigned int> NodeDegree;				// for each node in NodeIDsVector, holds it's degree (number of neighbours)
std::vector<unsigned int> NodeInterNeighboursLinks;	// for each node in NodeIDsVector, number of links between the neighbours of that node.
double MaxRadius = 0;
//------------------------------------------------------------------------------------------------------------------
struct NodeKCCData {
	NodeKCCData(unsigned int theNodeID=-1,unsigned int theR=-1):
		NodeID(theNodeID),R(theR), NodesIn(0),NodesAt(0),NodesOut(0),
			LinksIn(0),LinksAt(0),LinksOut(0),
			CCIn(mxGetNaN()),CCAt(mxGetNaN()),CCOut(mxGetNaN())
		{}
	unsigned int NodeID;
	unsigned int R; // radius
	unsigned int NodesIn; // nodes at distance <R
	unsigned int NodesAt; // nodes at distance =R
	unsigned int NodesOut; // nodes, linked to the source (NodeID) but outside the radius R
	unsigned int LinksIn; // number of links from nodes at shell Rgoing inwwards.
	unsigned int LinksAt; // number of links within the shell
	unsigned int LinksOut; // number of links from nodes in the shell outwards.	
	double		 CCIn;
	double		 CCAt;
	double		 CCOut;

	const NodeKCCData& operator+=(const NodeKCCData& rhs) { 
		NodesIn		+= rhs.NodesIn;
		NodesAt		+= rhs.NodesAt;
		NodesOut	+= rhs.NodesOut;
		LinksIn		+= rhs.LinksIn;
		LinksAt		+= rhs.LinksAt;
		LinksOut	+= rhs.LinksOut;
		CCIn		+= rhs.CCIn;
		CCAt		+= rhs.CCAt;
		CCOut		+= rhs.CCOut;
		return *this;
	}

};
std::map<unsigned int,NodeKCCData> SummedKCCData;
std::vector<unsigned int> SummedKCCDataCount;
//------------------------------------------------------------------------------------------------------------------

typedef std::vector<unsigned int> TNodesCollection;

//std::map<unsigned int,std::set<unsigned int> > Links; // nodes are keys, liks from (to) that node (depending on the direction) are the values,

unsigned int FindInterconnectedNodes(const TNodesCollection& Cluster );

char DummyStr[256];
TStaticGraph Graph;
TMLDebugHelper MLDebugHelper;
mxArray* KCCDataCellArray = NULL;
unsigned int MaxMeasuredRadius;
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	//pInputGraph	=	NULL;
	SummedKCCDataCount.clear();
	SummedKCCData.clear();
	MaxMeasuredRadius = 0;
	pNodeIDs	=	NULL;
	KCCDataCellArray  = NULL;
	if (nrhs <1 || nrhs >4 ) { mexErrMsgTxt("One, two, three or four input arguments required."); }
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

	if (nrhs>3) { MaxRadius = *mxGetPr(prhs[3]);}
	else {	MaxRadius = mxGetInf(); }

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
void FindNodeDistances(unsigned int SourceNodeID, unsigned int CurrentDistance, std::vector<unsigned int>& nodeDistances, std::map<unsigned int,std::set<unsigned int> >& nodeNeighbours,std::map<unsigned int,NodeKCCData>& KCCData )
{
	if (!mxIsInf(MaxRadius) && CurrentDistance>MaxRadius+1) { return ; }
	NodeKCCData CurrentData(SourceNodeID,CurrentDistance);
	nodeNeighbours.insert(std::make_pair(CurrentDistance,std::set<unsigned int>()));
	
	if (CurrentDistance==0) {  
		nodeDistances.assign(Graph.GetMaxNodeID()+1,-1); 
		nodeNeighbours.clear();		
		nodeNeighbours[CurrentDistance].insert(SourceNodeID);
		nodeDistances[SourceNodeID]=CurrentDistance;	

		KCCData.insert(std::make_pair(CurrentDistance,CurrentData));
		FindNodeDistances(SourceNodeID, CurrentDistance+1,nodeDistances, nodeNeighbours,KCCData);
	}
	else {  // CurrentDistance>0
		for(std::set<unsigned int>::const_iterator it = nodeNeighbours[CurrentDistance-1].begin(); it!=nodeNeighbours[CurrentDistance-1].end(); ++it) {
			// for each node in previouse shell
			const std::vector<unsigned int> & Neighbours = Graph.Neighbours(*it);
			for (std::vector<unsigned int>::const_iterator CurrNeighbour = Neighbours.begin(); CurrNeighbour != Neighbours.end(); ++CurrNeighbour) {
				if (nodeDistances[*CurrNeighbour]==-1) {
					nodeDistances[*CurrNeighbour] = CurrentDistance;
					nodeNeighbours[CurrentDistance].insert(*CurrNeighbour);
					++KCCData[CurrentDistance-1].LinksOut;	// +1 linksout to outer level
				}
				else { // already connected
					if (nodeDistances[*CurrNeighbour]==CurrentDistance-1) { // notice, in undirected network, nodeDistances[*CurrNeighbour] may only be (CurrentDistance-1)
						++KCCData[CurrentDistance-1].LinksAt; // +1 LinksIn to current level
					}
					else {// if  (nodeDistances[*CurrNeighbour]<CurrentDistance-1){ 
						++KCCData[CurrentDistance-1].LinksIn; // +1 linksat to one of the previouse levels
					}

				}
			}
		}
		KCCData.insert(std::make_pair(CurrentDistance,CurrentData));
		if (nodeNeighbours[CurrentDistance].size()>0) {
			FindNodeDistances(SourceNodeID, CurrentDistance+1,nodeDistances, nodeNeighbours,KCCData);	
		}
	}
	std::map<unsigned int,std::set<unsigned int> >::const_iterator it;
	for (it = nodeNeighbours.begin(); CurrentDistance>0 && it->first != CurrentDistance; ++it) { 
		KCCData[CurrentDistance].NodesIn += (unsigned int)it->second.size();
	}
	KCCData[CurrentDistance].NodesAt = (unsigned int)it->second.size();
	
	for (++it;it!=nodeNeighbours.end(); ++it) {
		KCCData[CurrentDistance].NodesOut += (unsigned int)it->second.size();
	}
	if (KCCData[CurrentDistance].NodesAt>1) {
		KCCData[CurrentDistance].CCAt = (double)(KCCData[CurrentDistance].LinksAt)/(double)(KCCData[CurrentDistance].NodesAt)/(double)(KCCData[CurrentDistance].NodesAt-1);
	}
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	

	KCCDataCellArray = mxCreateCellMatrix(NumberOfNodes, 1);
	std::vector<unsigned int> nodeDistances;
	SummedKCCDataCount.clear();
	SummedKCCData.clear();
	//NodeKCCData SumData(-1,
	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NumberOfNodes; ++CurrentNodeIndex) {		
		unsigned int NodeID = NodeIDsVector[CurrentNodeIndex];
		if (NodeID<=Graph.GetMaxNodeID()) {
			std::vector<unsigned int> nodeDistances;
			std::map<unsigned int,std::set<unsigned int> > nodeNeighbours;
			std::map<unsigned int,NodeKCCData> KCCData;
			FindNodeDistances(NodeID, 0, nodeDistances, nodeNeighbours,KCCData );
				
			mxArray* KCCDataStructArray = mxCreateStructMatrix((int)KCCData.size(),1,KCCDataFieldNamesCount,KCCDataFieldNames);
			if (MaxMeasuredRadius < KCCData.size()) { MaxMeasuredRadius  = (unsigned int)KCCData.size(); }
			for (unsigned int R = 0; R < KCCData.size(); ++R) {
				mxSetField(KCCDataStructArray,R,"NodeID",mxCreateDoubleScalar(KCCData[R].NodeID));
				mxSetField(KCCDataStructArray,R,"R",mxCreateDoubleScalar(KCCData[R].R));
				mxSetField(KCCDataStructArray,R,"NodesIn",mxCreateDoubleScalar(KCCData[R].NodesIn));
				mxSetField(KCCDataStructArray,R,"NodesAt",mxCreateDoubleScalar(KCCData[R].NodesAt));
				mxSetField(KCCDataStructArray,R,"NodesOut",mxCreateDoubleScalar(KCCData[R].NodesOut));
				mxSetField(KCCDataStructArray,R,"LinksIn",mxCreateDoubleScalar(KCCData[R].LinksIn));
				mxSetField(KCCDataStructArray,R,"LinksAt",mxCreateDoubleScalar(KCCData[R].LinksAt));
				mxSetField(KCCDataStructArray,R,"LinksOut",mxCreateDoubleScalar(KCCData[R].LinksOut));
				mxSetField(KCCDataStructArray,R,"CCAt",mxCreateDoubleScalar(KCCData[R].CCAt));

				if (SummedKCCDataCount.size()<(R+1)) {
					SummedKCCDataCount.push_back(0);
					SummedKCCData.insert(std::make_pair(R, NodeKCCData(-1,R)));
				}
				SummedKCCDataCount[R]+=1;
				SummedKCCData[R]+= KCCData[R];
			}			
			mxSetCell(KCCDataCellArray,CurrentNodeIndex,KCCDataStructArray);
		}
	}	
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{

	const char* chKCCData = "KCCData";
	const char* chKCCDataAverage = "KCCDataAverage";
	const char* chKCCSummary = "Summary";
	
	const char* FieldNames[] = { chKCCData,chKCCDataAverage,chKCCSummary };
	mxArray*		Result		=	mxCreateStructMatrix(1,1,3,FieldNames);

	mxSetField(Result,0,chKCCData, KCCDataCellArray );

	const char* chNumberOfNodes= "NumberOfNodes";
	const char* chR = "R";
	const char* chNodesIn= "NodesIn";
	const char* chNodesAt = "NodesAt";
	const char* chNodesOut = "NodesOut";

	const char* chLinksIn = "LinksIn";
	const char* chLinksAt = "LinksAt";
	const char* chLinksOut = "LinksOut";
	const char* chCCAt = "CCAt";
	const char* SummaryFieldNames[] = { chNumberOfNodes,chR,chNodesIn,chNodesAt,chNodesOut,chLinksIn,chLinksAt, chLinksOut,chCCAt  };
	mxArray* mxSummary = mxCreateStructMatrix(1,1,9,SummaryFieldNames);
	for (unsigned int i = 0; i < 9; ++i) {
		mxSetField(mxSummary,0,SummaryFieldNames[i],mxCreateDoubleMatrix(1,SummedKCCDataCount.size(),mxREAL));
	}

	mxArray* AveragedData  = mxCreateStructMatrix((int)SummedKCCDataCount.size(),1,KCCDataFieldNamesCount,KCCDataFieldNames);
	for (unsigned int R = 0; R < SummedKCCDataCount.size(); ++R) {
			mxSetField(AveragedData,R,chNumberOfNodes,mxCreateDoubleScalar(SummedKCCDataCount[R]));
			mxGetPr(mxGetField(mxSummary,0,chNumberOfNodes))[R] = SummedKCCDataCount[R];

			mxSetField(AveragedData,R,"R",mxCreateDoubleScalar(R));
			mxGetPr(mxGetField(mxSummary,0,chR))[R] = R;

			mxSetField(AveragedData,R,"NodesIn",mxCreateDoubleScalar((double)SummedKCCData[R].NodesIn/(double)SummedKCCDataCount[R]));
			mxGetPr(mxGetField(mxSummary,0,chNodesIn))[R] = (double)SummedKCCData[R].NodesIn/(double)SummedKCCDataCount[R];

			mxSetField(AveragedData,R,"NodesAt",mxCreateDoubleScalar((double)SummedKCCData[R].NodesAt/(double)SummedKCCDataCount[R]));
			mxGetPr(mxGetField(mxSummary,0,chNodesAt))[R] = (double)SummedKCCData[R].NodesAt/(double)SummedKCCDataCount[R];

			mxSetField(AveragedData,R,"NodesOut",mxCreateDoubleScalar((double)SummedKCCData[R].NodesOut/(double)SummedKCCDataCount[R]));
			mxGetPr(mxGetField(mxSummary,0,chNodesOut))[R] = (double)SummedKCCData[R].NodesOut/(double)SummedKCCDataCount[R];

			mxSetField(AveragedData,R,"LinksIn",mxCreateDoubleScalar((double)SummedKCCData[R].LinksIn/(double)SummedKCCDataCount[R]));
			mxGetPr(mxGetField(mxSummary,0,chLinksIn))[R] = (double)SummedKCCData[R].LinksIn/(double)SummedKCCDataCount[R];

			mxSetField(AveragedData,R,"LinksAt",mxCreateDoubleScalar((double)SummedKCCData[R].LinksAt/(double)SummedKCCDataCount[R]));
			mxGetPr(mxGetField(mxSummary,0,chLinksAt))[R] = (double)SummedKCCData[R].LinksAt/(double)SummedKCCDataCount[R];

			mxSetField(AveragedData,R,"LinksOut",mxCreateDoubleScalar((double)SummedKCCData[R].LinksOut/(double)SummedKCCDataCount[R]));
			mxGetPr(mxGetField(mxSummary,0,chLinksOut))[R] = (double)SummedKCCData[R].LinksOut/(double)SummedKCCDataCount[R];

			mxSetField(AveragedData,R,"CCAt",mxCreateDoubleScalar((double)SummedKCCData[R].CCAt/(double)SummedKCCDataCount[R]));
			mxGetPr(mxGetField(mxSummary,0,chCCAt))[R] = (double)SummedKCCData[R].CCAt/(double)SummedKCCDataCount[R];
	}

	mxSetField(Result,0,chKCCDataAverage,AveragedData);


	mxSetField(Result,0,chKCCSummary,mxSummary);
	plhs[0]=Result;

	Graph.Clear();
	NodeIDsVector.clear();
	NodeDegree.clear();
	NodeInterNeighboursLinks.clear();
	SummedKCCDataCount.clear();
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