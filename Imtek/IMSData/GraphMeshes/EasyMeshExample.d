
#*******************************************************

  Everything enclosed inside the cashes is a comment.

  This input file is used to generate the triangular
  mesh over the following domain:

     3--------------------2
     |                    |
     |    5----6          |
     |    |    |          |
     |    |    |          |
     |    4----7          |
     |                    |
     0--------------------1


  Run EasyMesh with the command:

  > EasyMesh example +fig
 
  if you want to see the results with xfig,
  or with

  > EasyMesh example +dxf

  if you want to see the results with some tool that
  suports Autodesk DXF format

*******************************************************#

#*********
  POINTS
*********#
8 # number of points defining the boundary #

# rectangular domain #
#-------+-----+-----+---------+--------#
# point |  x  |  y  | spacing | marker #
#-------+-----+-----+---------+--------#
   0:     0.0   0.0    0.05       1
   1:     2.0   0.0    0.25       2
   2:     2.0   1.6    0.25       2
   3:     0.0   1.6    0.1        1

# square hole #
#-------+-----+-----+---------+--------#
# point |  x  |  y  | spacing | marker #
#-------+-----+-----+---------+--------#
   4:     0.5   0.5    0.05       3
   5:     0.5   1.1    0.08       3
   6:     1.1   1.1    0.2        3
   7:     1.1   0.5    0.2        3

#***********
  SEGMENTS
***********#
8 # number of segments #

# domain #
#---------+-----+-----+--------#
# segment | 1st | 2nd | marker #
#---------+-----+-----+--------#
     0:      0     1      1
     1:      1     2      2
     2:      2     3      1
     3:      3     0      1

# hole #
#---------+-----+-----+--------#
# segment | 1st | 2nd | marker #
#---------+-----+-----+--------#
     4:      4     5      3
     5:      5     6      3
     6:      6     7      3
     7:      7     4      3
