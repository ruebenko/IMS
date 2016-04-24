
            DOUBLE PRECISION A,ABSERR,B,EPSABS,EPSREL,F,RESULT,WORK
            INTEGER IER,IWORK,LAST,LENW,LIMIT,NEVAL
            DIMENSION IWORK(100),WORK(400)
            EXTERNAL F
            A = -1000.0D0
            B = 1000.0D0
            EPSABS = 0.0D0
            EPSREL = 1.0D-5
            LIMIT = 100
            LENW = LIMIT*4
            CALL DQAGS(F,A,B,EPSABS,EPSREL,RESULT,ABSERR,NEVAL,IER,
     *  LIMIT,LENW,LAST,IWORK,WORK)
     				PRINT *, RESULT, ABSERR, NEVAL, IER
            STOP
            END
            DOUBLE PRECISION FUNCTION F(X)
            DOUBLE PRECISION X
            F = EXP(-X**2)
            RETURN
            END
