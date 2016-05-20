
#include "EvaluateCirclesOfDegree.h"
#include <fstream>
#include<iostream>
#include <math.h>
#include <map>
#include <set>
#include <list>
#include <vector>
#include <algorithm>

using namespace std;

#include "../Utilities/Graph/TStaticGraph.h"	
#include "../Utilities/DebugHelper/MLDebugHelper.h"
TStaticGraph Graph;
TMLDebugHelper MLDebugHelper;

const mxArray*	pInputGraph	=	NULL; 

unsigned int	NumberOfLinksInGraph	=	0;
unsigned int	SourceNodeNumber = -1;

std::set< std::list<unsigned int> > PathSet;
std::map<unsigned int,std::set< std::list<unsigned int> > > Circles;
std::set<unsigned int> NodesList; // List of nodes which are yet not processed.
//std::map<unsigned int,std::set<unsigned int> > Links; // nodes are keys, liks from (to) that node (depending on the direction) are the values
//map-is 2 value library taht gets a key(the node),and the data(value)-set of sorted target nodes

typedef std::multimap< unsigned int , std::list< unsigned int > > TPassesType;
typedef std::pair<unsigned int ,std::list< unsigned int > > TPassesKeyType; //x,y
TPassesType Passes;
bool SkipTrivialCircles;
//------------------------------------------------------------------------------------------------------------------ 

void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Clear();
	pInputGraph	=	NULL;

	if (nrhs < 1 || nrhs > 2) { mexErrMsgTxt(" one or two input arguments required."); }
	if (nlhs != 2){	mexErrMsgTxt("one or two output arguments allowed.");	}
	pInputGraph	= prhs[0];	
	{
		mxArray *GraphType = mxCreateString("Graph");	
		mxArray *ErrorMessage = mxCreateString("The input must be of the type \"Graph\". Please use ObjectCreateGraph function");	
		mxArray *rhs[3] = {const_cast<mxArray*>(pInputGraph), GraphType, ErrorMessage};
		mxArray *lhs[1];
		mexCallMATLAB(0, lhs, 3, rhs, "ObjectIsType");
		mxDestroyArray(GraphType);		GraphType		=	NULL;
		mxDestroyArray(ErrorMessage);	ErrorMessage	=	NULL;
	}	
} 
//-----------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
		Graph.Assign(pInputGraph,dirDirect); 
		if (nrhs>1) {
			SkipTrivialCircles = (floor(mxGetScalar(prhs[1]))!=0);
		}
		else {  
			SkipTrivialCircles = false;
		}
		Graph.SortNodes();
		NumberOfLinksInGraph = Graph.GetNumberOfLinks();
}
//------------------------------------------------------------------------------------------------------------------ 
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{ 
	for(unsigned int i=1;i<=Graph.GetNumberOfLinkedNodes();i++)
	{
		SourceNodeNumber=i;
		Passes.insert(TPassesKeyType(SourceNodeNumber,std::list<unsigned int>(1,SourceNodeNumber)));
		unsigned int Depth = 1;
		TPassesType* OldPasses = new TPassesType(Passes);
		while (!OldPasses->empty()) 
		{
			// find Passes of the (Depth+1) length
			TPassesType  *NewPasses = new TPassesType();
			// go over all passes of depth Depth (collected during the previous cycle).
			for (TPassesType::const_iterator CurrentPassIt = OldPasses->begin(); CurrentPassIt!=OldPasses->end(); ++CurrentPassIt) {
				NodesList.insert(CurrentPassIt->first); // collect all nodes to which the pass was found.
				std::list<unsigned int> CurrentPath = CurrentPassIt->second;
				const std::vector<unsigned int>& LastNodeNeighbours = Graph.Neighbours(CurrentPath.back());
				// go over all neighbours of the last node in the current pass (of length Depth)
				unsigned int PassCounter  = 0;
				unsigned int PrevNodeID = -1;
				for(std::vector<unsigned int>::const_iterator It = LastNodeNeighbours.begin(); It != LastNodeNeighbours.end(); ++It) {
					if ( Passes.find(*It)==Passes.end() ) { // no pass of the length <=Depth exists. Add pass of (Depth+1)
						CurrentPath.push_back(*It);  
						NewPasses->insert( TPassesKeyType(*It,CurrentPath) );
						CurrentPath.pop_back();
						++PassCounter;
					}
					else  //if exists a circle on this path
						if ( *It == SourceNodeNumber)
							if (!SkipTrivialCircles || (SkipTrivialCircles && CurrentPath.size()>2))
						{
							std::list<unsigned int>& DummyPath=CurrentPath;
							unsigned int find_min= -1;
							unsigned int leg=1,leg_min=0;							
							for(std::list<unsigned int>::iterator It1 = DummyPath.begin(); It1 != DummyPath.end(); ++It1,leg++)	{							
								if( *It1 < find_min ){
									find_min=*It1;
									leg_min=leg;							
								}
								if(leg_min != 1) {
									//this method convert a circle which start with 
									leg_min=(unsigned int)DummyPath.size()-leg_min;	
									It1 = DummyPath.end();
									It1--;
									for(unsigned int j=0; j<= leg_min; j++) {
										DummyPath.push_front(*It1);
										It1--;
										DummyPath.pop_back();
									}
								}
								Circles[(unsigned int)DummyPath.size()].insert(DummyPath);
							}
						}
						if (SkipTrivialCircles) { PrevNodeID = *It; }
				}
				CurrentPath.pop_front(); // Only internal nodes are counted - the ones on the edge are excluded 
			}
			Passes.insert(NewPasses->begin(), NewPasses->end());
			delete OldPasses;
			OldPasses = NewPasses;
			++Depth;
		}
		delete OldPasses;
		OldPasses = NULL;
		Passes.clear();
	}
}
//================================================================================================
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{  
	const char *FNCircleLength	  = "CircleLength";
	const char *FNNumberOfCircles  = "NumberOfCircles";
	const char *FNPasses		  = "Circles";
	const char* FieldNames[3]	  = {  FNCircleLength, FNNumberOfCircles, FNPasses};
	
	mxArray* Result = mxCreateStructMatrix((int)Circles.size(),1,3,FieldNames);
	mxArray* circle_length=mxCreateDoubleMatrix(1,(int)(Circles.size()+1),mxREAL);
	
	double* P = mxGetPr(circle_length);
	//P++;

	int ArrayIndex = 0;
	int circleLength;
	int numberOfCircles;
	for (std::map< unsigned int,std::set< std::list<unsigned int> > >::const_iterator LengthCircleIt = Circles.begin();LengthCircleIt !=  Circles.end(); LengthCircleIt++,++ArrayIndex) {
		circleLength=LengthCircleIt->first;
		numberOfCircles=(int)LengthCircleIt->second.size();
		*P=static_cast<double>(LengthCircleIt->second.size());
		//++P;
		mxSetField(Result,ArrayIndex,FNCircleLength,mxCreateDoubleScalar((double)circleLength) );
		mxSetField(Result,ArrayIndex,FNNumberOfCircles,mxCreateDoubleScalar((double)numberOfCircles) );
		mxSetField(Result,ArrayIndex,FNPasses,mxCreateDoubleMatrix(circleLength,numberOfCircles,mxREAL));
		double* CurrentDataPtr = mxGetPr( mxGetField(Result,ArrayIndex,FNPasses) );
		for (std::set< std::list<unsigned int> >::const_iterator CurrentPass = LengthCircleIt->second.begin(); CurrentPass != LengthCircleIt->second.end(); ++CurrentPass) {			
			for (std::list<unsigned int>::const_iterator It = CurrentPass->begin(); It != CurrentPass->end(); ++It, ++CurrentDataPtr) {
				*CurrentDataPtr  = (double)*It;
			}			
		}
		++P;
	}
	plhs[0] = Result;
	plhs[1] = circle_length;
	Graph.Clear();
	PathSet.clear(); 
	NodesList.clear();
	Circles.clear();	

}



