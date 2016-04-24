(* *)
(* Title: PackageTemplate.m *)
(* Context: *)
(* Author: Jan Korvink and Oliver Ruebenkoenig *)
(* Summary: This is the IMTEK template for writing a mathematica packages *)
(* Package Copyright: GNU GPL *)
(* Package Version: 0.1 *)
(* Mathematica Version: 4.1 *)
(* History: *)
(* Keywords: *)
(* Sources: noner *)
(* Warnings: *)
(* Limitations: no checking is done wheather a file in MIFToFile exisis! *)
(* Discussion: *)
(* Requirements: *)
(* Examples: *)
(* *)

(* *)
BeginPackage["Miffer`"];

(* *)
(* documentation for functions in package go here *)
(* *)

MIFForm::usage="MIFForm[expr] takes an expression and convertrs it to MIF form.";


MIFToFile::usage="MIFToFile[expr, file] writes expr to file.";

(*package error message*)
Miffer::"Error type: badarg"="Check you arguments please. You called `1` with
argument `2`!";

(* end documentation *)


(* *)
(* define your options *)
(* *)


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

(* *)
(* functions contained in package start here*)
(* *)
	
MIFForm[expr_]:=Block[{
      form,Integrate, tostring,
      Times:=times,
      Plus:=plus,
      Equal:=equal,
      Power:=power,
      Rational:=over,
      DifferentialD:=diff
      },
    
    Integrate[ f_,List[x_,a_,b_] ]:=int [f \[DifferentialD]x,a,b ];
    Integrate[ f_,x_ ]:=int[ f \[DifferentialD]x ];
    
    form[ Hold[x_] ]:=form[x];
    form[ HoldForm[x_] ]:=form[x];
    form[ x_Integer|x_Real ]:=num[ x,"\""<>ToString[x]<>"\"" ];
    form[ x_String ]:=string["\""<>ToString[x]<>"\""];
    form[ a_Symbol ]:=char[
        With[{
            s=StringReplace[ SymbolName[a],{"\\["\[Rule]"","]"\[Rule]""} ]
            },
          If[
            StringMatchQ[ s,"Capital*" ],
            StringReplace[ s,"Capital"\[Rule]"" ],
            If[ StringLength[s]>1,ToLowerCase[s],s ] ]
          ]
        ];
    form[ x_?MatrixQ ]:=matrix@@Join[ Dimensions[x],form /@ Flatten[x] ];
    form[ x_List ]:=atop@@(form /@ x);
    form[ f_[x__] ]:=f@@form/@{x};
    
    tostring[ f_[x_,y___] ]:=SymbolName[f]<>"["<>tostring[x]<>Map[","<>tostring[#]&,{y}]<>"]";
    tostring[ x_ ]:=ToString[x];
    tostring[ form[expr] ]
    ]

(* no checking done - any ideas ? *)

MIFToFile[expr_,filename_String]:=StringToFile["<MIFFile 5.00>\n<Math\n  <MathFullForm `"<>MIFForm[expr]<>"'>\n  <MathOrigin 10.0 cm 10.0 cm>\n>\n", filename]


(* package internal stuff *)

StringToFile[ string_String, filename_String ]:=Module[{
      stream=OpenWrite[filename]
      },
    WriteString[ stream, string ];
    Close[ stream ]
    ]


End[] (* of Begin Private *)

(* Protect[] (* anything *) *)

EndPackage[]
