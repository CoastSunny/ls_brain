
#include "EvaluateMultiFind.h"


#include "../Utilities/DebugHelper/MLDebugHelper.h"

TMLDebugHelper MLDebugHelper;
//const mxArray* pData   = NULL;
//const mxArray* pSearch = NULL;
//mxArray* pResult = NULL;

//------------------------------------------------------------------------------------------------------------------
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs != 2 ) { mexErrMsgTxt("Two input arguments required."); }
	if (nlhs > 1	) {	mexErrMsgTxt("Up to 1 output argument allowed.");	}
	if (mxGetNumberOfDimensions(prhs[0])!=2) { mexErrMsgTxt("Firts argument must be vector or matrix");	}
}
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (mxGetM(prhs[0])!=1 && mxGetN(prhs[0])!=1) { // pData is matrix
		plhs[0] = mxCreateCellMatrix(1,static_cast<int>(mxGetN(prhs[0])));
	}
	else { // pData is vector
		plhs[0]= mxCreateNumericArray(mxGetNumberOfDimensions(prhs[1]),mxGetDimensions(prhs[1]), mxUINT32_CLASS,mxREAL);
	}
}
//------------------------------------------------------------------------------------------------------------------
template <typename T> void DoFind(unsigned int* CurRes, const T* const pSearch, const unsigned int SearchSize, const T* const pData, const unsigned int DataSize) 
{
	memset(CurRes,0,SearchSize*sizeof(unsigned int));
	for (const T* CurSearch = pSearch; CurSearch < pSearch + SearchSize; ++CurRes, ++CurSearch) {
		for (const T*	CurData	= pData; *CurRes==0 &&  CurData < pData+DataSize; ++CurData) {
			if (*CurData == *CurSearch) {
				*CurRes = (unsigned int)(CurData -  pData+1);
			}				
		}
	}	
}
//------------------------------------------------------------------------------------------------------------------
// template specification for string arrays.
template <> void DoFind<mxArray>(unsigned int* CurRes, const mxArray* const pSearch, const unsigned int SearchSize, const mxArray* const pData, const unsigned int DataSize) 
{
	memset(CurRes,0,SearchSize*sizeof(unsigned int));
	for (unsigned int CurrSearchIndex = 0; CurrSearchIndex < SearchSize; ++CurRes, ++CurrSearchIndex) {
		const mxArray* const CurSearch = mxGetCell(pSearch,CurrSearchIndex);
		for(unsigned int CurrDataIndex = 0; *CurRes==0  && CurrDataIndex < DataSize; ++CurrDataIndex) {
			const mxArray* const CurData = mxGetCell(pData,CurrDataIndex);
			if ( (mxGetNumberOfElements(CurData)==mxGetNumberOfElements(CurSearch)) && (memcmp(mxGetPr(CurData),mxGetPr(CurSearch),mxGetNumberOfElements(CurData))==0) ) 
			{
				*CurRes = CurrDataIndex+1;
			}
		}
	}	
}
//------------------------------------------------------------------------------------------------------------------

void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	const mxArray*	pData	=	prhs[0];	
	const mxArray*	pSearch	=	prhs[1];
	mxArray*		pResult =	plhs[0];

	if ( mxIsCell(pResult) ) {
		mxArray* CurrRes =mxCreateNumericMatrix(static_cast<int>(mxGetM(pData)),1, mxGetClassID(pData),mxREAL);
			//mxCreateDoubleMatrix(mxGetM(pData),1,mxREAL);
		mxArray *plhs[1];
		mxArray *prhs[2] = { CurrRes, const_cast<mxArray*>(pSearch) };
		unsigned int Count = static_cast<unsigned int>(mxGetN(pData));
		for (unsigned int i = 0; i < mxGetN(pData); ++i) {
			memcpy(mxGetPr(CurrRes), (char*)mxGetPr(pData)+ mxGetElementSize(pData)*i*mxGetM(pData),mxGetElementSize(pData)*mxGetM(pData));
			mexCallMATLAB(1, plhs, 2,prhs, "mexMultiFind");
			mxSetCell(pResult,i, plhs[0]);
		}       			  
	}
	else {	
		unsigned int* CurRes = reinterpret_cast<unsigned int*>(mxGetPr(pResult));
		if ( (mxGetClassID(pSearch)==mxUINT32_CLASS) &&(mxGetClassID(pData)==mxUINT32_CLASS) ){
			DoFind(CurRes, reinterpret_cast<unsigned int*>(mxGetPr(pSearch)), static_cast<unsigned int>(mxGetNumberOfElements(pSearch)), reinterpret_cast<unsigned int*>(mxGetPr(pData)),static_cast<unsigned int>(mxGetNumberOfElements(pData)));
		}
		else if ( (mxGetClassID(pSearch)==mxINT32_CLASS) &&(mxGetClassID(pData)==mxINT32_CLASS) ){
			DoFind(CurRes, reinterpret_cast<int*>(mxGetPr(pSearch)), static_cast<unsigned int>(mxGetNumberOfElements(pSearch)), reinterpret_cast<int*>(mxGetPr(pData)),static_cast<unsigned int>(mxGetNumberOfElements(pData)));
		}
		else if ( (mxGetClassID(pSearch)==mxSINGLE_CLASS) &&(mxGetClassID(pData)==mxSINGLE_CLASS) ){
			DoFind(CurRes, reinterpret_cast<float*>(mxGetPr(pSearch)), static_cast<unsigned int>(mxGetNumberOfElements(pSearch)), reinterpret_cast<float*>(mxGetPr(pData)),static_cast<unsigned int>(mxGetNumberOfElements(pData)));
		}
		else if ((mxGetClassID(pSearch)==mxDOUBLE_CLASS) &&(mxGetClassID(pData)==mxDOUBLE_CLASS)) {
			DoFind(CurRes, mxGetPr(pSearch), static_cast<unsigned int>(mxGetNumberOfElements(pSearch)), mxGetPr(pData),static_cast<unsigned int>(mxGetNumberOfElements(pData)));
		}
		else if ((mxGetClassID(pSearch)==mxCELL_CLASS) &&(mxGetClassID(pData)==mxCELL_CLASS)) {
			DoFind(CurRes, pSearch, static_cast<unsigned int>(mxGetNumberOfElements(pSearch)), pData,static_cast<unsigned int>(mxGetNumberOfElements(pData)));
		}
		else {
			mexErrMsgTxt("Noth inputs must be of the same data type");
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
//	plhs[0] = pResult;
}
//------------------------------------------------------------------------------------------------------------------
