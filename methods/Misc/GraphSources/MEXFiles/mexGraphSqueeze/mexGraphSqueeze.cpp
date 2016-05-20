// mexGraphSqueeze.cpp : Defines the entry point for the DLL application.
//
/**********************************************************************
function Graph = mexGraphSqueeze(Graph)
% Renumbers the graph nodes so that they are numbered by consecutive numbers. This is assumed for many of the Graph  toolbox functions
%
% Receive:
%	Graph	-	Graph Struct	-	Struct created with ObjectCreateGraph function (probanly called by GraphLoad.
%
% Returns: 
%	Graph	-	Graph Struct	-	The same graph with node numbers re-enumerated
% 
% See Also:
%	ObjectCreateGraph , GraphLoad
%																										
%Created:																							
%	Lev Muchnik,	04/06/04 (Cologne University)
%	lev@topspin.co.il, +972-54-326496																							
%Major Update:  
%	Lev Muchnik,	12/02/05
%	The function also supports Index field of Graphs, maintaining agreement between node index and name.
%
%	Lev Muchnik,	21/02/2005
%	Index can contain unlinked nodes and the squeeze operation re-enumerates them properly.
%  
%
%
**********************************************************************/

#include "EvaluateGraphSqueeze.h"
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
