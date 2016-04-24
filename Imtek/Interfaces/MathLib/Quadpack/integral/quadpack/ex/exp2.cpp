#include <iostream>
#include <time.h>

using namespace std;

extern "C"{

int dqags_(double (*f)(double*), double *a, double *b, double *espabs, double *epsrel, double *result, double *abserr, int *neval, int *ier, int *limit, int *lenw, int *last, int *iwork, double *work);

double fExp(double *x)
{
	return exp(-*x**x);
}

}

int main(int argc, char *argv[])
{
  if (argc != 2)
  {
    cout << "usage: exp2 n" << endl;
    return 0;
  }
  int n = atoi(argv[1]);
  double a = -1000.;
  double b = 1000.;
  double epsabs = 0.;
  double epsrel = 1e-6;
  double res;
	double abserr;
	int neval;
	int ier;
	int iwork[100];
	double work[400];
	int limit = 100;
	int lenw = limit*4;
	int last;
	clock_t c1 = clock();
	for (int i = 0; i < n; ++i)
		dqags_(&fExp, &a, &b, &epsabs, &epsrel, &res, &abserr, &neval, &ier, &limit, &lenw, &last, iwork, work);
	double time = double(clock() - c1)/CLK_TCK/n;
	cout << "time is " << time << endl;
	cout << "integral is " << res << endl;
	cout << "number of function evaluations is " << neval << endl;
}