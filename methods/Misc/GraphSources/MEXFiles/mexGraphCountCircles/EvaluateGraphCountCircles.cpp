
#include "EvaluateGraphCountCircles.h"
#include <fstream>
#include<iostream>
#include <math.h>
#include <map>
#include <set>
#include <list>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;

#include "../Utilities/Graph/TStaticGraph.h"	
#include "../Utilities/DebugHelper/MLDebugHelper.h"
TStaticGraph Graph;
TMLDebugHelper MLDebugHelper;

unsigned int	NumberOfLinksInGraph	=	0;
unsigned int    MaxCircleLength  = 0;
std::list< std::vector<unsigned int> > Circles;

void FindCircles(std::list< std::vector<unsigned int> >& Circles,std::list<unsigned int> CurrentPath);
//------------------------------------------------------------------------------------------------------------------ 

void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Clear();
	Circles.clear();
	if (nrhs < 1 || nrhs >2 ) { mexErrMsgTxt(" one or two input arguments required."); }
	if (nlhs > 2){	mexErrMsgTxt("one or two output arguments allowed.");	}
} 
//-----------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
		Graph.Assign(prhs[0],dirBoth);
		if (nrhs>1) {
			if (mxIsInf(mxGetScalar(prhs[1]))) { MaxCircleLength  = -1; }
			else { MaxCircleLength = (unsigned int)floor(0.5+mxGetScalar(prhs[1])); }
		}
		else { MaxCircleLength = 10; } 
		Graph.SortNodes();
		NumberOfLinksInGraph = Graph.GetNumberOfLinks();
}
//------------------------------------------------------------------------------------------------------------------ 
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{ 
	std::vector<unsigned int> Nodes = Graph.GetAllNodesIDs();
	for (std::vector<unsigned int>::const_iterator CurrNode = Nodes.begin(); CurrNode != Nodes.end(); ++CurrNode) {
		std::list<unsigned int> CurrentPath;
		std::list< std::vector<unsigned int> > CurCircles;
		CurrentPath.push_back(*CurrNode);
		FindCircles(CurCircles,CurrentPath);
		for (std::list< std::vector<unsigned int> >::const_iterator CurCircle  = CurCircles.begin();CurCircle  != CurCircles.end(); ++CurCircle) {
			Circles.push_back(*CurCircle);
		}
	}
}
//================================================================================================
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{  
		//mxArray* mxCircles = mxCreateStructMatrix((int)Circles.size(),1,3,FieldNames);
		const char* CircleFieldNames[2] = { "CircleSize","NumberOfCircles" };
		mxArray* mxCircleLengthHistogram=mxCreateStructMatrix(1,1,2,CircleFieldNames);

		unsigned int MaxCircleSize = 0;
		for (std::list< std::vector<unsigned int> >::const_iterator CurCircle = Circles.begin();CurCircle != Circles.end(); ++CurCircle) {
			if (MaxCircleSize < (unsigned int)CurCircle->size()) { MaxCircleSize = (unsigned int)CurCircle->size(); }
		}
		mxSetField(mxCircleLengthHistogram,0,CircleFieldNames[0],mxCreateDoubleMatrix(1,MaxCircleSize ,mxREAL));
		mxSetField(mxCircleLengthHistogram,0,CircleFieldNames[1],mxCreateDoubleMatrix(1,MaxCircleSize ,mxREAL));
		for (unsigned int I = 0; I < MaxCircleSize; ++I) { 
			*(mxGetPr( mxGetField(mxCircleLengthHistogram,0,CircleFieldNames[0])) + I) = (I+1);
		}
		mxArray* mxNumberOfCircles = mxGetField(mxCircleLengthHistogram,0,CircleFieldNames[1]);
		
		for (std::list< std::vector<unsigned int> >::const_iterator CurCircle = Circles.begin();CurCircle != Circles.end(); ++CurCircle) {
			double* pNumberOfCircles = mxGetPr(mxNumberOfCircles)+ CurCircle->size()-1;	
			(*pNumberOfCircles)+=1;
		}
		plhs[0] = mxCircleLengthHistogram;	

		if (nlhs>1) {
			const char *FNCircleLength	  =  "CircleLength";
			const char *FNNumberOfCircles = "NumberOfCircles";
			const char *FNPasses		  = "Circles";
			const char* FieldNames[3]	  = {  FNCircleLength, FNNumberOfCircles, FNPasses};

			mxArray* mxCircles = mxCreateStructMatrix(1,MaxCircleSize,3,FieldNames);
			for (unsigned int I = 0; I < MaxCircleSize; ++I) { 			
				mxSetField(mxCircles,I,FNCircleLength,mxCreateDoubleScalar(I+1));		
				unsigned int NumberOfCircles = (unsigned int)floor(*(mxGetPr(mxGetField(plhs[0],0,"NumberOfCircles"))+I)+0.5);
				mxSetField(mxCircles,I,FNNumberOfCircles,mxCreateDoubleScalar(0));
				mxArray* Temp = mxCreateDoubleMatrix(NumberOfCircles,I+1,mxREAL);
				mxSetField(mxCircles,I,FNPasses,Temp);
			}
			for (std::list< std::vector<unsigned int> >::const_iterator CurCircle = Circles.begin();CurCircle != Circles.end(); ++CurCircle) {
				unsigned int  CurcleSize = (unsigned int)CurCircle->size();
				unsigned int CurIndex = (unsigned int)floor(*mxGetPr(mxGetField(mxCircles,CurcleSize-1,FNNumberOfCircles))+0.5);
				unsigned int NumberOfCircles  = (unsigned int)(unsigned int)floor(*(mxGetPr(mxGetField(plhs[0],0,"NumberOfCircles"))+CurCircle->size()-1)+0.5);
				*mxGetPr(mxGetField(mxCircles,CurcleSize-1,FNNumberOfCircles)) = CurIndex+1;
				mxArray* Temp = mxGetField(mxCircles,CurcleSize-1,FNPasses);
				double* CirclesArray = mxGetPr(Temp);
				for (unsigned int j = 0; j < CurCircle->size(); ++j) {
					*(CirclesArray+CurIndex+j*NumberOfCircles) = CurCircle->at(j);
				}
				++(*(mxGetPr( mxGetField(mxCircleLengthHistogram,0,CircleFieldNames[0])) + CurCircle->size()-1));
			}
			plhs[1] = mxCircles;
		}	
		Graph.Clear();
		Circles.clear();	
}
//================================================================================================
// recursively searches for cicrles in undirected graphs (for each {i,j}, if edge i->j, j->i also exists) starting at Source node .
// Only simple circles are counted (i->j->k->j->i is skipped).
// Trivial circles (i->j, j->i) are not considered.
// However, direction of each circle can be reverced. Out of 2 possible direction, the one with the second node having smallest ID is chosen.
void FindCircles(std::list< std::vector<unsigned int> >& Circles,std::list<unsigned int> CurrentPath)
{
	const std::vector<unsigned int>& Neighbours = Graph.Neighbours(CurrentPath.back());
	std::queue<unsigned int> NextStepsNeighbours;

	for(std::vector<unsigned int>::const_iterator CurrNeighbourIt = Neighbours.begin();CurrNeighbourIt != Neighbours.end(); ++CurrNeighbourIt) {
		const unsigned int CurrNeighbour = *CurrNeighbourIt + 1;
		if (CurrNeighbour > CurrentPath.front()) { // continue browsing!
			if (  std::find(CurrentPath.begin(),CurrentPath.end(),CurrNeighbour)==CurrentPath.end()) { // not on the path yet!
				NextStepsNeighbours.push(CurrNeighbour);
			}
		}
		else if (CurrNeighbour == CurrentPath.front() && CurrentPath.size()>2) { // circle found!
			// make circle
			std::vector<unsigned int> NewCircle(CurrentPath.begin(),CurrentPath.end());
			if ( NewCircle[1] > NewCircle.back()) {
				std::reverse(NewCircle.begin()+1,NewCircle.end());
			}
			//check if the circle if already on the list
			if (std::find(Circles.begin(),Circles.end(),NewCircle)==Circles.end()) {
				Circles.push_back(NewCircle);
				for (std::list< std::vector<unsigned int> >::iterator It = Circles.begin();It != Circles.end(); ++It) {
					
				}				
			}	
			return;
		}		
	}

	if (CurrentPath.size() < MaxCircleLength) { 
		while (!NextStepsNeighbours.empty()) {
			CurrentPath.push_back(NextStepsNeighbours.front());
			FindCircles(Circles,CurrentPath);
			CurrentPath.pop_back();
			NextStepsNeighbours.pop();
		}
	}
}
//================================================================================================

