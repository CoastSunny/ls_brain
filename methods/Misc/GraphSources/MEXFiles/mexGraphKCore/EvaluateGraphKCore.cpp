
#include "EvaluateGraphKCore.h"

//#include <map>
#include <set>
#include <math.h>
#include <string.h> 
#include <vector> 
#include <queue> 
#include <algorithm>

#include "../Utilities/Graph/TStaticGraph.h"
#include "../Utilities/DebugHelper/MLDebugHelper.h"

unsigned int K = 0;
const mxArray* pInputGraph	=	NULL;
unsigned int   Distance		=	0;
//enum EDirection { dirNone = -1, dirDirect=0, dirInverse=1, dirBoth = 2 };
//EDirection	   Direction	=	dirNone;
unsigned int	NumberOfLinksInGraph	=	0;
mxArray*		Result		=	NULL;

//std::vector< std::vector<unsigned int> > Graph; // For each node, neighbour
std::vector< unsigned int> ActualInDegree,ActualOutDegree;
std::vector<unsigned short> ShellNumber;

std::set<unsigned int> FindNodesToRemove(const std::set<unsigned int>& NodesSuspected);
std::set<unsigned int> RemoveNodes(const std::set<unsigned int>& NodesToRemove);
unsigned int MaximalShellNumber = 0;
char DummyStr[256];
TStaticGraph Graph,InverseGraph;
TMLDebugHelper MLDebugHelper;
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	pInputGraph	=	NULL;
	if (nrhs !=1 && nrhs!=2 ) { mexErrMsgTxt("1 or 2 input parameters are allowed");	}
	if (nlhs >1) {	mexErrMsgTxt("Up to one output arguments required.");	}
	
	MaximalShellNumber= 0;
	ActualInDegree.clear();
	ActualOutDegree.clear();
	ShellNumber.clear();
}
//------------------------------------------------------------------------------------------------------------------

void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	if (nrhs>1 && !mxIsEmpty(prhs[1])) {// create a list of links	
		Graph.Assign(prhs[0],prhs[1]); // Graph with reversed directionality of links will be created.
		InverseGraph.Assign(prhs[0],prhs[1],true);
	}
	else {  
		Graph.Assign(prhs[0],dirDirect); 
		InverseGraph.Assign(prhs[0],dirInverse);
	}
	NumberOfLinksInGraph  = Graph.GetNumberOfLinks();
	ActualInDegree.resize(Graph.GetMaxNodeID()+1);
	ActualOutDegree.resize(Graph.GetMaxNodeID()+1);
	for (unsigned int i = 1; i <= Graph.GetMaxNodeID(); ++i) { 
		ActualOutDegree[i] = (unsigned int)Graph.Neighbours(i).size();
		ActualInDegree[i] = (unsigned int)InverseGraph.Neighbours(i).size();
	}
	ShellNumber.resize(Graph.GetMaxNodeID()+1,-1);
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	unsigned short K = 0;
	bool Proceed  = true;
	while (Proceed) {
		Proceed = false;
		std::queue<unsigned int> PendingNodes; 
		for (unsigned int i = 1; i <= Graph.GetMaxNodeID(); ++i) {
			if (ActualOutDegree[i]==K || ActualInDegree[i]==K) {
				PendingNodes.push(i);
				ShellNumber[i] = K;
				ActualOutDegree[i] = 0;
				ActualInDegree[i]= 0;
			}
			else if (!Proceed && ActualInDegree[i]!=0 || ActualOutDegree[i]!=0) 
			{
				Proceed = true; 
//				MLDebugHelper << i;
			}
	//		MLDebugHelper << i << "\t" << K << "\t" << ActualDegree[i] << "\t" << ShellNumber[i] << "\n";
		}
//		MLDebugHelper << 650 <<  "\t" << K << "\t" << ActualInDegree[650] << "\t" << ActualOutDegree[650];
//		MLDebugHelper.Flush();
		while (!PendingNodes.empty()) {
			for (std::vector<unsigned int>::const_iterator it = Graph.Neighbours(PendingNodes.front()).begin();it!=Graph.Neighbours(PendingNodes.front()).end(); ++it) {
				if (ShellNumber[*it]==(unsigned short)-1) {
					if (ActualInDegree[*it]==K+1 && ActualOutDegree[*it]>=K) {
						PendingNodes.push(*it);
						ShellNumber[*it] = K; 
						ActualInDegree[*it] = 0;
						ActualOutDegree[*it] = 0;
					}
					else {
						--ActualInDegree[*it];
					}
				}
			}
			for (std::vector<unsigned int>::const_iterator it = InverseGraph.Neighbours(PendingNodes.front()).begin();it!=InverseGraph.Neighbours(PendingNodes.front()).end(); ++it) {
				if (ShellNumber[*it]==(unsigned short)-1) {
					if (ActualOutDegree[*it]==K+1 && ActualInDegree[*it]>=K) {
						PendingNodes.push(*it);
						ShellNumber[*it] = K; 
						ActualInDegree[*it] = 0;
						ActualOutDegree[*it] = 0;
					}
					else {
						--ActualOutDegree[*it];
					}
				}
			}
			PendingNodes.pop();
		}
		++K;
	}
	MaximalShellNumber = K-1;
}
//------------------------------------------------------------------------------------------------------------------

void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chNodeIDs		= "NodeIDs";
	const char* chNodeShell		= "NodeShell";
	const char* chNodesInShell  = "NodesInShell";
	const char* chShellNumber   = "ShellNumber";
	const char* FieldNames[] = { chNodeIDs, chNodeShell, chNodesInShell, chShellNumber };
	mxArray*		Result		=	mxCreateStructMatrix(1,1,4,FieldNames);

	mxSetField(Result,0,chNodeIDs,mxCreateDoubleMatrix(	static_cast<int>(ShellNumber.size())-1, 1, mxREAL) );
	mxSetField(Result,0,chNodeShell,mxCreateDoubleMatrix(	static_cast<int>(ShellNumber.size())-1, 1, mxREAL) );
	mxSetField(Result,0,chNodesInShell,mxCreateDoubleMatrix(	static_cast<int>(MaximalShellNumber+2), 1, mxREAL) );
	mxSetField(Result,0,chShellNumber,mxCreateDoubleMatrix(	static_cast<int>(MaximalShellNumber+2), 1, mxREAL) );

	double* pNodeIDs		=	mxGetPr(mxGetField(Result,0,chNodeIDs ));
	double* pNodeShell		=	mxGetPr(mxGetField(Result,0,chNodeShell));
	double* pNodesInShell	=	mxGetPr(mxGetField(Result,0,chNodesInShell));
	double* pShellNumber	=	mxGetPr(mxGetField(Result,0,chShellNumber ));

	for (unsigned int i = 0; i < ShellNumber.size()-1; ++i) { pNodeIDs[i] = i+1; }
	for (unsigned int i = 0; i < ShellNumber.size()-1; ++i) { pNodeShell[i] = ShellNumber[i+1]; }

	for (unsigned int i = 0; i < MaximalShellNumber+2; ++i) { 
		pNodesInShell[i] = 0;
		pShellNumber[i] = i;
	}
	pShellNumber[MaximalShellNumber+1] =  mxGetInf();
	for (unsigned int i = 1; i < ShellNumber.size(); ++i) {
		if (ShellNumber[i]!=(unsigned short)-1) {
			++pNodesInShell[ShellNumber[i]];
		}
		else {
			++pNodesInShell[MaximalShellNumber+1];
		}
	}
	plhs[0] = Result;
	Graph.Clear();
	InverseGraph.Clear();
	MaximalShellNumber= 0;
	ActualInDegree.clear();
	ActualOutDegree.clear();
	ShellNumber.clear();
}
//------------------------------------------------------------------------------------------------------------------
/*
std::set<unsigned int> FindNodesToRemove(const std::set<unsigned int>& NodesSuspected)
{
	std::set<unsigned int> NodesToRemove;
	for (std::set<unsigned int>::const_iterator It = NodesSuspected.begin(); It != NodesSuspected.end(); ++It) {		

		if (Links[*It].size()< K && (Links[*It].size()!=0 || InverseLinks[*It].size()!=0) ){
			NodesToRemove.insert(*It);
		}
	}
   return NodesToRemove;
}
//------------------------------------------------------------------------------------------------------------------
std::set<unsigned int> RemoveNodes(const std::set<unsigned int>& NodesToRemove)
{
	std::set<unsigned int> NodesSuspected;
	for (std::set<unsigned int>::const_iterator It = NodesToRemove.begin(); It != NodesToRemove.end(); ++It) {
		for (std::set<unsigned int>::const_iterator It1 = Links[*It].begin(); It1 !=  Links[*It].end(); ++It1) {
			InverseLinks[*It1].erase(*It);
		}
		NodesSuspected.insert(Links[*It].begin(), Links[*It].end());
		Links[*It].clear();


		for (std::set<unsigned int>::const_iterator It1 = InverseLinks[*It].begin(); It1 != InverseLinks[*It].end(); ++It1) {
			Links[*It1].erase(*It);
		}
		NodesSuspected.insert(InverseLinks[*It].begin(), InverseLinks[*It].end());
		InverseLinks[*It].clear();		
	}
	return NodesSuspected;
}
//------------------------------------------------------------------------------------------------------------------
*/