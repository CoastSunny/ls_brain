
#include "stdafx.h"
#include "TStaticWeightedGraph.h"
#include <algorithm>

/********************************************************************************************************/
TStaticWeightedGraph::TStaticWeightedGraph(const mxArray*	pInputGraph,const mxArray*	Direction):TStaticGraph(pInputGraph,Direction)
{
	Assign(pInputGraph);
}
/********************************************************************************************************/
TStaticWeightedGraph::TStaticWeightedGraph(const mxArray*	pInputGraph,EDirection	Direction):TStaticGraph(pInputGraph,Direction)
{
	Assign(pInputGraph);
}
/********************************************************************************************************/
void TStaticWeightedGraph::Clear()
{
	FGraphWeights.clear();
	TStaticGraph::Clear();
}
/********************************************************************************************************/
void TStaticWeightedGraph::Assign(const mxArray*	pInputGraph)
{
	Clear();
	CheckIfGraph(pInputGraph);
	const double* Data			= mxGetPr(mxGetField(pInputGraph,0,"Data"));	
	unsigned int NumberOfLinks	= static_cast<unsigned int>(mxGetM( mxGetField(pInputGraph,0,"Data") ));
	std::vector< std::map<unsigned int,double> > TempGraph;
	unsigned int NumberOfNodes	= GraphNodeLinks(pInputGraph,GetDir(), TempGraph); 

	FGraph.assign(NumberOfNodes, std::vector<unsigned int>() );
	FGraphWeights.assign(NumberOfNodes, std::vector<double>() );
	for (unsigned int i = 0; i < NumberOfNodes; ++i) {
		FGraph[i].reserve(TempGraph[i].size()); 
		for (std::map<unsigned int,double>::const_iterator it = TempGraph[i].begin(); it!=TempGraph[i].end(); ++it) {
			FGraph[i].push_back(it->first);
			FGraphWeights[i].push_back(it->second);
		}
		
	}
	SetNumberOfLinkedNodes(NumberOfNodes);
	SetNumberOfLinks(NumberOfLinks);

}

/********************************************************************************************************/
std::vector<unsigned int> TStaticWeightedGraph::GetAllNodesIDs() const
{
	std::vector<unsigned int> NodeIDs( GetNumberOfLinkedNodes(),0 );
	for(unsigned int i = 0; i < NodeIDs.size(); ++i) {
		NodeIDs[i] = (i+1); 
	}
	return NodeIDs;
}
/********************************************************************************************************/
void TStaticWeightedGraph::SortNodes()
{
	throw "Not implemented";
}
/********************************************************************************************************/
std::vector< std::pair<unsigned int, unsigned int> > TStaticWeightedGraph::GetNodesByDegree(bool Descending) const
{
	throw "Not implemented";
}
/********************************************************************************************************/