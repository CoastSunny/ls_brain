

#include "TStaticGraph.h"
#include <algorithm>

/********************************************************************************************************/
TStaticGraph::TStaticGraph(const mxArray*	pInputGraph,const mxArray*	Direction):TBasicGraph(Direction)
{
	Assign(pInputGraph);
}
/********************************************************************************************************/
TStaticGraph::TStaticGraph(const mxArray*	pInputGraph,EDirection	Direction):TBasicGraph(Direction)
{
	Assign(pInputGraph);
}
/********************************************************************************************************/
void TStaticGraph::Clear()
{
	FGraph.clear();
	TBasicGraph::Clear();
}
/********************************************************************************************************/
void TStaticGraph::Assign(const mxArray*	pInputGraph)
{
	Clear();
	CheckIfGraph(pInputGraph);
	const double* Data			= mxGetPr(mxGetField(pInputGraph,0,"Data"));	
	unsigned int NumberOfLinks	= static_cast<unsigned int>(mxGetM( mxGetField(pInputGraph,0,"Data") ));
	std::vector< std::set<unsigned int> > TempGraph;
	unsigned int NumberOfNodes	= GraphNodeLinks(pInputGraph,GetDir(), TempGraph); 

	FGraph.assign(NumberOfNodes, std::vector<unsigned int>() );
	for (unsigned int i = 0; i < NumberOfNodes; ++i) {
		FGraph[i].assign(TempGraph[i].begin(),TempGraph[i].end() );
	}
	SetNumberOfLinkedNodes(NumberOfNodes);
	SetNumberOfLinks(NumberOfLinks);

}

/********************************************************************************************************/
std::vector<unsigned int> TStaticGraph::GetAllNodesIDs() const
{
	std::vector<unsigned int> NodeIDs( GetNumberOfLinkedNodes(),0 );
	for(unsigned int i = 0; i < NodeIDs.size(); ++i) {
		NodeIDs[i] = (i+1); 
	}
	return NodeIDs;
}
/********************************************************************************************************/
void TStaticGraph::SortNodes()
{
	for (std::vector< std::vector<unsigned int> >::iterator It =  FGraph.begin(); It !=  FGraph.end(); ++It) {
		std::sort(It->begin(),It->end());
	}
}
/********************************************************************************************************/
bool CompairDegreesDescending(const std::pair<unsigned int, unsigned int>& Element1, const std::pair<unsigned int, unsigned int>& Element2) 
{
	return (Element1.second>Element2.second);
}
/********************************************************************************************************/
bool CompairDegreesAscending(const std::pair<unsigned int, unsigned int>& Element1, const std::pair<unsigned int, unsigned int>& Element2) 
{
	return (Element1.second<Element2.second);
}
/********************************************************************************************************/
std::vector< std::pair<unsigned int, unsigned int> > TStaticGraph::GetNodesByDegree(bool Descending) const
{
	std::vector< std::pair<unsigned int, unsigned int> > Result(FGraph.size());
	for (unsigned int i = 0; i < FGraph.size(); ++i) {
		Result[i] = std::pair<unsigned int, unsigned int>(i+1,(unsigned int)FGraph[i].size());
	}
	if (Descending) { // goes down, default
		std::sort(Result.begin(),Result.end(),&CompairDegreesDescending);
	}
	else {
		std::sort(Result.begin(),Result.end(),&CompairDegreesAscending);
	}
	return Result;
}
/********************************************************************************************************/