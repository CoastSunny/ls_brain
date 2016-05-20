
#include "EvaluateGraphPageRank.h"
#include <iostream>
#include <fstream>
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

unsigned int	NumberOfLinksInGraph	=	0;
unsigned int    NumberOfNodes = 0;

std::vector< std::pair<unsigned int /*Number of outgoing links*/, float /*Rank*/> > PageRank;

float			DampingFactor;
unsigned int	NumberOfIterations;
bool			ShowProgress;
std::vector<float> AverageScore;

//------------------------------------------------------------------------------------------------------------------ 
void DisplayProgressUpdate(unsigned int Progress, unsigned int Total);
void Disp(const char* Str);
//------------------------------------------------------------------------------------------------------------------ 
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Clear();
	PageRank.clear();

	if (nrhs < 1 || nrhs > 5  ) { mexErrMsgTxt("One to five input arguments allowed."); }
	if (nlhs > 1	) {	mexErrMsgTxt("Up to 1  output arguments allowed.");	}
	
	if (nrhs>1 && !mxIsEmpty(prhs[1])) { // Get number of iterations from input
		NumberOfIterations  = static_cast<unsigned int>(mxGetScalar(prhs[1]));
	}
	else { NumberOfIterations  = 50; }
	if (nrhs>2 && !mxIsEmpty(prhs[2])) { // Get damping factor from input.
		DampingFactor= static_cast<float>(mxGetScalar(prhs[2]));
	}
	else { DampingFactor = 0.15F; }
	if (nrhs>4 && !mxIsEmpty(prhs[4])) { // Show progress?
		ShowProgress = (static_cast<unsigned int>(floor(mxGetScalar(prhs[4])+0.5))!=0);
	}
	else { ShowProgress = false; }
} 
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs>3 && !mxIsEmpty(prhs[3])) {// create a list of links	
		Graph.Assign(prhs[0],prhs[3],true); // Graph with reversed directionality of links will be created.
	}
	else {  Graph.Assign(prhs[0],dirDirect,true); }

	NumberOfNodes = Graph.GetNumberOfLinkedNodes();
	NumberOfLinksInGraph = Graph.GetNumberOfLinks();
} 
//------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	// First, allocate memory for the result and find number of outgoing links for each node.
	PageRank.assign(NumberOfNodes +1, std::pair<unsigned int, float>(0,0.0f));
	if (ShowProgress) { Disp("Pre-allocating memmory and computing node degrees. Should take few seconds.");}
	for (unsigned int CurrentNode = 1; CurrentNode	 <= NumberOfNodes; ++CurrentNode) {
		const std::vector<unsigned int> & Neighbours = Graph.Neighbours(CurrentNode);
		for (  std::vector<unsigned int>::const_iterator It = Neighbours.begin(); It != Neighbours.end(); ++It) {
			++PageRank[*It].first;
		}
	}
	AverageScore.assign(NumberOfIterations,0.0);
	if (ShowProgress) {	 DisplayProgressUpdate(0,0); }

	for (unsigned int Iteration = 0; Iteration < NumberOfIterations; ++Iteration) {
		if (ShowProgress) { DisplayProgressUpdate(Iteration, NumberOfIterations); }
		for (unsigned int CurrentNode = 1; CurrentNode	 <= NumberOfNodes; ++CurrentNode) {
			const std::vector<unsigned int> & Neighbours = Graph.Neighbours(CurrentNode);	// neighbours, pointing at node.
			float Score = 0.0;
			for (  std::vector<unsigned int>::const_iterator It = Neighbours.begin(); It != Neighbours.end(); ++It) {
				Score += PageRank[*It].second/PageRank[*It].first;
			}
			PageRank[CurrentNode].second = DampingFactor + (1.0F-DampingFactor)*Score;
			AverageScore[Iteration] += PageRank[CurrentNode].second;
		}
		AverageScore[Iteration] /= NumberOfNodes;
	}
	if (ShowProgress) { DisplayProgressUpdate(NumberOfIterations, NumberOfIterations); }
}

//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chAverage  = "Average";
	const char* chNodeID   = "NodeID";
	const char* chPageRank = "PageRank";

	const char* FieldNames[] = { chAverage, chNodeID, chPageRank };
	mxArray*		Result		=	mxCreateStructMatrix(1,1,3,FieldNames);

	mxSetField(Result,0,chAverage,mxCreateDoubleMatrix(		(int)AverageScore.size(),		1, mxREAL) );
	mxSetField(Result,0,chNodeID,mxCreateDoubleMatrix(		max((int)PageRank.size()-1,0),	1, mxREAL) );
	mxSetField(Result,0,chPageRank,mxCreateDoubleMatrix(	max((int)PageRank.size()-1,0),	1, mxREAL) );

	double* pAverage =	mxGetPr(mxGetField(Result,0,chAverage ));
	double* pNodeID = mxGetPr(mxGetField(Result,0,chNodeID ));
	double* pPageRank = mxGetPr(mxGetField(Result,0,chPageRank ));

	for (unsigned int i = 0; i <  AverageScore.size(); ++i) {
	   pAverage[i] =  AverageScore[i];
	}
	for (unsigned int i = 0; i < PageRank.size()-1; ++i) {
	   pNodeID[i]	=	i+1;
	   pPageRank[i]	=	PageRank[i+1].second;
	}

	AverageScore.clear();
	Graph.Clear();
	PageRank.clear();

	plhs[0]  = Result;
}
//------------------------------------------------------------------------------------------------------------------
double TimerCount()
{
	mxArray* Output[1] = { NULL };
	mexCallMATLAB(1, Output, 0, NULL, "toc");
	double Result = mxGetScalar(Output[0]);
	mxDestroyArray(Output[0]);	Output[0] = NULL; 
	return Result;
}
//------------------------------------------------------------------------------------------------------------------
void Disp(const char* Str)
{
	mxArray* Input[1] = { mxCreateString(Str) };
	mexCallMATLAB(0,NULL, 1, Input , "disp");
	mxDestroyArray(Input [0]);	Input[0] = NULL; 
}
//------------------------------------------------------------------------------------------------------------------
void DisplayProgressUpdate(unsigned int Progress, unsigned int Total)
{
	if (Progress==0) { // initialize
		mexCallMATLAB(0, NULL, 0, NULL, "tic");
	}
	else {
		char DummyStr[256];
		mxArray* Output[1] = { NULL };
		mexCallMATLAB(1, Output, 0, NULL, "toc");
		if (ShowProgress) {
			double ElapsedTime = mxGetScalar(Output[0]);
			mxDestroyArray(Output[0]);	Output[0] = NULL; 
			double ToGoTime	=	((Progress) ? ElapsedTime / Progress*(Total-Progress) : 0);
			sprintf_s(DummyStr,256,"Progress: Node %d of %d, (%d%%), Elapsed: %fsec. Left: %f.", Progress,Total,int((100.0*Progress)/Total+0.5),ElapsedTime,ToGoTime);
			Disp(DummyStr);	
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
