

#include "EvaluateGraphAllNodeShortestPaths.h"
#include <math.h>
#include <mex.h>
#include <map>
#include <set>
#include <list>
#include <vector>
#include <queue>
#include <algorithm>

#include "../Utilities/Graph/TStaticGraph.h"	
#include "../Utilities/DebugHelper/MLDebugHelper.h"

const mxArray*	pInputGraph	=	NULL;

typedef std::map< unsigned int /* destination id */, std::vector< unsigned int > /* path */> TPathsType;

TMLDebugHelper MLDebugHelper;

TStaticGraph Graph;
std::vector<unsigned int> SourceNodeIDs; 
//------------------------------------------------------------------------------------------------------------------ 
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Clear();
	SourceNodeIDs.clear();
	if (nrhs < 1 || nrhs > 3  ) { mexErrMsgTxt("One, Two or three input arguments required."); }
	if (nlhs > 2	) {	mexErrMsgTxt("Up to 2 output arguments allowed.");	}
	pInputGraph	= prhs[0];	


	if (!mxIsNumeric(prhs[1]) &&  !mxIsEmpty(prhs[1])) {  mexErrMsgTxt("Second parameter must be numeric  or empty"); }
	//SourceNodeNumber = static_cast<unsigned int>(floor(0.5+mxGetScalar(prhs[1])));


//sprintf(DummyStr,"%d ",Direction);
//mexWarnMsgTxt(DummyStr);

} 
//------------------------------------------------------------------------------------------------------------------ 
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
 	if (nrhs>2) {
		Graph.Assign(pInputGraph,prhs[2]);
	}
	else {  Graph.Assign(pInputGraph,dirDirect); }
	if (mxIsEmpty(prhs[1])) { 
		SourceNodeIDs = Graph.GetAllNodesIDs();
	}
	else {
		SourceNodeIDs = MexToVectorOfIDs(prhs[1]); 
	}
} 
//------------------------------------------------------------------------------------------------------------------ 
void FindPaths(TPathsType& Paths, unsigned int SourceNodeID)
{
	Paths.clear();
	Paths.insert(TPathsType::value_type(SourceNodeID, std::vector< unsigned int >())); 
	std::vector<bool> Visited(Graph.GetMaxNodeID()+1,false);
	Visited[SourceNodeID] = true;
	std::queue<unsigned int> Pending; 
	Pending.push(SourceNodeID); 
	while (!Pending.empty()) {
		unsigned int CurrentNodeID  = Pending.front();			
		Pending.pop();
		const std::vector<unsigned int>& CurrentPath = Paths[CurrentNodeID];
		const std::vector<unsigned int>& Peers = Graph.Neighbours(CurrentNodeID); 
		for (std::vector<unsigned int>::const_iterator it = Peers.begin(); it != Peers.end(); ++it) {
			if (!Visited[*it]) {
				Visited[*it] = true;
				Pending.push(*it);
				std::vector<unsigned int> NewPath;
				NewPath.reserve(CurrentPath.size()+1);
				NewPath.assign(CurrentPath.begin(),CurrentPath.end() );
				NewPath.push_back(*it);
				Paths.insert( TPathsType::value_type(*it,NewPath));
			}
		}
	}
}
//------------------------------------------------------------------------------------------------------------------ 
void StorePathStructure(const TPathsType& Paths, unsigned int SourceNodeID,mxArray* Res, unsigned int index)
{
	// set node ID
	mxArray *pSourceNodeID = mxCreateNumericMatrix(1, 1, mxUINT32_CLASS, mxREAL );
	*((unsigned int*)mxGetPr(pSourceNodeID)) = SourceNodeID;
	mxSetFieldByNumber(Res, index, mxGetFieldNumber(Res,"NodeID"), pSourceNodeID );


	mxArray* pDestNodeIDs = mxCreateNumericMatrix(Paths.size(),1,mxUINT32_CLASS, mxREAL );
	mxArray* pPaths = mxCreateCellMatrix(Paths.size(),1); 

	unsigned int* ppDestNodeIDs = (unsigned int*)mxGetPr(pDestNodeIDs);
	int i = 0; 
	unsigned int MaxPathLength = 0; 
	for (TPathsType::const_iterator it = Paths.begin(); it!=Paths.end(); ++it,++i) {
		ppDestNodeIDs[i] = it->first;
		mxArray* CurPath = mxCreateNumericMatrix(1,it->second.size(),mxUINT32_CLASS, mxREAL );
		unsigned int* pCurPath = (unsigned int*) mxGetPr(CurPath);
		if (it->second.size()>0) { 
			memcpy((unsigned int*) mxGetPr(CurPath),(const void*)&(it->second[0]),it->second.size()*sizeof(unsigned int)); 
		}
		mxSetCell(pPaths, i, CurPath); 

		if (it->second.size()>MaxPathLength) { MaxPathLength  = (unsigned int)it->second.size(); }
	}
	mxSetFieldByNumber(Res, index, mxGetFieldNumber(Res,"DestNodeIDs"), pDestNodeIDs );
	mxSetFieldByNumber(Res, index, mxGetFieldNumber(Res,"Paths"), pPaths );

	mxArray* PathHistogram = mxCreateNumericMatrix(MaxPathLength+1,1,mxUINT32_CLASS, mxREAL );
	unsigned int* pPathHistogram = (unsigned int*)mxGetPr(PathHistogram); 
	for (TPathsType::const_iterator it = Paths.begin(); it!=Paths.end(); ++it,++i) {
		++pPathHistogram [it->second.size()] ;
	}
	mxSetFieldByNumber(Res, index, mxGetFieldNumber(Res,"PathHistogram"), PathHistogram );

	unsigned int WeightedSum = 0, Count = 0; 
	for (unsigned int i = 1; i < MaxPathLength+1; ++i) {
		WeightedSum += pPathHistogram[i]*i; 
		Count += pPathHistogram[i];
	}
	if (Count >0) {  mxSetFieldByNumber(Res, index, mxGetFieldNumber(Res,"MeanPathLength"), mxCreateDoubleScalar( ((double)WeightedSum) / ((double)Count))); }
	else { mxSetFieldByNumber(Res, index, mxGetFieldNumber(Res,"MeanPathLength"), mxCreateDoubleScalar( mxGetNaN())); }
}
	
//------------------------------------------------------------------------------------------------------------------ 
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{		
	const char* FNSourceNodeID = "NodeID";
	const char* FNDestNodeIDs = "DestNodeIDs";
	const char* FNPaths = "Paths";
	const char* FNPathHistigram = "PathHistogram";
	const char* FNMeanPathLength = "MeanPathLength";

	const char* FieldNames[5] = {FNSourceNodeID, FNDestNodeIDs, FNPaths, FNPathHistigram,FNMeanPathLength};
	mxArray* Result = mxCreateStructMatrix((int)SourceNodeIDs.size(),1,5,FieldNames);
	//mxArray* Result = mxCreateCellMatrix(1,SourceNodeIDs.size(), sizeof(FieldNames), FieldNames);

	TPathsType Paths; 
	for (unsigned int i = 0; i < SourceNodeIDs.size(); ++i) {
		FindPaths(Paths,SourceNodeIDs[i]);
		StorePathStructure(Paths,SourceNodeIDs[i],Result,i);
	}
	plhs[0] = Result;
}

//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{  
	if (nlhs>1) {		
		plhs[1] = mxCreateNumericMatrix(SourceNodeIDs.size(),1,mxUINT32_CLASS, mxREAL );
		if (SourceNodeIDs.size()>0) { memcpy(mxGetPr(plhs[1]),  &SourceNodeIDs[0],sizeof(unsigned int)*SourceNodeIDs.size()); }
	}	
	Graph.Clear();
	SourceNodeIDs.clear();
}
//------------------------------------------------------------------------------------------------------------------ 