// mexCreateGUID.cpp : Defines the entry point for the DLL application.
//
/**********************************************************************
function GUID = mexCreateGIUD
% Generates and returns a unique GUID number.
%
% Receives:
%		nothing
%
% Returns:
%		GUID		-	string	-	GUID
%
% 
% Created:
%   
%   Lev Muchnik    14/03/2005, lev@topspin.co.il, +972-54-4326496
%   
% Major Updates
%
**********************************************************************/

#include <objbase.h>
 //#include <atlbase.h>

#include "..\Utilities\mexMatLab\MatLabDefs.h"
void mexFunction(
		int nlhs,              // Number of left hand side (output) arguments
		mxArray *plhs[],       // Array of left hand side arguments
		int nrhs,              // Number of right hand side (input) arguments
		const mxArray *prhs[]  // Array of right hand side arguments
	)
		
	{
		CoInitialize(NULL);
		if (nrhs!=0) { 	mexErrMsgTxt("The function receives no parameters");	}
		if (nlhs>1) { 	mexErrMsgTxt("The function returns at most one parameter");	}
		GUID theGUID;
		char GUIDStr[80];		
		GUIDStr[0] = 0;

		//LPOLESTR OLEGUIDStr = A2OLE(GUIDStr);
		if ( (CoCreateGuid(&theGUID) == S_OK ) && (StringFromGUID2(theGUID,(LPOLESTR)GUIDStr,80) != 0) ) {
		//	plhs[0] = mxCreateString(OLE2A(GUIDStr)); 
			for (int i = 0; i < 40; ++i) {	GUIDStr[i] = GUIDStr[2*i];	}			
			plhs[0] = mxCreateString((GUIDStr)); 
		}
		else {
			plhs[0] = mxCreateString(NULL);
		}
	}


