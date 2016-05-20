
#include "EvaluateGraphNeighboursDegree.h"
#include <map>
#include <algorithm>
#include <math.h>
#include <vector>


const mxArray*	pInputGraph	=	NULL;
const mxArray*	pNodeIDs	=	NULL; 
int*			NodeIDsVector=	NULL;
unsigned int	NumberOfNodes	=	0;

mxArray*		ResultNodesDegreeHist				=	NULL;
mxArray*		ResultNodesNeighboursDegreeHist	=	NULL;

unsigned int	NumberOfLinksInGraph	=	0;

//typedef std::set<unsigned int> TNodesCollection;

std::multimap<unsigned int,unsigned int> LinksDirect,LinksInverse; // nodes are keys, liks from (to) that node (depending on the direction) are the values,

//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	pInputGraph	=	NULL;
	pNodeIDs	=	NULL;
	ResultNodesDegreeHist		=	NULL;
	ResultNodesNeighboursDegreeHist		=	NULL;

	if (nrhs <1 || nrhs > 2 ) { mexErrMsgTxt("One, two or three input arguments required."); }
	if (nlhs != 2) {	mexErrMsgTxt("Two output arguments are required.");	}
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
	// NodeIDs:		prhs[1]
	pNodeIDs	= (nrhs>=2) ? prhs[1] : NULL;

//sprintf(DummyStr,"%d ",Direction);
//mexWarnMsgTxt(DummyStr);

	NumberOfLinksInGraph = static_cast<unsigned int>(mxGetM(mxGetField(pInputGraph,0,"Data")));
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const mxArray* const pData = mxGetField(pInputGraph,0,"Data"); 
	const double* const  DataPtr = mxGetPr(pData); 
	if (pNodeIDs && !mxIsEmpty(pNodeIDs)) {
		NumberOfNodes	=	static_cast<unsigned int>(mxGetNumberOfElements(prhs[1]));
		NodeIDsVector   =   new int[NumberOfNodes];
		const double* p = mxGetPr(pNodeIDs);
		for (unsigned int i = 0; i < NumberOfNodes; ++i) {
			NodeIDsVector[i] = (unsigned int)floor(p[i]+0.5);
		}
	}
	else {
		NumberOfNodes = (unsigned int)floor(0.5 + *std::max_element(mxGetPr(pData),mxGetPr(pData)+2*mxGetM(pData)));
		NodeIDsVector   =   new int[NumberOfNodes];
		for (unsigned int i = 0; i < NumberOfNodes; ++i) {
			NodeIDsVector[i] = i+1;
		}
	}
	// create a list of links

	for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
		LinksDirect.insert(std::multimap<unsigned int,unsigned int>::value_type( (unsigned int)floor( *(DataPtr+i) + 0.5),(unsigned int)floor( *(DataPtr+i+NumberOfLinksInGraph) + 0.5) ));
		LinksInverse.insert(std::multimap<unsigned int,unsigned int>::value_type( (unsigned int)floor( *(DataPtr+i+NumberOfLinksInGraph) + 0.5),(unsigned int)floor( *(DataPtr+i+0) + 0.5) ));
	}
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	
	ResultNodesDegreeHist =  mxCreateDoubleMatrix(NumberOfNodes,2,mxREAL);
	ResultNodesNeighboursDegreeHist =  mxCreateDoubleMatrix(NumberOfNodes,4,mxREAL);
	double *pResultDegree = mxGetPr(ResultNodesDegreeHist);
	double *pResultNeighboursDegree = mxGetPr(ResultNodesNeighboursDegreeHist);

	std::vector<unsigned int> Degree(NumberOfNodes*2,0);
	std::vector<unsigned int> Counter(NumberOfNodes*2,0);

	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NumberOfNodes; ++CurrentNodeIndex) {		
		std::pair<std::multimap<unsigned int,unsigned int>::const_iterator,std::multimap<unsigned int,unsigned int>::const_iterator> DestinationsDirect = LinksDirect.equal_range(NodeIDsVector[CurrentNodeIndex]);
		std::pair<std::multimap<unsigned int,unsigned int>::const_iterator,std::multimap<unsigned int,unsigned int>::const_iterator> DestinationsInverse = LinksInverse.equal_range(NodeIDsVector[CurrentNodeIndex]);
		unsigned int InDegree = 0;
		unsigned int OutDegree = 0;
		for (std::multimap<unsigned int,unsigned int>::const_iterator ItDirect = DestinationsDirect.first; ItDirect != DestinationsDirect.second; ++ItDirect) {	++OutDegree;	}
		for (std::multimap<unsigned int,unsigned int>::const_iterator ItInvert = DestinationsInverse.first; ItInvert != DestinationsInverse.second; ++ItInvert) { InDegree++; }
		pResultDegree[InDegree]++;
		pResultDegree[OutDegree+NumberOfNodes]++;

		Degree[NodeIDsVector[CurrentNodeIndex]]  = InDegree;
		Degree[NodeIDsVector[CurrentNodeIndex]+NumberOfNodes]  = OutDegree;
	}

	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NumberOfNodes; ++CurrentNodeIndex) {		
		std::pair<std::multimap<unsigned int,unsigned int>::const_iterator,std::multimap<unsigned int,unsigned int>::const_iterator> DestinationsDirect = LinksDirect.equal_range(NodeIDsVector[CurrentNodeIndex]);
		std::pair<std::multimap<unsigned int,unsigned int>::const_iterator,std::multimap<unsigned int,unsigned int>::const_iterator> DestinationsInverse = LinksInverse.equal_range(NodeIDsVector[CurrentNodeIndex]);

		unsigned int InDegree = Degree[NodeIDsVector[CurrentNodeIndex]];
		unsigned int OutDegree = Degree[NodeIDsVector[CurrentNodeIndex]+NumberOfNodes];

		for (std::multimap<unsigned int,unsigned int>::const_iterator ItDirect = DestinationsDirect.first; ItDirect != DestinationsDirect.second; ++ItDirect) {
			// follow outgoing links.
		    pResultNeighboursDegree[OutDegree+2*NumberOfNodes] += Degree[ItDirect->second]; // incoming degree
		    pResultNeighboursDegree[OutDegree+3*NumberOfNodes] += Degree[ItDirect->second+NumberOfNodes]; // outgoing degree
			Counter[OutDegree+NumberOfNodes]++;
		}
		for (std::multimap<unsigned int,unsigned int>::const_iterator ItInvert = DestinationsInverse.first; ItInvert != DestinationsInverse.second; ++ItInvert) {
			// follow incoming links
			pResultNeighboursDegree[InDegree] += Degree[ItInvert->second];	// incoming
			pResultNeighboursDegree[InDegree+NumberOfNodes] += Degree[ItInvert->second+NumberOfNodes]; // outgoing
			Counter[InDegree]++;
		}
	}
	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex < NumberOfNodes; ++CurrentNodeIndex) {		
		if (Counter[CurrentNodeIndex ]) {
			pResultNeighboursDegree[CurrentNodeIndex]/=Counter[CurrentNodeIndex ];
			pResultNeighboursDegree[CurrentNodeIndex+NumberOfNodes]/=Counter[CurrentNodeIndex ];
		}
		if (Counter[CurrentNodeIndex +NumberOfNodes]) {
			pResultNeighboursDegree[CurrentNodeIndex+NumberOfNodes*2]/=Counter[CurrentNodeIndex +NumberOfNodes];
		    pResultNeighboursDegree[CurrentNodeIndex+NumberOfNodes*3]/=Counter[CurrentNodeIndex +NumberOfNodes];
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	LinksDirect.clear();
	LinksInverse.clear();
	delete [] NodeIDsVector;	NodeIDsVector	=	NULL;
	plhs[0]=ResultNodesDegreeHist;
	plhs[1]=ResultNodesNeighboursDegreeHist;
}
//------------------------------------------------------------------------------------------------------------------
	
