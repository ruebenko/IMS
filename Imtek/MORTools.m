(*******************************************************************
This file was generated automatically by the Mathematica front end.
It contains Initialization cells from a Notebook file, which
typically will have the same name as this file except ending in
".nb" instead of ".m".

This file is intended to be loaded into the Mathematica kernel using
the package loading commands Get or Needs.  Doing so is equivalent
to using the Evaluate Initialization Cells menu command in the front
end.

DO NOT EDIT THIS FILE.  This entire file is regenerated
automatically each time the parent Notebook file is saved in the
Mathematica front end.  Any changes you make to this file will be
overwritten.
***********************************************************************)





(* *)
(* Title: MORTools.m *)
(* Context: *)
(* Author:christian moosmann *)
(* 
  Date: 20.9.2005,Freiburg i Br *)
(* 
  Summary: This package provides useful functions for handling reduced \
systems after Model Order Reduction.*)
(* Package Copyright: GNU GPL *)
(* 
  Package Version: 0.2a *)
(* Mathematica Version: 5.0 *)
(* History: 
  ;
  28.3.06: added FilterOptions to imsSolveAtPar;
  20.9. new Functions (imsSolveAtPar,imsGetReorderedNode,imsProjectSystem,
      imsExtendProjection) 
  *)
(* Keywords: *)
(* Sources: *)
(* Warnings: *)
(* Limitations: *)
(* 
  Discussion: *)
(* Requirements: *)
(* Examples: *)
(* *)



(* Disclaimer: *)

(* <one line to give the program's name and a brief idea of what it does.> *)
\

(* Copyright (C) 2004 christian moosmann *)

(* This program is free software; *)

(* you can redistribute it and/
      or modify it under the terms of the GNU General Public License *)

(* as published by the Free Software Foundation;
  either version 2 of the License, *)

(* or (at your option) any later version.This program is distributed in the \
hope that *)

(* it will be useful,but WITHOUT ANY WARRANTY; *)

(* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A \
PARTICULAR PURPOSE. *)

(* See the GNU General Public License for more details. 
      You should have received a copy of *)

(* the GNU General Public License along with this program;if not, 
  write to the *)

(* Free Software Foundation,Inc.,59 Temple Place,Suite 330,Boston,
  MA 02111-1307 USA *)



(* Start Package *)
BeginPackage["Imtek`MORTools`"];





(* *)
(* documentation *)
(* *)

(* functions *)

imsReorderStateToNodes::usage="imsReorderStateToNodes[stateVector,reorderMatrix,dirichletList] takes a stateVector from an ANSYS-generated discretisation and reorders it based on the reorder Matrix provided by mor4ansys. At last values from dirichletList are reinserted. dirichletList is a list of nodes with their corresponding Dirichlet values with original node numbers"
\

imsDiscreteTransferfunction::usage="imsDiscreteTransferfunction[matC,matK,load,freqRange] takes the ODE system C x\.b4[t]= K x[t] + b and computes the transfer function for discrete frequencies. Frequencies are computed based on freqRange. freqRange is {minFreq,maxFreq,steps}. steps is the number of frequencies computet with logarithmic frequency increase. It returns a List consisting of the StateTable and the list of frequencies. The StateTable itself is a list containing the state vectors at the different frequencies."
\

imsAppendOrthoNormal::usage="imsAppendOrthoNormal[matrix,vector] appends a vector to a matrix after othogonalizing it to all the vectors in the matrix and normalizeing it."
\

imsSolveAtPar::usage="imsSolveAtPar[system_imsSystem,par_List] computes a harmonic solution or a system using parameters and frequencies specified with par"
\

imsGetReorderedNode::usage="imsGetReorderedNode[reorderTable_Matrix,dirichletPositions_List,orgNode_Number] returns the number of a node in a reordered equations system"
\

imsProjectSystem::usage="imsProjectSystem[system_imsSystem,projM_Matrix,projMT_Matrix] projects a system using the projection Matrix projM and its Transpose projMT"
\

imsExtendProjection::usage=
  "imsExtendProjection[system_imsSystem,load_Vector,projMT_Matrix,conv_List,expandPointer_Integer,expansionPoint_,testPoint_List,testNodes_List,combinationVec_List,criterion_Number,maxIterations_Number,normThreshold_Number] extends the transposed projection Matrix projMT for the imsSystem system with the load Vector load."




(* *)
(* options docu *)
(* *)
imsStepping::usage="Define the type of frequency stepping (linear, logarithmic or Automatic)."

imsNormThreshold::usage=
  "Threshold value to decide if a vector should be appended or not."



(* *)
(* Error Messages *)
(* *)



(* *)
(* implementation part *)
(* *)



Begin["`Private`"];



(*Needs[ "Imtek`ShowStatus`" ]*)
Needs["Imtek`System`"]
Needs["Utilities`FilterOptions`"]
Needs["Imtek`Debug`"]



(* *)
(* define your options *)
(* *)

Options[imsDiscreteTransferfunction]={imsStepping\[Rule]Automatic}
Options[imsAppendOrthoNormal]={imsNormThreshold\[Rule] 0.}



(* selector *)



(* predicates *)



(* public functions *)

imsReorderStateToNodes[redVec_List,reorderMatrix_,dirichletList_]:=Module[
    {dirichletpos,dirichletval,stateVec},
    stateVec=reorderMatrix.redVec;
    {dirichletpos,dirichletval}=Transpose[dirichletList];
    dirichletpos=IntegerPart[dirichletpos];
    TestRange=Range[dirichletpos[[1]],Last[dirichletpos]];
    Timing[While[Unequal[dirichletval,{}],
        test=True;
        For[i=1,test,i++,
          
          If[(dirichletpos[[i]]\[Equal]TestRange[[i]])&&(i<
                  Length[dirichletpos]),test=True;length1=i,
            
            If[(dirichletpos[[i]]\[Equal]TestRange[[i]])&&(i==
                    Length[dirichletpos]),test=False;length1=i,test=False]
            ]
          ];
        dirichlettemp=Take[dirichletval,length1];
        stateVec= 
          Flatten[Append[
              Flatten[Prepend[dirichlettemp,
                  Take[stateVec,dirichletpos[[1]]-1 ] ]],
              Drop[stateVec,dirichletpos[[1]]-1 ] ] ];
        dirichletval=Drop[dirichletval,length1];
        dirichletpos=Drop[dirichletpos,length1];
        If[Unequal[dirichletval,{}],
          TestRange=Range[dirichletpos[[1]],Last[dirichletpos]]];
        ]];
    Return[stateVec]
    ]


imsDiscreteTransferfunction[matC_,matK_,load_List,singleFreq_?NumericQ,
    opts___]:=transferCorefirstOrder[matC,matK,load,singleFreq]



imsDiscreteTransferfunction[matC_,matK_,load_List,freqRange_List,opts___]:=
  Module[
    {stepMethod,freqList},
    stepMethod=imsStepping/.{opts}/.Options[imsDiscreteTransferfunction];
    Which[
      Length[freqRange]\[Equal]1,
      Return[transferCorefirstOrder[matC,matK,load,freqRange[[1]]]],
      Length[freqRange]\[Equal]2,Which[
        freqRange[[1]]\[Equal]freqRange[[2]],
        Return[transferCorefirstOrder[matC,matK,load,freqRange[[1]]]],
        True,
        Return[imsDiscreteTransferfunction[matC,matK,load,
            Append[freqRange,100],opts]]
        ],
      Length[freqRange]\[Equal]3,
      	Which[
        	stepMethod==="Linear",freqList=buildLinFreqs[freqRange],
        	stepMethod==="Logarithmic",freqList=buildLogFreqs[freqRange],
        	stepMethod===Automatic,
        		Which[
          		freqRange[[1]]\[Equal]0,freqList=buildLinFreqs[freqRange],
          		True,freqList=buildLogFreqs[freqRange]
          	]
        ];
      stateTable=transferCorefirstOrder[matC,matK,load,#]&/@freqList;
      Return[{stateTable,freqList}]]
    ]


imsAppendOrthoNormal[matV_,newVec_,opts___]:=
    Module[{hij,newVecNorm,internalVec,threshold},
      internalVec=newVec/Norm[newVec];
      threshold=imsNormThreshold/.{opts}/.Options[imsAppendOrthoNormal];
      For[i=1,i\[LessEqual]Length[matV],i++,
        hij=internalVec.matV[[i]];
        internalVec=internalVec-hij*matV[[i]];
        ];
      For[i=1,i\[LessEqual]Length[matV],i++,
        hij=internalVec.matV[[i]];
        internalVec=internalVec-hij*matV[[i]];
        ];
      
      newVecNorm=Norm[internalVec];
      If[newVecNorm>threshold,
        
        internalVec=internalVec/newVecNorm;
        AppendTo[matV,internalVec];
        ];
      Return[newVecNorm];
      ];

SetAttributes[imsAppendOrthoNormal,HoldFirst];


imsSolveAtPar[system_imsSystem,par_List,opts___]:=Which[
      imsStationaryQ[system],
      LinearSolve[
        Apply[Plus,
          Drop[par,Length[Transpose[imsGetLoad[system]]]]*
            imsGetStiffness[system]],
        Normal[Apply[Plus,
            Take[par,Length[Transpose[imsGetLoad[system]]]]*
              Transpose[imsGetLoad[system]]]],
        FilterOptions[ LinearSolve, opts ]],
      imsFirstOrderQ[system],
      LinearSolve[
        Apply[Plus,
          Drop[par,Length[Transpose[imsGetLoad[system]]]]*
            Flatten[{imsGetStiffness[system],imsGetDamping[system]},1]],
        Normal[Apply[Plus,
            Take[par,Length[Transpose[imsGetLoad[system]]]]*
              Transpose[imsGetLoad[system]]]],
        FilterOptions[ LinearSolve, opts ]],
      imsSecondOrderQ[system],
      LinearSolve[
        Apply[Plus,
          Drop[par,Length[Transpose[imsGetLoad[system]]]]*
            Flatten[{imsGetStiffness[system],imsGetDamping[system],
                imsGetInertia[system]},1]],
        Normal[Apply[Plus,
            Take[par,Length[Transpose[imsGetLoad[system]]]]*
              Transpose[imsGetLoad[system]]]],
        FilterOptions[ LinearSolve, opts ]]
      ];


imsGetReorderedNode[reorderTable_,dirichletPos_,orgNode_]:=
    Cases[ArrayRules[reorderTable],
        a:({orgNode-Length[Select[dirichletPos,#<orgNode&]],
                  b_}\[Rule]_)\[Rule]b][[1]];

imsMORProjectPolynomMatrix[m_imsPolynomMatrix,projM_,projMT_]:=Module[
      {e=imsGetPolynomMatrixExponents[m],ts=0,te=0,
        mv=imsGetPolynomMatrixValues[m]},
      
      If[Length[e]\[GreaterEqual]1,ts=(Plus@@e[[1]])+2];
      If[Length[e]\[GreaterEqual]2,te=ts+(Plus@@e[[2]])-1];
      
      If[TensorRank[mv]\[Equal]2 && ts\[Equal]2 && te\[Equal]2, 
        Return[imsMakePolynomMatrix[e,projMT.(mv.projM)]]];
      
      Return[
        imsMakePolynomMatrix[e,
          imsPolynomMatrixContract[
            mv,
            Join[{{ts-1,Transpose[projMT]}},Table[{i,projM},{i,ts,te}]]
            ]
          ]
        ]
      ];

imsProjectSystem[system_?imsSystemContainsMoreExponentsQ,projM_,projMT_]:=
    Module[{e=imsGetSystemVariables[system]},
      e[[2]]=Dimensions[projM][[2]];
      imsMakeSystemPolynomial[e,
        imsMORProjectPolynomMatrix[#,projM,projMT]&/@
          imsGetSystemPolynomMatrices[system,_]]];

imsProjectSystem[system_?imsSecondOrderQ,projM_,projMT_]:=
  imsMakeSystem[
      projMT.imsGetLoad[system],(projMT.(#.projM))&/@imsGetStiffness[system],
      If[imsSystemContainsExponentsQ[ 
          system, {{1},{0,1}}|{{},{0,1}} ],(projMT.(#.projM))&/@
          imsGetDamping[system],{}],(projMT.(#.projM))&/@
        imsGetInertia[system]]/;Not[imsSystemContainsMoreExponentsQ[system]]

imsProjectSystem[system_?imsFirstOrderQ,projM_,projMT_]:=
  imsMakeSystem[
      projMT.imsGetLoad[system],(projMT.(#.projM))&/@
        imsGetStiffness[system],(projMT.(#.projM))&/@imsGetDamping[system]]/;
    Not[imsSystemContainsMoreExponentsQ[system]]

imsProjectSystem[system_?imsStationaryQ,projM_,projMT_]:=
  imsMakeSystem[
      projMT.imsGetLoad[system],(projMT.(#.projM))&/@imsGetStiffness[system]]/;
    Not[imsSystemContainsMoreExponentsQ[system]]



imsExtendProjection[system_,load_,projMT_,conv_,expandPointer_Integer,
    expansion_,test_,testNodes_,criterion_:10.^-10,maxIterations_:30,
    normThreshold_:10.^-4]:=
  Module[{allMatrices,expandMatrix,constMatrix,kInvFunc,localProjMT={},
      localProjM,returnProjM,returnProjMT,returnConv,outVec,reducedSystem,
      localVal},
    allMatrices=Which[
        imsSecondOrderQ[system],
        Flatten[{imsGetStiffness[system],imsGetDamping[system],
            imsGetInertia[system]},1],
        imsFirstOrderQ[system],
        Flatten[{imsGetStiffness[system],imsGetDamping[system]},1],
        True,imsGetStiffness[system]
        ];
    
    expandMatrix=allMatrices[[expandPointer]];
    constMatrix=Apply[Plus,expansion*allMatrices];
    
    imsDebugMessage["imsAppendOrthoNormal",2,"building base matrix"];
    
    kInvFunc=LinearSolve[constMatrix];
    localProjMT={};
    returnProjMT=projMT;
    returnConv=conv;
    
    imsAppendOrthoNormal[localProjMT,kInvFunc[Flatten[Normal[load]]],
      imsNormThreshold\[Rule]normThreshold];
    imsAppendOrthoNormal[returnProjMT,localProjMT[[1]],
      imsNormThreshold\[Rule]normThreshold];
    imsAppendOrthoNormal[localProjMT,kInvFunc[expandMatrix.localProjMT[[1]]],
      imsNormThreshold\[Rule]normThreshold];
    imsAppendOrthoNormal[returnProjMT,localProjMT[[-1]],
      imsNormThreshold\[Rule]normThreshold];
    
    returnProjM=Transpose[returnProjMT];
    
    reducedSystem=imsProjectSystem[system,returnProjM,returnProjMT];
    
    imsDebugMessage["imsAppendOrthoNormal",2,"testing"];
    
    localVal[1]=returnProjM.imsSolveAtPar[reducedSystem,test];
    AppendTo[returnConv,Norm[localVal[1]]/Length[load]];
    
    While[
      (Last[returnConv]>criterion)&&(Length[localProjMT]<maxIterations),
      imsAppendOrthoNormal[localProjMT,
        kInvFunc[expandMatrix.Last[localProjMT]],
        imsNormThreshold\[Rule]normThreshold];
      imsAppendOrthoNormal[returnProjMT,Last[localProjMT],
        imsNormThreshold\[Rule]normThreshold];
      returnProjM=Transpose[returnProjMT];
      reducedSystem=imsProjectSystem[system,returnProjM,returnProjMT];
      localVal[2]=returnProjM.imsSolveAtPar[reducedSystem,test];
      AppendTo[returnConv,Norm[localVal[2]-localVal[1]]/Length[load]];
      localVal[1]=localVal[2];
      ];
    Return[{reducedSystem,returnProjM,returnProjMT,returnConv}]]

imsExtendProjection[system_,load_,projMT_,expandPointer_Integer,expansion_,
    iterations_:30,normThreshold_:10.^-4]:=
  Module[{allMatrices,expandMatrix,constMatrix,kInvFunc,localProjMT={},
      localProjM,returnProjM,returnProjMT,returnConv,outVec,reducedSystem,
      localVal},
    allMatrices=Which[
        imsFirstOrderQ[system],
        Flatten[{imsGetStiffness[system],imsGetDamping[system]},1],
        True,imsGetStiffness[system]
        ];
    
    expandMatrix=allMatrices[[expandPointer]];
    constMatrix=Apply[Plus,expansion*allMatrices];
    kInvFunc=LinearSolve[constMatrix];
    localProjMT={};
    returnProjMT=projMT;
    
    imsAppendOrthoNormal[localProjMT,kInvFunc[Flatten[Normal[load]]],
      imsNormThreshold\[Rule]normThreshold];
    imsAppendOrthoNormal[returnProjMT,localProjMT[[1]],
      imsNormThreshold\[Rule]normThreshold];
    
    Do[
      imsAppendOrthoNormal[localProjMT,
        kInvFunc[expandMatrix.Last[localProjMT]],
        imsNormThreshold\[Rule]normThreshold];
      imsAppendOrthoNormal[returnProjMT,Last[localProjMT],
        imsNormThreshold\[Rule]normThreshold];
      ,{i,2,iterations}];
    
    returnProjM=Transpose[returnProjMT];
    
    reducedSystem=imsProjectSystem[system,returnProjM,returnProjMT];
    
    Return[{reducedSystem,returnProjM,returnProjMT}]
    ]


(* private functions *)

transferCorefirstOrder[matC_,matK_,load_,freq_]:=Module[{omega,stateVec},
      omega=2.*Pi*freq;
      stateVec=LinearSolve[omega*matC-matK,load];
      Return[stateVec]
      ];
buildLogFreqs[freqRange_]:=
    Module[{minFreq,maxFreq,steps,stepWidth,freqList,freq},
      minFreq=freqRange[[1]];
      maxFreq=freqRange[[2]];
      steps=freqRange[[3]];
      stepWidth=Log[10, (maxFreq/minFreq)]/(steps-1);
      freqList={};
      Do[
        freq=minFreq*10.^(i*stepWidth);
        AppendTo[freqList,freq],
        {i,0,steps-1}];
      Return[freqList]
      ];
buildLinFreqs[freqRange_]:=
    Module[{minFreq,maxFreq,steps,stepWidth,freqList,freq},
      minFreq=freqRange[[1]];
      maxFreq=freqRange[[2]];
      steps=freqRange[[3]];
      stepWidth=(maxFreq-minFreq)/(steps-1);
      freqList={};
      Do[
        freq=minFreq+(i*stepWidth);
        AppendTo[freqList,freq],
        {i,0,steps-1}];
      Return[freqList]
      ];



(* representors *)



End[] (* of Begin Private *)



(* Protect[] (* anything *) *)
EndPackage[] 




