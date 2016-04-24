#include <stdio.h>
#include <mathlink.h>
#include "config.h"

void
maToMa( void ) {

    double *originalMatrix;
    char **heads;
    long *dims, depth;
    //long  numberOfRows, numberOfColumns;
    long returnDimsMatrix[] = {0,0};

    MLGetRealArray(stdlink, &originalMatrix, &dims, &heads, &depth);
    
    
    //numberOfRows = dims[1];
    //numberOfColumns = dims[2];
    returnDimsMatrix[0] = dims[1]; //numberOfRows;
    returnDimsMatrix[1] = dims[2]; //numberOfColumns;

    MLPutRealArray(stdlink, originalMatrix, returnDimsMatrix , NULL, 2);	
    
    // clean up
    MLDisownRealArray(stdlink, originalMatrix, dims, heads, depth);
    return;
}

int
main(int argc, char *argv[]) {
    return MLMain(argc, argv);
}
