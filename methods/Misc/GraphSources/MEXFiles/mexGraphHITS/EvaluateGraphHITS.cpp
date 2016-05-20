
#include "EvaluateGraphHITS.h"
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

TStaticGraph *GraphDirect = NULL, *GraphInverse = NULL;
TMLDebugHelper MLDebugHelper;

unsigned int    NumberOfNodes = 0;

std::vector< std::pair<double /*x - authority weights*/, double /*y - hub weights*/> > Weights;

unsigned int				NumberOfIterations = 50;
bool						ShowProgress	=	false;
std::vector< std::pair<double,double> >	AverageScore; // Average of all weights [mean(x), mean(y)] just before normalizations. can be used to see convergence

//------------------------------------------------------------------------------------------------------------------ 
void DisplayProgressUpdate(unsigned int Progress, unsigned int Total);
void Disp(const char* Str);
//------------------------------------------------------------------------------------------------------------------ 
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	if (nrhs < 1 || nrhs > 4  ) { mexErrMsgTxt("One to four input arguments allowed."); }
	if (nlhs > 1	) {	mexErrMsgTxt("Up to 1  output arguments allowed.");	}
	
	if (nrhs>1 && !mxIsEmpty(prhs[1])) { // Get number of iterations from input
		NumberOfIterations  = static_cast<unsigned int>(mxGetScalar(prhs[1]));
	}
	else { NumberOfIterations  = 50; }

	if (nrhs>3 && !mxIsEmpty(prhs[3])) { // Show progress?
		ShowProgress = (static_cast<unsigned int>(floor(mxGetScalar(prhs[3])+0.5))!=0);
	}
	else { ShowProgress = false; }
} 
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	// Load graph. If Direction is 'Both', the Direct and Inverse graphs are identical and point at the same structure.
	// if Direction is either direct or  inverse, the two graphs point at the complementary structures.
	// In the first case, 50% of space is saved.
	if (GraphDirect) { 
		if (GraphInverse!=GraphDirect) { delete GraphInverse; GraphInverse = NULL; }
		delete GraphDirect;  GraphDirect  = NULL; 
	} 
	GraphDirect = new TStaticGraph();
	if (nrhs>2 && !mxIsEmpty(prhs[2])) {// create a list of links	
		GraphDirect->Assign(prhs[0],prhs[2],false); // Graph with reversed directionality of links will be created.
	}
	else {  GraphDirect->Assign(prhs[0],dirDirect,false); }
	if (GraphDirect->GetDir() == dirDirect || GraphDirect->GetDir() == dirInverse) {
		GraphInverse = new TStaticGraph();
		GraphInverse->Assign(prhs[0],GraphDirect->GetDir(),true); // reverse link direction.
	}
	else { GraphInverse =   GraphDirect; }

	NumberOfNodes = GraphDirect->GetNumberOfLinkedNodes();
} 
//------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	// First, allocate memory for the result and find number of outgoing links for each node.
	Weights.assign(NumberOfNodes +1, std::pair<double, double>(1.0,1.0));
	AverageScore.assign(NumberOfIterations,std::pair<double, double>(1.0,1.0));
	std::vector< std::pair<double,double> > CurrentWeight(NumberOfNodes +1, std::pair<double, double>(1.0,1.0));

	if (ShowProgress) {	 DisplayProgressUpdate(0,0); }

	for (unsigned int Iteration = 0; Iteration < NumberOfIterations; ++Iteration) {
		if (ShowProgress) { DisplayProgressUpdate(Iteration, NumberOfIterations); }
		std::pair<double,double> WeightSum(0.0F,0.0F);

		for (unsigned int CurrentNode = 1; CurrentNode	 <= NumberOfNodes; ++CurrentNode) {
			const std::vector<unsigned int> & InverseNeighbours = GraphInverse->Neighbours(CurrentNode);	// neighbours, pointing at node. Sum of their hub-values (y) is authority (x).
			double Xi = 0.0F, Yi = 0.0F;
			for (std::vector<unsigned int>::const_iterator It = InverseNeighbours.begin(); It != InverseNeighbours.end(); ++It) {
				Xi += Weights[*It].second;
			}	
			const std::vector<unsigned int> & DirectNeighbours  = GraphDirect->Neighbours(CurrentNode);	// neighbours, at which node is pointing (node is a hub to them, gives them authority). Hub-value (y) of the node is a sum of all authority values (x), of the pointed nodes.
			for (std::vector<unsigned int>::const_iterator It = DirectNeighbours.begin(); It != DirectNeighbours.end(); ++It) {
				Yi+= Weights[*It].first;
			}
			CurrentWeight[CurrentNode]= std::pair<double,double>(Xi,Yi);
		//	if (  CurrentNode > 10050 && CurrentNode <10250 ) {
		//		MLDebugHelper << CurrentNode<< "  " << Weights[CurrentNode].first << "  " << Weights[CurrentNode].second << "  " <<  WeightSum.first << "  " << WeightSum.second << dbFlush;
		//	}
			WeightSum.first += (Xi*Xi);
			WeightSum.second += (Yi*Yi);
		}
		// normalization
		Weights = CurrentWeight;
		WeightSum = std::pair<double,double>( sqrt(WeightSum.first), sqrt(WeightSum.second) );
		for (unsigned int CurrentNode = 1; CurrentNode	 <= NumberOfNodes; ++CurrentNode) {
			Weights[CurrentNode].first	/=	 WeightSum.first;
			Weights[CurrentNode].second	/=	 WeightSum.second;
		} 
		AverageScore[Iteration] = std::pair<double,double>( WeightSum.first/NumberOfNodes, WeightSum.second/NumberOfNodes );
		
	}
	if (ShowProgress) { DisplayProgressUpdate(NumberOfIterations, NumberOfIterations); }
}

//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	
	const char* chAverage  = "Average";
	const char* chNodeID   = "NodeID";
	const char* chAuthority = "Authority";
	const char* chHub = "Hub";

	const char* FieldNames[] = { chAverage, chNodeID, chAuthority, chHub };
	mxArray*		Result		=	mxCreateStructMatrix(1,1,4,FieldNames);
	
	
	mxSetField(Result,0,chAverage,mxCreateDoubleMatrix(		(int)AverageScore.size(),			2, mxREAL) );
	mxSetField(Result,0,chNodeID,mxCreateDoubleMatrix(		max((int)Weights.size()-1,0),		1, mxREAL) );
	mxSetField(Result,0,chAuthority,mxCreateDoubleMatrix(	max((int)Weights.size()-1,0),		1, mxREAL) );
	mxSetField(Result,0,chHub,mxCreateDoubleMatrix(			max((int)Weights.size()-1,0),		1, mxREAL) );
	 
	double* pAverage	=	mxGetPr(mxGetField(Result,0,chAverage ));
	double* pNodeID		=	mxGetPr(mxGetField(Result,0,chNodeID ));
	double* pAuthority	=	mxGetPr(mxGetField(Result,0,chAuthority ));
	double* pHub		=	mxGetPr(mxGetField(Result,0,chHub ));
	
	for (int i = 0; i <  (int)AverageScore.size(); ++i) {
	   pAverage[i]						=	AverageScore[i].first;
	   pAverage[i+AverageScore.size()]	=	AverageScore[i].second;
	}
	
	for (int i = 0; i < (int)Weights.size()-1; ++i) {
	   pNodeID[i]	=	i+1;
	   pAuthority[i]	=	Weights[i+1].first;
	   pHub[i]			=	Weights[i+1].second;
	}
	plhs[0]  = Result;

	
	AverageScore.clear();
	Weights.clear();
	if (GraphInverse!=GraphDirect) { delete GraphInverse; GraphInverse = NULL; }
	delete GraphDirect;  GraphDirect  = NULL;   
	  
	
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
