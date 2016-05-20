/* 
	file:	TBasicGraph (.h & .cpp)
	class:	TBasicGraph
	This is a helper cass which can effectively import and - most importantly - browse directed graphs. 
	This basic class provides an interface for the TStaticGraph and TDynamicGraph. It also defines some
	of the types, variables and methods used by them.

	Requires:
		MatLab, 'ObjectIsType' function, STL

*/


#ifndef T_BASIC_GRAPH
#define T_BASIC_GRAPH
	#include "..\mexMatLab\MatLabDefs.h"
	#include "GraphUtilities.h"

class TBasicGraph {

public:
	TBasicGraph()
		{ FDir  = dirDirect; FNumberOfLinkedNodes = 0;	FNumberOfLinks = 0; }
	TBasicGraph(const mxArray*	Direction) 
		{ FDir   = GetDirection(Direction); FNumberOfLinkedNodes = 0;	FNumberOfLinks = 0; }
	 TBasicGraph(EDirection	Direction) 
		{ FDir   = Direction; FNumberOfLinkedNodes = 0;	FNumberOfLinks = 0; }

	virtual ~TBasicGraph() {}

	// returns total number of nodes, considering even those which are not connected.
	unsigned int GetNumberOfLinkedNodes()	const { return FNumberOfLinkedNodes; }	// returns the number of connected nodes in the graph.
	unsigned int GetNumberOfLinks()			const { return FNumberOfLinks; }
	EDirection	 GetDir()					const { return FDir; }

	virtual void Assign(const mxArray*	pInputGraph) = 0;
	virtual void Clear();
	// returns IDs of all linked nodes.
	virtual std::vector<unsigned int> GetAllNodesIDs() const = 0;

protected:               	
	

	void SetNumberOfLinkedNodes(unsigned int value) { FNumberOfLinkedNodes = value; }
	void SetNumberOfLinks(unsigned int value)		{ FNumberOfLinks = value; }
 	void SetDir(EDirection value, bool Inverse=false);	// If 'Inverse' is true, the actual direction will be inverse of the provided one. Only applies to Direct and Inverse. Not to Both.


	static void			CheckIfGraph(const mxArray*	pInputGraph); // Prints error message if the variable is indeed graph and was created with GraphLoad or similar MatLab function
	static EDirection	GetDirection(const mxArray*	Direction); //	receives case insensitive direction string in MatLab format. return the direction in DIR type. 
																//	Issues MatLab error if DIR is illegal
private:
	unsigned int FNumberOfLinkedNodes;
	unsigned int FNumberOfLinks;
	EDirection FDir;	// the direction of the MatLab Graph.


};

#endif // T_BASIC_GRAPH