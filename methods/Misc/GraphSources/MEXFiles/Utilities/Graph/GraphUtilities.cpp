
#include "GraphUtilities.h"

#include <algorithm>
#include <set>
#include <map>
#include <math.h>
/********************************************************************************************************/
unsigned int GraphNodeDegrees(const mxArray* Graph, EDirection Dir, std::vector<unsigned int>& Degrees)
{
	const double* Data			= mxGetPr(mxGetField(Graph,0,"Data"));	
	unsigned int NumberOfLinks	= static_cast<unsigned int>(mxGetM( mxGetField(Graph,0,"Data") ));
	unsigned int NumberOfNodes	= GraphGetMaximalNodeID(Graph);
	Degrees.assign(NumberOfNodes,0); // to account for the 0-based indexing of C++! Index 0 is not used.

	switch (Dir) {
		case dirDirect	:
			for (unsigned int i = 0; i < NumberOfLinks; ++i) {
								++Degrees[ (unsigned int)ceil(  *(Data+i)-0.5 )-1 ];
							}
							break;
		case dirInverse	:
							Data =	Data + NumberOfLinks;
							for (unsigned int i = 0; i < NumberOfLinks; ++i) {
								++Degrees[ (unsigned int)ceil(  *(Data+i)-0.5 )-1 ];
							}
							break;		
		case dirBoth	:   {
								std::vector< std::set<unsigned int> > Links(NumberOfNodes);
								for (unsigned int i = 0; i < NumberOfLinks; ++i) {
									unsigned int P1 = (unsigned int)ceil(  *(Data+i)-0.5-1 ) ;
									unsigned int P2 = (unsigned int)ceil(  *(Data+i+NumberOfLinks)-0.5-1 ) ;
									Links[P1].insert(P2);
									Links[P2].insert(P1);
								}
								for (unsigned int i = 0; i < NumberOfNodes; ++i) {
									Degrees[i] = (unsigned int)Links[i].size();
								}
							}
							break;
	};
	return NumberOfNodes; 
}
/********************************************************************************************************/
unsigned int GraphNodeLinks(const mxArray* Graph, EDirection Dir, std::vector< std::set<unsigned int> >& OutputGraph)
{
	const double* Data			= mxGetPr(mxGetField(Graph,0,"Data"));	
	unsigned int NumberOfLinks	= static_cast<unsigned int>(mxGetM( mxGetField(Graph,0,"Data") ));
	unsigned int NumberOfNodes	= GraphGetMaximalNodeID(Graph);
	OutputGraph.assign(NumberOfNodes, std::set<unsigned int>() );

	switch (Dir) {
		case dirDirect	:
							for (unsigned int i = 0; i < NumberOfLinks; ++i) {
								OutputGraph[ (unsigned int)ceil(  *(Data+i)-0.5 -1) ].insert( (unsigned int)ceil(  *(Data+i+NumberOfLinks)-0.5 ));
							}
							break;
		case dirInverse	:
							for (unsigned int i = 0; i < NumberOfLinks; ++i) {
								OutputGraph[ (unsigned int)ceil(  *(Data+i+NumberOfLinks)-0.5-1 ) ].insert( (unsigned int)ceil(  *(Data+i)-0.5 ));
							}
							break;		
		case dirBoth	:   								
							for (unsigned int i = 0; i < NumberOfLinks; ++i) {
									unsigned int P1 = (unsigned int)ceil(  *(Data+i)-0.5 ) ;
									unsigned int P2 = (unsigned int)ceil(  *(Data+i+NumberOfLinks)-0.5 ) ;
									OutputGraph[P1-1].insert(P2);
									OutputGraph[P2-1].insert(P1);
							}							
							break;
	};

	return NumberOfNodes; 
}
/********************************************************************************************************/
unsigned int GraphNodeLinks(const mxArray* Graph, EDirection Dir, std::vector< std::map<unsigned int,double> >& OutputGraph)
{
	const double* Data			= mxGetPr(mxGetField(Graph,0,"Data"));	
	unsigned int NumberOfLinks	= static_cast<unsigned int>(mxGetM( mxGetField(Graph,0,"Data") ));
	unsigned int NumberOfNodes	= GraphGetMaximalNodeID(Graph);
	OutputGraph.assign(NumberOfNodes, std::map<unsigned int,double>() );

	switch (Dir) {
		case dirDirect	:
							for (unsigned int i = 0; i < NumberOfLinks; ++i) {
								const unsigned int Source= (unsigned int)ceil(  *(Data+i)-0.5 -1);
								const unsigned int Target = (unsigned int)ceil(  *(Data+i+NumberOfLinks)-0.5 );
								const double Weight = *(Data+i+2*NumberOfLinks);
								OutputGraph[ Source ].insert( std::map<unsigned int,double>::value_type(Target,Weight));
							}
							break;
		case dirInverse	:
							for (unsigned int i = 0; i < NumberOfLinks; ++i) {
								const unsigned int Source= (unsigned int)ceil(  *(Data+i+NumberOfLinks)-0.5 -1);
								const unsigned int Target = (unsigned int)ceil(  *(Data+i)-0.5 );
								const double Weight = *(Data+i+2*NumberOfLinks);
								OutputGraph[ Source ].insert( std::map<unsigned int,double>::value_type(Target,Weight));
							}
							break;		
		case dirBoth	:   								
							for (unsigned int i = 0; i < NumberOfLinks; ++i) {
									const unsigned int Source= (unsigned int)ceil(  *(Data+i)-0.5 -1);
									const unsigned int Target = (unsigned int)ceil(  *(Data+i+NumberOfLinks)-0.5 );
									const double Weight = *(Data+i+2*NumberOfLinks);
									OutputGraph[ Source ].insert( std::map<unsigned int,double>::value_type(Target,Weight));
									OutputGraph[ Target ].insert( std::map<unsigned int,double>::value_type(Source,Weight));
							}							
							break;
	};

	return NumberOfNodes; 
}
/********************************************************************************************************/
unsigned int GraphGetMaximalNodeID(const mxArray* Graph)
{
	const double* Data = mxGetPr(mxGetField(Graph,0,"Data"));
	unsigned int NumberOfLinks = static_cast<unsigned int>(mxGetM( mxGetField(Graph,0,"Data") ));
	unsigned int Result = (unsigned int)ceil(*std::max_element(Data , Data + 2*NumberOfLinks)-0.5);
	return Result;
}
/********************************************************************************************************/

std::vector<unsigned int> MexToVectorOfIDs(const mxArray* V)
	{
		std::vector<unsigned int> SourceNodeIDs;
		if (mxIsNumeric(V)) {
			switch (mxGetClassID (V)) {
				case mxDOUBLE_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<double>(V); break;
				case mxSINGLE_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<float>(V); break;
				case mxINT8_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<char>(V); break;
				case mxUINT8_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<unsigned char>(V); break;
				case mxINT16_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<short>(V); break;
				case mxUINT16_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<unsigned short>(V); break;
				case mxINT32_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<int>(V); break;
				case mxUINT32_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<unsigned int>(V); break;
				case mxINT64_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<INT64T>(V); break;
				case mxUINT64_CLASS : SourceNodeIDs = DoMexToVectorOfIDs<unsigned INT64T>(V); break;
				default : mexErrMsgTxt("Unsupported NodeIDs class type");
			} // switch 
		}
		return SourceNodeIDs; 
	}

/********************************************************************************************************/