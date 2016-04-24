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

using namespace std;

//ofstream out("info.txt");

bool file_open = false;
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
	record = new int[100000];
//	out << "reclng is " << reclng << endl;	
//	out << "intpdp is " << intpdp << endl;	
//	out << "lenfnm is " << lenfnm << endl;	
}

int closeAnsysFile()
{
	if(file_open)
	{
    binclo_(&nblk, "KEEP", buffer, 4);
		nblk = 1;
		rec = 0;
		file_open = false;
		return 0;
	}
	else
		return -1;
}

int openAnsysFile(char *name, long lenname)
{
	if(file_open)
		closeAnsysFile();
//	out << "name " << name << endl;
//	out << "length is " << strlen(name) << endl;
	
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

void readRecord()
{
	if(!file_open)
	{
		MLPutInteger(stdlink, -1);
		return;
	}
	int n = 10;
	int kbf;
//	out << "rec is " << rec << endl;
	binrd_(&nblk, &rec, &n, record, &kbf, buffer);
//	out << "rec is " << rec << endl;
//	out << "n " << n << endl;
	if(n <= 0)
	{
		MLPutInteger(stdlink, -2);
		return;		
	}
	if(kbf == 0)
	{
		n = n/intpdp;
		MLPutRealList(stdlink, (double*)record, n);
	}
	else
	{
		MLPutIntegerList(stdlink, record, n);
	}
}

void readRecords(int n)
{
	MLPutFunction(stdlink, "List", n);	
	for(int i = 0; i < n; ++i)
		readRecord();
}

}

int main(int argc, char *argv[]) 
{
	init();
  return MLMain(argc, argv);
}


