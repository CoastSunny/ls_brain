
#include "stdafx.h"
#include "EvaluateGraphAllNodeShortestPassesHistogram.h"
#include <math.h>
#include <mex.h>
#include <map>
#include <set>
#include <list>
#include <vector>
#include <algorithm>
#include <numeric>

#include "..\Utilities\Graph\TStaticGraph.h"	
#include "..\Utilities\DebugHelper\MLDebugHelper.h"

const mxArray*	pInputGraph	=	NULL;
unsigned int	NumberOfLinksInGraph	=	0;

TStaticGraph Graph;

unsigned int	SourceNodeNumber = -1;

std::vector<int> PassesLengthHistogram; // counts the number of passes of each length. Each destination node is only counted once!
std::vector< std::pair<unsigned int,unsigned int> > PassesToNode;			// counts number of shortest passes from the source node to the destination and their length
typedef std::list< 

TPassesType Passes;s

TMLDebugHelper MLDebugHelper;
//------------------------------------------------------------------------------------------------------------------ 
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{

	if (nrhs < 2 || nrhs > 3  ) { mexErrMsgTxt("Two or three input arguments required."); }
	if (nlhs > 2	) {	mexErrMsgTxt("Up to 2 output arguments allowed.");	}
	pInputGraph	= prhs[0];	
	
	SourceNodeNumber = static_cast<unsigned int>(floor(0.5+mxGetScalar(prhs[1])));

	NumberOfLinksInGraph = mxGetM(mxGetField(pInputGraph,0,"Data"));
} 
//------------------------------------------------------------------------------------------------------------------ 
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
 	// create a list of links	
	if (nrhs>2) {
		Graph.Assign(pInputGraph,prhs[2]);
	}
	else {  Graph.Assign(pInputGraph,dirDirect); }
} 
//------------------------------------------------------------------------------------------------------------------ 
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{		
	MLDebugHelper << Graph.GetNumberOfLinkedNodes() << "  " << Graph.GetNumberOfLinks() <<	  dbFlush;
	
	Passes.clear();
	PassesToNode.assign( Graph.GetNumberOfLinkedNodes(), std::pair<unsigned int,unsigned int>(0,0) );	
	
	std::vector<unsigned int> SelfPath(1,SourceNodeNumber);
	std::list<  std::vector<unsigned int> > SingleSelfPath;
	SingleSelfPath.push_back(SelfPath);
	Passes.push_back( SingleSelfPath );
	PassesToNode[SourceNodeNumber] = std::pair<unsigned int,unsigned int>(1,1);
	PassesLengthHistogram.assign(1,1);

	TPassesType::const_iterator CurrentPosition = Passes.begin();	 // pointer to the current pass	
int i = 0;
	while (CurrentPosition != Passes.end() && CurrentPosition->size()>0 && i < 1000000) {
		// go to next deapth
		PassesLengthHistogram.push_back(0);
		Passes.push_back (std::list< std::vector<unsigned int> >());
		std::list< std::vector<unsigned int> >& NextDeapth = Passes.back();
		for (std::list< std::vector<unsigned int> >::const_iterator CurrentPath = CurrentPosition->begin(); CurrentPath != CurrentPosition->end(); ++CurrentPath ) {
			std::vector<unsigned int> CurrentPathVector(*CurrentPath);	CurrentPathVector.resize(CurrentPath ->size()+1);
			const std::vector<unsigned int>& LastNodeNeighbours = Graph.Negighbours(CurrentPath->back());
{		 MLDebugHelper << "Deapth: " << PassesLengthHistogram.size() << ". Elements: " << CurrentPosition->size() << ". i= " << i << dbFlush; }			
			// go over all neighbours of the last node in the current pass (of length Depth)			
			for(std::vector<unsigned int>::const_iterator It = LastNodeNeighbours.begin(); i < 1000000 && It != LastNodeNeighbours.end(); ++It) {
				if (PassesToNode[*It].first==0) {   // first pass to the node *It
					PassesToNode[*It].first =   PassesLengthHistogram.size();
					++PassesLengthHistogram.back();	 
				}
				++PassesToNode[*It].second;
				CurrentPathVector.back() = *It;
				NextDeapth.push_back(CurrentPathVector);
++i;					
			} // loop over all neighbours of the last node
		} // loop over all passes of the current deapth
		++CurrentPosition; // go to next deapth
		MLDebugHelper << i << "     " << Passes.size() <<	  dbFlush;

	}
}

//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{  
	return;
	const char *FNDestinationNode = "DestinationNode";
	const char *FNPassLength	  = "PassLength";
	const char *FNNumberOfPasses  = "NumberOfPasses";
	const char *FNPasses		  = "Passes";
	const char* FieldNames[4]	  = { FNDestinationNode, FNPassLength, FNNumberOfPasses, FNPasses};

	unsigned int TotalDistinctDestonations = std::accumulate(PassesLengthHistogram.begin(),PassesLengthHistogram.end(),0);
	mxArray* Result = mxCreateStructMatrix(TotalDistinctDestonations,1,4,FieldNames);
	int LastArrayIndex = 0;
	std::map<unsigned int,unsigned int> LookupTable;
	for (TPassesType::const_iterator CurrentDeapth = Passes.begin(); CurrentDeapth !=  Passes.end(); ++CurrentDeapth) {
		for (std::list< std::vector<unsigned int> >::const_iterator CurrentPath =  CurrentDeapth->begin(); CurrentPath !=  CurrentDeapth->end(); ++CurrentPath) {
			if (LookupTable.find(CurrentPath->back())==LookupTable.end()) {
				LookupTable[CurrentPath->back()] = LastArrayIndex;			
				mxSetField(Result,LastArrayIndex,FNDestinationNode,mxCreateDoubleScalar(CurrentPath->back()));
				
				mxSetField(Result,LastArrayIndex,FNPassLength,mxCreateDoubleScalar((double)CurrentPath->size()));
				mxSetField(Result,LastArrayIndex,FNPasses,mxCreateDoubleMatrix( (int) CurrentPath->size(),PassesToNode[CurrentPath->back()].second,mxREAL));
				mxSetField(Result,LastArrayIndex,FNNumberOfPasses,mxCreateDoubleScalar(0));			
				++LastArrayIndex;
			}
			unsigned int ArrayIndex = LookupTable[CurrentPath->back()];
			double* CurrentDataPtr = mxGetPr( mxGetField(Result,ArrayIndex,FNPasses) );
			mxArray*  Shift = mxGetField(Result,ArrayIndex,FNNumberOfPasses);
			std::copy(CurrentPath->begin(),CurrentPath->end(),CurrentDataPtr + (int)(mxGetScalar(Shift))*CurrentPath->size());
			*mxGetPr(Shift) = mxGetScalar(Shift)+1;
		}
	}
	plhs[0] = Result;
	if (nlhs>1) {
		mxArray* Result = mxCreateDoubleMatrix((int)PassesLengthHistogram.size(),1,mxREAL);
		double* Ptr = mxGetPr(Result);
		for (unsigned int i = 0; i <  PassesLengthHistogram.size(); ++i) {
			Ptr[i] = (double)PassesLengthHistogram[i];
		}
		plhs[1] = Result;
	}
	Graph.Clear();
	PassesLengthHistogram.clear(); 
	Passes.clear();
	PassesToNode.clear();
}
//------------------------------------------------------------------------------------------------------------------ 
