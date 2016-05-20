
#include "EvaluateGraphNeighboursOverlap.h"
#include <map>
#include <algorithm>
#include <math.h>
#include <vector>
#include <set>


const mxArray*	pInputGraph	=	NULL;
const mxArray*	pNodeIDs1	=	NULL; 
const mxArray*	pNodeIDs2	=	NULL; 
unsigned int	NumberOfNodes	=	0;

//mxArray*		ResultNodesDegreeHist				=	NULL;
//mxArray*		ResultNodesNeighboursOverlapHist	=	NULL;

unsigned int	NumberOfLinksInGraph	=	0;
unsigned int	MaxUsedNodeID = 0;
//typedef std::set<unsigned int> TNodesCollection;
std::set<unsigned int>** Neighbours = NULL;
std::vector<unsigned int> NodeIDs1,NodeIDs2;
unsigned int IntersectSize(const std::set<unsigned int>& lhs,const std::set<unsigned int>& rhs);
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	pInputGraph	=	NULL; 
	pNodeIDs1	=	NULL;
	pNodeIDs2    =  NULL;
	
	if (nrhs !=3 ) { mexErrMsgTxt("Exactly three input arguments required."); }
	if (nlhs !=1  && nlhs!=3) {	mexErrMsgTxt("One or three output arguments allowed.");	}
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
	pNodeIDs1	= prhs[1];
	pNodeIDs2	= prhs[2];
//sprintf(DummyStr,"%d ",Direction);
//mexWarnMsgTxt(DummyStr);
	NumberOfLinksInGraph = static_cast<unsigned int>(mxGetM(mxGetField(pInputGraph,0,"Data")));
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const mxArray* const pData = mxGetField(pInputGraph,0,"Data"); 
	const double* const  DataPtr = mxGetPr(pData); 
	
	if (Neighbours!=NULL) { 
		for (unsigned int i = 0; i <= MaxUsedNodeID ; ++i) { 
			delete Neighbours[i]; 
		}
		delete [] Neighbours; 
	}
	MaxUsedNodeID = 0;
	/*for (unsigned int i = 0; i < 2*NumberOfLinksInGraph; ++i) {
		if ( (DataPtr[i] + 0.5)>MaxUsedNodeID) { MaxUsedNodeID = (unsigned int)floor(DataPtr[i] + 0.5); }
	}*/
		
	NodeIDs1.clear();
	NodeIDs1.reserve(mxGetM(pNodeIDs1)*mxGetN(pNodeIDs1));
	for (unsigned int i = 0; i < static_cast<unsigned int>(mxGetM(pNodeIDs1)*mxGetN(pNodeIDs1)); ++i) {
		NodeIDs1.push_back(static_cast<unsigned int>(floor(*(mxGetPr(pNodeIDs1)+i)+0.5)));
		if (NodeIDs1.back()>MaxUsedNodeID) { MaxUsedNodeID = NodeIDs1.back(); }
	}
	NodeIDs2.clear();
	NodeIDs2.reserve(mxGetM(pNodeIDs1)*mxGetN(pNodeIDs1));
	for (unsigned int i = 0; i < static_cast<unsigned int>(mxGetM(pNodeIDs2)*mxGetN(pNodeIDs2)); ++i) {
		NodeIDs2.push_back(static_cast<unsigned int>(floor(*(mxGetPr(pNodeIDs2)+i)+0.5)));
		if (NodeIDs2.back()>MaxUsedNodeID) { MaxUsedNodeID = NodeIDs2.back(); }
	}	
	Neighbours = new std::set<unsigned int>*[MaxUsedNodeID+1];
	memset(Neighbours,0,(MaxUsedNodeID+1)*sizeof(std::set<unsigned int>*));

	for (unsigned int i = 0; i <NodeIDs1.size(); ++i) {
		if (Neighbours[NodeIDs1[i]]==NULL) { Neighbours[NodeIDs1[i]] = new std::set<unsigned int>(); }
	}
	for (unsigned int i = 0; i <NodeIDs2.size(); ++i) {
		if (Neighbours[NodeIDs2[i]]==NULL) { Neighbours[NodeIDs2[i]] = new std::set<unsigned int>(); }
	}
	for (unsigned int i = 0; i < NumberOfLinksInGraph; ++i) {
		unsigned int Source = static_cast<unsigned int>( floor( DataPtr[i]+0.5));
		if ( Source<=MaxUsedNodeID && Neighbours[Source]!=NULL)  {
			Neighbours[Source]->insert( static_cast<unsigned int>( floor( DataPtr[i+NumberOfLinksInGraph]+0.5)));
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	
	
} 
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	mxArray *Result = mxCreateNumericMatrix((int)NodeIDs1.size(),(int)NodeIDs2.size(),mxUINT32_CLASS,mxREAL);
	unsigned int* pResult = (unsigned int*)mxGetPr(Result);
	for (unsigned int i = 0; i < NodeIDs1.size(); ++i) {
		for (unsigned int j = 0; j < NodeIDs2.size(); ++j) {
			if (NodeIDs1[i]!=NodeIDs2[j]) {
				//std::set<unsigned int> Intersection;
				//std::set_intersection(Neighbours[NodeIDs1[i]]->begin(),Neighbours[NodeIDs1[i]]->end(),Neighbours[NodeIDs2[j]]->begin(),Neighbours[NodeIDs2[j]]->end(),Intersection.begin());
				unsigned int theIntersectSize  =IntersectSize(*Neighbours[NodeIDs1[i]],*Neighbours[NodeIDs2[j]]);
				pResult[i + j*NodeIDs1.size()] = theIntersectSize;
			}
			else {
				pResult[i + j*NodeIDs1.size()] = (unsigned int)Neighbours[NodeIDs1[i]]->size();
			}
		} 
	}
	plhs[0]=Result;
	if (nlhs==3) {
		mxArray *NodeDegree1 = mxCreateNumericMatrix((int)NodeIDs1.size(),1,mxUINT32_CLASS,mxREAL);
		unsigned int* pNodeDegree1 = (unsigned int*)mxGetPr(NodeDegree1);
		for (unsigned int i = 0;i < NodeIDs1.size(); ++i) {
			pNodeDegree1[i] = (unsigned int)Neighbours[NodeIDs1[i]]->size();
		}
		plhs[1] = NodeDegree1;

		mxArray *NodeDegree2 = mxCreateNumericMatrix(1, (int)NodeIDs2.size(),mxUINT32_CLASS,mxREAL);
		unsigned int* pNodeDegree2 = (unsigned int*)mxGetPr(NodeDegree2);
		for (unsigned int i = 0;i < NodeIDs2.size(); ++i) {
			pNodeDegree2[i] = (unsigned int)Neighbours[NodeIDs2[i]]->size();
		}
		plhs[2] = NodeDegree2;
	}
	if (Neighbours!=NULL) { 
		for (unsigned int i = 0; i <= MaxUsedNodeID ; ++i) { 
			delete Neighbours[i]; 
		}
		delete [] Neighbours;  Neighbours  = NULL;
	}	
	MaxUsedNodeID = 0;
	NodeIDs1.clear();
	NodeIDs2.clear();
	pNodeIDs1 = NULL;
	pNodeIDs2 = NULL;
	
}
//------------------------------------------------------------------------------------------------------------------
unsigned int IntersectSize(const std::set<unsigned int>& lhs,const std::set<unsigned int>& rhs)
{
	unsigned int Result = 0;
	std::set<unsigned int>::const_iterator it1 = lhs.begin(); 
	std::set<unsigned int>::const_iterator it2 = rhs.begin(); 
	while (it1!=lhs.end() && it2!=rhs.end()) {
		if (*it1==*it2) { ++Result; ++it1; ++it2; }
		else if (*it1<*it2)  { ++it1; }
		else { ++it2; }
	}
	return Result;
}
