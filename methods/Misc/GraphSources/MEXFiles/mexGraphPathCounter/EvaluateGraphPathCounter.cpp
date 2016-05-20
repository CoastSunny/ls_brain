

#include "EvaluateGraphPathCounter.h"

#include <string.h>
#include <math.h>
#include <vector>
#include <map>
#include <list>
#include <set>
#include <map>
#include <algorithm>
#include "../Utilities/Graph/TStaticGraph.h"
#include "../Utilities/DebugHelper/MLDebugHelper.h"

TStaticGraph Graph;
//const mxArray*	pInputGraph	=	NULL;
const mxArray*	pNodeIDs	=	NULL; 
unsigned int    MaxRange  = 0;
unsigned int	NumberOfLinksInGraph	=	0;
unsigned int	NumberOfNodes	=	0;

const char*		ResultDataFieldNames[] = { "SourceNodeID","Shell" };
unsigned int	ResultDataFieldNamesCount = 2;
mxArray*		Result =NULL;
std::vector<unsigned int> NodeIDsVector;			// holds the IDs of the nodes to check.
//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

typedef std::vector<unsigned int> TNodesCollection;

//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	pNodeIDs	=	NULL;
	if (nrhs <2 || nrhs >4 ) { mexErrMsgTxt("Two, three or four input arguments required."); }
	if (nlhs >1) {	mexErrMsgTxt("Up to one output arguments required.");	}
	MaxRange = (unsigned int)floor(*mxGetPr(prhs[1])+0.5);
	pNodeIDs	= (nrhs>=3) ? prhs[2] : NULL;
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	NodeIDsVector.clear();
	if (nrhs>3 && !mxIsEmpty(prhs[3])) {// create a list of links	
		Graph.Assign(prhs[0],prhs[3]); // Graph with reversed directionality of links will be created.
	}
	else {  Graph.Assign(prhs[0],dirDirect); }
	NumberOfLinksInGraph  = Graph.GetNumberOfLinks();

	if (pNodeIDs && !mxIsEmpty(pNodeIDs)) {
		NumberOfNodes	=	static_cast<unsigned int>(mxGetNumberOfElements(pNodeIDs));
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
}
//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	Result = mxCreateStructMatrix(1,NumberOfNodes, ResultDataFieldNamesCount,  ResultDataFieldNames);
	for (unsigned int CurrentNodeIndex = 0; CurrentNodeIndex< NumberOfNodes; ++CurrentNodeIndex) {
			mxArray* mxSourceNodeID = mxCreateNumericMatrix(1,1,mxDOUBLE_CLASS,mxREAL);
			*mxGetPr(mxSourceNodeID) = NodeIDsVector[CurrentNodeIndex];
			mxSetField(Result,CurrentNodeIndex,ResultDataFieldNames[0],mxSourceNodeID);
			mxArray* mxData = mxCreateCellMatrix(MaxRange+1,1);
			mxSetField(Result,CurrentNodeIndex,ResultDataFieldNames[1], mxData);


			mxArray* mxCurrentShell = mxCreateNumericMatrix(1,2,mxINT32_CLASS,mxREAL);
			int* pCurrentShell = (int*) mxGetPr(mxCurrentShell);
			pCurrentShell[0] = NodeIDsVector[CurrentNodeIndex];
			pCurrentShell[1] = 1;			
			mxSetCell(mxData,0,mxCurrentShell);

			for (unsigned int Range = 1; Range<=MaxRange; ++Range) {
				const int* pPreviouseShell = (const int*)mxGetPr(mxGetCell(mxData,Range-1));
				unsigned int NumberOfElementsInPrevShell = (unsigned int)mxGetNumberOfElements(mxGetCell(mxData,Range-1))/2;
				std::map<unsigned int, unsigned int> CurrentShell;
				for (unsigned int i = 0; i < NumberOfElementsInPrevShell; ++i) { // for each node in prev. shell
					const std::vector<unsigned int>& Neighbours = Graph.Neighbours(pPreviouseShell[i]); 
					for (unsigned int j=0; j < Neighbours.size(); ++j) { // go through all neighbours
						if (CurrentShell.find(Neighbours[j])!=CurrentShell.end()) { //  already visited at this shell
							CurrentShell[Neighbours[j]]+=pPreviouseShell[i+NumberOfElementsInPrevShell];
						}
						else { CurrentShell.insert(std::make_pair(Neighbours[j],pPreviouseShell[i+NumberOfElementsInPrevShell])); }
					}
				}
				mxCurrentShell = mxCreateNumericMatrix(CurrentShell.size(),2,mxINT32_CLASS,mxREAL);
				pCurrentShell = (int*) mxGetPr(mxCurrentShell);
				for(std::map<unsigned int, unsigned int>::const_iterator it = CurrentShell.begin(); it!=CurrentShell.end(); ++it) {
					*pCurrentShell = it->first;
					*(pCurrentShell+CurrentShell.size()) = it->second;
					++pCurrentShell;
				}
				mxSetCell(mxData,Range,mxCurrentShell);
			}
	}	
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	NodeIDsVector.clear();
	plhs[0] = Result;
}
//------------------------------------------------------------------------------------------------------------------