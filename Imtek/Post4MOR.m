(* 
	Evgenii Rudnyi (c) 2004, rudnyi@imtek.uni-freuburg.de
*)

(* Title: Post4MOR.m *)
(* Context: Imtek`Post4MOR*)
(* Author: Evgenii Rudnyi *)
(* Date: December 2004, Freiburg *)
(* Summary: This is a package for post-processing dynamic models.*)
(* Package Copyright: GNU GPL *)
(* Package Version: 2.0 *)
(* Mathematica Version: 5.01 *)
(* History: *)
(* Keywords: *)
(* Sources: *)
(* Warnings: *)
(* Limitations: *)
(* Discussion: *)
(* Requirements: *)
(* Examples: See documentations *)
(* *)

(* Whereever the GNU GPL is not applicable, 
  the software should be used in the same spirit. *)

(* Users of this code must verify correctness for their application. *)
(* Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
  MA 02111-1307 USA *)
(* Disclaimer: *)
(* <one line to give the program's name and a brief idea of what it does.> *)
(* Copyright (C) 2004 Evgenii Rudnyi*)

(* This program is free software; *)
(* you can redistribute it and or modify it under the terms of the GNU General Public License *)
(* as published by the Free Software Foundation; either version 2 of the License,*)
(* or (at your option) any later version.This program is distributed in the \
hope that *)
(* it will be useful, but WITHOUT ANY WARRANTY; *)
(* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. *)
(* See the GNU General Public License for more details. 
      You should have received a copy of *)
(* the GNU General Public License along with this program; if not, 
  write to the *)
(* Free Software Foundation,Inc.,59 Temple Place,Suite 330,Boston,
  MA 02111-1307 USA *)

BeginPackage["Imtek`Post4MOR`", {"LinearAlgebra`MatrixManipulation`", "Utilities`FilterOptions`", "Graphics`MultipleListPlot`"}];

DynamicSystem::usage = "Use MakeDynamicSystem, MakeFirstOrderSystem, and MakeSecondOrderSystem to construct the object; MatrixMQ, MatrixEQ, MatrixDQ, FirstOrderSystemQ, SecondOrderSystemQ to make a query; MatrixM, MatrixE, MatrixK, MatrixA, MatrixB, MatrixC, MatrixD, OutputNames to select a component.";

MakeDynamicSystem::usage = "MakeDynamicSystem[matM, matE, matK, matB, matC, namesC, matD] gives a DynamicSystem object. matM, matE, and matD should be matrices or Null. matK, matB, and matC must be matrices. namesC is a list of strings. matD is optional and by default is Null.";
MakeFirstOrderSystem::usage = "MakeFirstOrderSystem[matA, matB, matC, namesC, matD] and MakeFirstOrderSystem[matE, matA, matB, matC, namesC, matD] give a DynamicSystem object for a first order system. matE, and matD should be matrices or Null. matA, matB, and matC must be matrices. namesC is a list of strings. matD is optional and by default is Null.";
MakeSecondOrderSystem::usage = "MakeSecondOrderSystem[matM, matK, matB, matC, namesC, matD] and MakeSecondOrderSystem[matM, matE, matK, matB, matC, namesC, matD] give a DynamicSystem object for a second order system. matM, matE, and matD should be matrices or Null. matK, matB, and matC must be matrices. namesC is a list of strings. matD is optional and by default is Null.";

MatrixM::usage = "MatrixM[sys] gives system matrix M of sys.";
MatrixE::usage = "MatrixE[sys] gives system matrix E of sys.";
MatrixA::usage = "MatrixA[sys] gives system matrix A of sys.";
MatrixK::usage = "MatrixK[sys] gives system matrix K of sys.";
MatrixB::usage = "MatrixB[sys] gives system matrix B of sys.";
MatrixC::usage = "MatrixC[sys] gives system matrix C of sys.";
MatrixD::usage = "MatrixD[sys] gives system matrix D of sys.";
OutputNames::usage = "OutputNames[sys] gives a list of output names of sys.";

MatrixMQ::usage = "MatrixMQ[sys] gives True if system matrix M is present in sys and False otherwise.";
MatrixEQ::usage = "MatrixEQ[sys] gives True if system matrix E is present in sys and False otherwise.";
MatrixDQ::usage = "MatrixMD[sys] gives True if system matrix D is present in sys and False otherwise.";
FirstOrderSystemQ::usage = "FirstOrderSystemQ[sys] gives True if sys represent a first order system and False otherwise.";
SecondOrderSystemQ::usage = "SecondOrderSystemQ[sys] gives True if sys represent a second order system and False otherwise.";
ExplicitSystemQ::usage = "ExplicitSystemQ[sys] gives True if sys represent an explicit first order system and False otherwise.";

DeleteDamping::usage = "DeleteDamping[sys] gives a new system without system matrix E. sys must be a second order system.";
AddDamping::usage = "AddDamping[sys, matE] gives a new system with matrix E inreased by matE. AddDamping[sys, alpha, beta] gives a new system with matrix E increased by Rayleigh damping alpha*matM+beta*matK. sys must be a second order system.";
ToFirstOrderSystem::usage = "ToFirstOrderSystem[sys] gives a new system in the form of a first order system.";
ToExplicitSystem::usage = "ToExplicitSystem[sys] gives a new system in the form of an explicit first order system.";

TakeSystem::usage = "TakeSystem[sys, dim] gives a new system of dimension dim. This operation makes sense only when an original system has been obtained by iterative model reduction method.";
ReadSystem::usage = "ReadSystem[baseName] reads a system from files with the base name baseName. For compatibility ReadSystem[file, type] reads a system from a file written in the old format. type must be a string FirstOrderSystem or SecondOrderSystem.";
WriteSystem::usage = "WriteSystem[sys, baseName] writes a system to files with the base name baseName.";

SimulationResult::usage = "Use MakeSimulationResult to construct the object; XSeries, XName, YSeries, YNames to select a component.";

MakeSimulationResult::usage = "MakeSimulationResult[XSeries, Xname, YSeries, YNames] gives a SimulationResult object. XSeries must be a vector, YSeries must be a matrix, XName must be a string and YNames must be a list of strings.";

XSeries::usage = "XSeries[res] gives XSeries of res.";
XName::usage = "XName[res] gives XName of res.";
YSeries::usage = "YSeries[res] gives YSeries of res.";
YNames::usage = "YNames[res] gives YNames of res.";

TransformResult::usage = "TransformResult[res, names] gives a new res whose YSeries correspond to names.";

CompatibleResultQ::usage = "CompatibleResultQ[res1, res2, ...] gives True if all objects are compatible and False otherwise.";

Difference::usage = "Difference[res1, {listres}, ops] gives a list of differences between res1 and each object in listres. All SimulationResult must be compatible. Option is ErrorFunction, by default ErrorFunction->Subtract.";

ErrorFunction::usage = "An option for Difference.";

ReadResult::usage = "ReadResult[file] reads SimulationResult from file. ReadResult[file, XName] read SimulationResult from file in old format.";
WriteResult::usage = "WriteResult[res, file] writes res to file.";
WriteResultOld::usage = "WriteResult[res, file] writes res to file in the old format.";

Log10::usage = "Log10[x] gives Log[10, x].";

PlotResult::usage = "PlotResult[listres, ops] makes plots for the list of compatible SimulationResult. Options: CommonTitle for a title, FunctionX and FunctionY to modify series values, MultipleListPlot options.";

CommonTitle::usage = "An option for PlotResult.";
FunctionX::usage = "An option for PlotResult.";
FunctionY::usage = "An option for PlotResult.";

StationarySolution::usage = "StationorySolution[sys, ops] gives a stationary solution. Options: InputFunction, LinearSolve options.";
HarmonicSolution::usage = "HarmonicSolution[freq, sys, ops] gives SimulationResult for a given list of freq. Options: InputFunction, LinearSolve options.";
TransientSolution::usage = "TransientSolution[time, sys, ops] gives SimulationResult for a given list time. Options: Verbose, InputFunction, NDSolve options. It uses different approaches for different types of DynamicSystem. Use ToFirstOrderSystem or ToExplicitSystem, if TransienSolution fails.";

InputFunction::usage = "An option for StationorySolution, TransientSolution, and HarmonicSolution.";
Verbose::usage = "An option for TransientSolution.";

Begin["`Private`"];

(*SystemFirstOrder*)

Format[sys_DynamicSystem] := If[Length[sys] == 7 && MatrixQ[MatrixK[sys]], 
	"DynamicSystem[{"<>ToString[Length[MatrixK[sys]]]<>","<>ToString[Dimensions[MatrixB[sys]][[2]]]<>","<>ToString[Length[MatrixC[sys]]]<>"}, ...]",
	"- DynamicSystem - "
]

(*
SetAttributes[{
	DynamicSystem,
	SimulationResult,
	FunctionX,
	FunctionY,
	CommonTitle
}, Protected]
*)

checkConsistence[sys_DynamicSystem] := Module[{dim},
	dim = Dimensions[MatrixK[sys]];	
	Which[
		MatrixMQ[sys] && Dimensions[originalMatrixM[sys]] != dim,
			Throw["DynamicSystem: MatrixM and MatrixK are not compatible"],
		MatrixEQ[sys] && Dimensions[originalMatrixE[sys]] != dim,
			Throw["DynamicSystem: MatrixE and MatrixK are not compatible"],
		dim[[1]] != Length[MatrixB[sys]],
			Throw["DynamicSystem: MatrixB and MatrixK are not compatible"],
		dim[[1]] != Dimensions[MatrixC[sys]][[2]],
			Throw["DynamicSystem: MatrixC and MatrixK are not compatible"],
		Length[MatrixC[sys]] != Length[OutputNames[sys]],
			Throw["DynamicSystem: MatrixC and OutputNames are not compatible"],
		MatrixDQ[sys] && (Length[originalMatrixD[sys]] != Length[MatrixC[sys]]),
			Throw["DynamicSystem: MatrixD and MatrixC are not compatible"],
		MatrixDQ[sys] && (Dimensions[originalMatrixD[sys]][[2]] != Dimensions[MatrixB[sys]][[2]]),
			Throw["DynamicSystem: MatrixD and MatrixB are not compatible"]
	];
	sys
]

MakeDynamicSystem[
	matM_ ,
	matE_ ,
	matK_ ,
	matB_ ,
	matC_ ,
	namesC_List,
	matD_ : Null] := (
	checkConsistence[DynamicSystem[matM, matE, matK, matB, matC, namesC, matD]]
) /; ((MatrixQ[matM] || matM === Null) 
	&& (MatrixQ[matE] || matE === Null)
	&& (MatrixQ[matK])
	&& (MatrixQ[matB])
	&& (MatrixQ[matC])
	&& (MatrixQ[matD] || matD === Null))


originalMatrixM[sys_DynamicSystem] := sys[[1]]

originalMatrixE[sys_DynamicSystem] := sys[[2]]

originalMatrixD[sys_DynamicSystem] := sys[[7]]

MatrixMQ[sys_DynamicSystem] := sys[[1]] =!= Null

MatrixEQ[sys_DynamicSystem] := sys[[2]] =!= Null

MatrixDQ[sys_DynamicSystem] := sys[[7]] =!= Null

FirstOrderSystemQ[sys_DynamicSystem] := sys[[1]] === Null

SecondOrderSystemQ[sys_DynamicSystem] := sys[[1]] =!= Null

ExplicitSystemQ[sys_DynamicSystem] := (sys[[1]] === Null && sys[[2]] === Null)

MatrixM[sys_DynamicSystem] := If[MatrixMQ[sys],
	sys[[1]],
	SparseArray[{},Dimensions[MatrixK[sys]]]
]

MatrixE[sys_DynamicSystem] := If[MatrixEQ[sys],
	sys[[2]],
	If[FirstOrderSystemQ[sys],
		SparseArray[{{i_, i_}->1.}, Dimensions[MatrixK[sys]]],
		SparseArray[{}, Dimensions[MatrixK[sys]]]
	]
]

MatrixK[sys_DynamicSystem] := sys[[3]]

MatrixA[sys_DynamicSystem] := -sys[[3]]

MatrixB[sys_DynamicSystem] := sys[[4]]

MatrixC[sys_DynamicSystem] := sys[[5]]

OutputNames[sys_DynamicSystem] := sys[[6]]

MatrixD[sys_DynamicSystem] := If[MatrixDQ[sys],
	sys[[7]],
	SparseArray[{},{Length[MatrixC[sys]], Dimensions[MatrixB[sys]][[2]]}]
]

MakeFirstOrderSystem[
	matA_,
	matB_,
	matC_,
	namesC_List,
	matD_ : Null] := 
MakeDynamicSystem[Null, Null, -matA, matB, matC, namesC, matD] /;
	((MatrixQ[matA])
	&& (MatrixQ[matB])
	&& (MatrixQ[matC])
	&& (MatrixQ[matD] || matD === Null))

MakeFirstOrderSystem[
	matE_, 
	matA_,
	matB_,
	matC_,
	namesC_List,
	matD_ : Null] := 
MakeDynamicSystem[Null, matE, -matA, matB, matC, namesC, matD] /;
	((MatrixQ[matE] || matE === Null)
	&& (MatrixQ[matA])
	&& (MatrixQ[matB])
	&& (MatrixQ[matC])
	&& (MatrixQ[matD] || matD === Null))

MakeSecondOrderSystem[
	matM_,
	matK_,
	matB_,
	matC_,
	namesC_List,
	matD_ : Null] := 
MakeDynamicSystem[matM, Null, matK, matB, matC, namesC, matD] /;
	((MatrixQ[matM])
	&& (MatrixQ[matK])
	&& (MatrixQ[matB])
	&& (MatrixQ[matC])
	&& (MatrixQ[matD] || matD === Null))

MakeSecondOrderSystem[
	matM_,
	matE_,
	matK_,
	matB_,
	matC_,
	namesC_List,
	matD_ : Null] := 
MakeDynamicSystem[matM, matE, matK, matB, matC, namesC, matD] /;
	((MatrixQ[matM])
	&& (MatrixQ[matE] || matE === Null)
	&& (MatrixQ[matK])
	&& (MatrixQ[matB])
	&& (MatrixQ[matC])
	&& (MatrixQ[matD] || matD === Null))

(*some functions for systemSecondOrder*)

DeleteDamping[sys_DynamicSystem /; SecondOrderSystemQ[sys]] := MakeSecondOrderSystem[
	MatrixM[sys],
	MatrixK[sys],
	MatrixB[sys],
	MatrixC[sys],
	OutputNames[sys],
	originalMatrixD[sys]
]

AddDamping[sys_DynamicSystem /; SecondOrderSystemQ[sys], matE_ /; MatrixQ[matE]] :=
MakeSecondOrderSystem[
	MatrixM[sys],
	MatrixE[sys] + matE,
	MatrixK[sys],
	MatrixB[sys],
	MatrixC[sys],
	OutputNames[sys],
	originalMatrixD[sys]
]

AddDamping[sys_DynamicSystem, alpha_, beta_ ] :=
MakeSecondOrderSystem[
	MatrixM[sys],
	MatrixE[sys] + N[alpha]*MatrixM[sys] + N[beta]*MatrixK[sys],
	MatrixK[sys],
	MatrixB[sys],
	MatrixC[sys],
	OutputNames[sys],
	originalMatrixD[sys]
] /; (SecondOrderSystemQ[sys] && NumericQ[alpha] && NumericQ[beta])


(*functions for both systems*)

ToFirstOrderSystem[sys_DynamicSystem] := Module[
	{zero = SparseArray[{}, Dimensions[MatrixK[sys]]], 
	one = SparseArray[{{i_, i_}->1.}, Dimensions[MatrixK[sys]]]},
	MakeFirstOrderSystem[
		BlockMatrix[{{MatrixE[sys], MatrixM[sys]},{-one, zero}}],
		-BlockMatrix[{{MatrixK[sys], zero},{zero, one}}],
		BlockMatrix[{{MatrixB[sys]},{SparseArray[{}, {Length[MatrixK[sys]],Dimensions[MatrixB[sys]][[2]]}] }}],
		BlockMatrix[{{MatrixC[sys], SparseArray[{}, {Length[MatrixC[sys]],Length[MatrixK[sys]]}] }}],
		OutputNames[sys],
		originalMatrixD[sys]
	]
] /; SecondOrderSystemQ[sys]

ToFirstOrderSystem[sys_DynamicSystem] := sys /; FirstOrderSystemQ[sys]

ToExplicitSystem[sys_DynamicSystem] := Module[{inv},
	If[MatrixEQ[sys],
			inv = Inverse[MatrixE[sys]];
			MakeFirstOrderSystem[
			inv.MatrixA[sys],
			inv.MatrixB[sys],
			MatrixC[sys],
			OutputNames[sys],
			originalMatrixD[sys]
		]
	,
		sys
	]
] /; FirstOrderSystemQ[sys]

ToExplicitSystem[sys_DynamicSystem] := ToExplicitSystem[ToFirstOrderSystem[sys]] /; SecondOrderSystemQ[sys]

TakeSystem[sys_DynamicSystem, dim_Integer] := (
	If[dim > Length[MatrixK[sys]],
		Throw["TakeSystem: dimension is smaller then required"]
	];
	DynamicSystem[
		If[MatrixMQ[sys], Take[MatrixM[sys], dim, dim], Null],
		If[MatrixEQ[sys], Take[MatrixE[sys], dim, dim], Null],
		Take[MatrixK[sys], dim, dim],
		Take[MatrixB[sys], dim],
		Take[MatrixC[sys], Length[MatrixC[sys]], dim],
		OutputNames[sys],
		If[MatrixDQ[sys], Take[MatrixD[sys], dim, dim], Null]
	]
)

fileQ[name_String] := Module[{in},
	Off[OpenRead::"noopen"];
	in = OpenRead[name];
	On[OpenRead::"noopen"];
	If [in === $Failed,
		False,
		Close[in]; True
	]
]

readMatrix1[name_String] := If[fileQ[name],
	Import[name, "MTX"],
	Throw["ReadSystem: No file "<>name]
]

readMatrix2[name_String] := If[fileQ[name],
	Import[name, "MTX"],
	Null
]

readNames[name_String] := Module[{in, Cnames},
	If[!fileQ[name], Throw["ReadSystem: No file "<>name]]; 
	in = OpenRead[name, DOSTextFormat->True];
	Cnames = ReadList[in, Word, WordSeparators->{" ", "\t", "\n", FromCharacterCode[10], FromCharacterCode[13]}];
	Close[in];
	Cnames 
]

readFirstOrder[baseName_String] := MakeFirstOrderSystem[
	readMatrix2[baseName<>".E"],
	readMatrix1[baseName<>".A"],
	readMatrix1[baseName<>".B"],
	readMatrix1[baseName<>".C"],
	readNames[baseName<>".C.names"],
	readMatrix2[baseName<>".D"]
]

readSecondOrder[baseName_String] := MakeSecondOrderSystem[
	readMatrix1[baseName<>".M"],
	readMatrix2[baseName<>".E"],
	readMatrix1[baseName<>".K"],
	readMatrix1[baseName<>".B"],
	readMatrix1[baseName<>".C"],
	readNames[baseName<>".C.names"],
	readMatrix2[baseName<>".D"]
]

ReadSystem[baseName_String] := (
	Which[
		fileQ[baseName<>".A"],
			readFirstOrder[baseName],
		fileQ[baseName<>".K"],
			readSecondOrder[baseName],
		True,
			Throw["ReadSystem: no files with A or K matrix"]
	]
)

ReadSystem[name_String, head_String] :=Module[
	{in, dimMax, Tini, redC, redK, ninp, funinp, bredin, nout, matout, names},
	in = OpenRead[name, DOSTextFormat->True];
	If[in == $Failed, Throw["ReadSystem: no such file"]];
	dimMax = Round[Read[in, Number]];
	Tini = N[Read[in, Number]];
	redC = N[Map[ReadList[in, Number, dimMax] &, Range[dimMax]]];
	redK = N[Map[ReadList[in, Number, dimMax] &, Range[dimMax]]];
	ninp = Round[Read[in, Number]];
	bredin = N[Map[ReadList[in, Number, dimMax] &, Range[ninp]]];
	nout = Round[Read[in, Number]];
	matout = {};
	names = {};
	Scan[
		(AppendTo[names, Read[in, Word, WordSeparators->{" ", "\t", "\n", FromCharacterCode[10], FromCharacterCode[13]}]]; 
		AppendTo[matout, N[ReadList[in, Number, dimMax]]])&, 
		Range[nout]
	];
	Close[in];
	Switch[
		head,
		"FirstOrderSystem",
			MakeFirstOrderSystem[redC, -redK, Transpose[bredin], matout, names],
		"SecondOrderSystem",
			MakeSecondOrderSystem[redC, redK, Transpose[bredin], matout, names],
		_,
			Throw["ReadSystem: wrong argument"]
	]
]

writeNames[name_String, list_List] := Module[{in},
	in = OpenWrite[name, FormatType -> OutputForm];
	Scan[
		Write[in, #]&
	,list];
	Close[in]
]

WriteSystem[sys_DynamicSystem, baseName_String] := (
	If[MatrixMQ[sys], Export[baseName<>".M", MatrixM[sys], "MTX"]];
	If[MatrixEQ[sys], Export[baseName<>".E", MatrixE[sys], "MTX"]];
	If[FirstOrderSystemQ[sys],
		Export[baseName<>".A", MatrixA[sys], "MTX"],
		Export[baseName<>".K", MatrixK[sys], "MTX"]
	];
	Export[baseName<>".B", MatrixB[sys], "MTX"];
	Export[baseName<>".C", MatrixC[sys], "MTX"];
	writeNames[baseName<>".C.names", OutputNames[sys]];
	If[MatrixDQ[sys], Export[baseName<>".D", MatrixD[sys], "MTX"]]
)

Format[res_SimulationResult] := "- SimulationResult - "

checkConsistence[res_SimulationResult] := Module[{dim},
	dim = Dimensions[YSeries[res]];	
	Which[
		Length[XSeries[res]] != dim[[2]],
			Throw["DynamicSystem: XSeries and YSeries are not compatible"],
		Length[YNames[res]] != dim[[1]],
			Throw["DynamicSystem: YNames and YSeries are not compatible"]
	];
	res
]

MakeSimulationResult[
	x_,
	xName_String,
	series_,
	names_List] := checkConsistence[SimulationResult[x, xName, series, names]] /;
	(VectorQ[x] && MatrixQ[series])

XSeries[res_SimulationResult] := res[[1]]

XName[res_SimulationResult] := res[[2]]

YSeries[res_SimulationResult] := res[[3]]

YNames[res_SimulationResult] := res[[4]]

TransformResult[res_SimulationResult, names_List] := Module[{ser, nam, pos},
	If[names == YNames[res],
		ser = YSeries[res];
		nam = names
	,
	 	ser = {};
		nam = {};
		Scan[(
			If[(pos = Position[YNames[res], #, 1, 1]) == {},
				Print["Series "<>#<>" is not present: ignored"]
			,
				AppendTo[ser, Flatten[Extract[YSeries[res], pos]]];
				AppendTo[nam, #]
			]
		)&, names]
	];
	If[ser == {}, Throw["FindResults: empty SimulationResult"]];
	MakeSimulationResult[
		XSeries[res],
		XName[res],
		ser,
		nam
	]
]

compatibleQ[res1_SimulationResult, res2_SimulationResult] := 
	XName[res1] === XName[res2] && YNames[res1] === YNames[res2]

CompatibleResultQ[res1_SimulationResult] := True 

CompatibleResultQ[res1_SimulationResult, res2__] := 
Apply[And, Map[compatibleQ[res1, #]&, {res2}]] /; VectorQ[{res2}, MatchQ[#, _SimulationResult]&]

CompatibleResultQ[list_List] := Apply[CompatibleResultQ, list]

Options[Difference] = {ErrorFunction->Subtract};

Difference[res1_SimulationResult, res2_SimulationResult, ops___] := 
	Difference[res1, {res2}, ops]

diff1[res1_, resi_, fun_] := MapThread[
	fun[#1, #2]&
, {YSeries[res1], YSeries[resi]}]

diff2[res1_, resi_, fun_, ops___] := MapThread[
	fun[#1, Interpolation[Transpose[{XSeries[resi], #2}], FilterOptions[Interpolation, {ops}], InterpolationOrder->1][XSeries[res1]]]&
, {YSeries[res1], YSeries[resi]}]

Difference[res1_SimulationResult, resList_List, ops___] := Module[{
	fun = ErrorFunction /. {ops} /. Options[Difference]},
	Map[
		MakeSimulationResult[
			XSeries[res1],
			XName[res1],
			If[XSeries[res1] == XSeries[#],
				diff1[res1, #, fun],
				diff2[res1, #, fun, ops]
			],
			YNames[res1]
		]&
	, resList]
] /; CompatibleResultQ[Prepend[res1, resList]]

ReadResult[file_String] := Module[{mat, names},
	mat = Chop[Import[file, "MTX"], $MinNumber];
	names = readNames[file<>".names"];
	MakeSimulationResult[
		mat[[1]],
		names[[1]],
		Delete[mat, 1],
		Delete[names, 1]		
	]
]

WriteResult[res_SimulationResult, file_String] := ( 
	Export[file, Prepend[YSeries[res], XSeries[res]], "MTX"];
	writeNames[file<>".names", Prepend[YNames[res], XName[res]]]
)

(*to read old format, the treatment of complex numbers is for Sam*)

ReadResult[name_String, nameX_String] := Module[{in, ntime, time, series, names, node, ser},
	Off[Read::"readn"];
	in = OpenRead[name];
	ntime = Round[Read[in, Number]];
	time = ReadList[in, Number, ntime];
	names = {};
	series = {};
	While[
    (node = Read[in, Word, WordSeparators->{" ", "\t", "\n", FromCharacterCode[10], FromCharacterCode[13]}]) =!= EndOfFile,
    AppendTo[names, node];
		ser = ReadList[in, Number, ntime*2];
		Which[
			Length[ser] === ntime*2,
				ser = Map[#[[1]]*Cos[#[[2]]*Degree] + I*#[[1]]*Sin[#[[2]]*Degree], Partition[ser, 2]],
			Length[ser] === ntime,
				ser,
			True,
				ser = Delete[ser, -1]
		];
    AppendTo[series, ser]
  ];
	Close[in];
	On[Read::"readn"];
	MakeSimulationResult[
		time,
		nameX,
		series,
		names
	]
]

(*for Sam*)

formatNumber[x_] := ToString[NumberForm[CForm[x],25,NumberPadding->{" ",""},SignPadding->False,ExponentFunction -> Identity]]

WriteResultOld[res_SimulationResult, file_String] := Module[{of},
	of = OpenWrite[file, FormatType -> OutputForm];
	Write[of, ToString[Length[XSeries[res]]]];
	Scan[
		Write[of, formatNumber[#]]&
	,XSeries[res]];
	MapIndexed[(
		Write[of, #1];
		Scan[
			If [Head[#] === Complex,
				Write[of, formatNumber[Abs[#]]<>" "<>formatNumber[Arg[#]/Degree]]				
			,
				Write[of, formatNumber[#]]
			]&
		, YSeries[res][[#2[[1]]]]]
  )&, YNames[res]];
	Close[of]		
]

defaultPlotOptions = {PlotRange->All, ImageSize->300, Frame->True, Axes->False};

Log10 := Log[10, #] &

Options[PlotResults] = {CommonTitle->"", FunctionX->Identity, FunctionY->Identity};

PlotResult[res_SimulationResult, ops___] := PlotResult[{res}, ops]

PlotResult[listres_List, ops___] := Module[{
		options = Join[{ops}, 
defaultPlotOptions],
		title = CommonTitle /. {ops} /. Options[PlotResults],	
		funx = FunctionX /. {ops} /. Options[PlotResults],
		funy = FunctionY /. {ops} /. Options[PlotResults]
	},
	MapIndexed[Function[{name, i},
		Apply[MultipleListPlot, Join[Map[Function[{res},
			Transpose[{funx[XSeries[res]], funy[YSeries[res][[i[[1]]]]]}]]
			, listres],
 			{FilterOptions[MultipleListPlot, options]},
			{PlotLabel->name<>": "<>title,
			PlotJoined->True,
			SymbolShape->None}]
		]
	],YNames[listres[[1]]]]
] /; CompatibleResultQ[listres]

makeInputs[inpFun_, n_] := Which[
	inpFun === Automatic,
		Table[1., {n}],
	Head[inpFun] === List && Length[inpFun] === n,
		inpFun,
	n === 1 && Head[inpFun] =!= List,
		{inpFun},
	True,
		Throw["Input functions are not compatible with the system"] 
]

Options[StationarySolution] = {InputFunction->Automatic};

StationarySolution[sys_DynamicSystem, inpFun_List, ops___] := Module[{inpFun},
	inpFun = InputFunction /. {ops} /. Options[StationarySolution];
	inpFun = makeInputs[inpFun, Last[Dimensions[MatrixB[sys]]]];
	If[!VectorQ[inpFun, NumericQ], Throw["Input functions must be numeric vales"]]; 
	MatrixC[sys].LinearSolve[MatrixK[sys], MatrixB[sys].inpFun, ops]]

harmonicLoop[list_, fun_, rhs_, ops___] := Map[
 LinearSolve[fun[#], rhs, ops]&, 
2.*N[Pi]*list]

Options[HarmonicSolution] = {InputFunction->Automatic};

HarmonicSolution[freq_List, sys_DynamicSystem, ops___] := Module[{inpFun},
	inpFun = InputFunction /. {ops} /. Options[HarmonicSolution];
	inpFun = makeInputs[inpFun, Last[Dimensions[MatrixB[sys]]]];
	If[!VectorQ[inpFun, NumericQ], Throw["Input functions must be numeric vales"]];
MakeSimulationResult[
	freq,
	"Frequency",
	MatrixC[sys].Transpose[Which[
	!MatrixMQ[sys],
		harmonicLoop[freq, (I*#*MatrixE[sys] + MatrixK[sys])&, 
		MatrixB[sys].inpFun, ops], 
	!MatrixEQ[sys],
		harmonicLoop[freq, (-#^2*MatrixM[sys] + MatrixK[sys])&, 
		MatrixB[sys].inpFun, ops], 
	True,
		harmonicLoop[freq, (-#^2*MatrixM[sys] + I*#*MatrixE[sys] + MatrixK[sys])&, 
		MatrixB[sys].inpFun, ops]
	]], 
	OutputNames[sys]
]] /; VectorQ[freq, NumericQ]

Options[TransientSolution] = {Verbose->False, InputFunction->Automatic};

TransientSolution[time_List, sys_DynamicSystem, ops___] := Module[{sol, tim, ver, inpFun, f1, init, init2},
	ver = Verbose /. {ops} /. Options[TransientSolution];
	inpFun = InputFunction /. {ops} /. Options[TransientSolution];
	inpFun = makeInputs[inpFun, Last[Dimensions[MatrixB[sys]]]];
	If[VectorQ[inpFun, NumericQ], 
		f1[x_?VectorQ, tau_] := -MatrixK[sys].x + MatrixB[sys].inpFun,
		f1[x_?VectorQ, tau_] := -MatrixK[sys].x + MatrixB[sys].Map[Function[el, el[x, tau]], inpFun]
	];
	init = Table[0., {Length[MatrixK[sys]]}];
	tim = AbsoluteTiming[sol = Which[
	ExplicitSystemQ[sys],
		NDSolve[{T'[tau] == f1[T[tau], tau], 
			T[0] == init}, T, {tau, 0, Last[time]}, FilterOptions[NDSolve, ops]],
	FirstOrderSystemQ[sys],
		init2 = LinearSolve[MatrixE[sys], f1[init, 0]];
		NDSolve[{(MatrixE[sys].#)&[T'[tau]] == f1[T[tau], tau], 
			T[0] == init, T'[0] == init2}, T, {tau, 0, Last[time]}, SolveDelayed->True, FilterOptions[NDSolve, ops]],
	True,
		init2 = LinearSolve[MatrixM[sys], f1[init, 0] - MatrixE[sys].init];
		NDSolve[{(MatrixM[sys].#)&[T''[tau]] + (MatrixE[sys].#)&[T'[tau]] == f1[T[tau], tau], 
			T[0] == init, T'[0] == init, T''[0] == init2}, T, {tau, 0, Last[time]}, SolveDelayed->True, FilterOptions[NDSolve, ops]]
	];];
If[ver, Print["NDSolve has made ", Length[sol[[1, 1, 2, 3, 1]]], " steps for ", tim[[1]]]];
MakeSimulationResult[
	time,
	"Time",
	MatrixC[sys].Transpose[T[time] /. First[sol]], 
	OutputNames[sys]
]
]	/; VectorQ[time, NumericQ]

End[];

EndPackage[];

