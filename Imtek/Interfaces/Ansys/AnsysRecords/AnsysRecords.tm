/*
Copyright (C) 2003 Evgenii Rudnyi, rudnyi@imtek.de
                                   http://www.imtek.de/simulation

Version of 10.05.2003.

This software is free; you can redistribute it and/or modify it under the 
terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your
option) any later version.  This software is distributed in the hope
that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the GNU General Public License for more details.
http://www.gnu.org/copyleft/gpl.html
*/


:Begin:
:Function:       openAnsysFile
:Pattern:        OpenAnsysFile[ str_String ]
:Arguments:      { str }
:ArgumentTypes:  { String }
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
:Function:       readRecord
:Pattern:        ReadAnsysRecord
:Arguments:      { }
:ArgumentTypes:  { }
:ReturnType:     Manual
:End:

:Begin:
:Function:       readRecords
:Pattern:        ReadAnsysRecords[ n_Integer ]
:Arguments:      { n }
:ArgumentTypes:  { Integer }
:ReturnType:     Manual
:End:

