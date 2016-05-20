// mexCountEmbeddedTies.cpp : Defines the entry point for the DLL application.
//
/*************************************************************************
function [EmbeddedTiesCount, varargout] = mexGraphCountEmbeddedTies(Graph,NodePairs,Direction)
% Computes the number of common friends between node pairs
%
% Receives:	
%	Graph		-	Graph Struct			-	Struct created with ObjectCreateGraph function (probanly called by GraphLoad).
%	NodePairs	-	vector of indeces, 2xM  -	A list of M node pairs. The number of common neighbors is computed for each pair. 
%	Direction	-	string					-	(optional) Either 'direct', 'inverse' or 'both'. Case insensitive. The incoming or outgoing links are 
%												followed as a function of this parameter. Default: 'direct'
%
%
%
% Returns: 
%	EmbeddedTiesCount -	vector of integer values, 1xM  -	number of common friends for each node
%	NodePairs		  - 	vector of indeces, 2xM  - (optional)list of node pairs for which he function was called. 
%
%
% Algorithm:
%       http://www.analytictech.com/ucinet/help/hs4387.htm
%
% See Also:
%	ObjectCreateGraph , GraphLoad
%																										
%Created:																							
%	Lev Muchnik,	01.Jan.2011
%	levmuchnik@gmail.com

*************************************************************************/


#include  "..\Utilities\mexMatLab\MatLabDefs.h"
#include "EvaluateGraphCountEmbeddedTies.h"

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


