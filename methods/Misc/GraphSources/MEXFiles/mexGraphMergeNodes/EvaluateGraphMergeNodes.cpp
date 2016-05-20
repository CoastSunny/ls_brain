
#include "EvaluateGraphMergeNodes.h"


#include <string.h>
#include <math.h>
#include <vector>
#include <set>
#include <map>
#include <algorithm>

//#include "../Utilities/DebugHelper/MLDebugHelper.h"
//TMLDebugHelper MLDebugHelper;

std::vector< std::set<unsigned int> > GraphDirect;
std::map<unsigned int,unsigned int>		LUT;		// Look up table

const mxArray*	pInputGraph	=	NULL;
const mxArray*	pLUT		=	NULL;	// Loock up table - list of nodes to be replaced. Nx2 matrix of indeces.


//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs != 2 ) { mexErrMsgTxt("Two input arguments required."); }
	if (nlhs > 2	) {	mexErrMsgTxt("Up to 2 output argument allowed.");	}
	pInputGraph	=	prhs[0];	
	pLUT		=	prhs[1];
	if ( mxGetN(pLUT)!=2 || mxGetNumberOfDimensions(pLUT)!=2) {
		mexErrMsgTxt("Second argument must Nx2 matrix");
	}

}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	// create a list of links	
	for (const double* pLUTFrom = mxGetPr(pLUT); pLUTFrom < mxGetPr(pLUT) + mxGetM(pLUT); ++pLUTFrom) { // go over all replacements
		LUT[(unsigned int)floor(*pLUTFrom+0.5)] = (unsigned int)floor(*(pLUTFrom+mxGetM(pLUT))+0.5);
	}
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	
	const mxArray* pData				=	NULL;
	if ( mxIsStruct(pInputGraph) ) {
	    pData = mxGetField(pInputGraph,0,"Data");
	}
	else {
		pData = pInputGraph;	
	}
	unsigned int NumberOfLinks 			=	static_cast<unsigned int>(mxGetM(pData));

	// Relax multiple redirections:
	for (std::map<unsigned int,unsigned int>::iterator It = LUT.begin(); It != LUT.end(); ++It) {
		std::map<unsigned int,unsigned int>::const_iterator DestIt;
		std::set<unsigned int> History;
		while ( (DestIt=LUT.find(It->second))!=LUT.end() && DestIt!=It) { // the second parameter prevents infinit loops for self-redirection.
			if (History.find(DestIt->second)==History.end()) {
				History.insert(It->second);
				It->second = DestIt->second;
			}
			else {
				break;
			}
		}
	}
	
	// Build the graph:
	unsigned int MaxNode = static_cast<unsigned int>(floor(*std::max_element( mxGetPr(pData),mxGetPr(pData)+2*NumberOfLinks)+0.5));
	GraphDirect.assign(	MaxNode +1, std::set<unsigned int> () );
	
	for (const double* P = mxGetPr(pData); P < mxGetPr(pData)+NumberOfLinks; ++P) {
		unsigned int From	= (unsigned int)floor(*P+0.5);
		unsigned int To		= (unsigned int)floor(*(P+NumberOfLinks)+0.5);
		
		std::map<unsigned int,unsigned int>::const_iterator It;
		if ( (It=LUT.find(From))!=LUT.end() ) {
			From = It->second;
		}
		if ( (It=LUT.find(To))!=LUT.end() ) {
			To = It->second;
		}
		if (From!=To) {
			GraphDirect[From].insert(To);
		}		
	}
	/* for (std::map<unsigned int,unsigned int>::iterator It = LUT.begin(); It != LUT.end(); ++It) {		
		GraphDirect[It->first].insert(It->second);		
	} */	
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	unsigned int FinalNumberOfLinks = 0;
	for (std::vector< std::set<unsigned int> >::const_iterator It = GraphDirect.begin();It != GraphDirect.end(); ++It) {
		FinalNumberOfLinks +=   (int)It->size();
	}	
	mxArray* Links = mxCreateDoubleMatrix(FinalNumberOfLinks,3,mxREAL);
	double *pLinks = mxGetPr(Links);
	for (unsigned int i = 0; i < GraphDirect.size() && pLinks <= mxGetPr(Links) + FinalNumberOfLinks; ++i) {		
		for (std::set<unsigned int>::const_iterator Dest = GraphDirect[i].begin(); Dest != GraphDirect[i].end() && pLinks <= mxGetPr(Links) + FinalNumberOfLinks; ++Dest) {
			*pLinks = i;
			*(pLinks+FinalNumberOfLinks)	= *Dest;
			*(pLinks+2*FinalNumberOfLinks)	= 1.0;
			++pLinks;
		}
	}
	if (nlhs>1) {
		plhs[1] = mxCreateDoubleMatrix((int)LUT.size(),2,mxREAL);
		double* pLUTResult = mxGetPr(plhs[1]);
		unsigned int i  = 0; 
		for (std::map<unsigned int,unsigned int>::const_iterator  it = LUT.begin(); it!=LUT.end(); ++it,++i) {
			pLUTResult[i] = it->first;
			pLUTResult[i+LUT.size()] = it->second;
		}
		
	}	 

	GraphDirect.clear();
	LUT.clear();	
	pInputGraph = NULL;
	pLUT = NULL;

	plhs[0] = Links;
}
//------------------------------------------------------------------------------------------------------------------
