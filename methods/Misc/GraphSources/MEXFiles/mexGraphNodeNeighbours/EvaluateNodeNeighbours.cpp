

#include "EvaluateNodeNeighbours.h"
#include <string.h>
#include <math.h>
#include <vector>
#include <set>
#include <algorithm>

#include "../Utilities/Graph/TStaticGraph.h"	
TStaticGraph Graph;
const mxArray* pInputGraph	=	NULL;
//const mxArray* NodeIDs		=	NULL;
short   Distance		=	0;
//enum EDirection { dirNone = -1, dirDirect=0, dirInverse=1, dirBoth = 2 };
//EDirection	   Direction	=	dirNone;

mxArray*		Result		=	NULL;
std::vector<unsigned int> SourceNodeIDs; 
//std::multimap<unsigned int,unsigned int> Links; // nodes are keys, liks from (to) that node (depending on the direction) are the values,

void	FindNeighbours(unsigned int NodeID,short* pVisited,std::vector<unsigned int>& Result, short DistanceToGo);
char DummyStr[256];
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Clear();
	SourceNodeIDs.clear();
	Distance	=	0;	
	Result		=	NULL;
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	// create a list of links
	if (nrhs < 1 || nrhs>4 ) {mexErrMsgTxt("One to Four input arguments required.");}
	if (nlhs >2) { mexErrMsgTxt("Up to two output arguments required.");}

	if (nrhs>3) { Graph.Assign(prhs[0],prhs[3]); }
	else {  Graph.Assign(prhs[0],dirDirect); }

	if (nrhs<2 || mxIsEmpty(prhs[1])) { SourceNodeIDs = Graph.GetAllNodesIDs(); }
	else { SourceNodeIDs = MexToVectorOfIDs(prhs[1]); } 
	// Distance: 	prhs[2]
	if (nrhs>2) {
		if (!mxIsDouble(prhs[2]) || mxGetNumberOfElements(prhs[2])!=1) {	mexErrMsgTxt("\"Distance\" must be scalar");	}
		Distance = (unsigned int)floor(mxGetScalar(prhs[2])+0.5);
		if (Distance<=0) { mexErrMsgTxt("\"Distance\" must be positive!");	}
	}
	else  { Distance = 0; }	
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	Result = mxCreateCellMatrix(1,SourceNodeIDs.size());
	short *pVisited  = new short[Graph.GetMaxNodeID()+1];
	for (unsigned int i = 0; i < Graph.GetMaxNodeID()+1; ++i)  { pVisited[i] = -1; }
	std::vector<unsigned int> CompleteResultSet;
	CompleteResultSet.reserve(Graph.GetMaxNodeID());
	for (unsigned int iNodeID = 0; iNodeID < SourceNodeIDs.size(); ++iNodeID) { 
	//	std::set<unsigned int> VisitedSet, CompleteResultSet;
		if (SourceNodeIDs[iNodeID] < Graph.GetMaxNodeID()) {
			pVisited[SourceNodeIDs[iNodeID]] = Distance;
			CompleteResultSet.push_back(SourceNodeIDs[iNodeID]); 
			if (Distance>0) {
				FindNeighbours(SourceNodeIDs[iNodeID],pVisited,CompleteResultSet,Distance-1);
			}
			mxArray* CurrentResult = mxCreateNumericMatrix((int)CompleteResultSet.size(),1,mxUINT32_CLASS, mxREAL);
			unsigned int* pCurrentResult = (unsigned int*)(mxGetPr(CurrentResult));
			for (unsigned int i = 0; i < CompleteResultSet.size(); ++i) {
				pCurrentResult[i] =CompleteResultSet[i]; 
			}
			mxSetCell(Result,iNodeID,CurrentResult);
		
			for (std::vector<unsigned int>::const_iterator it = CompleteResultSet.begin(); it!=CompleteResultSet.end(); ++it) { pVisited[*it] = -1; }
			CompleteResultSet.clear();
		}
	}
	delete pVisited ;
	CompleteResultSet.clear();
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
//	Links.clear();
	plhs[0]=Result;
	if (nlhs>1) {
		plhs[1] = mxCreateNumericMatrix(SourceNodeIDs.size(),1,mxUINT32_CLASS, mxREAL);
		unsigned int* p = (unsigned int*)mxGetPr(plhs[1]);
		for (unsigned int i = 0; i < SourceNodeIDs.size(); ++i) { p[i] = SourceNodeIDs[i]; }
	}
	Graph.Clear();
	SourceNodeIDs.clear();
}
//------------------------------------------------------------------------------------------------------------------
void	FindNeighbours(unsigned int NodeID,short* pVisited,std::vector<unsigned int>& Result,  short DistanceToGo)
{
	const std::vector<unsigned int>& Neighbours = Graph.Neighbours(NodeID);
	for (std::vector<unsigned int>::const_iterator it = Neighbours.begin(); it!=Neighbours.end(); ++it) {
		if (pVisited[*it] ==-1 ||  pVisited[*it] < DistanceToGo ) {
			pVisited[*it] = DistanceToGo;
			Result.push_back(*it); 
			if (DistanceToGo>0) {
				FindNeighbours(*it, pVisited,Result,DistanceToGo-1);
			}
		}		
	}
}
//------------------------------------------------------------------------------------------------------------------