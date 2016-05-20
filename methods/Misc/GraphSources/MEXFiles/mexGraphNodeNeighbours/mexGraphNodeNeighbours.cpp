// mexGraphNodeNeighbours.cpp : Defines the entry point for the DLL application.
//
/****************************************************************************
function Neightbours = mexGraphNodeNeighbours(Graph,NodeIDs,Distance,Direction)
% Returns the list of nodes being at the specified Distance from the Node when shortes pathes are considered
%
% Receive:
%	Graph		-	Graph Struct	-	Struct created with ObjectCreateGraph function (probanly called by GraphLoad).
%	NodeIDs		-	integer			-	the ID of the node for whitch the neighbours are searched.
%					vector			-	List of IDs, in this case cell array lists of neighbours is returned.
%	Distance	-	integer			-	The distance at witch to look. The computation time may increas with the distance dramatically
%	Direction	-	string			-	(optional) Either 'direct' or 'inverse'. Case insensitive. The incoming or outgoing links are 
%										followed as a function of this parameter. Default: 'direct'
%
%
%
% Returns: 
%	Neightbours	-	vector (Nx1)	-	If NodeID is scalar, a vector of unique Distance-Neighbour IDs is returned
%					cell array		-	If NodeID is vector, cell array is returned. Each cell contains a vector like in the case above.
% 
% See Also:
%	ObjectCreateGraph , GraphLoad
%																										
%Created:																							
%	Lev Muchnik,	04-05/06/04 (Tannenbush )
%	lev@topspin.co.il, +972-54-326496																							
%  
%
%

****************************************************************************/


#include "EvaluateNodeNeighbours.h"
#include  "..\Utilities\mexMatLab\MatLabDefs.h"

void mexFunction(
		int nlhs,              // Number of left hand side (output) arguments
		mxArray *plhs[],       // Array of left hand side arguments
		int nrhs,              // Number of right hand side (input) arguments
		const mxArray *prhs[]  // Array of right hand side arguments
	)

	{
		SetInputParameters(nlhs,plhs,nrhs,prhs);
		PrepareToRun(nlhs,plhs,nrhs,prhs);
		PerformCalculations(nlhs,plhs,nrhs,prhs);
		FreeResourses(nlhs,plhs,nrhs,prhs);
	}
