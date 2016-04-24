OBJ = dqags.o dqagse.o dqelg.o dqk21.o dqpsrt.o d1mach.o

libquadpack.a: $(OBJ) 
	ar crs $@ $?
	ranlib $@

%.o : %.f
	g77 -funroll-all-loops -fno-f2c -O3 -c $< 

