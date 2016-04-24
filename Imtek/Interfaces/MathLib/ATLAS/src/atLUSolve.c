#include <stdio.h>
#include <stdlib.h>
#include <mathlink.h>
#include <cblas.h>
#include <clapack.h>
#include "config.h"

#define MAX(a,b) (a>b)?a:b
#define MIN(a,b) (a<b)?a:b

extern int
clapack_dgetrf(const enum CBLAS_ORDER Order, const int M, const int N,
                   double *A, const int lda, int *ipiv);

extern int 
clapack_dgetrs (const enum CBLAS_ORDER Order, const enum CBLAS_TRANSPOSE Trans,
    const int N, const int NRHS, const double *A, const int lda,
    const int *ipiv, double *B, const int ldb);

void
atLUSolve( void ) {

    int m, n, ldA, ldB, *ipiv, info;
    double *A, *B;
    char **headsA, **headsB;
    long *dimsA, *dimsB, depthA, depthB;
    long returnDimsMatrixA[] = { 0, 0 };
    long returnDimsMatrixB[] = { 0, 0 };
    long returnDimsIpiv[] = { 0 };
   
    MLGetRealArray(stdlink, &A, &dimsA, &headsA, &depthA);
    MLGetRealArray(stdlink, &B, &dimsB, &headsB, &depthB);
    
    
    // how big is the original matrix A
    returnDimsMatrixA[0] = dimsA[0];
    returnDimsMatrixA[1] = dimsA[1];
    // size of B 
    returnDimsMatrixB[0] = dimsB[0];
    returnDimsMatrixB[1] = dimsB[1];

    returnDimsIpiv[0] = MIN(dimsA[0], dimsA[1]);

    // - do what thou wilt - with the matrix
    m = (int ) dimsA[0];
    n = (int ) dimsA[1];
    ldA = (int ) MAX((long ) 1, dimsA[0]);
    ldB = (int ) MAX((long ) 1, dimsB[0]);
    ipiv = (int *) \
	 calloc( (size_t) MIN(dimsA[0], dimsA[1]), sizeof(int) );
    info = (int ) 0;   

    clapack_dgetrf(CblasRowMajor, m, n, A, ldA, ipiv);
    clapack_dgetrs(CblasRowMajor, CblasNoTrans, m, dimsB[1], \
					    A, ldA, ipiv, B, ldB);

    // if (info == 0) /* success */
    //MLPutFunction(stdlink, "List", 3);
	//MLPutRealArray(stdlink, A, returnDimsMatrixA , NULL, 2);	
	//MLPutIntegerArray(stdlink, ipiv , returnDimsIpiv , NULL, 1);	
	MLPutRealArray(stdlink, B, returnDimsMatrixB , NULL, 2);	

    // clean up
    MLDisownRealArray(stdlink, A, dimsA, headsA, depthA);
    MLDisownRealArray(stdlink, B, dimsB, headsB, depthB);
    free(ipiv);
    return;
}

int
main(int argc, char *argv[]) {
    return MLMain(argc, argv);
}
