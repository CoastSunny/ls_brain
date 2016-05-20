
#include "EvaluateGraphBoxCounting.h"
#include <iostream>
#include <fstream>
#include <math.h>
#include <map>
#include <set>
#include <list>
#include <vector>
#include <algorithm>
#include <stdio.h>


//using namespace std;
                

#include "../Utilities/Graph/TStaticGraph.h"	
#include "../Utilities/DebugHelper/MLDebugHelper.h"
TStaticGraph Graph;
TMLDebugHelper MLDebugHelper;

unsigned int	NumberOfLinksInGraph	=	0;
unsigned int    NumberOfNodes = 0;

unsigned char MaxDistance; // list of distances to compute for.
unsigned char MaxActualDistance; // stires the maximal distance between elements in the same box (graph radius)
bool	GetBoxContent;
bool	ShowProgress;

typedef std::map<unsigned int,unsigned char> TSingleBox; // Node Index, Maximal distance
typedef std::list< std::pair<unsigned char, TSingleBox>	> TBoxHistory; // Distance, TSingleBox
typedef std::list<TBoxHistory>	TBoxesCollection;

TBoxesCollection Boxes; // for each box, and each distance a list of nodes is given


//------------------------------------------------------------------------------------------------------------------ 
void DisplayProgressUpdate(unsigned int Progress, unsigned int Total);
void Disp(const char* Str);
void FindNodeDistancies(unsigned int NodeID,unsigned char *NodeDistance,std::vector<unsigned int>& Shell1,std::vector<unsigned int>& Shell2,unsigned char MaxDistance);
//------------------------------------------------------------------------------------------------------------------ 
void	SetInputParameters(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Clear();
	Boxes.clear();

	if (nrhs < 1 || nrhs > 3  ) { mexErrMsgTxt("One to three input arguments allowed."); }
	if (nlhs > 2	) {	mexErrMsgTxt("Up to 2  output arguments allowed.");	}
	
	if (nrhs>1 && !mxIsEmpty(prhs[1])) { // Get max distance
		unsigned int TempMaxDistance = (unsigned int) floor(mxGetScalar(prhs[1])+0.5);
		if (TempMaxDistance>255) { TempMaxDistance = 255; }
		MaxDistance  = (unsigned char)TempMaxDistance;		
	}
	else { MaxDistance  = 255; }
	if (nrhs>2 && !mxIsEmpty(prhs[2])) { // Show progress?
		ShowProgress = (floor(mxGetScalar(prhs[2])+0.5)!=0);
	}
	else { ShowProgress = false; }
} 
//------------------------------------------------------------------------------------------------------------------
void	PrepareToRun(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	Graph.Assign(prhs[0],dirDirect,true); // create a list of links	
	Graph.SortNodes();

	NumberOfNodes = Graph.GetNumberOfLinkedNodes();
	NumberOfLinksInGraph = Graph.GetNumberOfLinks();
	MaxActualDistance = 0;
	if (ShowProgress) {	 DisplayProgressUpdate(0,0); }
} 
//------------------------------------------------------------------------------------------
void	PerformCalculations(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	std::vector< std::pair<unsigned int, unsigned int> > SortedNodesList = Graph.GetNodesByDegree(true); // sort nodes by their degree.
	unsigned int NumberOfConnectedNodes = 0;
	if (ShowProgress) {
		for (std::vector< std::pair<unsigned int, unsigned int> >::const_iterator Vi = SortedNodesList.begin(); Vi != SortedNodesList.end() && Vi->second!=0; ++Vi) {// loop over all nodes in descending order (by their degree).
			++NumberOfConnectedNodes;
		}
	}
	unsigned char* NodeDistance = new unsigned char[NumberOfNodes+1]; // holds distance of each node from the source.
	std::vector<unsigned int> Shell1(NumberOfNodes,0),Shell2(NumberOfNodes,0);
	
	for (std::vector< std::pair<unsigned int, unsigned int> >::const_iterator Vi = SortedNodesList.begin(); Vi != SortedNodesList.end() && Vi->second!=0; ++Vi) {// loop over all nodes in descending order (by their degree).
		FindNodeDistancies(Vi->first,NodeDistance,Shell1,Shell2,MaxDistance); // finds distances of each node of a graph from Vi.
		bool Placed  = false;
		unsigned char MaxDistanceToSearch = MaxDistance;
		for ( TBoxesCollection::iterator CurrentBoxHistory = Boxes.begin();MaxDistanceToSearch!=1 && CurrentBoxHistory != Boxes.end(); ++CurrentBoxHistory) {
			// search all boxes untill MaxDistanceToSearch equals 1.
			unsigned char CurrentMinDistance = 1;			
			for (TBoxHistory::iterator CurrentBox = CurrentBoxHistory->begin(); CurrentMinDistance!=-1 && CurrentMinDistance < MaxDistanceToSearch && CurrentBox != CurrentBoxHistory->end(); ++CurrentBox) {
				const unsigned char CurrentDistance = CurrentBox->first;
				for (TSingleBox::const_iterator CurrentBoxMember = CurrentBox->second.begin();CurrentMinDistance!=-1 && CurrentMinDistance < MaxDistanceToSearch && CurrentBoxMember != CurrentBox->second.end(); ++CurrentBoxMember) {
					// for each node in the box, check it's distance to Vi.
					if ( NodeDistance[CurrentBoxMember->first]==0 || NodeDistance[CurrentBoxMember->first]>MaxDistanceToSearch) { // Vi is not connected to one of the nodes in the box. Vi can never be placed in this box.
						CurrentMinDistance = -1;
					}
					else if (NodeDistance[CurrentBoxMember->first]>CurrentDistance) { // the node in the box is at distance larger then any other node till now.
						CurrentMinDistance = NodeDistance[CurrentBoxMember->first];
					}
				} // iterate over the current box at current distance.
			}  // iterate over all populated distances.
			if (CurrentMinDistance!=-1 && CurrentMinDistance < MaxDistanceToSearch) { // put Vi in the current box for all distances from now on!
				for (unsigned char j = CurrentBoxHistory->back().first; j <  CurrentMinDistance; ++j) {// append empty boxes!
					std::pair<unsigned char, TSingleBox> NewBox(j+1,TSingleBox());
					CurrentBoxHistory->push_back(NewBox);
				}
				TBoxHistory::iterator CurrentBox = CurrentBoxHistory->begin();
				std::advance(CurrentBox,CurrentMinDistance-1);
				CurrentBox->second.insert(TSingleBox::value_type(Vi->first,MaxDistanceToSearch));
				MaxDistanceToSearch = CurrentMinDistance; // stop searching this tree. Do search deeper that this distance at other boxes.
				if (MaxActualDistance < CurrentBoxHistory->size()) {
					//MaxActualDistance = (unsigned char)CurrentBoxHistory->size();
					MaxActualDistance = CurrentMinDistance;
				}
			}
		} // current box
		if (MaxDistanceToSearch!=1) { // create new box
			TSingleBox NewBox;
			NewBox.insert(TSingleBox::value_type(Vi->first,MaxDistanceToSearch));
			TBoxHistory NewHistory;
			NewHistory.push_back(std::pair<unsigned char, TSingleBox>(1,NewBox));
			Boxes.push_back( NewHistory);
		}
		if (ShowProgress) { DisplayProgressUpdate( (unsigned int)(Vi -SortedNodesList.begin())+1, NumberOfConnectedNodes); }
	} // Vi
	delete [] NodeDistance; NodeDistance = NULL;
}

//------------------------------------------------------------------------------------------------------------------
void	FreeResourses(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	const char* chDistance			= "Distance";
	const char* chNumberOfBoxes		= "NumberOfBoxes";
	const char* chBoxSizes			= "BoxSizes";

	const char* FieldNames[] = { chDistance, chNumberOfBoxes, chBoxSizes};
	mxArray*		Result		=	mxCreateStructMatrix(MaxActualDistance,1,3,FieldNames);
	
	for (unsigned int i = 0; i < MaxActualDistance; ++i) {
		mxSetField(Result,i,chDistance,mxCreateDoubleScalar(i+1) );
		mxSetField(Result,i,chNumberOfBoxes,mxCreateDoubleScalar(0.0) );
	}
	// find number of boxes for each distance
	
	for (TBoxesCollection::const_iterator CurrentBoxHistory=Boxes.begin();CurrentBoxHistory!=Boxes.end(); ++CurrentBoxHistory) {
		unsigned char CurrentMaxHistory = (unsigned char)CurrentBoxHistory->size();
		for (TBoxHistory::const_iterator CurrentBox = CurrentBoxHistory->begin(); CurrentBox != CurrentBoxHistory->end(); ++CurrentBox) {
			for (TSingleBox::const_iterator CurrentElement = CurrentBox->second.begin(); CurrentElement != CurrentBox->second.end(); ++CurrentElement) {
				if ((CurrentElement->second-1) > CurrentMaxHistory) { CurrentMaxHistory = CurrentElement->second-1; }
			}
		}
		if (CurrentMaxHistory>MaxActualDistance) { CurrentMaxHistory = MaxActualDistance; }
		for (unsigned char i = 0; i < CurrentMaxHistory; ++i) { 
			double* pNumberOfBoxes = mxGetPr(mxGetField(Result,i,chNumberOfBoxes));
			*pNumberOfBoxes += 1;
		}
	}
	
	// allocate memory for BoxSize:
	std::vector< std::vector<unsigned int> > BoxSizes(MaxActualDistance,std::vector<unsigned int>());
	for (unsigned int i = 0; i < MaxActualDistance; ++i) {
		unsigned int NumberOfBoxes = unsigned int(floor(mxGetScalar( mxGetField(Result,i,chNumberOfBoxes))+0.5));
		BoxSizes[i].reserve(NumberOfBoxes);
	}
	// find Box sizes for each distance
	for (TBoxesCollection::const_iterator CurrentBoxHistory = Boxes.begin();CurrentBoxHistory!=Boxes.end(); ++CurrentBoxHistory) {
		std::vector<unsigned int> Sizes(MaxActualDistance,0);
		for (TBoxHistory::const_iterator CurrentBox = CurrentBoxHistory->begin(); CurrentBox != CurrentBoxHistory->end(); ++CurrentBox) {
			for (TSingleBox::const_iterator CurrentElement = CurrentBox->second.begin(); CurrentElement != CurrentBox->second.end(); ++CurrentElement) {
				for (unsigned char d = CurrentBox->first; d < CurrentElement->second && d < MaxActualDistance; ++d) {
					Sizes[d-1] +=1; 
				}
			}
		}
		for (unsigned int i = 0; i < Sizes.size() && Sizes[i]!=0 ; ++i) {
			BoxSizes[i].push_back(Sizes[i]);
		}
	}
	for (unsigned int i = 0; i < MaxActualDistance; ++i) { 
		mxArray* CurrentArray = mxCreateDoubleMatrix((int)BoxSizes[i].size(),1,mxREAL);
		mxSetField(Result,i,chBoxSizes,CurrentArray);
		double* pCurrentArray = mxGetPr(CurrentArray);
		for (unsigned int j = 0; j < BoxSizes[i].size(); ++j) {
			pCurrentArray[j] = BoxSizes[i][j];
		}
	}
	// find number of element in each box
	plhs[0]  = Result;

	if (nlhs>1) {
		plhs[1] = mxCreateDoubleMatrix(MaxActualDistance,1,mxREAL);
		double *p = mxGetPr(plhs[1]);
		for (unsigned int i = 0; i < MaxActualDistance; ++i) {
			p[i] = mxGetScalar( mxGetField(Result,i,chNumberOfBoxes));
		}
	}
	
	Graph.Clear();
	Boxes.clear();
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
			sprintf_s(DummyStr,256, "Progress: Node %d of %d, (%d%%), Elapsed: %fsec. Left: %f.", Progress,Total,int((100.0*Progress)/Total+0.5),ElapsedTime,ToGoTime);

			Disp(DummyStr);	
		}
	}
}
//------------------------------------------------------------------------------------------------------------------
void FindNodeDistancies(unsigned int NodeID,unsigned char *NodeDistance,std::vector<unsigned int>& Shell1,std::vector<unsigned int>& Shell2,unsigned char MaxDistance)
{
	std::vector<unsigned int>* pShell1 = &Shell1;
	std::vector<unsigned int>* pShell2 = &Shell2;
	memset(NodeDistance,0,NumberOfNodes*sizeof(char));
	(*pShell1)[0]= NodeID;
	NodeDistance[NodeID] = 1; // DUMMY DISTANCE - to avoid checking for self. Distance 0 means - no path from V
	unsigned int ShellSize = 1, Distance=0;
	while (ShellSize>0 && Distance<MaxDistance) { // for each distance
		unsigned int NewShellSize = 0;
		++Distance;
		for (unsigned int i =0; i < ShellSize; ++i) { // for each node at outer shell
			const std::vector<unsigned int>& Neighbours = Graph.Neighbours( (*pShell1)[i] );
			for (unsigned int CurrNeighbour = 0; CurrNeighbour < Neighbours.size(); ++CurrNeighbour) { // check each neighbour.
				if (NodeDistance[Neighbours[CurrNeighbour]]==0) { // not yet found. 
					NodeDistance[Neighbours[CurrNeighbour]] = Distance;
					(*pShell2)[NewShellSize] = Neighbours[CurrNeighbour]; // Add to outer shell
					++NewShellSize;
				}
			}
		} // for each node at outer shell
		ShellSize = NewShellSize;
		std::vector<unsigned int>* Temp = pShell1; pShell1 = pShell2; pShell2 = Temp; // swap shell containers
	} // for each distance
	NodeDistance[NodeID] =0; // reset the distance to self.
}
//------------------------------------------------------------------------------------------------------------------