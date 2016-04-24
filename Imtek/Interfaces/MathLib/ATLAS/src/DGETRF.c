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
void
DGETRF( void ) {

    int m, n, ldoriginalMatrix, *ipiv, info;
    double *originalMatrix;
    char **heads;
    long *dims, depth, numberOfRows, numberOfColumns;
    long returnDimsMatrix[] = {0,0};
    long returnDimsIpiv[] = {0};

    MLGetRealArray(stdlink, &originalMatrix, &dims, &heads, &depth);
    
    
    // how big is the original matrix
    // we do not need checking for dims[ > 2 ] since this 
    // is done via a pattern
    numberOfRows = dims[1];  // check this!!!
    numberOfColumns = dims[2];
    returnDimsMatrix[0] = numberOfRows;
    returnDimsMatrix[1] = numberOfColumns;
    returnDimsIpiv[0] = MIN(numberOfRows, numberOfColumns);

    // - do what thou wilt - with the matrix
    m = (int ) numberOfRows;
    n = (int ) numberOfColumns;
    ldoriginalMatrix = (int ) MAX((long ) 1, numberOfRows);
    ipiv = (int *) \
	 calloc( (size_t) MIN(numberOfRows, numberOfColumns), sizeof(int) );
    info = (int ) 0;   

    clapack_dgetrf(CblasRowMajor, m, n, originalMatrix, ldoriginalMatrix, ipiv);

    // if (info == 0) /* success */
    MLPutFunction(stdlink, "List", 2);
	MLPutRealArray(stdlink, originalMatrix, returnDimsMatrix , NULL, 2);	
	MLPutIntegerArray(stdlink, ipiv , returnDimsIpiv , NULL, 1);	
    
    // clean up
    MLDisownRealArray(stdlink, originalMatrix, dims, heads, depth);
    free(ipiv);
    return;
}

int
main(int argc, char *argv[]) {
    return MLMain(argc, argv);
}
