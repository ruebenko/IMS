LIB = -L.. -lquadpack -L/sw/lib -lfrtbegin -lg2c

%.o : %.f
	g77 -fno-f2c -O3 -c $< 

%.o : %.cpp
	gcc -c $< 
	
$(NAME) : $(NAME).o 
	g++ -s $< $(LIB) -o $@

