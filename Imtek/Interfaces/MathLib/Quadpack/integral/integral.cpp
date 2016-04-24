//#include <fstream>

#include <mathlink.h>
#include <string>
#include <time.h>
#include <math.h>

using namespace std;

//ofstream out("log.txt");

string s;
bool global_error;

extern "C"{

int dqags_(double (*f)(double*), double *a, double *b, double *espabs, double *epsrel, double *result, double *abserr, int *neval, int *ier, int *limit, int *lenw, int *last, int *iwork, double *work);
	
double f(double *x)
{
	if (global_error)
		return 0.;
	else
	{
//	out << "x " << *x << endl;
	MLPutFunction(stdlink, "EvaluatePacket", 1);
	MLPutFunction(stdlink, s.c_str(), 1);
  MLPutReal(stdlink, *x);
  MLEndPacket(stdlink);
  long n; //number of arguments
  MLCheckFunction(stdlink, "ReturnPacket", &n);
//  out << "number of arguments is " << n << endl;
  double res;
  int ret = MLGetReal(stdlink, &res);
//  out << "return is " << ret << endl;
//  out << "res is " << res << endl;
  if (ret != 1 )  {global_error = true; res = 0;}
  return res;
  }
}

void integral(char *str, long len, double a, double b, double epsabs, double epsrel) 
{
//	out << str << endl;
//	out << len << endl;
//	out << a << endl;
//	out << b << endl;
/* 
	len value is strange - it may be a size of the whole string buffer
	but we do not need it anyway
*/
	s = str;
//	out << s << endl;
	double res;
	double abserr;
	int neval;
	int ier;
	int iwork[100];
	double work[400];
	int limit = 100;
	int lenw = limit*4;
	int last;
	global_error = false;
	dqags_(&f, &a, &b, &epsabs, &epsrel, &res, &abserr, &neval, &ier, &limit, &lenw, &last, iwork, work);
	if (global_error)
	{
//		out << "error" << endl;
		MLClearError(stdlink);
		MLNewPacket(stdlink);
		res = HUGE_VAL;
		ier = 7;
	}
  MLPutFunction(stdlink, "List", 5);
  MLPutReal(stdlink, res);
  MLPutReal(stdlink, abserr);
  MLPutInteger(stdlink, neval);
  MLPutInteger(stdlink, ier);
  MLPutInteger(stdlink, last);
}

double fExp(double *x)
{
	return exp(-*x**x);
}

void integralExp(double a, double b, double epsabs, double epsrel) 
{
	double res;
	double abserr;
	int neval;
	int ier;
	int iwork[100];
	double work[400];
	int limit = 100;
	int lenw = limit*4;
	int last;
	dqags_(&fExp, &a, &b, &epsabs, &epsrel, &res, &abserr, &neval, &ier, &limit, &lenw, &last, iwork, work);
  MLPutFunction(stdlink, "List", 5);
  MLPutReal(stdlink, res);
  MLPutReal(stdlink, abserr);
  MLPutInteger(stdlink, neval);
  MLPutInteger(stdlink, ier);
  MLPutInteger(stdlink, last);
}

void testCall()
{
	MLPutFunction(stdlink, "EvaluatePacket", 1);
  MLPutReal(stdlink, 2.5);
  MLEndPacket(stdlink);
  long n; //number of arguments
  MLCheckFunction(stdlink, "ReturnPacket", &n);
  double res;
  MLGetReal(stdlink, &res);
}


double functionCall(int n)
{
	clock_t c1 = clock();
	for (int i = 0; i < n; ++i)
		testCall();
	return double(clock() - c1)/CLK_TCK;	
}
}

