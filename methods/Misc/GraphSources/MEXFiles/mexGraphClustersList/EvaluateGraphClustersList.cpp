
#include "EvaluateGraphClustersList.h"



#include <string.h>
#include <math.h>
#include <vector>
#include <list>
#include <set>
#include <map>
#include <algorithm>

const mxArray*	pInputGraph	=	NULL;

unsigned int	NumberOfNodes	=	0;
enum EDirection { dirNone = -1, dirDirect=0, dirInverse=1, dirBoth = 2 };
EDirection	   Direction	=	dirNone;

mxArray*		Result		=	NULL;

unsigned int	NumberOfLinksInGraph	=	0;

typedef std::set<unsigned int> TNodesCollection;

std::list<std::set<unsigned int> > Clusters; // List of clusters
std::set<unsigned int> NodesList; // List of nodes which are yet not processed.

std::map<unsigned int,std::set<unsigned int> > Links; // nodes are keys, liks from (to) that node (depending on the direction) are the values,

void FindAllNeighbours(unsigned int NodeID,std::set<unsigned int>& FoundNeighbours);

char DummyStr[256];
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	pInputGraph	=	NULL;
	Result		=	NULL;

	if (nrhs <1 || nrhs > 2 ) { mexErrMsgTxt("One or two input arguments required."); }
	if (nlhs >2) {	mexErrMsgTxt("Af most two output arguments allowed.");	}
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
	
	// Direction: prhs[1]
	if (nrhs>=2) {
		if (!mxIsChar(prhs[1])) {	mexErrMsgTxt("1 \"Direction\" must be string: either \'direct\' or \'inverse\' or \'both\'.");	}
		char strDirection[16];
		mxGetString(prhs[1],strDirection,16);
		_strlwr_s(strDirection,16);
		if (strcmp(strDirection,"direct")==0) {Direction=dirDirect; }
		else if (strcmp(strDirection,"inverse")==0) {Direction=dirInverse; }
		else if (strcmp(strDirection,"both")==0) {Direction=dirBoth; }
		else { mexErrMsgTxt("\"Direction\" must be string: either \'direct\' or \'inverse\' or \'both\'.");	}
	}
	else { Direction=dirDirect; }

//sprintf(DummyStr,"%d ",Direction);
//mexWarnMsgTxt(DummyStr);

	NumberOfLinksInGraph = static_cast<unsigned int>(mxGetM(mxGetField(pInputGraph,0,"Data")));
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	// create a list of links	
	if (Direction == dirBoth) {
		Direction=dirDirect;
		PrepareToRun(nlhs,plhs,nrhs,prhs);
		Direction=dirInverse;
		PrepareToRun(nlhs,plhs,nrhs,prhs);
		Direction = dirBoth;
	}
	else {
		const mxArray* const pData = mxGetField(pInputGraph,0,"Data"); 
		const double* const  DataPtr = mxGetPr(pData); 
		unsigned int SourceShift = (Direction==dirDirect) ? 0 : NumberOfLinksInGraph;
		unsigned int DestinationShift = (Direction==dirDirect) ? NumberOfLinksInGraph : 0;
		for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
			Links[(unsigned int)floor( *(DataPtr+i+SourceShift) + 0.5)].insert((unsigned int)floor( *(DataPtr+i+DestinationShift) + 0.5) );
			NodesList.insert((unsigned int)floor( *(DataPtr+i+SourceShift) + 0.5));
			NodesList.insert((unsigned int)floor( *(DataPtr+i+DestinationShift) + 0.5));
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	while(!NodesList.empty()) {
		std::set<unsigned int> FoundNeighbours;
		FoundNeighbours.insert(	*NodesList.begin() );
		FindAllNeighbours(*NodesList.begin(),FoundNeighbours);
		int before = static_cast<int>(NodesList.size());
		for (std::set<unsigned int>::const_iterator It = FoundNeighbours.begin(); It != FoundNeighbours.end(); ++It) {
			NodesList.erase(*It);
		}
sprintf_s(DummyStr,256,"List Size: before = %d, after = %d, diff=%d, Neighbours=%d",before,NodesList.size(),before-NodesList.size(),FoundNeighbours.size());
mexWarnMsgTxt(DummyStr);
		Clusters.push_back(FoundNeighbours);
	}
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Result = mxCreateCellMatrix((int)Clusters.size(), 1);
	double* pClusterSizes = NULL;
	if (nlhs>1) {
		plhs[1] = mxCreateDoubleMatrix((int)Clusters.size() ,1 ,mxREAL); 
		pClusterSizes = mxGetPr(plhs[1]);
	}
	unsigned int ClusterIndex = 0;
	for (std::list<std::set<unsigned int> >::const_iterator CurrentCluster = Clusters.begin(); CurrentCluster != Clusters.end(); ++CurrentCluster, ++ClusterIndex) {
		mxArray* NewCluster = mxCreateDoubleMatrix((int)CurrentCluster->size() ,1 , mxREAL); 
		double*  pNewCluster= mxGetPr(NewCluster);
		for(std::set<unsigned int>::const_iterator CurrentNode =  CurrentCluster->begin();CurrentNode !=  CurrentCluster->end(); ++CurrentNode,++pNewCluster ) {
			*pNewCluster  = *CurrentNode;
		}
		if (pClusterSizes) { *pClusterSizes = static_cast<double>(CurrentCluster->size()); ++pClusterSizes; }
		mxSetCell(Result,ClusterIndex,NewCluster);
	}

	NodesList.clear();
	Links.clear();
	Clusters.clear();
	plhs[0]=Result;
}
//------------------------------------------------------------------------------------------------------------------
void FindAllNeighbours(unsigned int NodeID,std::set<unsigned int>& FoundNeighbours)
{
	std::set<unsigned int> Neighbours;
	const std::set<unsigned int>& Destinations = Links[NodeID];
	//std::pair<std::multimap<unsigned int,unsigned int>::const_iterator,std::multimap<unsigned int,unsigned int>::const_iterator> Destinations = Links.equal_range(NodeID);
	for (std::set<unsigned int>::const_iterator CurrentDestination = Destinations.begin(); CurrentDestination != Destinations.end(); ++CurrentDestination) {
		if (FoundNeighbours.find(*CurrentDestination)==FoundNeighbours.end()) {
			FoundNeighbours.insert(*CurrentDestination);
			Neighbours.insert(*CurrentDestination);			
		}
	}
	for (std::set<unsigned int>::const_iterator It = Neighbours.begin(); It != Neighbours.end(); ++It) {
		if (FoundNeighbours.find(*It)==FoundNeighbours.end()) {
			FindAllNeighbours(*It,FoundNeighbours);
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
