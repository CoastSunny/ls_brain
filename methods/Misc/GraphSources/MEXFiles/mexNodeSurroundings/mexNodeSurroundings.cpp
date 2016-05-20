// mexNodeSurroundings.cpp : Defines the entry point for the DLL application.
//
// Graph = GraphLoad('E:\Documents\Articles\Data\ColiNet\CoilInterNoAutoRegVec.Graph')
// 
/*********************************************************************
function [Neightbours, varargout]= mexNodeSurroundings(Graph,NodeIDs,Distance,Direction)
% For each requested node, a list of neighbours for each distance (up the the specified) is returned
% The function is a general case of mexNodeNeighbours which concentrates on single distance only. It is 
% slightly less efficient.
%
% Receive:
%	Graph		-	Graph Struct	-	Struct created with ObjectCreateGraph function (probanly called by GraphLoad).
%	NodeIDs		-	integer			-	the ID of the node for whitch the neighbours are searched.
%					vector			-	List of IDs, in this case cell array lists of neighbours is returned.
%	Distance	-	integer			-	The distance up to witch to look. The computation time may increas with the distance dramatically (especially for densly connected graphs).
%	Direction	-	string			-	(optional) Either 'direct' or 'inverse'. Case insensitive. The incoming or outgoing links are 
%										followed as a function of this parameter. Default: 'direct'
%
%
%
% Returns: 
%	Neightbours	-	cell array, (Distancex1)	-	If NodeID is scalar, cell array of vectors is returned. Each vector lists the neighbors at the appropiate distance. 
%													The first element is 0-distance (the node itself). Second - immidiate neighbours, etc.
%					cell array					-	If NodeID is vector, cell array is returned. Each cell is cell array on it's own, representing neigbours of the 
%													appropriate node. (see above).
%	NumberOfAgents	-	matrix	size(NodeIDs) x Distance - (optional) Generated only if a placeholder for parameter is provided. The matrix holds number  of neighbours at each distance for each node.
% 
% See Also:
%	ObjectCreateGraph , GraphLoad, mexNodeNeighbours
%																										
%Created:																							
%	Lev Muchnik,	11/06/04 (Bonn)
%	lev@topspin.co.il, +972-54-326496																							
%  
%
%
*********************************************************************/


#include "EvaluateNodeSurroundings.h"
#include  "..\Utilities\mexMatLab\MatLabDefs.h"

void mexFunction(
		int nlhs,              // Number of left hand side (output) arguments
		mxArray *plhs[],       // Array of left hand side arguments
		int nrhs,              // Number of right hand side (input) arguments
		const mxArray *prhs[]  // Array of right hand side arguments
	)
	{
		if (!nrhs) return;
		SetInputParameters(nlhs,plhs,nrhs,prhs);
		PrepareToRun(nlhs,plhs,nrhs,prhs);
		PerformCalculations(nlhs,plhs,nrhs,prhs);
		FreeResourses(nlhs,plhs,nrhs,prhs);
	}


