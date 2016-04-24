NAME = integral
CC = gcc
CCP = g++

FLAGS = -Wno-long-double

MLINKDIR = /Applications/Mathematica\ 4.2.app/AddOns/MathLink/DeveloperKit

SYS = Darwin
CADDSDIR = ${MLINKDIR}/${SYS}/CompilerAdditions

INCDIR = ${CADDSDIR}
LIBDIR = ${CADDSDIR}

MPREP = ${CADDSDIR}/mprep

$(NAME) : $(NAME)tm.o $(NAME).o main.o 
	${CCP} -I${INCDIR} $(NAME)tm.o $(NAME).o main.o -L${LIBDIR} -lML -Lquadpack -lquadpack -L/sw/lib -lg2c -lm -o $@

.c.o :
	${CC} -c $(FLAGS) -I${INCDIR} $<
	
.cpp.o :
	${CC} -c $(FLAGS) -I${INCDIR} $<

$(NAME)tm.c : $(NAME).tm
	${MPREP} $? -o $@

