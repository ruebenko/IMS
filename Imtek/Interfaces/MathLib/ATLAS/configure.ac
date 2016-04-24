# Process this file with autoconf to produce a configure script.
AC_INIT(atlasPlugin, 0.1)
AC_CONFIG_SRCDIR([src/maToMa.c])
AM_INIT_AUTOMAKE
AM_CONFIG_HEADER(src/config.h)
AC_CANONICAL_BUILD

AC_ARG_WITH(ML-lib,
  [  --with-ML-lib=dirs   Search for ML library in specified directories],
  [ LDFLAGS="$LDFLAGS"`echo " $withval" |
        sed -e 's/ / -L/g' -e 's/-L //g' -e 's/-L$//'`
    LTLDFLAGS="$LTLDFLAGS"`echo " $withval" |
        sed -e 's/ / -R/g' -e 's/-R //g' -e 's/-R$//'`],
  [ LDFLAGS="$LDFLAGS -L/usr/local/lib" ])

AC_ARG_WITH(ATLAS-lib,
  [  --with-ATLAS-lib=dirs   Search for ATLAS library in specified directories],
  [ LDFLAGS="$LDFLAGS"`echo " $withval" |
        sed -e 's/ / -L/g' -e 's/-L //g' -e 's/-L$//'`
    LTLDFLAGS="$LTLDFLAGS"`echo " $withval" |
        sed -e 's/ / -R/g' -e 's/-R //g' -e 's/-R$//'`],
  [ LDFLAGS="$LDFLAGS -L/usr/local/lib" ])

AC_ARG_WITH(mathlink-include,
  [  --with-mathlink-include=dirs    Search directories for mathlink.h ],
  [ CPPFLAGS="$CPPFLAGS"`echo " $withval" |
        sed -e 's/ / -I/g' -e 's/-I //g' -e 's/-I$//'` ],
  [ CPPFLAGS="$CPPFLAGS -I/usr/local/include" ])

AC_ARG_WITH(ATLAS-specific-include,
  [  --ATLAS-specific-include=dirs   Search directories for atlas_buildinfo.h ],
  [ CPPFLAGS="$CPPFLAGS"`echo " $withval" |
        sed -e 's/ / -I/g' -e 's/-I //g' -e 's/-I$//'` ],
  [ CPPFLAGS="$CPPFLAGS -I/usr/local/include" ])

AC_ARG_WITH(ATLAS-include,
  [  --ATLAS-include=dirs    Search directories for cblas.h ],
  [ CPPFLAGS="$CPPFLAGS"`echo " $withval" |
        sed -e 's/ / -I/g' -e 's/-I //g' -e 's/-I$//'` ],
  [ CPPFLAGS="$CPPFLAGS -I/usr/local/include" ])

# Checks for programs.
AC_PROG_CC

AC_CHECK_PROG(Mprep, mprep, yes, no)
    if test $Mprep = no;
    then
	AC_MSG_ERROR(Cannot find Mathematica mprep. Put it in your path.)
    fi;


# Checks for libraries.
# sun4 stuff
case $build_vendor in
       sun)
	    AC_CHECK_LIB(nsl, open , ,
	        AC_MSG_ERROR(you need to install libnsl 
			    )
			)
	    AC_CHECK_LIB(socket, bind , ,
	        AC_MSG_ERROR(you need to install libsocket 
			    )
			)
	    # probably not neccessary
	    AC_CHECK_LIB(m, acos , ,
	        AC_MSG_ERROR(you need to install libm 
			    )
			)
         ;;
     esac

AC_CHECK_LIB(ML, MLInit, , 
    AC_MSG_ERROR(you need to install the Mathematica libML.a 
		or give the path to it using the option 
		--with-ML-lib=dirs
		)
	    ) 

AC_CHECK_LIB(atlas, ATL_xerbla  , , 
    AC_MSG_ERROR(you need to install ATLAS lib atlas
		or give the path to it using the option 
		--with-ATLAS-lib=dirs
		)
	    ) 

# is it realy required? perhaps some other than cblas_xerbla
AC_CHECK_LIB(cblas, cblas_xerbla, , 
    AC_MSG_ERROR(you need to install ATLAS lib cblas
		or give the path to it using the option 
		--with-ATLAS-lib=dirs
		)
	    ) 
# i can not check for ATL_dgetrf. Why?
AC_CHECK_LIB(lapack, ATL_dlaswp , , 
    AC_MSG_ERROR(you need to install ATLAS lib lapack
		or give the path to it using the option 
		--with-ATLAS-lib=dirs
		)
	    ) 



# Checks for header files.
AC_CHECK_HEADER(mathlink.h, ,
    AC_MSG_ERROR(   could not find mathlink.h
		    use the --with-mathlink-include=dirs option
		    to specify the directory contaning mathlink.h
	    )
	)

AC_CHECK_HEADER(atlas_buildinfo.h, ,
    AC_MSG_ERROR(   could not find ATLAS system specific buildinfo.h 
		    use the --with-ATLAS-specific-include=dirs option
		    to specify the directory contaning buildinfo.h
	    )
	)

AC_CHECK_HEADER(cblas.h, ,
    AC_MSG_ERROR(   could not find ATLAS cblas.h 
		    use the --with-ATLAS-include=dirs option
		    to specify the directory contaning cblas.h
	    )
	)

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_SIZE_T

# Checks for library functions.


AC_PROG_MAKE_SET
AC_OUTPUT(Makefile
	    src/Makefile
	    notebooks/Makefile)
