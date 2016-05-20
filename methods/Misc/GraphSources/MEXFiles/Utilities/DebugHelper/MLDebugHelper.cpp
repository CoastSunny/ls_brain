

#include "MLDebugHelper.h"

//#include <mex.h>
#include "..\mexMatLab\MatLabDefs.h"
#include <stdlib.h>

//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
TMLDebugHelper& operator<< (TMLDebugHelper& out,int value)
{
	char buffer[65];
	_ltoa_s(value,buffer,10);
	return out << (buffer);
}
//--------------------------------------------------------------------------------------------
TMLDebugHelper& operator<< (TMLDebugHelper& out,unsigned int value)
{
	char buffer[65];
	_ultoa_s(value,buffer,10);
	return out << (buffer);
}
//--------------------------------------------------------------------------------------------
#ifdef _M_X64
TMLDebugHelper& operator<< (TMLDebugHelper& out, size_t value)
{
	char buffer[65];
	_ultoa_s((unsigned int)value,buffer,10);
	return out << (buffer);
}
#endif // #ifdef _M_X64
//--------------------------------------------------------------------------------------------
TMLDebugHelper& operator<< (TMLDebugHelper& out,double value)
{
	char buffer[65];
	_gcvt_s(buffer,65,value,10);
	return out << (buffer);
}
//--------------------------------------------------------------------------------------------
TMLDebugHelper& operator<< (TMLDebugHelper& out, char value)
{
	return out << (&value);
}
//--------------------------------------------------------------------------------------------
TMLDebugHelper& operator<< (TMLDebugHelper& out, EMLDebugHelper value)
{
	switch(value) {
	 case dbEndl	: 
		 return out << ("\n");
	 case dbFlush	:
		 return out.Flush();
	 default		:
		 return out;
	}
}
//--------------------------------------------------------------------------------------------
TMLDebugHelper& TMLDebugHelper::Flush()
{
	mxArray* Str = mxCreateString(FStr.c_str());
	mxArray *rhs[1] = { Str };
	mexCallMATLAB(0, NULL , 1, rhs, "disp");
	mxDestroyArray(rhs[0]); rhs[0] = NULL;		
	Clear();
	return *this;
}
//--------------------------------------------------------------------------------------------