/*
Copyright (C) 2003 Evgenii Rudnyi, rudnyi@imtek.de
                                   http://www.imtek.de/simulation

Version of 10.05.2003.

This software is free; you can redistribute it and/or modify it under the 
terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your
option) any later version.  This software is distributed in the hope
that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the GNU General Public License for more details.
http://www.gnu.org/copyleft/gpl.html
*/

/*
  To compile the code you need both Mathlink and Ansys 'bin' libraries. 
  Makefile should work only at Sun's workstations at IMTEK configuration.

  Good news:
    Makefile is an ASCII file. You can modify it.

  Bad news:
		It is not that easy to compile with the Ansys 'bin' library. Good luck.
*/

//#include <fstream>

extern "C"{
#include <mathlink.h>
}

#include <string.h>
#include <time.h>
#include <math.h>
#include <vector>

using namespace std;

//ofstream out("info.txt");

bool file_open = false;
bool elem_ready = false;
bool convert = true;
int nblk = 1;
int reclng;
int intpdp;
int lenfnm;
int rec = 0;
int *buffer;
int *record;
int iout = 6;   // it may be necessary to change it but to what?

extern "C"{

/* 
  The headers for Ansys functions are borrowed from Dennis Weiss 
	(weissd@imtek.de) code. 
  
	He has a nice code to deal with a substructure matrices file. 
*/

int binset_(int *, int *, int *, int *, int *, int *, char *, int *, int *, int *, int);
int biniqr_(int *, int *);
int binclo_(int *, char *, int *, int);
int binini_(int *);
int binrd_(int *, int *, int *, int *, int *, int *);        

void init()
{
  int i0 = 0;
  int i1 = 1;
  reclng = biniqr_(&i0, &i1);
  i1 = 2;
  intpdp = biniqr_(&i0, &i1);
  i1 = 3;
  lenfnm = biniqr_(&i0, &i1);
  binini_(&iout); 
	buffer = new int[reclng];
	record = new int[100000]; // TODO to choose the right size dynamically
}

int doNotConvert(int i)
{
	if (i == 1)
		convert = false;
	else
		convert = true;
	return !convert;
}

int closeAnsysFile()
{
	if(file_open)
	{
    binclo_(&nblk, "KEEP", buffer, 4);
		nblk = 1;
		rec = 0;
		file_open = false;
		elem_ready = false;
		return 0;
	}
	else
		return -1;
}

int openAnsysFile(char *name, long lenname)
{
	if(file_open)
		closeAnsysFile();
	int nunit = 12;
  int keyrw = 1;
	int lbuf = 1;
	int npage = 1;
	int kext = 1;
  int i = binset_(&nblk, &nunit, &keyrw, &lbuf, &reclng, &npage, name, &lenfnm, &kext, buffer, strlen(name));
	if(i == 0)
		file_open = true;
	return i;
}

void readHeader()
{
	if(!file_open)
	{
		MLPutString(stdlink, "File is not opened.");
		return;
	}
	if(elem_ready)
	{
		MLPutString(stdlink, "The header was alredy read.");
		return;
	}
	int n = 10;
	int kbf;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	if(n <= 0)
	{
		MLPutString(stdlink, "End of file at the second record.");
		return;		
	}
	if(kbf == 0)
	{
		MLPutString(stdlink, "Second record is not doubles.");
		return;		
	}
	if(record[0] != 2)
	{
		MLPutString(stdlink, "This is not emat file.");
		return;		
	}
	int num_elem = record[1];
	int ndofspernode = record[2];
	int ndofs = record[3];
	int nnodes = record[4];
	int max_node = record[5];
	int nnodes_used = record[8];
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	if(n <= 0)
	{
		MLPutString(stdlink, "End of file at node equivalence table.");
		return;		
	}
	if(kbf == 0)
	{
		MLPutString(stdlink, "Equivalence node table is doubles.");
		return;		
	}
	MLPutFunction(stdlink, "List", 3);
	MLPutFunction(stdlink, "List", 6);
	MLPutInteger(stdlink, num_elem);
	MLPutInteger(stdlink, ndofspernode);
	MLPutInteger(stdlink, ndofs);
	MLPutInteger(stdlink, nnodes);
	MLPutInteger(stdlink, max_node);
	MLPutInteger(stdlink, nnodes_used);
	MLPutIntegerList(stdlink, record, n);
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	MLPutIntegerList(stdlink, record, n);
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	elem_ready = true;
}

vector<double> fullMat;

double* toFullMatrix(double* tri, int dim)
{
//fullMat is alreday resized
	int loc = 0;
	for (int i = 0; i < dim; ++i)
		for (int j = 0; j <=i; ++j)
		{
			if (i == j)
				fullMat[i*(1 + dim)] = tri[loc];
			else
				fullMat[i + j*dim] = fullMat[j + i*dim] = tri[loc];
			++loc;
		}
	return &*fullMat.begin();
}

void readElement()
{
	if(!elem_ready)
	{
		MLPutString(stdlink, "Not ready to read elements.");
		return;
	}
	int n = 10;
	int kbf;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	if(n <= 0)
	{
		MLPutString(stdlink, "End of file: closing it.");
		closeAnsysFile();
		return;		
	}
	if(kbf == 0)
	{
		MLPutString(stdlink, "Element header is doubles.");
		elem_ready = false;
		return;
	}
	int dim = record[9];
//it is not clear what happens with load vectors 
//and what is their meaning
//below the assumption is that there is one load vector
	int head[6];
	head[5] = convert ? abs(dim) : dim;
	int nrec = 0;
	for (int i = 0; i < 4; ++i)
	{
		if (record[i] == 1) ++nrec;
		head[i] = record[i];
	}
	int nrkey = record[5];
	int ikey = record[6];
	if (convert && dim < 0)
		fullMat.resize(dim*dim);
	MLPutFunction(stdlink, "List", 3 + nrec);
	MLPutIntegerList(stdlink, head, 6);
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	MLPutIntegerList(stdlink, record, n);
	for (int i = 0; i < 4; ++i)
		if (head[i] == 1)
		{
			n = 10;
			binrd_(&nblk, &rec, &n, record, &kbf, buffer);
			if(convert && dim < 0)
				MLPutRealList(stdlink, toFullMatrix((double*)record, abs(dim)), dim*dim);
			else
				MLPutRealList(stdlink, (double*)record, n/intpdp);
		}
	n = 10;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
	bool write = false;
	double *vec = (double*)record;
	for (int i=0; i < abs(dim); ++i)
		if(vec[i] != 0.) write = true;
	if(write)
		MLPutRealList(stdlink, vec, abs(dim));
	else
		MLPutFunction(stdlink, "List", 0);
//	n = 10;
//	if(nrkey == 1)
//		binrd_(&nblk, &rec, &n, record, &kbf, buffer);
//	if(ikey == 1)
//		binrd_(&nblk, &rec, &n, record, &kbf, buffer);
}

void readElements(int n)
{
	MLPutFunction(stdlink, "List", n);	
	for(int i = 0; i < n; ++i)
		readElement();
}

}

int main(int argc, char *argv[]) 
{
	init();
  return MLMain(argc, argv);
}

