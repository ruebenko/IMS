:Begin:
:Function:       integral
:Pattern:        integral[ str_String, a_Real, b_Real, epsabs_Real, epsrel_Real ]
:Arguments:      { str, a, b, epsabs, epsrel }
:ArgumentTypes:  { String, Real, Real, Real, Real }
:ReturnType:     Manual
:End:


:Begin:
:Function:       integralExp
:Pattern:        integralExp[a_Real, b_Real, epsabs_Real, epsrel_Real ]
:Arguments:      { a, b, epsabs, epsrel }
:ArgumentTypes:  { Real, Real, Real, Real }
:ReturnType:     Manual
:End:

:Begin:
:Function:       functionCall
:Pattern:        functionCall[n_Integer ]
:Arguments:      { n }
:ArgumentTypes:  { Integer }
:ReturnType:     Real
:End: