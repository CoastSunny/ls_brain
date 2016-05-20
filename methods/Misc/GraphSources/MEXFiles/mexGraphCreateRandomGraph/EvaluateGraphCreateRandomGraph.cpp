
#include "EvaluateGraphCreateRandomGraph.h"

#include "../Utilities/DebugHelper/MLDebugHelper.h"

TMLDebugHelper MLDebugHelper;

#include <vector>
#include <numeric>
#include <math.h>
#include <stack>
#include <queue>
#include <set>
#include <map>
#include <stdlib.h>
#include <time.h>
#include <algorithm>


/*
#include <fstream>
#include<iostream>
#include <math.h>
#include <mex.h>
#include <map>
#include <set>
#include <list>

#include <algorithm>
*/

unsigned int NumberOfNodes;
unsigned int NumberOfLinks;
std::vector<unsigned int> DistributionX;
std::vector<unsigned int> DistributionY;
std::vector< std::set<unsigned int> > Graph;
bool Directional;

void BuildDirectionalGraph();
void BuildUndirectionalGraph();
//------------------------------------------------------------------------------------------------------------------ 

void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs != 3 && nrhs!=4) { mexErrMsgTxt(" Three or four input arguments required."); }
	if (nlhs > 1){	mexErrMsgTxt("one output arguments allowed.");	}

	if (mxGetNumberOfElements(prhs[1])!= mxGetNumberOfElements(prhs[2])) { mexErrMsgTxt("2'nd and 3'rd parameters sizes mismatch.");	}

	NumberOfNodes = (unsigned int)floor(0.5+mxGetScalar(prhs[0]));
	DistributionX.clear();
	DistributionX.reserve(mxGetNumberOfElements(prhs[1]));
	for (unsigned int i = 0; i < mxGetNumberOfElements(prhs[1]); ++i)  {
		DistributionX.push_back((unsigned int)floor(0.5+*(mxGetPr(prhs[1])+i)));
	}
	DistributionY.clear();
	DistributionY.reserve(mxGetNumberOfElements(prhs[2]));
	double Factor = NumberOfNodes/std::accumulate(mxGetPr(prhs[2]),mxGetPr(prhs[2])+mxGetNumberOfElements(prhs[2]),0.0);
	NumberOfNodes = 0;
	NumberOfLinks = 0;
	for (unsigned int i = 0; i < mxGetNumberOfElements(prhs[2]); ++i)  {
		unsigned int CurrentValue = (unsigned int)floor( 0.5+ Factor* *(mxGetPr(prhs[2])+i));
		DistributionY.push_back(CurrentValue);
		NumberOfNodes+=CurrentValue;
		NumberOfLinks+=CurrentValue*DistributionX[i];
	}
	if (nrhs>3) { Directional = (((int)floor(mxGetScalar(prhs[3])+0.5))!=0);	}
	else { Directional = true;	}
} 
//-----------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	srand( (unsigned)time( NULL ) );
}
//------------------------------------------------------------------------------------------------------------------ 
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{ 
	Graph.clear();
	if (Directional) {
		BuildDirectionalGraph();
	}
	else {
		BuildUndirectionalGraph();
	}
}
//================================================================================================
void BuildDirectionalGraph()
{
	std::stack<unsigned int>	DestinationNodes;
	std::vector<unsigned int>	NodeDegrees;
	NodeDegrees.reserve(NumberOfNodes);
	// Buid a queue of destination nodes.
	unsigned int CurrentNodeID = 1;
	for (unsigned int i = 0; i < DistributionX.size(); ++i) {
		for (unsigned int j = 0; j < DistributionY[i]; ++j) { // number of nodes of degree DistributionX[i]
			for (unsigned int k = 0; k < DistributionX[i]; ++k) { // 
				DestinationNodes.push(CurrentNodeID);
			}
			NodeDegrees.push_back(DistributionX[i]);
			++CurrentNodeID;
		}
	}
	// create temporary structure of node's and their links
	std::vector< std::pair<unsigned int, std::set<unsigned int> > > IncompleteNodes;
	IncompleteNodes.reserve(NumberOfNodes);
	Graph.resize(NumberOfNodes);
	for (unsigned int NodeID = 1; NodeID<=NumberOfNodes; ++NodeID) {
		std::pair<unsigned int, std::set<unsigned int> > NewNode = std::pair<unsigned int, std::set<unsigned int> >(NodeID,std::set<unsigned int>());
		IncompleteNodes.push_back(NewNode);
	}
	while(!DestinationNodes.empty() && !IncompleteNodes.empty()) {
		unsigned int DestinationNodeID = DestinationNodes.top();
		DestinationNodes.pop();
		// find if there is any chance of inserting the destination node.
		bool CheckChance = false;
		for (unsigned int i = 0;!CheckChance && i < IncompleteNodes.size(); ++i) {
			if (IncompleteNodes[i].first != DestinationNodeID && IncompleteNodes[i].second.find(DestinationNodeID)==IncompleteNodes[i].second.end()) {
				CheckChance = true;
			}
		}
		if (CheckChance) { // insert the node.
			bool Inserted = false; 
			while (!Inserted) {
				unsigned int RandomSource = (unsigned int)(((double) rand()/(double) RAND_MAX)*(double)IncompleteNodes.size());
				if (RandomSource<IncompleteNodes.size() && IncompleteNodes[RandomSource].first !=DestinationNodeID) {// && IncompleteNodes[RandomSource].second.find(DestinationNodeID)==IncompleteNodes[RandomSource].second.end()) {
					if (IncompleteNodes[RandomSource].second.find(DestinationNodeID)==IncompleteNodes[RandomSource].second.end()) {
						IncompleteNodes[RandomSource].second.insert(DestinationNodeID);
						Inserted  = true;
						if (IncompleteNodes[RandomSource].second.size() == NodeDegrees[IncompleteNodes[RandomSource].first-1]) { // node complete!
							Graph[IncompleteNodes[RandomSource].first-1]=IncompleteNodes[RandomSource].second; //.assign(IncompleteNodes[RandomSource].second.begin(),IncompleteNodes[RandomSource].second.end());
							if (IncompleteNodes.size()>1 && RandomSource!= (IncompleteNodes.size()-1)) {
								IncompleteNodes[RandomSource] = IncompleteNodes[IncompleteNodes.size()-1];
							}
							IncompleteNodes.pop_back();
						}
					}
				}
			}
		}
	}

}
//================================================================================================
void BuildUndirectionalGraph()
{
	std::vector<unsigned int>	NodeIDsVector;
	std::queue<unsigned int>	NodeIDs;
	std::vector<unsigned int>	NodeDegrees;
	NodeIDsVector.reserve(NumberOfLinks);
	NodeDegrees.reserve(NumberOfNodes);
	Graph.resize(NumberOfNodes);

	// Buid a queue of destination nodes.
	unsigned int CurrentNodeID = 1;
	for (unsigned int i = 0; i < DistributionX.size(); ++i) {
		for (unsigned int j = 0; j < DistributionY[i]; ++j) { // number of nodes of degree DistributionX[i]
			for (unsigned int k = 0; k < DistributionX[i]; ++k) { // 
				//DestinationNodes.push(CurrentNodeID);
				NodeIDsVector.push_back(CurrentNodeID);
			}
			NodeDegrees.push_back(DistributionX[i]);
			//Graph[CurrentNodeID-1].reserve(DistributionX[i]);
			++CurrentNodeID;
		}
	}
	
	random_shuffle(NodeIDsVector.begin(), NodeIDsVector.end()) ;
	for (std::vector<unsigned int>::const_iterator It = NodeIDsVector.begin(); It!= NodeIDsVector.end(); ++It) {
		NodeIDs.push(*It);
	}
	while (NodeIDs.size()>=2) {
		unsigned int ID1 = NodeIDs.front();
		NodeIDs.pop();
		bool Inserted = false; 
		std::set<unsigned int>& SourceSet = Graph[ID1-1];
		for (unsigned int i = 0; !Inserted && i < NodeIDs.size(); ++i) {
			if (NodeIDs.front()!=ID1 && SourceSet.find(NodeIDs.front())==SourceSet.end()) {
				SourceSet.insert(NodeIDs.front());
				Graph[NodeIDs.front()-1].insert(ID1);
				
				Inserted = true;
			}
			else {
				NodeIDs.push(NodeIDs.front());
			}
			NodeIDs.pop();
		}
		// if at this point Inserted is false, no pair has been found. The source node is dropped.
	}

}
//================================================================================================
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{  
	unsigned int ActualNumberOfLinks = 0; 	
	for(std::vector< std::set<unsigned int> >::const_iterator NodesIt = Graph.begin(); NodesIt != Graph.end(); ++NodesIt) {
		ActualNumberOfLinks+= (unsigned int)NodesIt->size();
	}
	mxArray* Links = mxCreateNumericMatrix(ActualNumberOfLinks,2,mxDOUBLE_CLASS,mxREAL);
	double* pLinks = mxGetPr(Links);
	for (unsigned int SourceIndex = 0; SourceIndex < Graph.size(); ++SourceIndex) {
		//for (unsigned int DestinationIndex = 0; DestinationIndex < Graph[SourceIndex].size(); ++DestinationIndex) {
		for (std::set<unsigned int>::const_iterator DestinationIt = Graph[SourceIndex].begin(); DestinationIt != Graph[SourceIndex].end(); ++DestinationIt) {
			*pLinks = (SourceIndex+1);
			*(pLinks+ActualNumberOfLinks) = *DestinationIt;
			++pLinks;
		}
	}
	mxArray* temp_plhs[1] = {NULL};
	mxArray* temp_prhs[2] = {Links, mxCreateString("mexGraphCreateRandomGraph")};
	mexCallMATLAB(1, temp_plhs, 2,temp_prhs,"ObjectCreateGraph");
	plhs[0] = temp_plhs[0];
//	[Graph]= ObjectCreateGraph(LinksData,Signature)
	DistributionX.clear();
	DistributionY.clear();
	Graph.clear();
}

//================================================================================================


