// mexGraphConnectedComponents.cpp : Defines the entry point for the DLL application.
//

/****************************************************************************
function [ConnectedComponents, varargout] = mexGraphConnectedComponents(Graph,Direction)
%Computes and returns the list of unconnected clusters of the Graph. Each cluster nodes are giver.
%
%	Graph		-	Graph Struct	-	Struct created with ObjectCreateGraph function (probanly called by GraphLoad).
%	Direction	-	string			-	(optional) Either 'direct', 'inverse' or 'both'. Case insensitive. The incoming or outgoing links are 
%										followed as a function of this parameter. Default: 'direct'
%
%
%
% Returns: 
%	ConnectedComponents - cellarray of 1D vectors	- Each cell represents a cluster disconnected from the other clusters and lists a nodes belongiong to that cluster.
%	ClusterSizes - vector of double			- (optional) If a placeholder for that parameter is provided, it lists the sizes of the clusters listed ConnectedComponents in the same order.
% 
% See Also:
%	ObjectCreateGraph , GraphLoad
%																										
%Created:																							
%	Lev Muchnik,	15/06/04 (Bielefeld, Germany)
%	lev@topspin.co.il, +972-54-326496																							
%




****************************************************************************/

#include "EvaluateGraphConnectedComponents.h"
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