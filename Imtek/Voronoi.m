(* *)
(* Title : Voronoi.m *)
(* Context : *)
(* Author : oliver ruebenkoenig *)
(* Summary : This is the IMTEK template for writing a mathematica packages *)
(* Package Copyright : GNU GPL *)
(* Package Version : 0.2.1 *)
(* Mathematica Version : 5.2 *)
(* History : *)
(* Keywords : *)
(* Sources :  *)
(* Warnings : *)
(* Limitations : only triangles *)
(* Discussion : *)
(* Requirements : *)
(* Examples : *)
(* *)


(* *)
BeginPackage["Imtek`Voronoi`"];
Needs["Imtek`Maintenance`"]
imsCreateObsoleteFunctionInterface[ VoronoiEdgeLength, $Context ]
imsCreateObsoleteFunctionInterface[ VoronoiEdgeUnitNormal, $Context ]

(*  *)
(* documentation for functions in package go here *)

(* function usage *)

imsVoronoiEdgeLength::usage = 
"imsVoronoiEdgeLength[{pti, ptj, ptk}, {pta}] gives three edge length
{aij, ajk, aki} from mid point of the three lines to the fourth given
point pta.";  

imsVoronoiEdgeUnitNormal::usage = 
"imsVoronoiEdgeUnitNormal[{pti, ptj, ptk}] gives a list containing
three edge normal vectors {nij, njk, nki}
to the Voronoi edge length {aij. ajk, aki}."; 

(* package error message *)
imsVoronoi::"badarg" = "Hello?! - What is this supposed to become?
You called `1` with wrong argument!"

(* end documentation*)
(* *)

(* *)
(* create own context : hide local functions and variables *)
(* *)
Begin["`Private`"];

Needs[ "Imtek`Point`" ];
Needs[ "Imtek`Triangle`"];
Needs[ "Imtek`Polygon`"];

(* *)
(* functions contained in package start here *)
(* *)

imsVoronoiEdgeLength[ { i_ , j_, k_ }, {MP_} ] :=		
  {	
    imsDistance[ { imsBisector[ {i, j} ], MP } ],	
    imsDistance[ { imsBisector[ {j, k} ], MP } ],	
    imsDistance[ { imsBisector[ {k, i} ], MP } ]	
    }/;
	VectorQ[i] && VectorQ[j] && VectorQ[k] && VectorQ[MP] ||
      	Message[imsVoronoi::"badarg", imsVoronoiEdgeLength]


imsVoronoiEdgeUnitNormal[{ {xi_, yi_}, {xj_, yj_}, {xk_, yk_} }] :=
      {
      {xj - xi, yj - yi},
      {xk - xj, yk - yj},
      {xi - xk, yi - yk} 
      }/imsEdgeLength[{ {xi, yi}, {xj, yj}, {xk, yk} }]/;
    NumericQ[xi] && NumericQ[yi] && 
      NumericQ[xj] && NumericQ[yj] && 
      NumericQ[xk] && NumericQ[yk] ||
      Message[imsVoronoi::"badarg", imsVoronoiEdgeUnitNormVec]

End[] (* of Begin Private *)

(* Protect[] *)

EndPackage[]
