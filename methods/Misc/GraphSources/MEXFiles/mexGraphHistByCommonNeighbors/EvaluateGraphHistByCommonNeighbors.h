#ifndef EVALUATE_GRAPH_HIST_BY_COMMON_NEIGHBORS
#define EVALUATE_GRAPH_HIST_BY_COMMON_NEIGHBORS
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
#endif	// EVALUATE_GRAPH_HIST_BY_COMMON_NEIGHBORS
