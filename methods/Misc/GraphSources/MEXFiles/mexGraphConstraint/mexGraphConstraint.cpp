// mexConstraint.cpp : Defines the entry point for the DLL application.
//
/*************************************************************************
function Ck = mexGraphConstraint(Graph,Nodes,Direction)
% Computes the clustering coefficient for any of the supplied nodes of the Graph.
% By deffinition (Collective dynamics of ‘small-world’ networks Duncan J. Watts* & Steven H. Strogatz), 
% the clusterung coefficient Ck of the node k is the ratio of neigbours of 
% the node k, connected between them
%
% Receives:	
%	Graph		-	Graph Struct	-	Struct created with ObjectCreateGraph function (probanly called by GraphLoad).
%	NodeIDs		-	vector of indeces	-	(optional) List the ID of the node for whitch the coefficient is computed.
%										If Nodes is an empty matrix, all graph nodes are used. 	Default: [] 
%	Direction	-	string			-	(optional) Either 'direct' or 'inverse'. Case insensitive. The incoming or outgoing links are 
%										followed as a function of this parameter. Default: 'direct'
%
%
%
% Returns: 
%	Ck			-	vector of double	-	Vector of clustering coefficient for each of the supplied nodes.
% 
% See Also:
%	ObjectCreateGraph , GraphLoad
%																										
%Created:																							
%	Lev Muchnik,	14/06/04 (Bonn),15/06/04 (train Cologne->Bielefeld)
%	lev@topspin.co.il, +972-54-326496																							
%

*************************************************************************/

#include "stdafx.h"
#include  "..\Utilities\mexMatLab\MatLabDefs.h"
#include "EvaluateGraphConstraint.h"

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


