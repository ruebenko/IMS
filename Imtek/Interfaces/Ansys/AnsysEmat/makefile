NAME = AnsysEmat
CC = gcc
CCP = g++
LD_RUN_PATH = /usr/local/ansys61/ansys61/customize/misc/usparc:/usr/local/ansys61/ansys61/syslib/usparc

FLAGS = 

#The macros below are to locate Mathlink tools, headers and libraries
MLINKDIR = /usr/local/mathematica4/AddOns/MathLink/DevelopersKits
SYS = Solaris
CADDSDIR = ${MLINKDIR}/${SYS}/CompilerAdditions
INCDIR = ${CADDSDIR}
LIBDIR = ${CADDSDIR}
MPREP = ${CADDSDIR}/mprep

#The macro below is to locate Ansys 'bin' and related libraries 
INCBIN = -L/usr/local/ansys61/ansys61/customize/misc/usparc -L/home/rudnyi/misc/ansys61/usparc -lbin -lF77 -lfsu -lfsumai -lsunmath

#Actually related libraries are at /usr/local/ansys61/ansys61/syslib/usparc
#For some reasons I do not not understand I needed to rename them.
#If you have a clue why -L/usr/local/ansys61/ansys61/syslib/usparc
#does not work, please let me know.

#Sun specific
SUNLIB = -lsocket -lnsl

$(NAME) : $(NAME)tm.o $(NAME).o 
	${CCP} -I${INCDIR} $(NAME)tm.o $(NAME).o -L${LIBDIR} -lML -lm $(SUNLIB) $(INCBIN) -o $@

.c.o :
	${CC} -c $(FLAGS) -I${INCDIR} $<
	
.cpp.o :
	${CC} -c $(FLAGS) -I${INCDIR} $<

$(NAME)tm.c : $(NAME).tm
	${MPREP} $? -o $@

clean : 
	rm *.o $(NAME)tm.c

