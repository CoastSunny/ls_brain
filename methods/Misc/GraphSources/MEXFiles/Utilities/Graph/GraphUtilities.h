

#ifndef GRAPH_UTILITIES
#define GRAPH_UTILITIES
	#include "..\mexMatLab\MatLabDefs.h"
	#include <vector>	
	#include <set>	
	#include <map>	

	enum EDirection { dirNone = -1, dirDirect=0, dirInverse=1, dirBoth = 2 };	

	// effectively computes degree of each node of the graph. Speed depends on the value of Dir. If it is dirDirect or
	// dirInverse, will require O(N) memory and O(L) time. If Dir is dirBoth - O(N+max(Degree)) memory and O(N*log(<Degree>)) of time.
	// - L - number of links, N - number of nodes, max(Degree) - maximal degree in the graph. For dirDirect & dirInverse, assumes that 
	// each link appears only onece.
	// Returns number of nodes in the graph.
	unsigned int GraphNodeDegrees(const mxArray* Graph, EDirection Dir, std::vector<unsigned int>& Degrees);

	// Creates a complete graph. Requires O(N+max(Degree)) memory and O(N*log(<Degree>)). For Dir=dirBoth, it makes sence to keep the complete graph as it is created 
	// in GraphNodeDegrees anyway.
	unsigned int GraphNodeLinks(const mxArray* Graph, EDirection Dir, std::vector< std::set<unsigned int> >& OutputGraph);
	unsigned int GraphNodeLinks(const mxArray* Graph, EDirection Dir, std::vector< std::map<unsigned int,double> >& OutputGraph);
	// Returns the highest ID of the node in graph. O(N).
	unsigned int GraphGetMaximalNodeID(const mxArray* Graph);


	template <typename T>  std::vector<unsigned int> DoMexToVectorOfIDs(const mxArray* V)
	{
		if (V==NULL || mxIsEmpty(V) ) { return std::vector<unsigned int>(); }
		std::vector<unsigned int> Results;
		Results.reserve(mxGetNumberOfElements(V));
		const T* p = (const T*)mxGetPr(V);
		for (unsigned int i = 0; i < mxGetNumberOfElements(V); ++i) {
			Results.push_back( (unsigned int)floor(0.5+p[i]));
		}
		return Results;
	}
	std::vector<unsigned int> MexToVectorOfIDs(const mxArray* V);
//------------------------------------------------------------------------------------------------------------------ 

#endif	// GRAPH_UTILITIES
