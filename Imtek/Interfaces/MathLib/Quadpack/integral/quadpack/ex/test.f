
            DOUBLE PRECISION A,ABSERR,B,EPSABS,EPSREL,F,RESULT,WORK
            INTEGER IER,IWORK,LAST,LENW,LIMIT,NEVAL
            DIMENSION IWORK(100),WORK(400)
            EXTERNAL F
            A = 0.0D0
            B = 1.0D0
            EPSABS = 0.0D0
            EPSREL = 1.0D-3
            LIMIT = 100
            LENW = LIMIT*4
            CALL DQAGS(F,A,B,EPSABS,EPSREL,RESULT,ABSERR,NEVAL,IER,
     *  LIMIT,LENW,LAST,IWORK,WORK)
            STOP
            END
            DOUBLE PRECISION FUNCTION F(X)
            DOUBLE PRECISION X
            F = 0.0D0
            IF(X.GT.0.0D0) F = 1.0D0/SQRT(X)
            RETURN
            END
