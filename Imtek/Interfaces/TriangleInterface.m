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
(* Title: TriangleMeshInterface.m *)
(* Context: *)
(* 
  Author:oliver ruebenkoenig *)
(* Date: 9.11.2005, Freiburg *)
(* 
  Summary: This is the IMTEK package for generating Triangle input files *)
(* 
  Package Copyright: GNU GPL *)
(* Package Version: 0.1.3 *)
(* 
  Mathematica Version: 5.2 *)
(* History:
    added possibility for loacal refinement;
  changed the file name inpuut for imsReadTri, 
  so that version prior to 5.1 can use it
    input format correction
   *)
(* Keywords: *)
(* Sources: Triangle is a mesh generator *)
(* 
  Warnings: *)
(* Limitations: *)
(* Discussion: *)
(* Requirements: *)
(* 
  Examples: *)
(* *)



(* Disclaimer *)

(* Whereever the GNU GPL is not applicable, 
  the software should be used in the same spirit. *)

(* Users of this code must verify correctness for their application. *)

(* Free Software Foundation,Inc.,59 Temple Place,Suite 330,Boston,
  MA 02111-1307 USA *)

(* Disclaimer: *)

(* This is the IMTEK package for generating Triangle input files. *)

(* Copyright (C) 2005 oliver ruebenkoenig *)

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

BeginPackage[
    "Imtek`Interfaces`TriangleInterface`", { "Imtek`Graph`", "Imtek`Nodes`",
      "Imtek`DomainElementLibrary`", "Imtek`MeshElementLibrary`" } ];





(* *)
(* documentation *)
(* *)

(* constructors *)

(* selectors *)

(* predicates *)

(* functions *)

imsToTriangleInputFile::usage = \
"imsToTriangleInputFile[ domain, {holePoints}, {markerPoints} ] returns an input file for triangle. Domain is a nexus. Optionally a list of hole points {x,y} and a list of marker points { { x, y }, marker, refinement } can be given, where refinement is optional.";\


imsReadTriangleOutput::usage = "imsReadTriangleOutput[file, boundaryFunction, boundaryData ] returns a nexus generated from triangle output file. The file can either be a *.poly file or a list of { *.node, *.ele } files. Optionally boundaryFunction[id, x, y, marker] and boundaryData[id, x, y, marker] can be given.";



(* *)
(* options docu *)
(* *)



(* *)
(* error messages *)
(* *)



Begin["`Private`"];



(* *)
(* private imports *)
(* *)



(* *)
(* implementation part *)
(* *)

(* constructor *)
(* *)



(* *)
(* define your options *)
(* *)



(* selector *)
(* *)



(* predicates *)
(* *)



(* private functions *)
(* *)

(* public functions *)
(* *)

imsToTriangleInputFile[ nexus_, pointsMarkingHoles_:{{}}, 
      pointsMarkingDomains_:{{}}  ] := 
    Module[ { nodes, numberOfNodes, firstLine, nodeLines,segments, 
        numberOfSegments, firstSegmentLine, segmentLines, numberOfHoles, 
        holePoints, numberOfDomains, domainPoints, i },
      
      nodes = imsGetNodes[ nexus ];
      numberOfNodes  = Length[ nodes ];
      segments = imsGetElements[ nexus ];
      numberOfSegments = Length[ segments ];
      
      firstLine = { { numberOfNodes, 2, 0, 1 } };
      nodeLines = 
        Flatten[{ imsGetIds[ # ], imsGetCoords[ # ], 
                imsGetMarkers[ # ] } ] &  /@ nodes;
      
      firstSegmentLine = { { numberOfSegments, 1 } };
      
      segmentLines = 
        Flatten[ { imsGetIds[ # ], imsGetIncidentsIds[ # ], 
                imsGetMarkers[ # ] } ] & /@ segments ;
      
      If[
        MatchQ[ pointsMarkingHoles, {{ _,_ }..} ],
        numberOfHoles = {{ Length[ pointsMarkingHoles ] }};
        i=1;
        holePoints = Flatten[ { i++, # } ]& /@ pointsMarkingHoles
        ,
        numberOfHoles = {{ 0 }};
        (* the empty sting is workaround for maVer5.0*)
        
        holePoints = {{" "}}
        ];
      
      If[
        MatchQ[ pointsMarkingDomains, { { { _,_ }, __ }..} ],
        numberOfDomains = {{ Length[ pointsMarkingDomains ] }};
        i=1;
        domainPoints = Flatten[ { i++, # } ]& /@ pointsMarkingDomains,
        numberOfDomains = {{ 0 }};
        domainPoints = {{" "}}
        ];
      
      Return[ 
        Join[ firstLine, nodeLines, firstSegmentLine, segmentLines, 
          numberOfHoles, holePoints, numberOfDomains, domainPoints ] ];
      ];

imsReadTriangleOutput[ fileName_, 
    boundaryFunction_:Function[ { id, x, y, marker }, {{ 0 }} ], 
    boundaryData_:Null ] := 
  imsReadTriangleOutput[ { (* 
        generate the correct file names for .node and .ele *)
      
      StringJoin[ 
        Join[ { DirectoryName[ fileName ] },
          StringJoin[ #, "." ]& /@ 
            Drop[ StringSplit[ 
                StringReplace[ fileName, 
                  DirectoryName[ fileName ] \[Rule] "" ],
                "." ],-1  ], {"node"} ]  ],
      StringJoin[ 
        Join[ { DirectoryName[ fileName ] },
          StringJoin[ #, "." ]& /@ 
            Drop[ StringSplit[ 
                StringReplace[ fileName, 
                  DirectoryName[ fileName ] \[Rule] "" ],
                "." ],-1  ], {"ele"} ]  ]
       }, boundaryFunction, boundaryData ]

imsReadTriangleOutput[ { nodeFileName_, elementFileName_ }, 
      boundaryFunction_:Function[ { id, x, y, marker }, {{ 0 }} ], 
      boundaryData_:Null ] := Module[
      {
        rawNodes, rawElements,
        numberOfElements, orderOfElement, boolMarker,
        elementType, elementIdPattern, elementIds,elementMarkerPattern, 
        elementMarkers,boolElementMarker,
        elementParsePattern,  elementParseAccess,
        interiorNodes, boundaryNodes, elements
        },
      
      (* generate the correct file names for .node and .ele *)
      (* 
        nodeFileName = 
          StringJoin[ 
            Join[ { DirectoryName[ fileName ] },
              StringJoin[ #, "." ]& /@ 
                Drop[ StringSplit[ 
                    StringReplace[ fileName, 
                      DirectoryName[ fileName ] \[Rule] "" ],
                    "." ],-1  ], {"node"} ]  ];
        elementFileName = 
          StringJoin[ 
            Join[ { DirectoryName[ fileName ] },
              StringJoin[ #, "." ]& /@ 
                Drop[ StringSplit[ 
                    StringReplace[ fileName, 
                      DirectoryName[ fileName ] \[Rule] "" ],
                    "." ],-1  ], {"ele"} ]  ];
        *)
      
      (* read the data *)
      rawNodes = Import[ nodeFileName, "Table" ];
      rawElements = Import[ elementFileName, "Table" ];
      
      interiorNodes = 
        Select[ Take[ rawNodes, {2, -2 } ], ( Last[ # ] == 0& ) ] /. { 
              id_Integer, xCoord_, yCoord_, nodeMarker_ } \[Rule] 
            imsMakeNode[ id, { xCoord, yCoord }  ];
      
      Which[
        boundaryData =!= Null,
        boundaryNodes = 
          Select[ Take[ rawNodes, {2, -2 } ], ( Last[ # ] != 0& ) ] /.{ 
                id_Integer, xCoord_, yCoord_, nodeMarker_ } :>
              imsMakeNode[ id, { xCoord, yCoord }, nodeMarker, 
                boundaryFunction[ id, xCoord, yCoord, nodeMarker ], 
                boundaryData[ id, xCoord, yCoord, nodeMarker ] ],
        boundaryData === Null,
        boundaryNodes = 
          Select[ Take[ rawNodes, {2, -2 } ], ( Last[ # ] != 0& ) ] /.{ 
                id_Integer, xCoord_, yCoord_, nodeMarker_ } :>
              imsMakeNode[ id, { xCoord, yCoord }, nodeMarker, 
                boundaryFunction[ id, xCoord, yCoord, nodeMarker ] ]
        ];
      
      { numberOfElements, orderOfElement, boolElementMarker } = 
        First[ rawElements ];
      
      Which[
        orderOfElement \[Equal] 3,
        elementType = imsMakeTriangleLinear1DOF;
        elementIdPattern = { id1_, id2_, id3_ };
        elementIds = { id1, id2, id3 }
        ,
        
        orderOfElement \[Equal] 6,
        elementType = imsMakeTriangleQuadratic1DOFSerendipity; 
        elementIdPattern = { id1_, id2_, id3_, id4_, id5_ ,id6_ }; 
        elementIds = { id1, id2, id3, id6 ,id4, id5 }
        ,
        
        True, Print["Element Order: ", orderOfElement, " not supported."];
        ];
      
      Which[
        boolElementMarker \[Equal] 0,
        elementMarkerPattern = {};
        elementMarkers = Sequence[]
        ,
        
        boolElementMarker \[Equal] 1,
        elementMarkerPattern = { marker_ };
        elementMarkers = marker
        ,
        True, Print["Marker: ", boolMarker, " not supported."];
        ];
      
      elementParsePattern = 
        Flatten[ { id_Integer, elementIdPattern, elementMarkerPattern } ];
      elementParseAccess = Sequence[ id, elementIds, elementMarkers ];
      
      elements = 
        Take[ rawElements, { 2, -2 } ] /. 
          elementParsePattern \[Rule] (elementType[ elementParseAccess ]);
      
      Return[ imsMakeNexus[ boundaryNodes, interiorNodes, elements ] ];
      ];



(* representors *)
(* *)



(* Begin Private *)
End[]



(* Protect[] *)
EndPackage[] 