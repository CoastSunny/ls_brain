

#include "EvaluateGraphGeneratePoissonRandomGraph.h"
#include <math.h>
#include <stdlib.h>
#include <list>
#include <utility>
#include <stdlib.h>
#include <time.h>

unsigned int	NumberOfNodes	=	0;
double			p				=	0.0;

std::list<std::pair<unsigned int,unsigned int> > LinksList; // list of the graph links
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs != 2) { mexErrMsgTxt("Two input arguments are required"); }
	if (nlhs >1) {	mexErrMsgTxt("Up to one output arguments is allowed.");	}
	
	NumberOfNodes = static_cast<unsigned int>(floor(mxGetScalar(prhs[0])+0.5));
	p			  = mxGetScalar(prhs[1]);
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	srand( (unsigned)time( NULL ) );
	mxArray *lhs[1] = { NULL };
	int P = static_cast<int>(floor(p*RAND_MAX+0.5));
	for (unsigned int i = 0; i < NumberOfNodes; ++i) {
		for (unsigned int j = 0; j < NumberOfNodes; ++j) {
			int CurrentP = rand();
			if (CurrentP<P && i!=j ) {
				LinksList.push_back( std::pair<unsigned int,unsigned int> (i,j) );
			}
		} // for j
	} // for i
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	unsigned int NumberOfLinks = static_cast<unsigned int>(LinksList.size());
	mxArray *rhs[2] = { mxCreateDoubleMatrix(NumberOfLinks,3, mxREAL), mxCreateString("mexGraphGeneratePoissonRandomGraph") };
	double* Ptr = mxGetPr(rhs[0]);
	while (!LinksList.empty()) {
		*Ptr						= LinksList.front().first;
		*(Ptr + NumberOfLinks)		= LinksList.front().second;
		*(Ptr + 2*NumberOfLinks)	= 1.0;			
		LinksList.pop_front();
		++Ptr;
	}
	mexCallMATLAB(1,plhs, 2 , rhs  , "ObjectCreateGraph");
	mxDestroyArray(rhs[0]); rhs[0] = NULL;
	mxDestroyArray(rhs[1]); rhs[1] = NULL;	
	LinksList.clear();
}
//------------------------------------------------------------------------------------------------------------------
