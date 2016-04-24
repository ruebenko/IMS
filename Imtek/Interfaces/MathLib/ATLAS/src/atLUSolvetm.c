/*
 * This file automatically produced by mprep from:
 *	atLUSolve.tm
 * mprep Revision 10 Copyright (c) Wolfram Research, Inc. 1990-2001
 */

#define MPREP_REVISION 10


int MLAbort = 0;
int MLDone  = 0;
long MLSpecialCharacter = '\0';

#include "mathlink.h"
MLINK stdlink = 0;
MLEnvironment stdenv = 0;
MLYieldFunctionObject stdyielder = 0;
MLMessageHandlerObject stdhandler = 0;

/********************************* end header *********************************/


void atLUSolve P(( void));

#if MLPROTOTYPES
static int _tr0( MLINK mlp)
#else
static int _tr0(mlp) MLINK mlp;
#endif
{
	int	res = 0;
	if( !mlp) return res; /* avoid unused parameter warning */

	atLUSolve();

	res = 1;

	return res;
} /* _tr0 */


static struct func {
	int   f_nargs;
	int   manual;
	int   (*f_func)P((MLINK));
	char  *f_name;
	} _tramps[1] = {
		{ 0, 2, _tr0, "atLUSolve" }
		};

#define CARDOF_EVALSTRS 0

static int _definepattern P(( MLINK, char*, char*, int));

int  _MLDoCallPacket P(( MLINK, struct func[], int));


#if MLPROTOTYPES
int MLInstall( MLINK mlp)
#else
int MLInstall(mlp) MLINK mlp;
#endif
{
	int _res;
	_res = MLConnect(mlp);
	if (_res) _res = _definepattern(mlp, "atLUSolve[ A:{ {__Real} ... }, B:{ {__Real} ... } ]", "{ A, B }", 0);
	if (_res) _res = MLPutSymbol( mlp, "End");
	if (_res) _res = MLFlush( mlp);
	return _res;
} /* MLInstall */


#if MLPROTOTYPES
int MLDoCallPacket( MLINK mlp)
#else
int MLDoCallPacket( mlp) MLINK mlp;
#endif
{
	return _MLDoCallPacket( mlp, _tramps, 1);
} /* MLDoCallPacket */

/******************************* begin trailer ********************************/

#ifndef EVALSTRS_AS_BYTESTRINGS
#	define EVALSTRS_AS_BYTESTRINGS 1
#endif


#if CARDOF_EVALSTRS
#if MLPROTOTYPES
static int  _doevalstr( MLINK mlp, int n)
#else
static int  _doevalstr( mlp, n)
	 MLINK mlp; int n;
#endif
{
	long bytesleft, charsleft, bytesnow;
#if !EVALSTRS_AS_BYTESTRINGS
	long charsnow;
#endif
	char **s, **p;
	char *t;

	s = evalstrs;
	while( n-- > 0){
		if( *s == 0) break;
		while( *s++ != 0){}
	}
	if( *s == 0) return 0;
	bytesleft = 0;
	charsleft = 0;
	p = s;
	while( *p){
		t = *p; while( *t) ++t;
		bytesnow = t - *p;
		bytesleft += bytesnow;
		charsleft += bytesnow;
#if !EVALSTRS_AS_BYTESTRINGS
		t = *p;
		charsleft -= MLCharacterOffset( &t, t + bytesnow, bytesnow);
		/* assert( t == *p + bytesnow); */
#endif
		++p;
	}


	MLPutNext( mlp, MLTKSTR);
#if EVALSTRS_AS_BYTESTRINGS
	p = s;
	while( *p){
		t = *p; while( *t) ++t;
		bytesnow = t - *p;
		bytesleft -= bytesnow;
		MLPut8BitCharacters( mlp, bytesleft, (unsigned char*)*p, bytesnow);
		++p;
	}
#else
	MLPut7BitCount( mlp, charsleft, bytesleft);
	p = s;
	while( *p){
		t = *p; while( *t) ++t;
		bytesnow = t - *p;
		bytesleft -= bytesnow;
		t = *p;
		charsnow = bytesnow - MLCharacterOffset( &t, t + bytesnow, bytesnow);
		/* assert( t == *p + bytesnow); */
		charsleft -= charsnow;
		MLPut7BitCharacters(  mlp, charsleft, *p, bytesnow, charsnow);
		++p;
	}
#endif
	return MLError( mlp) == MLEOK;
}
#endif /* CARDOF_EVALSTRS */


#if MLPROTOTYPES
static int  _definepattern( MLINK mlp, char *patt, char *args, int func_n)
#else
static int  _definepattern( mlp, patt, args, func_n)
	MLINK  mlp;
	char  *patt, *args;
	int    func_n;
#endif
{
	MLPutFunction( mlp, "DefineExternal", (long)3);
	  MLPutString( mlp, patt);
	  MLPutString( mlp, args);
	  MLPutInteger( mlp, func_n);
	return !MLError(mlp);
} /* _definepattern */


#if MLPROTOTYPES
int _MLDoCallPacket( MLINK mlp, struct func functable[], int nfuncs)
#else
int _MLDoCallPacket( mlp, functable, nfuncs)
	MLINK mlp;
	struct func functable[];
	int nfuncs;
#endif
{
	long len;
	int n, res = 0;
	struct func* funcp;

	if( ! MLGetInteger( mlp, &n) ||  n < 0 ||  n >= nfuncs) goto L0;
	funcp = &functable[n];

	if( funcp->f_nargs >= 0
	&& ( ! MLCheckFunction(mlp, "List", &len)
	     || ( !funcp->manual && (len != funcp->f_nargs))
	     || (  funcp->manual && (len <  funcp->f_nargs))
	   )
	) goto L0;

	stdlink = mlp;
	res = (*funcp->f_func)( mlp);

L0:	if( res == 0)
		res = MLClearError( mlp) && MLPutSymbol( mlp, "$Failed");
	return res && MLEndPacket( mlp) && MLNewPacket( mlp);
} /* _MLDoCallPacket */


#if MLPROTOTYPES
mlapi_packet MLAnswer( MLINK mlp)
#else
mlapi_packet MLAnswer( mlp)
	MLINK mlp;
#endif
{
	mlapi_packet pkt = 0;

	while( !MLDone && !MLError(mlp) && (pkt = MLNextPacket(mlp), pkt) && pkt == CALLPKT){
		MLAbort = 0;
		if( !MLDoCallPacket(mlp)) pkt = 0;
	}
	MLAbort = 0;
	return pkt;
} /* MLAnswer */



/*
	Module[ { me = $ParentLink},
		$ParentLink = contents of RESUMEPKT;
		Message[ MessageName[$ParentLink, "notfe"], me];
		me]
*/

#if MLPROTOTYPES
static int refuse_to_be_a_frontend( MLINK mlp)
#else
static int refuse_to_be_a_frontend( mlp)
	MLINK mlp;
#endif
{
	int pkt;

	MLPutFunction( mlp, "EvaluatePacket", 1);
	  MLPutFunction( mlp, "Module", 2);
	    MLPutFunction( mlp, "List", 1);
		  MLPutFunction( mlp, "Set", 2);
		    MLPutSymbol( mlp, "me");
	        MLPutSymbol( mlp, "$ParentLink");
	  MLPutFunction( mlp, "CompoundExpression", 3);
	    MLPutFunction( mlp, "Set", 2);
	      MLPutSymbol( mlp, "$ParentLink");
	      MLTransferExpression( mlp, mlp);
	    MLPutFunction( mlp, "Message", 2);
	      MLPutFunction( mlp, "MessageName", 2);
	        MLPutSymbol( mlp, "$ParentLink");
	        MLPutString( mlp, "notfe");
	      MLPutSymbol( mlp, "me");
	    MLPutSymbol( mlp, "me");
	MLEndPacket( mlp);

	while( (pkt = MLNextPacket( mlp), pkt) && pkt != SUSPENDPKT)
		MLNewPacket( mlp);
	MLNewPacket( mlp);
	return MLError( mlp) == MLEOK;
}


#if MLPROTOTYPES
int MLEvaluate( MLINK mlp, charp_ct s)
#else
int MLEvaluate( mlp, s)
	MLINK mlp;
	charp_ct s;
#endif
{
	if( MLAbort) return 0;
	return MLPutFunction( mlp, "EvaluatePacket", 1L)
		&& MLPutFunction( mlp, "ToExpression", 1L)
		&& MLPutString( mlp, s)
		&& MLEndPacket( mlp);
} /* MLEvaluate */


#if MLPROTOTYPES
int MLEvaluateString( MLINK mlp, charp_ct s)
#else
int MLEvaluateString( mlp, s)
	MLINK mlp;
	charp_ct s;
#endif
{
	int pkt;
	if( MLAbort) return 0;
	if( MLEvaluate( mlp, s)){
		while( (pkt = MLAnswer( mlp), pkt) && pkt != RETURNPKT)
			MLNewPacket( mlp);
		MLNewPacket( mlp);
	}
	return MLError( mlp) == MLEOK;
} /* MLEvaluateString */


#if MLPROTOTYPES
void MLDefaultHandler( MLINK mlp, unsigned long message, unsigned long n)
#else
void MLDefaultHandler( mlp, message, n)
	MLINK mlp;
	unsigned long message, n;
#endif
{
	switch (message){
	case MLTerminateMessage:
		MLDone = 1;
	case MLInterruptMessage:
	case MLAbortMessage:
		MLAbort = 1;
	default:
		return;
	}
}

#if MLPROTOTYPES
static int _MLMain( charpp_ct argv, charpp_ct argv_end, charp_ct commandline)
#else
static int _MLMain( argv, argv_end, commandline)
  charpp_ct argv, argv_end;
  charp_ct commandline;
#endif
{
	MLINK mlp;
	long err;

	if( !stdenv)
		stdenv = MLInitialize( (MLParametersPointer)0);
	if( stdenv == (MLEnvironment)0) goto R0;

	if( !stdhandler)
		stdhandler = MLCreateMessageHandler( stdenv, MLDefaultHandler, 0);


	mlp = commandline
		? MLOpenString( stdenv, commandline, &err)
		: MLOpenArgv( stdenv, argv, argv_end, &err);
	if( mlp == (MLINK)0){
		MLAlert( stdenv, MLErrorString( stdenv, err));
		goto R1;
	}

	if( stdyielder) MLSetYieldFunction( mlp, stdyielder);
	if( stdhandler) MLSetMessageHandler( mlp, stdhandler);

	if( MLInstall( mlp))
		while( MLAnswer( mlp) == RESUMEPKT){
			if( ! refuse_to_be_a_frontend( mlp)) break;
		}

	MLClose( mlp);
R1:	MLDeinitialize( stdenv);
	stdenv = (MLEnvironment)0;
R0:	return !MLDone;
} /* _MLMain */


#if MLPROTOTYPES
int MLMainString( charp_ct commandline)
#else
int MLMainString( commandline)  charp_ct commandline;
#endif
{
	return _MLMain( (charpp_ct)0, (charpp_ct)0, commandline);
}

#if MLPROTOTYPES
int MLMainArgv( char** argv, char** argv_end) /* note not FAR pointers */
#else
int MLMainArgv( argv, argv_end)  char **argv, **argv_end;
#endif
{   
	static char FAR * far_argv[128];
	int count = 0;
	
	while(argv < argv_end)
		far_argv[count++] = *argv++;
		 
	return _MLMain( far_argv, far_argv + count, (charp_ct)0);

}

#if MLPROTOTYPES
int MLMain( int argc, charpp_ct argv)
#else
int MLMain( argc, argv) int argc; charpp_ct argv;
#endif
{
 	return _MLMain( argv, argv + argc, (charp_ct)0);
}
 
