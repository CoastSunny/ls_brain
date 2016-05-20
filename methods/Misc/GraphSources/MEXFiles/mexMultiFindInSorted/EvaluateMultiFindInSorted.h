
#ifndef EVALUATE_MULTI_FIND_IN_SORTED
#define EVALUATE_MULTI_FIND_IN_SORTED
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
#endif	// EVALUATE_MULTI_FIND_IN_SORTED
