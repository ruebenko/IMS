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
(* Title: Assembler.m *)
(* Context: *)
(* 
  Author:oliver ruebenkoenig *)
(* Date: 25.3.2008, Train to Duesseldorf *)
(* 
  Summary: This is the IMTEK template for writing a mathematica packages *)
(* 
  Package Copyright: GNU GPL *)
(* Package Version: 0.3.0 *)
(* 
  Mathematica Version: 6.0 *)
(* History:
          
          speed improvement by 50% for version 6.0 using a new sparse array \
option; 
        improved speed by +- 
              20% by using PackedArrays and by making some functions \
Listable;
        addedVals was not in the module list in imsAssemble;
        improved speed (one order of magnitude) and memory usage;
        deleted old symbol and imsAssociativeMatrix support;
        reduced memory consumption;
        performance imporements for vectoriesed imsAssembler;
        vectorised imsAssembler: Code improvment factor 5;-);
      Code improvment ;
      Code improvement - + 60% ;-)
    Took the initialization for assembly into a symbol out of the assemble \
procedure and put them into a new function imsAssociativeMatrix. *)
(* 
  Keywords: *)
(* Sources: *)
(* Warnings: *)
(* Limitations: *)
(* 
  Discussion: *)
(* Requirements: *)
(* Examples: *)
(* *)
(* check out:
      Developer`SetSystemOptions[
          "SparseArrayOptions"\[Rule]{"TreatRepeatedEntries"\[Rule]1}] to add \
repeated entries.
   *)



(* Start Package *)
BeginPackage["Imtek`Assembler`"];





(* *)
(* documentation *)
(* *)
Needs["Imtek`Maintenance`"]
imsCreateObsoleteFunctionInterface[ MakeElementMatrix, $Context \
];imsCreateObsoleteFunctionInterface[ GetElementMatrixValues, $Context \
];imsCreateObsoleteFunctionInterface[ GetElementMatrixRows, $Context \
];imsCreateObsoleteFunctionInterface[ GetElementMatrixColumns, $Context \
];imsCreateObsoleteFunctionInterface[ ElementMatrixQ, $Context \
];imsCreateObsoleteFunctionInterface[ Assemble, $Context \
];imsCreateObsoleteFunctionInterface[ AssociativeMatrix, $Context \
];imsCreateObsoleteFunctionInterface[ ToSparseMatrix, $Context ];

(* constructors *)

imsMakeElementMatrix::usage = \
"imsMakeElementMatrix[ values, rows, columns ] constructs an element matrix to be used with imsAssemble. values is a matrix of values to be build in a global matrix by imsAssemble at rows and columns.";\


imsElementMatrix::usage = "imsElementMatrix is the data type returned by imsMakeElementMatrix."
\

(* selectors *)

imsGetElementMatrixValues::usage = \
"imsGetElementMatrixValues[ elementMatrix ] returns the value matrix of an element matrix.";\


imsGetElementMatrixRows::usage = \
"imsGetElementMatrixRows[ elementMatrix ] returns the rows at which the element matrix is to be assembled into a global matrix by imsAssemble.";\


imsGetElementMatrixColumns::usage = \
"imsGetElementMatrixColumns[ elementMatrix ] returns the columns at which the element matrix is to be assembled into a global matrix by imsAssemble.";\


(* predicates *)

imsElementMatrixQ::usage = \
"imsElementMatrixQ[ expr ] returns True if expr is an imsElementMatrix. Else False is returned.";\


(* functions *)

imsAssemble::usage = "imsAssemble[ { elementMatrix, .. }, matrix ] builds an elementMatrix or a list of elementMatrices into matrix. elementMatrix has to be constructed with imsMakeElementMatrix.";



(* *)
(* Error Messages *)
(* *)

imsAssemble::"range"="The imsElementMatrix is trying to access a position not defined in matrix.";



Begin["`Private`"];



(* *)
(* implementation part *)
(* *)

(* constructor *)

imsMakeElementMatrix[ values_?MatrixQ, rowPos_List, columnPos_List ]:= 
    imsElementMatrix[ values, rowPos, columnPos ];

(* Attributes *)
SetAttributes[ imsAssemble, HoldRest ];



(* private imports *)
<<Developer`



(* *)
(* define your options *)
(* *)



(* selector *)

imsGetElementMatrixValues[ 
      imsElementMatrix[ values_, rowPos_, columnPos_ ] ] := values;
imsGetElementMatrixRows[  imsElementMatrix[ values_, rowPos_, columnPos_ ] ] := 
    rowPos;
imsGetElementMatrixColumns[  
      imsElementMatrix[ values_, rowPos_, columnPos_ ] ] := columnPos;



(* predicates *)

imsElementMatrix /: 
    imsElementMatrixQ[ imsElementMatrix[ values_, rowPos_, columnPos_ ] ] := 
    True;
imsElementMatrixQ[ _ ] := False;



(* private functions *)

(* private functions *)
SetAttributes[ convertToInci, Listable ]
SetAttributes[ convertToVal, Listable ]
convertToInci[ imsElementMatrix[ ma_, r_, c_ ] ] := Outer[ List, r, c ];
convertToVal[ imsElementMatrix[ ma_, r_, c_ ] ] := ma;

(* functions *)
imsAssemble[ {},matrix_]/;MatrixQ[matrix]:= matrix;

(* for Version 6 and higher *)

imsAssemble[allElements_,
        matrix_]/;(MatrixQ[matrix] && 
          Head[ allElements ] === List && $VersionNumber >= 6.0):=Block[
      { incidents, vals },
      
      Developer`SetSystemOptions[
        "SparseArrayOptions"\[Rule]{"TreatRepeatedEntries"\[Rule]1}];
      
      incidents=ToPackedArray[ Flatten[convertToInci[allElements],2 ] ];
      vals = Flatten[ convertToVal[allElements] ];
      
      matrix += SparseArray[ incidents \[Rule]  vals,Dimensions[matrix] ];
      
      Developer`SetSystemOptions[
        "SparseArrayOptions"\[Rule]{"TreatRepeatedEntries"\[Rule]0}];
      
      ];

imsAssemble[allElements_,
        matrix_]/;(MatrixQ[matrix] && Head[ allElements ] === List):=Module[
      {incidents,len, vals, addedVals, orderedList },
      
      (* Print["entry: ",  MemoryInUse[] / 1024.^2, " ", 
            MaxMemoryUsed[] / 1024.^2 ]; *)
      
      (* get origianl incidents *)
      (*Print[ " Get INCI ",Timing[ *)
    
        incidents=ToPackedArray[ Flatten[convertToInci[allElements],2 ] ];
      (* ], " ", MemoryInUse[] / 1024.^2, " ", 
            MaxMemoryUsed[] / 1024.^2 ]; *)
      
      (* store and order incidents, 
        split them into chunks of same incidents *)
      (* 
        build a new incidents list with duplicates removed and store the \
length *)
      (* of the chunks *)
      (* Print[ " Split ",Timing[ *)
     
       incidents = 
        ToPackedArray[ 
          Split[ incidents[[ orderedList = Ordering[ incidents ] ]] ] ];
      (* ], " ", MemoryInUse[] / 1024.^2, " ", 
            MaxMemoryUsed[] / 1024.^2 ]; *)
      
      
      (* retrieve the matrix values *)
      (* Print[ " vals ",Timing[ *)
   
         vals = Flatten[ convertToVal[allElements] ][[ orderedList ]];
      (* ], " ", MemoryInUse[] / 1024.^2, " ", 
            MaxMemoryUsed[] / 1024.^2 ]; *)
      
      
      (* add the values according to the length of the chunks *)
      (* 
        Print[ " addVals ",Timing[ *)
      
      addedVals  =  ( Plus @@ Take[ vals, # ] )& /@ 
          Drop[ Transpose[ { #, RotateLeft[ # ]-1 }&  [ 
                FoldList[  Plus, 1, Length /@ incidents ] ] ], -1 ];
      (* ], " ", MemoryInUse[] / 1024.^2, " ", 
            MaxMemoryUsed[] / 1024.^2 ]; *)
      
      (* create the sparse array *)
      
      (* Print[ " SPA ",Timing[ *)
      
      matrix += SparseArray[ 
          ToPackedArray[ incidents[[ All, 1 ]] ] \[Rule]  addedVals,
          Dimensions[matrix]];
      (* ], " ", MemoryInUse[] / 1024.^2, " ", 
            MaxMemoryUsed[] / 1024.^2 ]; *)
      
      (* clean up *)
      (* Print[ " Clean Up ",Timing[ *)
      
      Remove["Imtek`Assembler`Private`incidents*", 
        "Imtek`Assembler`Private`vals*", "Imtek`Assembler`Private`addedVals*",
        "Imtek`Assembler`Private`len*", 
        "Imtek`Assembler`Private`orderedList*"];
      (* ], " ", MemoryInUse[] / 1024.^2, " ", 
            MaxMemoryUsed[] / 1024.^2 ]; *)
      
      ];


(* bracking the law of _not_ using constuctor and selector *)

imsAssemble[ imsElementMatrix[ valueMatrix_, rowList_, colList_ ], 
    matrix_ ] := 
  If[ (* Error checking *)
      
      Max[ rowList ] > Length[ matrix ] || 
        Max[ colList ] > Length[ First[ matrix ] ], 
      Message[ imsAssemble::"range" ]; Return[],
      matrix[[ rowList, colList ]] += valueMatrix;
      ]/; MatrixQ[ matrix ]


(* old
      imsAssemble[ a_, matrix_ ] := Module[
        { rowList = imsGetElementMatrixRows[ a ],
          colList = imsGetElementMatrixColumns[ a ],
          valueMatrix = imsGetElementMatrixValues[ a ],
          lenRow = Length[ imsGetElementMatrixRows[ a ] ],
          lenCol = Length[ imsGetElementMatrixColumns[ a ] ],
          i=1, j=1, rows = 0, cols = 0
           },
        
        (* Error checking *)
        {rows, cols } = Dimensions[ matrix ];
        If[ Max[ rowList ] > rows || Max[ colList ] > cols, 
          Message[ imsAssemble::"range" ]; Return[] ];
        
        (* fast *)
        matrix[[ rowList, colList ]] += valueMatrix;
        
        (*
          (* slow *)
          Do[
              
              matrix[[ rowList[[ i ]], colList[[ j ]] ]] += 
                valueMatrix[[ i, j ]],
              { i, lenRow }, {j ,lenCol }
              ];
          *)
        
        ] /; imsElementMatrixQ[ a ] && MatrixQ[ matrix ]
  *)




End[] (* of Begin Private *)



(* Protect[] (* anything *) *)
EndPackage[] 