

#ifndef EVALUATE_GRAPH_ALL_NODE_SHORTEST_PATHS
#define EVALUATE_GRAPH_ALL_NODE_SHORTEST_PATHS
	#include  "..\Utilities\mexMatLab\MatLabDefs.h"

// External Functions:
	#ifdef __cplusplus
		extern "C" {
	#endif			

	// functions, called from mexFunction
	void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
	void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
	void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
	void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);

	#ifdef __cplusplus
		}
	#endif	
#endif	// EVALUATE_GRAPH_ALL_NODE_SHORTEST_PATHS
