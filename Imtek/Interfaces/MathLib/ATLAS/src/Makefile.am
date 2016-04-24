## Process this file with automake to produce Makefile.in

MAINTAINERCLEANFILES = Makefile.in config.h.in maToMatm.c

bin_PROGRAMS	= maToMa DGETRF atLUSolve


maToMa_SOURCES	= maToMa.c maToMatm.c

maToMatm.c : maToMa.tm
	mprep maToMa.tm -o maToMatm.c


DGETRF_SOURCES = DGETRF.c DGETRFtm.c

DGETRFtm.c : DGETRF.tm
	mprep DGETRF.tm -o DGETRFtm.c


atLUSolve_SOURCES = atLUSolve.c atLUSolvetm.c

atLUSolvetm.c : atLUSolve.tm
	mprep atLUSolve.tm -o atLUSolvetm.c
