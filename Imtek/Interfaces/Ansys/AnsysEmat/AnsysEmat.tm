:Begin:
:Function:       openAnsysFile
:Pattern:        OpenAnsysFile[ str_String ]
:Arguments:      { str }
:ArgumentTypes:  { String }
:ReturnType:     Integer
:End:


:Begin:
:Function:       doNotConvert
:Pattern:        DoNotConvertAnsysMatrices[ key_Integer ]
:Arguments:      { key }
:ArgumentTypes:  { Integer }
:ReturnType:     Integer
:End:

:Begin:
:Function:       closeAnsysFile
:Pattern:        CloseAnsysFile
:Arguments:      { }
:ArgumentTypes:  { }
:ReturnType:     Integer
:End:


:Begin:
:Function:       readHeader
:Pattern:        ReadAnsysHeader
:Arguments:      { }
:ArgumentTypes:  { }
:ReturnType:     Manual
:End:

:Begin:
:Function:       readElement
:Pattern:        ReadAnsysElement
:Arguments:      { }
:ArgumentTypes:  { }
:ReturnType:     Manual
:End:

:Begin:
:Function:       readElements
:Pattern:        ReadAnsysElements[ n_Integer ]
:Arguments:      { n }
:ArgumentTypes:  { Integer }
:ReturnType:     Manual
:End:


