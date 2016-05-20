
#include <set>
#include <map>
#include <math.h>

#include "EvaluateGraphSqueeze.h"
#include "../Utilities/DebugHelper/MLDebugHelper.h"

//TMLDebugHelper MLDebugHelper;
const mxArray* pInputGraph = NULL;
mxArray* pOutputGraph = NULL;
std::map<unsigned int,unsigned int> HashTable;
//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs != 1 ) {
		mexErrMsgTxt("One input arguments required.");		
	}
	if (nlhs > 2) {
		mexErrMsgTxt("Up to two output arguments are allowed.");
	}
	pInputGraph	= prhs[0];
	
	mxArray *GraphType = mxCreateString("Graph");
	mxArray *ErrorMessage = mxCreateString("The input must be of the type \"Graph\". Please use ObjectCreateGraph function");
	

	mxArray *rhs[3] = {const_cast<mxArray*>(pInputGraph), GraphType, ErrorMessage};
	mxArray *lhs[1];
	mexCallMATLAB(0, lhs, 3, rhs, "ObjectIsType");
	mxDestroyArray(GraphType);		GraphType		=	NULL;
	mxDestroyArray(ErrorMessage);	ErrorMessage	=	NULL;
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
}
//------------------------------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	std::set<unsigned int> OriginalNodes;
	pOutputGraph = mxDuplicateArray(pInputGraph);	 

	// create a list of nodes:
	double* DataPtr = mxGetPr(mxGetField(pOutputGraph,0,"Data"));
	const double* const DataPtrEnd = mxGetPr(mxGetField(pOutputGraph,0,"Data")) + mxGetM(mxGetField(pOutputGraph,0,"Data"))*2;
	for (const double* CurrentDataPtr = DataPtr;  CurrentDataPtr < DataPtrEnd ; ++CurrentDataPtr) {
		OriginalNodes.insert((unsigned int)floor(*CurrentDataPtr+0.5));
	}

	// create a dictionary of replacement order:	
	HashTable.clear();
	std::map<unsigned int,unsigned int>::iterator InsertesLocation = 	HashTable.begin();
	for (std::set<unsigned int>::const_iterator It = OriginalNodes.begin(); It != OriginalNodes.end(); ++It) {
		 InsertesLocation =  HashTable.insert(InsertesLocation,std::map<unsigned int,unsigned int>::value_type(*It,static_cast<unsigned int>(HashTable.size()+1)));
	}
	
	// replace node numbers in the output array:
	for (double* CurrentDataPtr = DataPtr;  CurrentDataPtr < DataPtrEnd ; ++CurrentDataPtr) {
		//OriginalNodes.insert((unsigned int)floor(*CurrentDataPtr+0.5));
		*CurrentDataPtr = (double) HashTable[(unsigned int)floor(*CurrentDataPtr + 0.5)];
	}
	
	// re-enumerate index:
	mxArray *IndexStructure = mxGetField(pOutputGraph,0,"Index");
	if (IndexStructure) {
		mxArray* IndexValues = mxGetField(IndexStructure,0,"Values");
		if (IndexValues) {
			//MLDebugHelper << (unsigned int)HashTable.size() << dbFlush;
			//MLDebugHelper << (const char*)"Index values ON: " << (int)mexGetNumberOfElements(IndexValues) << dbFlush;			
			for (double* CurrentDataPtr = mxGetPr(IndexValues); CurrentDataPtr < mxGetPr(IndexValues)+mxGetNumberOfElements(IndexValues); ++CurrentDataPtr) {				
				if (HashTable.find((unsigned int)floor(*CurrentDataPtr + 0.5))==HashTable.end()) {
					HashTable[(unsigned int)floor(*CurrentDataPtr + 0.5)] = (unsigned int)(HashTable.size()+1);
				}
				*CurrentDataPtr = (double) HashTable[(unsigned int)floor(*CurrentDataPtr + 0.5)];
			}
		}
		mxArray* NodeProperties = mxGetField(IndexStructure,0,"Values");

		// re-enumerate properties:
		mxArray* Properties = mxGetField(IndexStructure,0,"Properties");
		for (unsigned int i = 0;Properties && i < mxGetNumberOfElements(Properties); ++i) { // for each property
			mxArray* CurrentPropertyValues = mxGetField(Properties,i,"NodeIDs");
			if (CurrentPropertyValues) {
				for (double* CurrentDataPtr = mxGetPr(CurrentPropertyValues); CurrentDataPtr < mxGetPr(CurrentPropertyValues)+mxGetNumberOfElements(CurrentPropertyValues); ++CurrentDataPtr) {				
					if (HashTable.find((unsigned int)floor(*CurrentDataPtr + 0.5))==HashTable.end()) {
						HashTable[(unsigned int)floor(*CurrentDataPtr + 0.5)] = (unsigned int)(HashTable.size()+1);
					}
					*CurrentDataPtr = (double) HashTable[(unsigned int)floor(*CurrentDataPtr + 0.5)];
				}
			}
		}
	}

	

/*
	char DummyStr[256];
	for (int i = 0; i < 10; ++i) {
		sprintf(DummyStr,"%f",*(DataPtr+i));
		mexWarnMsgTxt(DummyStr);	
	}
*/

}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	/*
	mxArray *pSignature = mxCreateString("mxGraphSqueeze");
	mxArray *rhs[3] = { pResult, const_cast<mxArray*>(pScale), pSignature};
	mxArray *lhs[1];
	mexCallMATLAB(1, lhs, 3, rhs, "ObjectCreateTimeSeries");

	mxDestroyArray(pResult); pResult = NULL; 
	mxDestroyArray(pSignature); pResult = NULL; 
	*/
	plhs[0]=pOutputGraph;
	if (nlhs>1) {
		mxArray *LUT = mxCreateDoubleMatrix(static_cast<unsigned int>(HashTable.size()), 2,mxREAL);
		double* Ptr = mxGetPr(LUT);	
		for (std::map<unsigned int,unsigned int>::const_iterator It = HashTable.begin(); It != HashTable.end(); ++It,++Ptr) {
			*Ptr = (double)It->first;
			*(Ptr+HashTable.size()) = (double)It->second;
		}
		plhs[1] = LUT;
	}
	HashTable.clear();
}
//------------------------------------------------------------------------------------------------------------------
