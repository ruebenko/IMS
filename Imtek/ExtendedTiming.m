(* *)
(* Title: ExtendedTiming.m *)
(* Context: *)
(* Author: oliver ruebenkoenig *) 
(* Summary: This is the IMTEK template for writing a mathematica packages *)
(* Package Copyright: GNU GPL *)
(* Package Version: 0.1 *)
(* Mathematica Version: 4.2 *)
(* History: *)
(* Keywords: *)
(* Sources: "programming in mathematica" by R. Maeder *)
(* Warnings: *)
(* Limitations: *)
(* Discussion: *)
(* Requirements: *)
(* Examples: *)
(* *)

(* *)
BeginPackage["Imtek`ExtendedTiming`"];

(* *)
(* documentation for functions in package go here *)
(* *)
Needs["Imtek`Maintenance`"]
imsCreateObsoleteFunctionInterface[ ExtendedTiming, $Context ];
imsCreateObsoleteFunctionInterface[ AveragedTiming, $Context ];


imsExtendedTiming::usage="imsExtendedTiming[ expr ] measures the absolute time needed for evaluating expr. The measurement is based on SessionTime and thus you can measure the time passed for evaluation; even calls to external programs via e.g. MathLink - which is not possible by making use of the Timing[] function. ExtendedTiming has attributes HoldAll.";

imsAveragedTiming::usage="imsAveragedTiming[ expr, n ] computes an average of ExtendedTiming for n iterations. AveragedTiming has attributes HoldAll";

(*package error message*)
(* non - everything is an expression ... *)

(* end documentation *)


(* *)
(* define your options *)
(* *)


(* end define options *)


(* *)
(* create own context : hide local functions and variables *)
(* *)
Begin["`Private`"];

(* *)
(* do we need another package ? *)
(* *)
(* Needs[""]; *)

(* *)
(* default values for MyOption *)
(* *) 
(* Options[NameOfYourFunction1] = {MyOption -> DefaultValue}; *)
Attributes[ imsExtendedTiming ] = HoldAll;
Attributes[ imsAveragedTiming ] = HoldAll;

(* *)
(* functions contained in package start here*)
(* *)
imsExtendedTiming[ expr_ ] := Module[
    { beginT },
    beginT = SessionTime[];
   (* the function should return in the same maner as
    Timing[] , so first the passed SessionTime, then the result *) 
    {ReleaseHold[ expr ],
	SessionTime[] - beginT } /. {x_, y_} :> Return[ {y, x} ]
      ];


imsAveragedTiming[ expr_, iterations_Integer:1 ] := Module[
      { totalTime = 0, averageTime = 0 },
      Do[
        totalTime += First[ imsExtendedTiming[ expr; ] ];
        , { iterations }
        ];
      averageTime = totalTime / iterations;
      Return[ averageTime ];
      ];

End[] (* of Begin Private *)

(* Protect[ imsExtendedTiming ] *)

EndPackage[]
