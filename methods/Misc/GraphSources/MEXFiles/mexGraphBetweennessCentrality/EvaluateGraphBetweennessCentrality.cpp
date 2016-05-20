
#include "EvaluateGraphBetweennessCentrality.h"
//#include <iostream>
//#include <fstream>
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
unsigned int    NumberOfNodes = 0;
double*			Betweeness=NULL;
bool			ShowProgress;
//------------------------------------------------------------------------------------------------------------------ 
void DisplayProgressUpdate(unsigned int Progress, unsigned int Total);
//------------------------------------------------------------------------------------------------------------------ 
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Clear();
	if (nrhs < 2 || nrhs > 3  ) { mexErrMsgTxt("Two or three input arguments required."); }
	if (nlhs > 2	) {	mexErrMsgTxt("Up to 2 output arguments allowed.");	}
	pInputGraph	= prhs[0];	
	if (nrhs>2) {
		ShowProgress = floor(mxGetScalar(prhs[2])+0.5)!=0;
	}
	else { ShowProgress = false; }
} 
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	// create a list of links	
	if (nrhs>1) {
		Graph.Assign(pInputGraph,prhs[1]);
	}
	else {  Graph.Assign(pInputGraph,dirDirect); }
	NumberOfNodes = Graph.GetNumberOfLinkedNodes();
	NumberOfLinksInGraph = Graph.GetNumberOfLinks();
} 
//------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	Betweeness=new double[ NumberOfNodes+1 ];
	double*sigma=new double[ NumberOfNodes+1 ];
	double*pair_dependencies = new double[ NumberOfNodes+1 ];
	int *distance=new int[ NumberOfNodes+1 ];

	for(unsigned int i=0;i<=NumberOfNodes;i++)
		Betweeness[i]=0;

	list<int> Stack;
	list<int> Queue;
	list<int> *P=new list<int>[NumberOfNodes+1];

	if (ShowProgress) { DisplayProgressUpdate(0,0); } // initialize timer.
	for(unsigned int CurrentNode = 1; CurrentNode <= Graph.GetNumberOfLinkedNodes(); ++CurrentNode)	
	{
		if (Graph.Neighbours(CurrentNode).size()) {
			Stack.empty();
			Queue.empty();
			for(unsigned int i=0;i<=NumberOfNodes;i++)
			{
				P[i].clear();
				sigma[i]=0;
				distance[i]=-1;
			}
			sigma[CurrentNode]=1;
			distance[CurrentNode]=0;

			Queue.push_back(CurrentNode);

			while( !Queue.empty() )
			{
				int v=Queue.front();
				Stack.push_front(v);
				Queue.pop_front();
				//for each neighbour w of v
				const std::vector<unsigned int>& Neighbours = Graph.Neighbours(v);
				for(std::vector<unsigned int>::const_iterator NeighbourOfvIt=Neighbours.begin();NeighbourOfvIt!=Neighbours.end();NeighbourOfvIt++)
				{
					//w is found on the first time?
					if(distance[*NeighbourOfvIt]<0)
					{
						Queue.push_back(*NeighbourOfvIt);
						distance[*NeighbourOfvIt]=distance[v]+1;
					}
					//shorteset path to w is via v?
					if( distance[*NeighbourOfvIt]== (distance[v]+1) ) {
						sigma[*NeighbourOfvIt]= sigma[*NeighbourOfvIt]+sigma[v];
						P[*NeighbourOfvIt].push_back(v);
					}
				}			
			}

			for(unsigned int i=0;i<=NumberOfNodes;i++)
				pair_dependencies[i]=0;
			while(!Stack.empty()) {
				int w=Stack.front();
				Stack.pop_front();
				for(std::list<int>::iterator ListIt=P[w].begin();ListIt != P[w].end();ListIt++)
					pair_dependencies[*ListIt]=pair_dependencies[*ListIt]+(1+pair_dependencies[w])*(sigma[*ListIt]/sigma[w]);
				if( w != CurrentNode )
					Betweeness[w]= Betweeness[w]+pair_dependencies[w];
			}
		}
		if (ShowProgress) { DisplayProgressUpdate(CurrentNode,Graph.GetNumberOfLinkedNodes()); }
	}
	Stack.clear();
	Queue.clear();
	delete[] sigma;
	delete[] pair_dependencies;
	delete[] distance;
}

//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	mxArray* Result = mxCreateDoubleMatrix(NumberOfNodes,1,mxREAL);
	for(unsigned int CurrentNode = 0; CurrentNode < Graph.GetNumberOfLinkedNodes(); ++CurrentNode)
	{
		*( mxGetPr(Result)+CurrentNode )= Betweeness[CurrentNode+1];
	}

	plhs[0] = Result;
	if (nlhs>1) {
		Result = mxCreateDoubleMatrix(NumberOfNodes,1,mxREAL);
		for(unsigned int CurrentNode = 0; CurrentNode < Graph.GetNumberOfLinkedNodes(); ++CurrentNode) {
			*( mxGetPr(Result)+CurrentNode )= (CurrentNode+1);
		}
		plhs[1] = Result;
	}
	delete[] Betweeness;
	Graph.Clear();
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
