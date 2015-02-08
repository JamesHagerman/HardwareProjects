#!/bin/sh
# This is a shell archive (produced by GNU sharutils 4.11.1).
# To extract the files from this archive, save it to some FILE, remove
# everything before the `#!/bin/sh' line above, then type `sh FILE'.
#
lock_dir=_sh23279
# Made on 2014-05-29 07:52 MDT by <fwb@fw>.
# Source directory was `/s/opt/UltraLib'.
#
# Existing files will *not* be overwritten, unless `-c' is specified.
#
# This shar contains:
# length mode       name
# ------ ---------- ------------------------------------------
#    437 -rw-r--r-- makefile
#    950 -rw-r--r-- x2lib.c
#  48486 -rw-r--r-- XLR_Format.txt
#   1230 -rw-r--r-- xlr.h
# 257868 -rw-r--r-- xlr.sh
#  22834 -rw-r--r-- xlr.y
#
MD5SUM=${MD5SUM-md5sum}
f=`${MD5SUM} --version | egrep '^md5sum .*(core|text)utils'`
test -n "${f}" && md5check=true || md5check=false
${md5check} || \
  echo 'Note: not verifying md5sums.  Consider installing GNU coreutils.'
if test "X$1" = "X-c"
then keep_file=''
else keep_file=true
fi
echo=echo
save_IFS="${IFS}"
IFS="${IFS}:"
gettext_dir=
locale_dir=
set_echo=false

for dir in $PATH
do
  if test -f $dir/gettext \
     && ($dir/gettext --version >/dev/null 2>&1)
  then
    case `$dir/gettext --version 2>&1 | sed 1q` in
      *GNU*) gettext_dir=$dir
      set_echo=true
      break ;;
    esac
  fi
done

if ${set_echo}
then
  set_echo=false
  for dir in $PATH
  do
    if test -f $dir/shar \
       && ($dir/shar --print-text-domain-dir >/dev/null 2>&1)
    then
      locale_dir=`$dir/shar --print-text-domain-dir`
      set_echo=true
      break
    fi
  done

  if ${set_echo}
  then
    TEXTDOMAINDIR=$locale_dir
    export TEXTDOMAINDIR
    TEXTDOMAIN=sharutils
    export TEXTDOMAIN
    echo="$gettext_dir/gettext -s"
  fi
fi
IFS="$save_IFS"
if (echo "testing\c"; echo 1,2,3) | grep c >/dev/null
then if (echo -n test; echo 1,2,3) | grep n >/dev/null
     then shar_n= shar_c='
'
     else shar_n=-n shar_c= ; fi
else shar_n= shar_c='\c' ; fi
f=shar-touch.$$
st1=200112312359.59
st2=123123592001.59
st2tr=123123592001.5 # old SysV 14-char limit
st3=1231235901

if touch -am -t ${st1} ${f} >/dev/null 2>&1 && \
   test ! -f ${st1} && test -f ${f}; then
  shar_touch='touch -am -t $1$2$3$4$5$6.$7 "$8"'

elif touch -am ${st2} ${f} >/dev/null 2>&1 && \
   test ! -f ${st2} && test ! -f ${st2tr} && test -f ${f}; then
  shar_touch='touch -am $3$4$5$6$1$2.$7 "$8"'

elif touch -am ${st3} ${f} >/dev/null 2>&1 && \
   test ! -f ${st3} && test -f ${f}; then
  shar_touch='touch -am $3$4$5$6$2 "$8"'

else
  shar_touch=:
  echo
  ${echo} 'WARNING: not restoring timestamps.  Consider getting and
installing GNU `touch'\'', distributed in GNU coreutils...'
  echo
fi
rm -f ${st1} ${st2} ${st2tr} ${st3} ${f}
#
if test ! -d ${lock_dir} ; then :
else ${echo} "lock directory ${lock_dir} exists"
     exit 1
fi
if mkdir ${lock_dir}
then ${echo} "x - created lock directory ${lock_dir}."
else ${echo} "x - failed to create lock directory ${lock_dir}."
     exit 1
fi
# ============= makefile ==============
if test -n "${keep_file}" && test -f 'makefile'
then
${echo} "x - SKIPPING makefile (file already exists)"
else
${echo} "x - extracting makefile (text)"
  sed 's/^X//' << 'SHAR_EOF' > 'makefile' &&
#
#	Makefile for XLR parser.
#
X
# CFLAGS = -DDEBUG
# CFLAGS = -O
CC	   = gcc
CFLAGS = -g -static
X
SOURCES = xlr.y
X
all  :	x2lib xlr.o
X
x2lib :	x2lib.o xlr.o 
X	gcc $(CFLAGS) x2lib.o xlr.o -o x2lib -lm
X
xlr :	xlr.o 
X	gcc $(CFLAGS) -c xlr.c
X
xlr.o : xlr.c
X
xlr.c : xlr.y
X	bison -t -v -d xlr.y 
X	cp xlr.tab.c xlr.c
X
dist:
X	shar xlr.y xlr.h  XLR_Format.txt makefile x2lib.c > xlr.sh
clean :
X	rm *.o xlr.c xlr.output xlr.tab.c xlr.tab.h x2lib
SHAR_EOF
  (set 20 08 04 18 17 51 46 'makefile'
   eval "${shar_touch}") && \
  chmod 0644 'makefile'
if test $? -ne 0
then ${echo} "restore of makefile failed"
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'makefile': 'MD5 check failed'
       ) << \SHAR_EOF
99feb614ad9382d2c7eeb6a7eaf59561  makefile
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'makefile'` -ne 437 && \
  ${echo} "restoration warning:  size of 'makefile' is not 437"
  fi
fi
# ============= x2lib.c ==============
if test -n "${keep_file}" && test -f 'x2lib.c'
then
${echo} "x - SKIPPING x2lib.c (file already exists)"
else
${echo} "x - extracting x2lib.c (text)"
  sed 's/^X//' << 'SHAR_EOF' > 'x2lib.c' &&
/*
X * xlr2lib - XLR to KiCad library
X */
#define global
X
#include <stdio.h>
#include <string.h>
X
int bug=0;  		// debug level: 
X
char *InFile = "-";
X
char  FileNameNet[64], FileNameLib[64], FileNameEESchema[64], FileNameKiPro[64];
FILE *FileEdf, *FileNet, *FileEESchema=NULL, *FileLib=NULL, *FileKiPro=NULL;
X
main(int argc, char *argv[])
{
X  char * version      = "0.97";
X  char * progname;
X
X  progname = strrchr(argv[0],'/');
X  if (progname)
X    progname++;
X  else
X    progname = argv[0];
X
X  fprintf(stderr,"*** %s Version %s ***\n", progname, version);
X
X  if( argc != 2 ) {
X     fprintf(stderr, " usage: XLRfile \n") ; return(1);
X  }
X
X  InFile= argv[1];
X  if( (FileEdf = fopen( InFile, "r" )) == NULL ) {
X       fprintf(stderr, " '%s' doesn't exist\n", InFile);
X       return(-1);
X  }
X
X  fprintf(stderr, "Parsing %s \n", InFile);
X  ParseXLR(FileEdf, stderr);
X
X  fprintf(stderr, "Writting Lib \n");
X
X  fprintf(stderr, "BonJour!\n");
X  return(0);
}
X
SHAR_EOF
  (set 20 08 04 18 17 38 29 'x2lib.c'
   eval "${shar_touch}") && \
  chmod 0644 'x2lib.c'
if test $? -ne 0
then ${echo} "restore of x2lib.c failed"
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'x2lib.c': 'MD5 check failed'
       ) << \SHAR_EOF
df31f3c9587319b3c3b29117db6c902f  x2lib.c
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'x2lib.c'` -ne 950 && \
  ${echo} "restoration warning:  size of 'x2lib.c' is not 950"
  fi
fi
# ============= XLR_Format.txt ==============
if test -n "${keep_file}" && test -f 'XLR_Format.txt'
then
${echo} "x - SKIPPING XLR_Format.txt (file already exists)"
else
${echo} "x - extracting XLR_Format.txt (text)"
  sed 's/^X//' << 'SHAR_EOF' > 'XLR_Format.txt' &&
# XLR Format
# 
#    This document is designed to give the user a clearer understanding of
# the ASCII XLR format used by Accelerated Designs.  This introduction is
# not a specification but is designed to explain the main flow of the
# document, what is contained in the different sections, how they are
# related and some of the syntax requirements.  Normally this file is
# modified and added to as new capabilities are required of the Ultra
# Librarian.  So any use of this file must take  into account the
# possibility of additional information in the same format.
# 
# By default all units in the file are assumed to be english mils.  Other
# units are possibple, and will have :"mm", "cn", "in", etc after the
# size.  Also, numbers are noted without quotes and all text is surrounded
# with quotes so that we can tell the difference.
# 
#   Ultra Librarian Gold 2.0.344 database file
#   Copyright  1999-2005 Accelerated Designs, Inc.
#   http://www.Accelerated-Designs.com
#
# Notice that comments are preceeded by the pound sign.  Anything
# following is ignored by the code.
# Layer information
#Layer Data
LayerData : 62
X    Layer : 1
X        Name      TOP_ASSEMBLY
X        LayerType
X    Layer : 2
X        Name      TOP_SILKSCREEN
X        LayerType
X    Layer : 3
X        Name      TOP_SOLDER_PASTE
X        LayerType
X    Layer : 4
X        Name      TOP_SOLDER_MASK
X        LayerType
X    Layer : 987
X        Name      CONTACT_AREA
X        LayerType
X    Layer : 5
X        Name      TOP
X        LayerType Signal
X    Layer : 12
X        Name      TOP_PLACE_BOUND
X        LayerType
X    Layer : 6
X        Name      INNER
X        LayerType Signal
X    Layer : 13
X        Name      BOTTOM_PLACE_BOUND
X        LayerType
X    Layer : 7
X        Name      BOTTOM
X        LayerType Signal
X    Layer : 8
X        Name      BOTTOM_SOLDER_MASK
X        LayerType
X    Layer : 9
X        Name      BOTTOM_SOLDER_PASTE
X        LayerType
X    Layer : 10
X        Name      BOTTOM_SILKSCREEN
X        LayerType
X    Layer : 11
X        Name      BOTTOM_ASSEMBLY
X        LayerType
X    Layer : 977
X        Name      DXF_3D 
X        LayerType
X    Layer : 978
X        Name      PIN1MARKER
X        LayerType
X    Layer : 979
X        Name      PINTEST
X        LayerType
X    Layer : 980
X        Name      TOP_BGA_PLACE_BOARD
X        LayerType
X    Layer : 981
X        Name      ATTRIBUTE4
X        LayerType
X    Layer : 982
X        Name      ATTRIBUTE3
X        LayerType
X    Layer : 983
X        Name      ATTRIBUTE2
X        LayerType
X    Layer : 984
X        Name      ATTRIBUTE1
X        LayerType
X    Layer : 985
X        Name      PIN_NUMBER
X        LayerType
X    Layer : 986
X        Name      CONSTRAINT_AREA
X        LayerType
X    Layer : 988
X        Name      INPUTDIMENSIONS
X        LayerType
X    Layer : 989
X        Name      ROUTE_KEEPOUT
X        LayerType
X    Layer : 990
X        Name      VIA_KEEPOUT
X        LayerType
X    Layer : 991
X        Name      DRILL_FIGURE
X        LayerType
X    Layer : 992
X        Name      TOP_COMP_BOUND
X        LayerType
X    Layer : 993
X        Name      BOTTOM_COMP_BOUND
X        LayerType
X    Layer : 994
X        Name      TOP_NO-PROBE
X        LayerType
X    Layer : 995
X        Name      BOTTOM_NO-PROBE
X        LayerType
X    Layer : 996
X        Name      PRO_E
X        LayerType
X    Layer : 997
X        Name      PIN_DETAIL
X        LayerType
X    Layer : 998
X        Name      DIMENSION
X        LayerType
X    Layer : 999
X        Name      BOARD
X        LayerType
X    Layer : 14
X        Name      INTERNAL1
X        LayerType
X    Layer : 15
X        Name      INTERNAL2
X        LayerType
X    Layer : 16
X        Name      INTERNAL3
X        LayerType
X    Layer : 17
X        Name      INTERNAL4
X        LayerType
X    Layer : 18
X        Name      INTERNAL5
X        LayerType
X    Layer : 19
X        Name      INTERNAL6
X        LayerType
X    Layer : 20
X        Name      INTERNAL7
X        LayerType
X    Layer : 21
X        Name      INTERNAL8
X        LayerType
X    Layer : 22
X        Name      INTERNAL9
X        LayerType
X    Layer : 23
X        Name      INTERNAL10
X        LayerType
X    Layer : 24
X        Name      INTERNAL11
X        LayerType
X    Layer : 25
X        Name      INTERNAL12
X        LayerType
X    Layer : 26
X        Name      INTERNAL13
X        LayerType
X    Layer : 27
X        Name      INTERNAL14
X        LayerType
X    Layer : 28
X        Name      INTERNAL15
X        LayerType
X    Layer : 30
X        Name      INTERNAL16
X        LayerType
X    Layer : 31
X        Name      USER1
X        LayerType
X    Layer : 32
X        Name      USER2
X        LayerType
X    Layer : 33
X        Name      USER3
X        LayerType
X    Layer : 34
X        Name      USER4
X        LayerType
X    Layer : 35
X        Name      USER5
X        LayerType
X    Layer : 36
X        Name      USER6
X        LayerType
X    Layer : 37
X        Name      USER7
X        LayerType
X    Layer : 38
X        Name      USER8
X        LayerType
X    Layer : 39
X        Name      USER9
X        LayerType
X    Layer : 40
X        Name      USER10
X        LayerType
# 
# Each layer is documented.  Each layer is required to have a number
# between 1 and 1000, and the number must be unique.  Each number is
# associated with a layer name, which again must be unique.  All of the
# data in our code will refer to the layers by number, but will display
# the associated name to the users.  The "UltraLibrarian\Layers.ini" file
# contains the list of default layer names and numbers.
# 
# Layertypes can be blank, Signal, NonSignal and Plane.  Capitals or lower
# case are acceptable.  If Layertype is left blank, it is assumed to be
# NonSignal.   Signal and Power layer types are used primarily in PadStack
# descriptions.
# TextStyle Section
#TextStyles
TextStyles : 3
X    TextStyle "H50S3" (FontWidth 3) (FontHeight 50) (FontCharWidth 13)
X    TextStyle "h125s6" (FontWidth 6) (FontHeight 125)
X    TextStyle "H80s4" (FontWidth 4) (FontHeight 80)
# 
# Each textstyle used in either a footprint or a symbol will have a name
# and at least the FontWidth and FontHeight keywords. 
# 
# PadStyles
#PadStyles
PadStacks : 1
X    PadStack "RX63Y14D0T" (HoleDiam 0) (Surface True) (Plated False)
X        Shapes       : 1
X        PadShape "Rectangle" (Width 63) (Height 14) (PadType 0) (Layer TOP)
X    EndPadStack
# 
# Usually made up of a name (in quote marks) and then a list of shapes,
# with the specified attributes for each shape.  Again, not all entities
# or descriptors will be used with each shape description.....
# 
# Possible shapes are: "Rectangle, Circle, Oblong. RoundedRectangle,
# Diamond, RoundedDiamond, Thermal, Thermalx and Polygon..  Additional
# shape descriptors include Layer (with the layer always in CAPs), Wide,
# High, SpokeWidth, Shape in quotes as above.  PadTypes are 0 by default.
# Other descriptors include OffsetX, OffsetY rotation, and Points (an
# array of points, each containing an X and Y location.  Used only with
# Polygonal pads shapes)..
# 
# Pattern Section
# 	By far the most complex by far is the pattern.  We are going to break
# this one up into sections to help you understand it better.
# 
# 
#Patterns
Patterns : 1
X    Pattern "so8-p30-a98"
X
# The name of the pattern in quotes.  The name can not contain quotes, or
# we will get confused.
X
X        OriginPoint (0, 0)
X        PickPoint   (0, 0)
X        GluePoint   (0, 0)
X
# The above data is available on all parts, and refers fo the location
# within the part of the centroid.  Thes enumbers are all all stored as
# long numbers in the code,  The origin in particular is an offset from
# the dimension a part was built in to where its placement point is.  This
# is normally 0,0 since the part is useally built from its placement
# point, but it could be located to the side of the part or at some other
# location if this was appropriate for some reason.  Not all tools will
# support or use the pickpoint and the gluedot.  The section below, Data,
# is in each part.  It contians some form of data  that could be displayed
# or stored abou tthe part.  We will detail some of the lines of this code
# for you. 
# 
X        Data        : 332
X            Text (Layer TOP_ASSEMBLY) (Origin -67.5, 87) (Text "*") (IsVisible True) (Justify UPPERCENTER) (TextStyle "H50S3")
X            Text (Layer TOP_SILKSCREEN) (Origin -67.5, 87) (Text "*") (IsVisible True) (Justify UPPERCENTER) (TextStyle "H50S3")
X            Pad (Number 1) (PinName "1") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin -57.5, 45) (OriginalPinNumber 1)
# 
# Each line in the data set contains a new entity for the part, and the
# properties that make these entities up.  The data lines can and often do
# use the same information as other forms of dats.  So for example a line
# may use the Origin ( x,y) property just as the Text entity may use this
# same property.  Many of the possible properties can and are shared
# across the data types.  Some of the common ones you will see ini use is
# Rotation, Flipped, Origin, Etc.  Note that the text before the first
# bracket delineates the type of entity available.  There are only a ferw
# permissable types at this point:     pad, line, arc, circle, attribute,
# pickpoint, poly, polykeepout, polykeepout_via, polykeepout_comp,
# polykeepin_comp, text, wizard.
# 
X            Line (Layer TOP_ASSEMBLY) (Origin -49, 39) (EndPoint -49, 51)
# 
# Lines will always require at least an origin EndPoint and layer
# property.  If they do not include the width property, they will be
# assigned a default width in our code.  The default width is user
# assignable in the configuration screen.
# 
X            Line (Layer TOP_ASSEMBLY) (Origin -49, 51) (EndPoint -75, 51)
X            Line (Layer TOP_ASSEMBLY) (Origin -75, 51) (EndPoint -75, 38.9999999999999)
X            Line (Layer TOP_ASSEMBLY) (Origin -75, 38.9999999999999) (EndPoint -49, 39)
X            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (-49, 39) (-49, 51) (-75, 51) (-75, 38.9999999999999)
# 
# A polygon requires a layer, an Orgin and at least two additional points
# to be valid.  It can also contain width, flipped, and several other
# properties.
# 
X            Pad (Number 2) (PinName "2") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin -57.5, 15) (OriginalPinNumber 2)
X
# A pad must contain a name and a number.  The name is what most users
# will see when referencing the footprint.  The number is arbitrarily
# assigned based.  Each footprint must have its pads numbered one to the
# amount of pads contined with no gaps or duplicates in numbering.  Also
# required are the Origin and Padstyle properties.  Other properties might
# be visible, such as rotation and flipped.
# 
X            Pad (Number 3) (PinName "3") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin -57.5, -15) (OriginalPinNumber 3)
X            Pad (Number 4) (PinName "4") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin -57.5, -45) (OriginalPinNumber 4)
X            Line (Layer TOP_ASSEMBLY) (Origin -49, 9) (EndPoint -49, 21)
X            Line (Layer TOP_ASSEMBLY) (Origin -49, 21) (EndPoint -75, 21)
X            Line (Layer TOP_ASSEMBLY) (Origin -75, 21) (EndPoint -75, 8.99999999999993)
X            Line (Layer TOP_ASSEMBLY) (Origin -75, 8.99999999999993) (EndPoint -49, 9)
X            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (-49, 9) (-49, 21) (-75, 21) (-75, 8.99999999999993)
X            Line (Layer TOP_ASSEMBLY) (Origin -49, -21) (EndPoint -49, -9)
X            Line (Layer TOP_ASSEMBLY) (Origin -49, -9) (EndPoint -75, -9.00000000000005)
X            Line (Layer TOP_ASSEMBLY) (Origin -75, -9.00000000000005) (EndPoint -75, -21.0000000000001)
X            Line (Layer TOP_ASSEMBLY) (Origin -75, -21.0000000000001) (EndPoint -49, -21)
X            Poly (Layer DXF-3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (-49, -21) (-49, -9) (-75, -9.00000000000005) (-75, -21.0000000000001)
X            Line (Layer TOP_ASSEMBLY) (Origin -48.9999999999999, -51) (EndPoint -49, -39)
X            Line (Layer TOP_ASSEMBLY) (Origin -49, -39) (EndPoint -75, -39.0000000000001)
X            Line (Layer TOP_ASSEMBLY) (Origin -75, -39.0000000000001) (EndPoint -74.9999999999999, -51.0000000000001)
X            Line (Layer TOP_ASSEMBLY) (Origin -74.9999999999999, -51.0000000000001) (EndPoint -48.9999999999999, -51)
X            Poly (Layer DXF-3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (-48.9999999999999, -51) (-49, -39) (-75, -39.0000000000001) (-74.9999999999999, -51.0000000000001)
X            Pad (Number 5) (PinName "5") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin 57.5, -45) (OriginalPinNumber 5)
X            Pad (Number 6) (PinName "6") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin 57.5, -15) (OriginalPinNumber 6)
X            Pad (Number 7) (PinName "7") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin 57.5, 15) (OriginalPinNumber 7)
X            Pad (Number 8) (PinName "8") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin 57.5, 45) (OriginalPinNumber 8)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, -39) (EndPoint 49, -51)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, -51) (EndPoint 75, -51)
X            Line (Layer TOP_ASSEMBLY) (Origin 75, -51) (EndPoint 75, -38.9999999999999)
X            Line (Layer TOP_ASSEMBLY) (Origin 75, -38.9999999999999) (EndPoint 49, -39)
X            Poly (Layer DXF-3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (49, -39) (49, -51) (75, -51) (75, -38.9999999999999)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, -9) (EndPoint 49, -21)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, -21) (EndPoint 75, -21)
X            Line (Layer TOP_ASSEMBLY) (Origin 75, -21) (EndPoint 75, -8.99999999999993)
X            Line (Layer TOP_ASSEMBLY) (Origin 75, -8.99999999999993) (EndPoint 49, -9)
X            Poly (Layer DXF-3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (49, -9) (49, -21) (75, -21) (75, -8.99999999999993)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, 21) (EndPoint 49, 9)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, 9) (EndPoint 75, 9.00000000000001)
X            Line (Layer TOP_ASSEMBLY) (Origin 75, 9.00000000000001) (EndPoint 75, 21.0000000000001)
X            Line (Layer TOP_ASSEMBLY) (Origin 75, 21.0000000000001) (EndPoint 49, 21)
X            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (49, 21) (49, 9) (75, 9.00000000000001) (75, 21.0000000000001)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, 51) (EndPoint 49, 39)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, 39) (EndPoint 75, 39)
X            Line (Layer TOP_ASSEMBLY) (Origin 75, 39) (EndPoint 74.9999999999999, 51.0000000000001)
X            Line (Layer TOP_ASSEMBLY) (Origin 74.9999999999999, 51.0000000000001) (EndPoint 49, 51)
X            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (49, 51) (49, 39) (75, 39) (74.9999999999999, 51.0000000000001)
X            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (-75, 51) (-75, 39) (-40, 39) (-40, 51)
X            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (-75, 21) (-75, 9) (-40, 9) (-40, 21)
X            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (-75, -9) (-75, -21) (-40, -21) (-40, -9)
X            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (-75, -39) (-75, -51) (-40, -51) (-40, -39)
X            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (40, -39) (40, -51) (75, -51) (75, -39)
X            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (40, -9) (40, -21) (75, -21) (75, -9)
X            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (40, 21) (40, 9) (75, 9) (75, 21)
X            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (40, 51) (40, 39) (75, 39) (75, 51)
X            Poly (Layer TOP_NO-PROBE) (Origin 0, 0) (Width 6)  (-104, -95) (-104, 95) (104, 95) (104, -95)
X            Line (Layer TOP_PLACE_BOUND) (Origin -89, -80) (EndPoint -89, 80)
X            Line (Layer TOP_PLACE_BOUND) (Origin -89, 80) (EndPoint 89, 80)
X            Line (Layer TOP_PLACE_BOUND) (Origin 89, 80) (EndPoint 89, -80)
X            Line (Layer TOP_PLACE_BOUND) (Origin 89, -80) (EndPoint -89, -80)
X            Poly (Layer TOP_PLACE_BOUND) (Origin 0, 0) (Width 6)  (-89, -80) (-89, 80) (89, 80) (89, -80)
X            Attribute (Layer PRO_E) (Origin 0, 0) (Attr "Height" "100") (Justify CENTER) (TextStyle "H50S3")
# 
# Attributes must contain a layer, an Origin, and a textstyle.  Attributes
# without a justification will be justified "CENTER".  It must  also
# conain the attribute prompt as well as value.  In the example above the
# prompt is "Height" and the value is "100".  Note that the value is
# always considered a string.  Always.
# 
# Justification is used on text and attributes.  Its available
# justifications are: UPPERLEFT, UPPERCENTER, UPPERRIGHT, LEFT, CENTER, RIGHT, LOWERLEFT, LOWERCENTER, LOWERRIGHT.
#
#
X            Attribute (Layer PRO_E) (Origin 0, 0) (Attr "MINHEIGHT" "10") (Justify CENTER) (TextStyle "H50S3")
X            Line (Layer PRO_E) (Origin -49, 80) (EndPoint -49, -80) (Width 6)
X            Line (Layer PRO_E) (Origin -49, -80) (EndPoint 49, -80) (Width 6)
X            Line (Layer PRO_E) (Origin 49, -80) (EndPoint 49, 80) (Width 6)
X            Line (Layer PRO_E) (Origin 49, 80) (EndPoint -49, 80) (Width 6)
X            Arc (Layer PRO_E) (Origin 0, 80) (Radius 8.166667) (StartAngle 180) (SweepAngle 180) (Width 6)
# 
# An Arc needs all of the fields above except the width field.  However it
# might have quite a few additional feilds like rotation and flipped.
# 
X            Text (Layer DIMENSION) (Origin 0, -230) (Text "Default Padstyle: RX63Y14D0T") (IsVisible True) (Justify UPPERCENTER) (TextStyle
"H50S3")
# 
# Text has the same requirements as an Attribute, except that rather than
# a prompt and a value, it just has a string representing what will show
# up as text.  In this case the string is"Default Padstyle: RX63Y14D0T". 
# It is always string information.  Yes always.
# 
X            Line (Layer INPUTDIMENSIONS) (Origin -49, 0) (EndPoint -49, 170)
X            Line (Layer INPUTDIMENSIONS) (Origin 49, 0) (EndPoint 49, 170)
X            Line (Layer INPUTDIMENSIONS) (Origin -49, 155) (EndPoint -99, 155)
X            Line (Layer INPUTDIMENSIONS) (Origin 49, 155) (EndPoint 99, 155)
X            Line (Layer INPUTDIMENSIONS) (Origin -49, 155) (EndPoint -59, 160)
X            Line (Layer INPUTDIMENSIONS) (Origin -49, 155) (EndPoint -59, 150)
X            Line (Layer INPUTDIMENSIONS) (Origin -59, 160) (EndPoint -59, 150)
X            Line (Layer INPUTDIMENSIONS) (Origin 49, 155) (EndPoint 59, 160)
X            Line (Layer INPUTDIMENSIONS) (Origin 49, 155) (EndPoint 59, 150)
X            Line (Layer INPUTDIMENSIONS) (Origin 59, 160) (EndPoint 59, 150)
X            Text (Layer INPUTDIMENSIONS) (Origin 0, 175) (Text "A") (Justify LOWERCENTER) (TextStyle "H50S3")
X            Line (Layer INPUTDIMENSIONS) (Origin -75, 0) (EndPoint -75, 245)
X            Line (Layer INPUTDIMENSIONS) (Origin 75, 0) (EndPoint 75, 245)
X            Line (Layer INPUTDIMENSIONS) (Origin -75, 230) (EndPoint 75, 230)
X            Line (Layer INPUTDIMENSIONS) (Origin -75, 230) (EndPoint -65, 235)
X            Line (Layer INPUTDIMENSIONS) (Origin -75, 230) (EndPoint -65, 225)
X            Line (Layer INPUTDIMENSIONS) (Origin -65, 235) (EndPoint -65, 225)
X            Line (Layer INPUTDIMENSIONS) (Origin 75, 230) (EndPoint 65, 235)
X            Line (Layer INPUTDIMENSIONS) (Origin 75, 230) (EndPoint 65, 225)
X            Line (Layer INPUTDIMENSIONS) (Origin 65, 235) (EndPoint 65, 225)
X            Text (Layer INPUTDIMENSIONS) (Origin 0, 250) (Text "L") (Justify LOWERCENTER) (TextStyle "H50S3")
X            Line (Layer INPUTDIMENSIONS) (Origin 0, 80) (EndPoint 164, 80)
X            Line (Layer INPUTDIMENSIONS) (Origin 0, -80) (EndPoint 164, -80)
X            Line (Layer INPUTDIMENSIONS) (Origin 149, 80) (EndPoint 149, -80)
X            Line (Layer INPUTDIMENSIONS) (Origin 149, 80) (EndPoint 144, 70)
X            Line (Layer INPUTDIMENSIONS) (Origin 149, 80) (EndPoint 154, 70)
X            Line (Layer INPUTDIMENSIONS) (Origin 144, 70) (EndPoint 154, 70)
X            Line (Layer INPUTDIMENSIONS) (Origin 149, -80) (EndPoint 144, -70)
X            Line (Layer INPUTDIMENSIONS) (Origin 149, -80) (EndPoint 154, -70)
X            Line (Layer INPUTDIMENSIONS) (Origin 144, -70) (EndPoint 154, -70)
X            Text (Layer INPUTDIMENSIONS) (Origin 169, 0) (Text "B") (Justify LEFT) (TextStyle "H50S3")
X            Line (Layer INPUTDIMENSIONS) (Origin -57.5, 45) (EndPoint -172.5, 45)
X            Line (Layer INPUTDIMENSIONS) (Origin -57.5, 15) (EndPoint -172.5, 15)
X            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 45) (EndPoint -157.5, 95)
X            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 15) (EndPoint -157.5, -35)
X            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 45) (EndPoint -162.5, 55)
X            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 45) (EndPoint -152.5, 55)
X            Line (Layer INPUTDIMENSIONS) (Origin -162.5, 55) (EndPoint -152.5, 55)
X            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 15) (EndPoint -162.5, 5)
X            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 15) (EndPoint -152.5, 5)
X            Line (Layer INPUTDIMENSIONS) (Origin -162.5, 5) (EndPoint -152.5, 5)
X            Text (Layer INPUTDIMENSIONS) (Origin -177.5, 30) (Text "P") (Justify RIGHT) (TextStyle "H50S3")
X            Line (Layer INPUTDIMENSIONS) (Origin -75, 0) (EndPoint -75, -170)
X            Line (Layer INPUTDIMENSIONS) (Origin -40, 0) (EndPoint -40, -170)
X            Line (Layer INPUTDIMENSIONS) (Origin -75, -155) (EndPoint -125, -155)
X            Line (Layer INPUTDIMENSIONS) (Origin -40, -155) (EndPoint 10, -155)
X            Line (Layer INPUTDIMENSIONS) (Origin -75, -155) (EndPoint -85, -150)
X            Line (Layer INPUTDIMENSIONS) (Origin -75, -155) (EndPoint -85, -160)
X            Line (Layer INPUTDIMENSIONS) (Origin -85, -150) (EndPoint -85, -160)
X            Line (Layer INPUTDIMENSIONS) (Origin -40, -155) (EndPoint -30, -150)
X            Line (Layer INPUTDIMENSIONS) (Origin -40, -155) (EndPoint -30, -160)
X            Line (Layer INPUTDIMENSIONS) (Origin -30, -150) (EndPoint -30, -160)
X            Text (Layer INPUTDIMENSIONS) (Origin -57.5, -175) (Text "T") (Justify UPPERCENTER) (TextStyle "H50S3")
X            Line (Layer DIMENSION) (Origin -49, 0) (EndPoint -49, 170)
X            Line (Layer DIMENSION) (Origin 49, 0) (EndPoint 49, 170)
X            Line (Layer DIMENSION) (Origin -49, 155) (EndPoint -99, 155)
X            Line (Layer DIMENSION) (Origin 49, 155) (EndPoint 99, 155)
X            Line (Layer DIMENSION) (Origin -49, 155) (EndPoint -59, 160)
X            Line (Layer DIMENSION) (Origin -49, 155) (EndPoint -59, 150)
X            Line (Layer DIMENSION) (Origin -59, 160) (EndPoint -59, 150)
X            Line (Layer DIMENSION) (Origin 49, 155) (EndPoint 59, 160)
X            Line (Layer DIMENSION) (Origin 49, 155) (EndPoint 59, 150)
X            Line (Layer DIMENSION) (Origin 59, 160) (EndPoint 59, 150)
X            Text (Layer DIMENSION) (Origin 0, 175) (Text "98") (Justify LOWERCENTER) (TextStyle "H50S3")
X            Line (Layer DIMENSION) (Origin -75, 0) (EndPoint -75, 245)
X            Line (Layer DIMENSION) (Origin 75, 0) (EndPoint 75, 245)
X            Line (Layer DIMENSION) (Origin -75, 230) (EndPoint 75, 230)
X            Line (Layer DIMENSION) (Origin -75, 230) (EndPoint -65, 235)
X            Line (Layer DIMENSION) (Origin -75, 230) (EndPoint -65, 225)
X            Line (Layer DIMENSION) (Origin -65, 235) (EndPoint -65, 225)
X            Line (Layer DIMENSION) (Origin 75, 230) (EndPoint 65, 235)
X            Line (Layer DIMENSION) (Origin 75, 230) (EndPoint 65, 225)
X            Line (Layer DIMENSION) (Origin 65, 235) (EndPoint 65, 225)
X            Text (Layer DIMENSION) (Origin 0, 250) (Text "150") (Justify LOWERCENTER) (TextStyle "H50S3")
X            Line (Layer DIMENSION) (Origin 0, 80) (EndPoint 164, 80)
X            Line (Layer DIMENSION) (Origin 0, -80) (EndPoint 164, -80)
X            Line (Layer DIMENSION) (Origin 149, 80) (EndPoint 149, -80)
X            Line (Layer DIMENSION) (Origin 149, 80) (EndPoint 144, 70)
X            Line (Layer DIMENSION) (Origin 149, 80) (EndPoint 154, 70)
X            Line (Layer DIMENSION) (Origin 144, 70) (EndPoint 154, 70)
X            Line (Layer DIMENSION) (Origin 149, -80) (EndPoint 144, -70)
X            Line (Layer DIMENSION) (Origin 149, -80) (EndPoint 154, -70)
X            Line (Layer DIMENSION) (Origin 144, -70) (EndPoint 154, -70)
X            Text (Layer DIMENSION) (Origin 169, 0) (Text "160") (Justify LEFT) (TextStyle "H50S3")
X            Line (Layer DIMENSION) (Origin -57.5, 45) (EndPoint -172.5, 45)
X            Line (Layer DIMENSION) (Origin -57.5, 15) (EndPoint -172.5, 15)
X            Line (Layer DIMENSION) (Origin -157.5, 45) (EndPoint -157.5, 95)
X            Line (Layer DIMENSION) (Origin -157.5, 15) (EndPoint -157.5, -35)
X            Line (Layer DIMENSION) (Origin -157.5, 45) (EndPoint -162.5, 55)
X            Line (Layer DIMENSION) (Origin -157.5, 45) (EndPoint -152.5, 55)
X            Line (Layer DIMENSION) (Origin -162.5, 55) (EndPoint -152.5, 55)
X            Line (Layer DIMENSION) (Origin -157.5, 15) (EndPoint -162.5, 5)
X            Line (Layer DIMENSION) (Origin -157.5, 15) (EndPoint -152.5, 5)
X            Line (Layer DIMENSION) (Origin -162.5, 5) (EndPoint -152.5, 5)
X            Text (Layer DIMENSION) (Origin -177.5, 30) (Text "30") (Justify RIGHT) (TextStyle "H50S3")
X            Line (Layer DIMENSION) (Origin -75, 0) (EndPoint -75, -170)
X            Line (Layer DIMENSION) (Origin -40, 0) (EndPoint -40, -170)
X            Line (Layer DIMENSION) (Origin -75, -155) (EndPoint -125, -155)
X            Line (Layer DIMENSION) (Origin -40, -155) (EndPoint 10, -155)
X            Line (Layer DIMENSION) (Origin -75, -155) (EndPoint -85, -150)
X            Line (Layer DIMENSION) (Origin -75, -155) (EndPoint -85, -160)
X            Line (Layer DIMENSION) (Origin -85, -150) (EndPoint -85, -160)
X            Line (Layer DIMENSION) (Origin -40, -155) (EndPoint -30, -150)
X            Line (Layer DIMENSION) (Origin -40, -155) (EndPoint -30, -160)
X            Line (Layer DIMENSION) (Origin -30, -150) (EndPoint -30, -160)
X            Text (Layer DIMENSION) (Origin -57.5, -175) (Text "35") (Justify UPPERCENTER) (TextStyle "H50S3")
X            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "RefDes" "RefDes") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
X            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "Type" "DEV") (Justify CENTER) (TextStyle "H50S3")
X            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "PN" "PN") (Justify CENTER) (TextStyle "H50S3")
X            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "DEV" "DEV") (Justify CENTER) (TextStyle "H50S3")
X            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "VAL" "VAL") (Justify CENTER) (TextStyle "H50S3")
X            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "TOL" "TOL") (Justify CENTER) (TextStyle "H50S3")
X            Attribute (Layer TOP_ASSEMBLY) (Origin 0, 0) (Attr "RefDes2" "RefDes2") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
X            Attribute (Layer USER1) (Origin 0, 0) (Attr "UserDefined1" "SYM_REV=A0") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
X            Attribute (Layer USER1) (Origin 0, 0) (Attr "UserDefined2" "CREATED_DATE") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
X            Attribute (Layer USER1) (Origin 0, 0) (Attr "UserDefined3" "ULTEMPLATE=Unknown") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
X            Line (Layer PIN_DETAIL) (Origin 366, 670) (EndPoint 266, 670)
X            Line (Layer PIN_DETAIL) (Origin 266, 670) (EndPoint 216, 570)
X            Line (Layer PIN_DETAIL) (Origin 216, 570) (EndPoint 266, 470)
X            Line (Layer PIN_DETAIL) (Origin 266, 470) (EndPoint 366, 470)
X            Line (Layer PIN_DETAIL) (Origin 216, 570) (EndPoint 166, 570)
X            Line (Layer PIN_DETAIL) (Origin 166, 570) (EndPoint 136, 450)
X            Line (Layer PIN_DETAIL) (Origin 150, 430) (EndPoint 180, 550)
X            Line (Layer PIN_DETAIL) (Origin 180, 550) (EndPoint 226, 550)
X            Line (Layer PIN_DETAIL) (Origin 363, 443) (EndPoint 394, 579)
X            Line (Layer PIN_DETAIL) (Origin 394, 579) (EndPoint 350, 610)
X            Line (Layer PIN_DETAIL) (Origin 350, 610) (EndPoint 383, 708)
X            Line (Layer PIN_DETAIL) (Origin 150, 430) (EndPoint 80, 430)
X            Line (Layer PIN_DETAIL) (Origin 80, 430) (EndPoint 80, 450)
X            Line (Layer PIN_DETAIL) (Origin 136, 450) (EndPoint 80, 450)
X            Line (Layer PIN_DETAIL) (Origin 178, 430) (EndPoint 52, 430)
X            Line (Layer PIN_DETAIL) (Origin 52, 430) (EndPoint 52, 420)
X            Line (Layer PIN_DETAIL) (Origin 52, 420) (EndPoint 178, 420)
X            Line (Layer PIN_DETAIL) (Origin 178, 420) (EndPoint 178, 430)
X            Line (Layer PIN_DETAIL) (Origin 150, 420) (EndPoint 150, 380)
X            Line (Layer PIN_DETAIL) (Origin 178, 420) (EndPoint 178, 400)
X            Line (Layer PIN_DETAIL) (Origin 150, 405) (EndPoint 178, 405)
X            Text (Layer PIN_DETAIL) (Origin 164, 395) (Text "14") (Justify UPPERLEFT) (TextStyle "H50S3")
X            Line (Layer PIN_DETAIL) (Origin 150, 405) (EndPoint 160, 400)
X            Line (Layer PIN_DETAIL) (Origin 160, 400) (EndPoint 160, 410)
X            Line (Layer PIN_DETAIL) (Origin 160, 410) (EndPoint 150, 405)
X            Line (Layer PIN_DETAIL) (Origin 178, 405) (EndPoint 168, 410)
X            Line (Layer PIN_DETAIL) (Origin 168, 410) (EndPoint 168, 400)
X            Line (Layer PIN_DETAIL) (Origin 168, 400) (EndPoint 178, 405)
X            Line (Layer PIN_DETAIL) (Origin 52, 420) (EndPoint 52, 400)
X            Line (Layer PIN_DETAIL) (Origin 80, 420) (EndPoint 80, 380)
X            Line (Layer PIN_DETAIL) (Origin 52, 405) (EndPoint 80, 405)
X            Text (Layer PIN_DETAIL) (Origin 66, 395) (Text "14") (Justify UPPERRIGHT) (TextStyle "H50S3")
X            Line (Layer PIN_DETAIL) (Origin 52, 405) (EndPoint 62, 410)
X            Line (Layer PIN_DETAIL) (Origin 62, 410) (EndPoint 62, 400)
X            Line (Layer PIN_DETAIL) (Origin 62, 400) (EndPoint 52, 405)
X            Line (Layer PIN_DETAIL) (Origin 80, 405) (EndPoint 70, 400)
X            Line (Layer PIN_DETAIL) (Origin 70, 400) (EndPoint 70, 410)
X            Line (Layer PIN_DETAIL) (Origin 70, 410) (EndPoint 80, 405)
X            Line (Layer PIN_DETAIL) (Origin 150, 385) (EndPoint 80, 385)
X            Text (Layer PIN_DETAIL) (Origin 115, 380) (Text "35") (Justify UPPERCENTER) (TextStyle "H50S3")
X            Line (Layer PIN_DETAIL) (Origin 80, 385) (EndPoint 90, 380)
X            Line (Layer PIN_DETAIL) (Origin 90, 380) (EndPoint 90, 390)
X            Line (Layer PIN_DETAIL) (Origin 90, 390) (EndPoint 80, 385)
X            Line (Layer PIN_DETAIL) (Origin 150, 385) (EndPoint 140, 390)
X            Line (Layer PIN_DETAIL) (Origin 140, 390) (EndPoint 140, 380)
X            Line (Layer PIN_DETAIL) (Origin 140, 380) (EndPoint 150, 385)
X            Line (Layer PIN_DETAIL) (Origin -262, 430) (EndPoint -238, 430)
X            Line (Layer PIN_DETAIL) (Origin -238, 430) (EndPoint -238, 570)
X            Line (Layer PIN_DETAIL) (Origin -262, 430) (EndPoint -262, 570)
X            Line (Layer PIN_DETAIL) (Origin -262, 450) (EndPoint -238, 450)
X            Line (Layer PIN_DETAIL) (Origin -292, 570) (EndPoint -208, 570)
X            Line (Layer PIN_DETAIL) (Origin -262, 470) (EndPoint -292, 470)
X            Line (Layer PIN_DETAIL) (Origin -238, 470) (EndPoint -208, 470)
X            Line (Layer PIN_DETAIL) (Origin -292, 670) (EndPoint -208, 670)
X            Line (Layer PIN_DETAIL) (Origin -198, 700) (EndPoint -228, 600)
X            Line (Layer PIN_DETAIL) (Origin -228, 600) (EndPoint -188, 540)
X            Line (Layer PIN_DETAIL) (Origin -188, 540) (EndPoint -215, 441)
X            Line (Layer PIN_DETAIL) (Origin -282, 700) (EndPoint -312, 600)
X            Line (Layer PIN_DETAIL) (Origin -312, 600) (EndPoint -272, 540)
X            Line (Layer PIN_DETAIL) (Origin -272, 540) (EndPoint -299, 441)
X            Line (Layer PIN_DETAIL) (Origin -263, 430) (EndPoint -237, 430)
X            Line (Layer PIN_DETAIL) (Origin -263, 420) (EndPoint -237, 420)
X            Line (Layer PIN_DETAIL) (Origin -263, 430) (EndPoint -263, 420)
X            Line (Layer PIN_DETAIL) (Origin -237, 430) (EndPoint -237, 420)
X            Line (Layer PIN_DETAIL) (Origin -263, 400) (EndPoint -263, 420)
X            Line (Layer PIN_DETAIL) (Origin -237, 400) (EndPoint -237, 420)
X            Line (Layer PIN_DETAIL) (Origin -263, 405) (EndPoint -293, 405)
X            Line (Layer PIN_DETAIL) (Origin -263, 405) (EndPoint -273, 410)
X            Line (Layer PIN_DETAIL) (Origin -273, 410) (EndPoint -273, 400)
X            Line (Layer PIN_DETAIL) (Origin -273, 400) (EndPoint -263, 405)
X            Line (Layer PIN_DETAIL) (Origin -237, 405) (EndPoint -207, 405)
X            Line (Layer PIN_DETAIL) (Origin -237, 405) (EndPoint -227, 410)
X            Line (Layer PIN_DETAIL) (Origin -227, 410) (EndPoint -227, 400)
X            Line (Layer PIN_DETAIL) (Origin -227, 400) (EndPoint -237, 405)
X            Text (Layer PIN_DETAIL) (Origin -197, 385) (Text "14") (Justify LOWERLEFT) (TextStyle "H50S3")
X            Line (Layer PIN_DETAIL) (Origin -262, 380) (EndPoint -262, 420)
X            Line (Layer PIN_DETAIL) (Origin -238, 380) (EndPoint -238, 420)
X            Line (Layer PIN_DETAIL) (Origin -262, 385) (EndPoint -292, 385)
X            Line (Layer PIN_DETAIL) (Origin -262, 385) (EndPoint -272, 390)
X            Line (Layer PIN_DETAIL) (Origin -272, 390) (EndPoint -272, 380)
X            Line (Layer PIN_DETAIL) (Origin -272, 380) (EndPoint -262, 385)
X            Line (Layer PIN_DETAIL) (Origin -238, 385) (EndPoint -208, 385)
X            Line (Layer PIN_DETAIL) (Origin -238, 385) (EndPoint -228, 390)
X            Line (Layer PIN_DETAIL) (Origin -228, 390) (EndPoint -228, 380)
X            Line (Layer PIN_DETAIL) (Origin -228, 380) (EndPoint -238, 385)
X            Text (Layer PIN_DETAIL) (Origin -198, 385) (Text "12") (Justify UPPERLEFT) (TextStyle "H50S3")
X            Text (Layer PIN_DETAIL) (Origin -50, 570) (Text "(2x Scale)") (Justify CENTER) (TextStyle "H50S3")
X            Line (Layer TOP_SILKSCREEN) (Origin -49, 80) (EndPoint -49, 65.1000003814697) (Width 6)
X            Line (Layer TOP_SILKSCREEN) (Origin -49, -80) (EndPoint 49, -80) (Width 6)
X            Line (Layer TOP_SILKSCREEN) (Origin 49, -80) (EndPoint 49, -65.1000003814697) (Width 6)
X            Line (Layer TOP_SILKSCREEN) (Origin 49, 80) (EndPoint -49, 80) (Width 6)
X            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=10,100") (Width 6)  (-49, 80) (-49, -80) (49, -80) (49, 80)
X            Arc (Layer TOP_SILKSCREEN) (Origin 0, 80) (Radius 12) (StartAngle 180) (SweepAngle 180) (Width 6)
X            Line (Layer TOP_ASSEMBLY) (Origin -49, 80) (EndPoint -49, -80)
X            Line (Layer TOP_ASSEMBLY) (Origin -49, -80) (EndPoint 49, -80)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, -80) (EndPoint 49, 80)
X            Line (Layer TOP_ASSEMBLY) (Origin 49, 80) (EndPoint -49, 80)
X            Arc (Layer TOP_ASSEMBLY) (Origin 0, 80) (Radius 12) (StartAngle 180) (SweepAngle 180)
# 
# Below, the "Wizard" entity type is considered a system variable.  This
# variable will always represent some user entered field that was used on
# calculating or creating your footprint.
# 
X            Wizard (Origin 0, 0) (VarName "TEMPLATE") (VarData "ADI_SO_C2.adt")
X            Wizard (Origin 0, 0) (VarName "NAME") (VarData "")
X            Wizard (Origin 0, 0) (VarName "N") (VarData "8")
X            Wizard (Origin 0, 0) (VarName "A") (VarData "98")
X            Wizard (Origin 0, 0) (VarName "L") (VarData "150")
X            Wizard (Origin 0, 0) (VarName "LM") (VarData "0")
X            Wizard (Origin 0, 0) (VarName "P") (VarData "30")
X            Wizard (Origin 0, 0) (VarName "B") (VarData "160")
X            Wizard (Origin 0, 0) (VarName "T") (VarData "35")
X            Wizard (Origin 0, 0) (VarName "W") (VarData "12")
X            Wizard (Origin 0, 0) (VarName "NT") (VarData "Arc")
X            Wizard (Origin 0, 0) (VarName "TT") (VarData "Normal Material")
X            Wizard (Origin 0, 0) (VarName "UTOE") (VarData "0")
X            Wizard (Origin 0, 0) (VarName "UHEEL") (VarData "0")
X            Wizard (Origin 0, 0) (VarName "USIDE") (VarData "0")
X            Wizard (Origin 0, 0) (VarName "KO") (VarData "0")
X            Wizard (Origin 0, 0) (VarName "KOW") (VarData "78.74")
X            Wizard (Origin 0, 0) (VarName "KOH") (VarData "78.74")
X            Wizard (Origin 0, 0) (VarName "HTT") (VarData "0")
X            Wizard (Origin 0, 0) (VarName "HTW") (VarData "82.677")
X            Wizard (Origin 0, 0) (VarName "HTH") (VarData "82.677")
X            Wizard (Origin 0, 0) (VarName "A1_PSH") (VarData "Oblong")
X            Wizard (Origin 0, 0) (VarName "A1_PADW") (VarData "60")
X            Wizard (Origin 0, 0) (VarName "A1_PADH") (VarData "90")
X            Wizard (Origin 0, 0) (VarName "A1_DRL") (VarData "30")
X            Wizard (Origin 0, 0) (VarName "A2_PSH") (VarData "Oblong")
X            Wizard (Origin 0, 0) (VarName "A2_PADW") (VarData "90")
X            Wizard (Origin 0, 0) (VarName "A2_PADH") (VarData "60")
X            Wizard (Origin 0, 0) (VarName "A2_DRL") (VarData "30")
X            Wizard (Origin 0, 0) (VarName "PPCK") (VarData "0")
X            Wizard (Origin 0, 0) (VarName "PPPSH") (VarData "Round")
X            Wizard (Origin 0, 0) (VarName "PPPSZ") (VarData "60")
X            Wizard (Origin 0, 0) (VarName "PPDS") (VarData "35")
X            Wizard (Origin 0, 0) (VarName "PPGC") (VarData "2")
X            Wizard (Origin 0, 0) (VarName "PPGR") (VarData "2")
X            Wizard (Origin 0, 0) (VarName "PPGP") (VarData "100")
X            Wizard (Origin 0, 0) (VarName "MWA") (VarData "4")
X            Wizard (Origin 0, 0) (VarName "RSMB") (VarData "2")
X            Wizard (Origin 0, 0) (VarName "ISML") (VarData "0")
X            Wizard (Origin 0, 0) (VarName "CHGT") (VarData "100")
X            Wizard (Origin 0, 0) (VarName "CMHGT") (VarData "10")
X            Wizard (Origin 0, 0) (VarName "PROT") (VarData "0")
X            Wizard (Origin 0, 0) (VarName "REVLEVEL") (VarData "A0")
X            Wizard (Origin 0, 0) (VarName "OriginalPinCount") (VarData "8")
X            Line (Layer TOP_SILKSCREEN) (Origin -49, -65.1000003814697) (EndPoint -49, -80) (Width 6)
X            Line (Layer TOP_SILKSCREEN) (Origin 49, 65.1000003814697) (EndPoint 49, 80) (Width 6)
X        EndData
X    EndPattern
# 
# Schematic symbols
# 	
# The symbol is laid out similar to the footprint.  Only details not
# defined above will be commented on.
# 
#Symbols
Symbols : 1
X    Symbol "so8-p30-a98"
X        OriginPoint  (0, 0)
X        OriginalName ""
X        Data         : 14
X            Pin (PinNum 1) (Origin -400, 200) (PinLength 100) (Rotate 180) (Width 8) (IsVisible True)
X                PinDes "1" (-420, 250) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
X                PinName "1" (-380, 200) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
# 
# The pin is equivelant in many ways to the footprint pad.  It must have a
# number and a designator.  Each symbol must have all of its pins assigned
# a number between one and the total number of pins with no gaps or
# duplicates in the numbers used.  Each pin requires an Orgin, PinLength
# attribute as well as the PinDes (pin designator) that will appear to the
# user.  The designator is ALWAYS  text.  Yes, always, even when it looks
# like a number.  The PinName is the text field that will be filled out
# with the pins function name. 
# 
X            Pin (PinNum 2) (Origin -400, 100) (PinLength 100) (Rotate 180) (Width 8) (IsVisible True)
X                PinDes "2" (-420, 150) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
X                PinName "2" (-380, 100) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
X            Pin (PinNum 3) (Origin -400, 0) (PinLength 100) (Rotate 180) (Width 8) (IsVisible True)
X                PinDes "3" (-420, 50) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
X                PinName "3" (-380, 0) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
X            Pin (PinNum 4) (Origin -400, -100) (PinLength 100) (Rotate 180) (Width 8) (IsVisible True)
X                PinDes "4" (-420, -50) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
X                PinName "4" (-380, -100) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
X            Pin (PinNum 5) (Origin 400, 200) (PinLength 100) (Width 8) (IsVisible True)
X                PinDes "5" (420, 150) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
X                PinName "5" (380, 200) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
X            Pin (PinNum 6) (Origin 400, 100) (PinLength 100) (Width 8) (IsVisible True)
X                PinDes "6" (420, 50) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
X                PinName "6" (380, 100) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
X            Pin (PinNum 7) (Origin 400, 0) (PinLength 100) (Width 8) (IsVisible True)
X                PinDes "7" (420, -50) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
X                PinName "7" (380, 0) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
X            Pin (PinNum 8) (Origin 400, -100) (PinLength 100) (Width 8) (IsVisible True)
X                PinDes "8" (420, -150) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
X                PinName "8" (380, -100) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
X            Line (Origin -400, 300) (EndPoint -400, -200) (Width 10)
X            Line (Origin 400, -200) (EndPoint -400, -200) (Width 10)
X            Line (Origin 400, -200) (EndPoint 400, 300) (Width 10)
X            Line (Origin 400, 300) (EndPoint -400, 300) (Width 10)
X            Attribute (Origin 0, 350) (Attr "RefDes" "RefDes") (IsVisible True) (Justify Center) (TextStyleRef "h125s6")
X            Attribute (Origin 0, -275) (Attr "Type" "Type") (IsVisible True) (Justify Center) (TextStyleRef "h125s6")
X        EndData
X    EndSymbol
# 
# Component Section
# 	
# A component is what ties the footprint and symbol together in our tool. 
# It contains a pointer to the footprint and the symbols that are used, as
# well as defining what pins can be swapped or which symbols can be swapped.
# 
#Components
Components : 1
X    Component "so8-p30-a98"
X        PatternName   "so8-p30-a98"
# 
# Currently only one footprint can be assigned to a component.  This area
# may be enhanced in the future to have an array available for alternate
# footprints.
# 
X        OriginalName  "so8-p30-a98"
X        SourceLibrary ""
X        RefDesPrefix  "U"
X        NumberofPins  8
X        NumParts      1
# 
# This refers to how many schematic symbols are required to completely
# represent this component.  That could be one symbol, as in this case, ot
# it could be 10 different symbols, or it could be four identical symbols.
# 
X        Composition   Heterogeneous
# 
# This can be hetrogeneous, as in each symbol is distinctly different, or
# homogeneous, as in each symbol is a duplicate of the other (like a 7400
# which has 4 identical symbols or gates).
# 
X        AltIEEE       False
# 
# Is there also an alternate symbol in IEEE format available?
# 
X        AltDeMorgan   False
# 
# Is there a Demorgan view of the symbol?
# 
X        PatternPins   8
X        Revision Level
X        Revision Note 
X        CompPins         : 8
X            CompPin 1 "1" (PartNum 1) (SymPinNum 1) (GateEq 0) (PinEq 0) (PinType Any) (Side Left) (Group 1)
# 
# The CompPin number refers to the arbitrarily numbered one to pin count
# no gaps no duplicates numbering assigned.  It is typically the same as
# the numbering of a numbered part, but does not have to be.  This number
# is used later in the PinMap to define the padnumber used in the
# footprint.  In the PinMap area this is called the CompPinRef.  Next to
# the CompPin is the Pin Designator that the user will see in almost all
# instances.  This is ALWAYS a string (yes always), and it can contain
# alpha numerics.  It should also be the same as what the designator is on
# the symbol and the footprint, but if not, this will ALWAYS take presidence.
# 
X            CompPin 2 "2" (PartNum 1) (SymPinNum 2) (GateEq 0) (PinEq 0) (PinType Any) (Side Left) (Group 1)
# 
# The PartNum property refers to which symbol in the collection of symbols
# for this component.  This component only has one symbol used, so all of
# the refereences to PartNum will be one.  SymPinNum is the number of the
# pin in the symbol that is being mapped.  It will always be a number, and
# will always be less than or equal to the number of pins carried on a symbol.
# 
# Gate eq and pin eq refer to gate (symbol) and pin swapability.  These
# can be 0, in which case they swap with no one, or they can be a whole
# number that matches those pins and or gates that are swappable.
# 
# PinType can be any of the following:  Input, OutPut, Bi-Directional,
# Any,  Power, TriState, Analog
# 
# Sides can be Top, Bottom, Left and Right,
# 
# Grouping will deal with the placement of the pins in the symbol. 
# Groupings with the same number will be grouped on the symbol together
# irregardless of how they appear in the spreadsheet.
# 
X            CompPin 3 "3" (PartNum 1) (SymPinNum 3) (GateEq 0) (PinEq 0) (PinType Any) (Side Left) (Group 1)
X            CompPin 4 "4" (PartNum 1) (SymPinNum 4) (GateEq 0) (PinEq 0) (PinType Any) (Side Left) (Group 1)
X            CompPin 5 "5" (PartNum 1) (SymPinNum 5) (GateEq 0) (PinEq 0) (PinType Any) (Side Right) (Group 1)
X            CompPin 6 "6" (PartNum 1) (SymPinNum 6) (GateEq 0) (PinEq 0) (PinType Any) (Side Right) (Group 1)
X            CompPin 7 "7" (PartNum 1) (SymPinNum 7) (GateEq 0) (PinEq 0) (PinType Any) (Side Right) (Group 1)
X            CompPin 8 "8" (PartNum 1) (SymPinNum 8) (GateEq 0) (PinEq 0) (PinType Any) (Side Right) (Group 1)
X        EndCompPins
X        CompData         : 7
X            Wizard (Origin 0, 0) (Number 1) (VarName "TEMPLATE") (VarData "TableSymbol_Dual.ads")
#
# This information, similar to what was in the footprint, is input into
# the wizard for rebuilding a symbol.  In each case, the VarName is the
# name of the variable in the template to be filled in, and is enclosed in
# quotes and always text.  Yes always.  The VarData is the actual value of
# the variable.
# 
X            Wizard (Origin 0, 0) (Number 1) (VarName "NAME") (VarData "so8-p30-a98")
X            Wizard (Origin 0, 0) (Number 1) (VarName "PL") (VarData "100")
X            Wizard (Origin 0, 0) (Number 1) (VarName "OV") (VarData "1")
X            Wizard (Origin 0, 0) (Number 1) (VarName "NST") (VarData "Top Down")
X            Wizard (Origin 0, 0) (Number 1) (VarName "PD") (VarData "100")
X            Wizard (Origin 0, 0) (Number 1) (VarName "PN") (VarData "300")
X        EndCompData
X        AttachedSymbols  : 1
X           AttachedSymbol (PartNum 1) (AltType Normal) (SymbolName "so8-p30-a98")
X        EndAttachedSymbols
X        PinMap       : 8
X            PadNum 1 (CompPinRef "1")
X            PadNum 2 (CompPinRef "2")
# 
# The pinMap is designed to identify the ComPPin (in the section above)
# with the PadNum in the footprint.  This section is not available if
# there is no footprint.
# 
X            PadNum 3 (CompPinRef "3")
X            PadNum 4 (CompPinRef "4")
X            PadNum 5 (CompPinRef "5")
X            PadNum 6 (CompPinRef "6")
X            PadNum 7 (CompPinRef "7")
X            PadNum 8 (CompPinRef "8")
X        EndPinMap
X    EndComponent
# 
# Future Expeansion
#WorkSpace
X    WorkSpaceSize (LowerLeft 0, 0)(UpperRight 0, 0)
#EndWorkSpace
# 
# 
# Future Expeansion 	Component Instances
ComponentInstances : 0
#EndComponentInstances
# 
# Future Expeansion 	
X
#Via Instances
ViaInstances : 0
#EndViaInstances
# 
#NetListInfo
Nets : 0
#EndNets
# 
#Schmatic
SchematicData :
X    Units "mil"
X    WorkSpace (LL 0,0) (UR 0,0) (Grid 0)
# 
#EndSchematic
# 
#SchematicSheets
Sheets : 0
#EndSchematicSheets
# 
#LayerData
Layers : 0
#EndLayerData
# 
#LayerTechnicalData
LayerTechnicalData : 0
#EndLayerTechnicalData
# 
# End of File
# 
# <file:///C:/UltraLibrarian/Help/index.html>
# Copyright  1999-2007 Accelerated Designs, Inc.  All Rights Reserved.
SHAR_EOF
  (set 20 08 04 19 09 41 45 'XLR_Format.txt'
   eval "${shar_touch}") && \
  chmod 0644 'XLR_Format.txt'
if test $? -ne 0
then ${echo} "restore of XLR_Format.txt failed"
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'XLR_Format.txt': 'MD5 check failed'
       ) << \SHAR_EOF
0275a7d193fc765d7409f762139ee2f6  XLR_Format.txt
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'XLR_Format.txt'` -ne 48486 && \
  ${echo} "restoration warning:  size of 'XLR_Format.txt' is not 48486"
  fi
fi
# ============= xlr.h ==============
if test -n "${keep_file}" && test -f 'xlr.h'
then
${echo} "x - SKIPPING xlr.h (file already exists)"
else
${echo} "x - extracting xlr.h (text)"
  sed 's/^X//' << 'SHAR_EOF' > 'xlr.h' &&
/*
X * ed.h
X */
#ifndef E_H
#define E_H
X
#ifndef global
#define global extern
#endif
X
#define YYDEBUG 1
X
#define IDENT_LENGTH            255
#define Malloc(s)               malloc(s)
#define Free(p)                 free(p)
#define ABS(v)                  ((v) < 0 ? -(v) : (v))
#define Getc(s)                 getc(s)
#define Ungetc(c)               ungetc(c,Input);
X
extern int atoi();
extern int bug;
X
struct inst {
X  char          *ins, *sym;
X  struct inst   *nxt;
};
X
char *cur_nnam;
X
struct con  {
X  char          *ref;
X  char          *pin;
X  char          *nnam;
X  struct con    *nxt;
};
X
struct FigGrpStruct {
X        char Name[20];
X        int  PathWidth, Color, TextHeight, Visible;
X        struct FigGrpStruct * nxt;
X        }; 
X
struct plst { int x, y; struct plst *nxt;};
struct st   { char *s; struct plst *p; int n; struct st *nxt;};
struct pwr  { char *s, *r ; struct pwr *nxt;};
X
#endif
X
/*
ViewRef :       VIEWREF ViewNameRef _ViewRef PopC
X                {
X                $$=$2; if(bug>2)fprintf(Error,"ViewRef: %25s ", $3);
X                iptr = (struct inst *)Malloc(sizeof (struct inst));
X                iptr->sym = $3;
X                iptr->nxt = insts;
X                insts = iptr;
X                }
*/
SHAR_EOF
  (set 20 08 04 15 12 46 14 'xlr.h'
   eval "${shar_touch}") && \
  chmod 0644 'xlr.h'
if test $? -ne 0
then ${echo} "restore of xlr.h failed"
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'xlr.h': 'MD5 check failed'
       ) << \SHAR_EOF
832f788e2bc85f35487a96b20e0ff7a8  xlr.h
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'xlr.h'` -ne 1230 && \
  ${echo} "restoration warning:  size of 'xlr.h' is not 1230"
  fi
fi
# ============= xlr.sh ==============
if test -n "${keep_file}" && test -f 'xlr.sh'
then
${echo} "x - SKIPPING xlr.sh (file already exists)"
else
${echo} "x - extracting xlr.sh (text)"
  sed 's/^X//' << 'SHAR_EOF' > 'xlr.sh' &&
#!/bin/sh
# This is a shell archive (produced by GNU sharutils 4.6.3).
# To extract the files from this archive, save it to some FILE, remove
# everything before the `#!/bin/sh' line above, then type `sh FILE'.
#
lock_dir=_sh07152
# Made on 2010-04-07 21:00 MDT by <root@fw>.
# Source directory was `/s/opt/UltraLib'.
#
# Existing files will *not* be overwritten, unless `-c' is specified.
#
# This shar contains:
# length mode       name
# ------ ---------- ------------------------------------------
#    950 -rw-r--r-- x2lib.c
# 127919 -rwxr-xr-x XLR_Format.html
#  48486 -rw-r--r-- XLR_Format.txt
#   1230 -rw-r--r-- xlr.h
#  22834 -rw-r--r-- xlr.y
#
MD5SUM=${MD5SUM-md5sum}
f=`${MD5SUM} --version | egrep '^md5sum .*(core|text)utils'`
test -n "${f}" && md5check=true || md5check=false
${md5check} || \
X  echo 'Note: not verifying md5sums.  Consider installing GNU coreutils.'
save_IFS="${IFS}"
IFS="${IFS}:"
gettext_dir=FAILED
locale_dir=FAILED
first_param="$1"
for dir in $PATH
do
X  if test "$gettext_dir" = FAILED && test -f $dir/gettext \
X     && ($dir/gettext --version >/dev/null 2>&1)
X  then
X    case `$dir/gettext --version 2>&1 | sed 1q` in
X      *GNU*) gettext_dir=$dir ;;
X    esac
X  fi
X  if test "$locale_dir" = FAILED && test -f $dir/shar \
X     && ($dir/shar --print-text-domain-dir >/dev/null 2>&1)
X  then
X    locale_dir=`$dir/shar --print-text-domain-dir`
X  fi
done
IFS="$save_IFS"
if test "$locale_dir" = FAILED || test "$gettext_dir" = FAILED
then
X  echo=echo
else
X  TEXTDOMAINDIR=$locale_dir
X  export TEXTDOMAINDIR
X  TEXTDOMAIN=sharutils
X  export TEXTDOMAIN
X  echo="$gettext_dir/gettext -s"
fi
if (echo "testing\c"; echo 1,2,3) | grep c >/dev/null
then if (echo -n test; echo 1,2,3) | grep n >/dev/null
X     then shar_n= shar_c='
'
X     else shar_n=-n shar_c= ; fi
else shar_n= shar_c='\c' ; fi
f=shar-touch.$$
st1=200112312359.59
st2=123123592001.59
st2tr=123123592001.5 # old SysV 14-char limit
st3=1231235901
X
if touch -am -t ${st1} ${f} >/dev/null 2>&1 && \
X   test ! -f ${st1} && test -f ${f}; then
X  shar_touch='touch -am -t $1$2$3$4$5$6.$7 "$8"'
X
elif touch -am ${st2} ${f} >/dev/null 2>&1 && \
X   test ! -f ${st2} && test ! -f ${st2tr} && test -f ${f}; then
X  shar_touch='touch -am $3$4$5$6$1$2.$7 "$8"'
X
elif touch -am ${st3} ${f} >/dev/null 2>&1 && \
X   test ! -f ${st3} && test -f ${f}; then
X  shar_touch='touch -am $3$4$5$6$2 "$8"'
X
else
X  shar_touch=:
X  echo
X  ${echo} 'WARNING: not restoring timestamps.  Consider getting and'
X  ${echo} 'installing GNU `touch'\'', distributed in GNU coreutils...'
X  echo
fi
rm -f ${st1} ${st2} ${st2tr} ${st3} ${f}
#
if test ! -d ${lock_dir}
then : ; else ${echo} 'lock directory '${lock_dir}' exists'
X  exit 1
fi
if mkdir ${lock_dir}
then ${echo} 'x - created lock directory `'${lock_dir}\''.'
else ${echo} 'x - failed to create lock directory `'${lock_dir}\''.'
X  exit 1
fi
# ============= x2lib.c ==============
if test -f 'x2lib.c' && test "$first_param" != -c; then
X  ${echo} 'x -SKIPPING x2lib.c (file already exists)'
else
${echo} 'x - extracting x2lib.c (text)'
X  sed 's/^X//' << 'SHAR_EOF' > 'x2lib.c' &&
/*
XX * xlr2lib - XLR to KiCad library
XX */
#define global
XX
#include <stdio.h>
#include <string.h>
XX
int bug=0;  		// debug level: 
XX
char *InFile = "-";
XX
char  FileNameNet[64], FileNameLib[64], FileNameEESchema[64], FileNameKiPro[64];
FILE *FileEdf, *FileNet, *FileEESchema=NULL, *FileLib=NULL, *FileKiPro=NULL;
XX
main(int argc, char *argv[])
{
XX  char * version      = "0.97";
XX  char * progname;
XX
XX  progname = strrchr(argv[0],'/');
XX  if (progname)
XX    progname++;
XX  else
XX    progname = argv[0];
XX
XX  fprintf(stderr,"*** %s Version %s ***\n", progname, version);
XX
XX  if( argc != 2 ) {
XX     fprintf(stderr, " usage: XLRfile \n") ; return(1);
XX  }
XX
XX  InFile= argv[1];
XX  if( (FileEdf = fopen( InFile, "r" )) == NULL ) {
XX       fprintf(stderr, " '%s' doesn't exist\n", InFile);
XX       return(-1);
XX  }
XX
XX  fprintf(stderr, "Parsing %s \n", InFile);
XX  ParseXLR(FileEdf, stderr);
XX
XX  fprintf(stderr, "Writting Lib \n");
XX
XX  fprintf(stderr, "BonJour!\n");
XX  return(0);
}
XX
XSHAR_EOF
X  (set 20 08 04 18 17 38 29 'x2lib.c'; eval "$shar_touch") &&
X  chmod 0644 'x2lib.c'
if test $? -ne 0
then ${echo} 'restore of x2lib.c failed'
fi
X  if ${md5check}
X  then (
X       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'x2lib.c: MD5 check failed'
X       ) << SHAR_EOF
df31f3c9587319b3c3b29117db6c902f  x2lib.c
XSHAR_EOF
X  else
test `LC_ALL=C wc -c < 'x2lib.c'` -ne 950 && \
X  ${echo} 'restoration warning:  size of x2lib.c is not 950'
X  fi
fi
# ============= XLR_Format.html ==============
if test -f 'XLR_Format.html' && test "$first_param" != -c; then
X  ${echo} 'x -SKIPPING XLR_Format.html (file already exists)'
else
${echo} 'x - extracting XLR_Format.html (binary)'
X  sed 's/^X//' << 'SHAR_EOF' | uudecode &&
begin 600 XLR_Format.html
M/"%$3T-465!%(&AT;6P@4%5"3$E#("(M+R]7,T,O+T141"!(5$U,(#0N,#$@
M5')A;G-I=&EO;F%L+R]%3B(^#0H\:'1M;#X-"CQH96%D/@T*("`\;65T82!C
M;VYT96YT/2)T97AT+VAT;6P[(&-H87)S970]25-/+3@X-3DM,2(@:'1T<"UE
M<75I=CTB8V]N=&5N="UT>7!E(CX-"B`@/'1I=&QE/EA,4E]&;W)M870\+W1I
M=&QE/@T*/"]H96%D/@T*/&)O9'D^#0H-"CQD:78@<W1Y;&4](F9O;G0M9F%M
M:6QY.B!T<F5B=6-H970@;7,[(B!C;&%S<STB4V5C=&EO;C$B/@T*/'-P86X@
M<W1Y;&4](F9O;G0M=V5I9VAT.B!B;VQD.R(^/"]S<&%N/@T*/&1I=B!S='EL
M93TB=&5X="UA;&EG;CH@8V5N=&5R.R(^/&)I9R!S='EL93TB9F]N="US='EL
M93H@:71A;&EC.R!C;VQO<CH@<F=B*#`L(#`L(#$U,RD[(CX\8FEG/EA,4B!&
M;W)M870\+V)I9SX\+V)I9SX\<W!A;B!S='EL93TB9F]N="UW96EG:'0Z(&)O
M;&0[(CX\+W-P86X^/&)R/@T*#0H\<W!A;B!S='EL93TB9F]N="UW96EG:'0Z
M(&)O;&0[(CX\+W-P86X^/"]D:78^#0H-"CQP('-T>6QE/2)F;VYT+69A;6EL
M>3H@=')E8G5C:&5T(&US.R(^/'-P86X@<W1Y;&4](F9O;G0M=V5I9VAT.B!B
M;VQD.R(^/"]S<&%N/B9N8G-P.R9N8G-P.PT*5&AI<R!D;V-U;65N="!I<R!D
M97-I9VYE9"!T;R!G:79E('1H92!U<V5R(&$@8VQE87)E<@T*=6YD97)S=&%N
M9&EN9R!O9B!T:&4@05-#24D@6$Q2(&9O<FUA="!U<V5D(&)Y($%C8V5L97)A
M=&5D#0I$97-I9VYS+B9N8G-P.PT*5&AI<R!I;G1R;V1U8W1I;VX@:7,@;F]T
M(&$@<W!E8VEF:6-A=&EO;B!B=70@:7,@9&5S:6=N960@=&\@97AP;&%I;B!T
M:&4-"FUA:6X@9FQO=R!O9B!T:&4@9&]C=6UE;G0L('=H870@:7,@8V]N=&%I
M;F5D(&EN('1H92!D:69F97)E;G0@<V5C=&EO;G,L#0IH;W<@=&AE>2!A<F4@
M<F5L871E9"!A;F0@<V]M92!O9B!T:&4@<WEN=&%X(')E<75I<F5M96YT<RXF
M;F)S<#L-"DYO<FUA;&QY#0IT:&ES(&9I;&4@:7,@;6]D:69I960@86YD(&%D
M9&5D('1O(&%S(&YE=R!C87!A8FEL:71I97,@87)E(')E<75I<F5D(&]F#0IT
M:&4@56QT<F$@3&EB<F%R:6%N+B9N8G-P.R!3;R!A;GD@=7-E(&]F('1H:7,@
M9FEL92!M=7-T('1A:V4F;F)S<#L@:6YT;PT*86-C;W5N=`T*=&AE('!O<W-I
M8FEL:71Y(&]F(&%D9&ET:6]N86P@:6YF;W)M871I;VX@:6X@=&AE('-A;64@
M9F]R;6%T+CQB<CX-"@T*/"]P/@T*#0H\<#X\<W!A;B!S='EL93TB9F]N="UF
M86UI;'DZ('1R96)U8VAE="!M<SLB/D)Y(&1E9F%U;'0@86QL('5N:71S(&EN
M('1H90T*9FEL92!A<F4@87-S=6UE9"!T;R!B92!E;F=L:7-H#0IM:6QS+B9N
M8G-P.R!/=&AE<@T*=6YI=',@87)E#0IP;W-S:6)P;&4L(&%N9"!W:6QL(&AA
M=F4@.B)M;2(L(")C;B(L(")I;B(L(&5T8R!A9G1E<B!T:&4@<VEZ92XF;F)S
M<#L-"D%L<V\L#0IN=6UB97)S(&%R92!N;W1E9"!W:71H;W5T('%U;W1E<R!A
M;F0@86QL('1E>'0@:7,@<W5R<F]U;F1E9"!W:71H('%U;W1E<PT*<V\@=&AA
M="!W92!C86X@=&5L;"!T:&4@9&EF9F5R96YC92X\+W-P86X^/&)R/@T*#0H\
M+W`^#0H-"CQD:78@<W1Y;&4](G1E>'0M86QI9VXZ(&-E;G1E<CLB/D5A8V@@
M<V5C=&EO;B!O9B!T:&4@8V]D92!I<R!D97-C<FEB960-"FEN('1H92!T86)L
M92!B96QO=SH@/&)R/@T*#0H\+V1I=CX-"@T*/&)R/@T*#0H\9&EV(&%L:6=N
M/2)C96YT97(B/@T*/'1A8FQE('-T>6QE/2)W:61T:#H@.34E.R(@8F]R9&5R
M/2(Q(B!C96QL<&%D9&EN9STB,"(@8V]L<STB,B(^#0H-"B`@/'1B;V1Y/@T*
M#0H@("`@/'1R/@T*#0H@("`@("`\=&0@<W1Y;&4](G!A9&1I;F<Z(#`N-S5P
M=#L@=VED=&@Z(#(P)3L@9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SL@9F]N
M="UW96EG:'0Z(&)O;&0[(&-O;&]R.B!R9V(H,"P@,"P@,"D[(B!W:61T:#TB
M,C`E(CY3=&5P/"]T9#X-"@T*("`@("`@/'1D('-T>6QE/2)P861D:6YG.B`P
M+C<U<'0[(&9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(&9O;G0M=V5I9VAT
M.B!B;VQD.R!C;VQO<CH@<F=B*#`L(#`L(#`I.R(^4V%M<&QE/"]T9#X-"@T*
M("`@(#PO='(^#0H-"B`@("`\='(^#0H-"B`@("`@(#QT9"!S='EL93TB<&%D
M9&EN9SH@,"XW-7!T.R!V97)T:6-A;"UA;&EG;CH@=&]P.R!W:61T:#H@,C`E
M.R(^/'-P86X@<W1Y;&4](F9O;G0M=V5I9VAT.B!B;VQD.R(^2&5A9&5R#0II
M;F9O<FUA=&EO;CPO<W!A;CX\8G(^#0H-"B`@("`@(#PO=&0^#0H-"B`@("`@
M(#QT9"!S='EL93TB<&%D9&EN9SH@,"XW-7!T.R(^/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B,F;F)S<#LF;F)S<#L-"E5L=')A($QI
M8G)A<FEA;B!';VQD(#(N,"XS-#0@9&%T86)A<V4@9FEL93PO<W!A;CX\8G(@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^(R9N8G-P.R9N8G-P
M.R!#;W!Y<FEG:'0-"B9C;W!Y.R`Q.3DY+3(P,#4@06-C96QE<F%T960@1&5S
M:6=N<RP@26YC+CPO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@P+"`Q
M-3,L(#`I.R(^/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/B,F;F)S<#LF;F)S<#L-"FAT='`Z+R]W=W<N06-C96QE<F%T960M1&5S:6=N
M<RYC;VT\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@P+"`P+"`P*3LB/DYO=&EC92!T:&%T(&-O;6UE;G1S(&%R90T*<')E
M8V5E9&5D(&)Y('1H92!P;W5N9"!S:6=N+B9N8G-P.R!!;GET:&EN9R!F;VQL
M;W=I;F<@:7,@:6=N;W)E9"!B>2!T:&4-"F-O9&4N/"]S<&%N/CQB<CX-"@T*
M("`@("`@/"]S<&%N/CPO=&0^#0H-"B`@("`\+W1R/@T*#0H@("`@/'1R/@T*
M#0H@("`@("`\=&0@<W1Y;&4](G!A9&1I;F<Z(#`N-S5P=#L@=F5R=&EC86PM
M86QI9VXZ('1O<#L@=VED=&@Z(#(P)3LB/CQS<&%N('-T>6QE/2)F;VYT+7=E
M:6=H=#H@8F]L9#LB/DQA>65R#0II;F9O<FUA=&EO;CPO<W!A;CX\8G(^#0H-
M"B`@("`@(#PO=&0^#0H-"B`@("`@(#QT9"!S='EL93TB<&%D9&EN9SH@,"XW
M-7!T.R!C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXC3&%Y97(@1&%T83QB<CX-
M"@T*3&%Y97)$871A(#H@-C(\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R!,
M87EE<B`Z(#$\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R!43U!?05-314U"3%D\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S
M<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`R/&)R/@T*#0HF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L@5$]07U-)3$M30U)%14X\8G(^#0H-"B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE
M<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`S/&)R
M/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@5$]07U-/
M3$1%4E]005-413QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P
M.R9N8G-P.R!,87EE<B`Z(#0\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R!43U!?4T],1$527TU!4TL\8G(^#0H-"B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@
M/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`Y.#<\8G(^#0H-
M"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3F%M929N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!#3TY404-47T%2
M14$\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@
M3&%Y97(@.B`U/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L@5$]0/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E(%-I9VYA;#QB<CX-"@T*)FYB<W`[
M)FYB<W`[)FYB<W`[($QA>65R(#H@,3(\8G(^#0H-"B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R!43U!?4$Q!0T5?0D]53D0\8G(^#0H-"B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE
M<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`V/&)R
M/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@24Y.15(\
M8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R!,87EE<E1Y<&4@4VEG;F%L/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S
M<#L@3&%Y97(@.B`Q,SQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[($)/5%1/35]03$%#15]"3U5.1#QB<CX-"@T*)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\
M8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#<\8G(^#0H-"B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M
M929N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!"3U143TT\8G(^#0H-
M"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,
M87EE<E1Y<&4@4VEG;F%L/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y
M97(@.B`X/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L@0D]45$]-7U-/3$1%4E]-05-+/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E(#QB<CX-"@T*
M)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@.3QB<CX-"@T*)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($)/5%1/35]33TQ$15)?4$%35$4\
M8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y
M97(@.B`Q,#QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[($)/5%1/35]324Q+4T-2145./&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E(#QB<CX-"@T*
M)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@,3$\8G(^#0H-"B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!"3U143TU?05-314U"3%D\8G(^
M#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@
M.B`Y-S<\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R`S1%]$6$8\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF
M;F)S<#L@3&%Y97(@.B`Y-S@\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R!024XQ34%22T52/&)R/@T*#0HF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E(#QB<CX-
M"@T*)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@.3<Y/&)R/@T*#0HF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@4$E.5$535#QB<CX-"@T*
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA
M>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#DX
M,#QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[(%1/
M4%]"1T%?4$Q!0T5?0D]!4D0\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S
M<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`Y.#$\8G(^#0H-"B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!!5%1224)55$4T/&)R/@T*#0HF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4
M>7!E(#QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@.3@R/&)R
M/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@05144DE"
M551%,SQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P
M.R!,87EE<B`Z(#DX,SQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[($%45%))0E5413(\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF
M;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`Y.#0\8G(^#0H-"B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!!5%1224)55$4Q/&)R/@T*#0HF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y
M97)4>7!E(#QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@.3@U
M/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@4$E.
M7TY534)%4CQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N
M8G-P.R!,87EE<B`Z(#DX-CQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[($-/3E-44D%)3E1?05)%03QB<CX-"@T*)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\
M8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#DX.#QB<CX-"@T*
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I.
M86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($E.4%541$E-14Y3
M24].4SQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P
M.R!,87EE<B`Z(#DX.3QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[(%)/551%7TM%15!/550\8G(^#0H-"B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*
M#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`Y.3`\8G(^#0H-"B9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!624%?2T5%4$]55#QB<CX-
M"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z
M(#DY,3QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M($1224Q,7T9)1U5213QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N
M8G-P.R9N8G-P.R!,87EE<B`Z(#DY,CQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[(%1/4%]#3TU07T)/54Y$/&)R/@T*#0HF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4
M>7!E(#QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@.3DS/&)R
M/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@0D]45$]-
M7T-/35!?0D]53D0\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S
M<#LF;F)S<#L@3&%Y97(@.B`Y.30\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R!43U!?3D\M4%)/0D4\8G(^#0H-"B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@
M/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`Y.34\8G(^#0H-
M"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3F%M929N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!"3U143TU?3D\M
M4%)/0D4\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S
M<#L@3&%Y97(@.B`Y.38\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R!04D]?13QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P
M.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#DY-SQB<CX-"@T*)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[(%!)3E]$151!24P\8G(^#0H-"B9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y
M<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`Y.3@\8G(^
M#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*3F%M929N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!$24U%3E-)
M3TX\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@
M3&%Y97(@.B`Y.3D\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R!"3T%21#QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N
M8G-P.R9N8G-P.R!,87EE<B`Z(#$T/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L@24Y415).04PQ/&)R/@T*#0HF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E(#QB
M<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@,34\8G(^#0H-"B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M
M929N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!)3E1%4DY!3#(\8G(^
M#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@
M.B`Q-CQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M($E.5$523D%,,SQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P
M.R9N8G-P.R!,87EE<B`Z(#$W/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L@24Y415).04PT/&)R/@T*#0HF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E(#QB<CX-
M"@T*)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@,3@\8G(^#0H-"B9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!)3E1%4DY!3#4\8G(^#0H-
M"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,
M87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`Q
M.3QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($E.
M5$523D%,-CQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N
M8G-P.R!,87EE<B`Z(#(P/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L@24Y415).04PW/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E(#QB<CX-"@T*
M)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@,C$\8G(^#0H-"B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!)3E1%4DY!3#@\8G(^#0H-"B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE
M<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`R,CQB
M<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($E.5$52
M3D%,.3QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P
M.R!,87EE<B`Z(#(S/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L@24Y415).04PQ,#QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N
M8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#(T/&)R/@T*#0HF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@24Y415).04PQ,3QB<CX-"@T*)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R
M5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#(U/&)R
M/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@24Y415).
M04PQ,CQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P
M.R!,87EE<B`Z(#(V/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L@24Y415).04PQ,SQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N
M8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#(W/&)R/@T*#0HF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@24Y415).04PQ-#QB<CX-"@T*)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R
M5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#(X/&)R
M/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@24Y415).
M04PQ-3QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P
M.R!,87EE<B`Z(#,P/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L@24Y415).04PQ-CQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N
M8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#,Q/&)R/@T*#0HF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@55-%4C$\8G(^#0H-"B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@
M/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97(@.B`S,CQB<CX-"@T*
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I.
M86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[(%5315(R/&)R/@T*
M#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@
M3&%Y97)4>7!E(#QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@
M,S,\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!5
M4T52,SQB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P
M.R!,87EE<B`Z(#,T/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L@55-%4C0\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF
M;F)S<#LF;F)S<#L@3&%Y97(@.B`S-3QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[(%5315(U/&)R/@T*#0HF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E(#QB<CX-
M"@T*)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R(#H@,S8\8G(^#0H-"B9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R!54T52-CQB<CX-"@T*)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R
M5'EP92`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#,W/&)R
M/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DYA;64F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@55-%4C<\
M8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R!,87EE<E1Y<&4@/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y
M97(@.B`S.#QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I.86UE)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[(%5315(X/&)R/@T*#0HF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E(#QB<CX-"@T*)FYB<W`[)FYB<W`[
M)FYB<W`[($QA>65R(#H@,SD\8G(^#0H-"B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3F%M929N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R!54T52.3QB<CX-"@T*)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[($QA>65R5'EP92`\8G(^#0H-"B9N
M8G-P.R9N8G-P.R9N8G-P.R!,87EE<B`Z(#0P/&)R/@T*#0HF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DYA;64F;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@55-%4C$P/&)R/@T*#0HF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@3&%Y97)4>7!E
M(#QB<CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L
M;W(Z(')G8B@P+"`P+"`P*3LB/D5A8V@@;&%Y97(@:7,-"F1O8W5M96YT960N
M)FYB<W`[($5A8V@@;&%Y97(@:7,@<F5Q=6ER960@=&\@:&%V92!A(&YU;6)E
M<B!B971W965N(#$@86YD#0HQ,#`P+"!A;F0@=&AE(&YU;6)E<B!M=7-T(&)E
M('5N:7%U92XF;F)S<#L@16%C:"!N=6UB97(@:7,@87-S;V-I871E9`T*=VET
M:"!A(&QA>65R(&YA;64L('=H:6-H(&%G86EN(&UU<W0@8F4@=6YI<75E+B9N
M8G-P.R!!;&P@;V8@=&AE(&1A=&$@:6X-"F]U<B!C;V1E('=I;&P@<F5F97(@
M=&\@=&AE(&QA>65R<R!B>2!N=6UB97(L(&)U="!W:6QL(&1I<W!L87D@=&AE
M#0IA<W-O8VEA=&5D(&YA;64@=&\@=&AE('5S97)S+B9N8G-P.R!4:&4@(E5L
M=')A3&EB<F%R:6%N7$QA>65R<RYI;FDB#0IF:6QE(&-O;G1A:6YS('1H92!L
M:7-T(&]F(&1E9F%U;'0@;&%Y97(@;F%M97,@86YD(&YU;6)E<G,N/&)R/@T*
M#0H@("`@("`\8G(^#0H-"DQA>65R='EP97,@8V%N(&)E(&)L86YK+"!3:6=N
M86PL($YO;E-I9VYA;"!A;F0@4&QA;F4N)FYB<W`[($-A<&ET86QS(&]R#0IL
M;W=E<B!C87-E(&%R92!A8V-E<'1A8FQE+B9N8G-P.R!)9B!,87EE<G1Y<&4@
M:7,@;&5F="!B;&%N:RP@:70@:7,-"F%S<W5M960@=&\@8F4@3F]N4VEG;F%L
M+B9N8G-P.R9N8G-P.R!3:6=N86P@86YD(%!O=V5R(&QA>65R('1Y<&5S(&%R
M90T*=7-E9"!P<FEM87)I;'D@:6X@4&%D4W1A8VL@9&5S8W)I<'1I;VYS+CQB
M<CX-"@T*("`@("`@/"]S<&%N/CPO=&0^#0H-"B`@("`\+W1R/@T*#0H@("`@
M/'1R/@T*#0H@("`@("`\=&0@<W1Y;&4](G!A9&1I;F<Z(#`N-S5P=#L@=F5R
M=&EC86PM86QI9VXZ('1O<#L@=VED=&@Z(#(P)3LB/CQS<&%N('-T>6QE/2)F
M;VYT+7=E:6=H=#H@8F]L9#LB/E1E>'13='EL90T*4V5C=&EO;CPO<W!A;CX\
M8G(^#0H-"B`@("`@(#PO=&0^#0H-"B`@("`@(#QT9"!S='EL93TB<&%D9&EN
M9SH@,"XW-7!T.R(^/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B-497AT4W1Y;&5S/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CY497AT4W1Y;&5S(#H@,SPO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M(%1E>'13='EL90T*(D@U,%,S(B`H1F]N=%=I9'1H(#,I("A&;VYT2&5I9VAT
M(#4P*2`H1F]N=$-H87)7:61T:"`Q,RD@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#L@5&5X
M=%-T>6QE#0HB:#$R-7,V(B`H1F]N=%=I9'1H(#8I("A&;VYT2&5I9VAT(#$R
M-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CXF;F)S<#LF;F)S<#LF;F)S<#L@5&5X=%-T>6QE#0HB2#@P<S0B("A&;VYT
M5VED=&@@-"D@*$9O;G1(96EG:'0@.#`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\8G(^#0H-"D5A8V@@
M=&5X='-T>6QE('5S960@:6X@96ET:&5R(&$@9F]O='!R:6YT(&]R(&$@<WEM
M8F]L('=I;&P@:&%V92!A(&YA;64-"F%N9"!A="!L96%S="!T:&4@1F]N=%=I
M9'1H(&%N9"!&;VYT2&5I9VAT(&ME>7=O<F1S+B9N8G-P.R`\8G(^#0H-"B`@
M("`@(#PO=&0^#0H-"B`@("`\+W1R/@T*#0H@("`@/'1R/@T*#0H@("`@("`\
M=&0@<W1Y;&4](G!A9&1I;F<Z(#`N-S5P=#L@=F5R=&EC86PM86QI9VXZ('1O
M<#L@=VED=&@Z(#(P)3LB/CQS<&%N('-T>6QE/2)F;VYT+7=E:6=H=#H@8F]L
M9#LB/E!A9%-T>6QE<SPO<W!A;CX\8G(^#0H-"B`@("`@(#PO=&0^#0H-"B`@
M("`@(#QT9"!S='EL93TB<&%D9&EN9SH@,"XW-7!T.R(^/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B-08613='EL97,\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/E!A9%-T86-K<R`Z
M(#$\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-
M"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/B9N8G-P.R9N8G-P.R9N8G-P.R!08613=&%C:PT*(E)8-C-9,31$,%0B("A(
M;VQE1&EA;2`P*2`H4W5R9F%C92!4<G5E*2`H4&QA=&5D($9A;'-E*3PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I3:&%P97,F
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@.B`Q/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!A9%-H87!E
M(")296-T86YG;&4B("A7:61T:"`V,RD@*$AE:6=H="`Q-"D@*%!A9%1Y<&4@
M,"D@*$QA>65R(%1/4"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#L-"D5N9%!A9%-T86-K
M/"]S<&%N/CQB<CX-"@T*("`@("`@/&)R/@T*#0I5<W5A;&QY(&UA9&4@=7`@
M;V8@82!N86UE("AI;B!Q=6]T92!M87)K<RD@86YD('1H96X@82!L:7-T(&]F
M('-H87!E<RP-"G=I=&@@=&AE('-P96-I9FEE9"!A='1R:6)U=&5S(&9O<B!E
M86-H('-H87!E+B9N8G-P.R!!9V%I;BP@;F]T(&%L;`T*96YT:71I97,@;W(@
M9&5S8W)I<'1O<G,@=VEL;"!B92!U<V5D('=I=&@@96%C:"!S:&%P92!D97-C
M<FEP=&EO;BXN+BXN/&)R/@T*#0H@("`@("`\8G(^#0H-"E!O<W-I8FQE('-H
M87!E<R!A<F4Z(")296-T86YG;&4L($-I<F-L92P@3V)L;VYG+B!2;W5N9&5D
M4F5C=&%N9VQE+`T*1&EA;6]N9"P@4F]U;F1E9$1I86UO;F0L(%1H97)M86PL
M(%1H97)M86QX(&%N9"!0;VQY9V]N+BXF;F)S<#L-"D%D9&ET:6]N86P@<VAA
M<&4@9&5S8W)I<'1O<G,@:6YC;'5D92!,87EE<B`H=VET:"!T:&4@;&%Y97(@
M86QW87ES(&EN#0I#05!S*2P@5VED92P@2&EG:"P@4W!O:V57:61T:"P@4VAA
M<&4@:6X@<75O=&5S(&%S(&%B;W9E+B9N8G-P.R!08614>7!E<PT*87)E(#`@
M8GD@9&5F875L="X@3W1H97(@9&5S8W)I<'1O<G,@:6YC;'5D92!/9F9S9718
M+"!/9F9S9719(')O=&%T:6]N+`T*86YD(%!O:6YT<R`H86X@87)R87D@;V8@
M<&]I;G1S+"!E86-H(&-O;G1A:6YI;F<@86X@6"!A;F0@60T*;&]C871I;VXN
M)FYB<W`[(%5S960@;VYL>2!W:71H(%!O;'EG;VYA;"!P861S('-H87!E<RDN
M+CQB<CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\+W1D/@T*#0H@("`@/"]T
M<CX-"@T*("`@(#QT<CX-"@T*("`@("`@/'1D('-T>6QE/2)P861D:6YG.B`P
M+C<U<'0[('9E<G1I8V%L+6%L:6=N.B!T;W`[('=I9'1H.B`R,"4[(CX\<W!A
M;B!S='EL93TB9F]N="UW96EG:'0Z(&)O;&0[(CY0871T97)N#0I396-T:6]N
M/"]S<&%N/CQB<CX-"@T*("`@("`@/"]T9#X-"@T*("`@("`@/'1D('-T>6QE
M/2)P861D:6YG.B`P+C<U<'0[(CY">2!F87(@=&AE(&UO<W0@8V]M<&QE>"!B
M>2!F87(@:7,-"G1H92!P871T97)N+B9N8G-P.R!792!A<F4@9V]I;F<@=&\@
M8G)E86L@=&AI<R!O;F4@=7`@:6YT;R!S96-T:6]N<R!T;PT*:&5L<"!Y;W4@
M=6YD97)S=&%N9"!I="!B971T97(N/&)R/@T*#0H@("`@("`\8G(^#0H-"B`@
M("`@(#QB<CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/B-0871T97)N<SPO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^4&%T=&5R;G,@.B`Q/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#L@4&%T=&5R;@T*(G-O."UP,S`M83DX(CPO<W!A;CX\8G(^#0H-"B`@("`@
M(#QB<CX-"@T*5&AE(&YA;64@;V8@=&AE('!A='1E<FX@:6X@<75O=&5S+B9N
M8G-P.R!4:&4@;F%M92!C86X@;F]T(&-O;G1A:6X-"G%U;W1E<RP@;W(@=V4@
M=VEL;"!G970@8V]N9G5S960N/&)R/@T*#0H@("`@("`\8G(^#0H-"B9N8G-P
M.SQS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"D]R:6=I;E!O:6YT("@P
M+"`P*3PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M#0I0:6-K4&]I;G0F;F)S<#LF;F)S<#L@*#`L(#`I/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"D=L=650;VEN="9N8G-P.R9N
M8G-P.R`H,"P@,"D\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CX-"@T*("`@("`@/&)R/@T*#0I4:&4@86)O=F4@9&%T82!I<R!A
M=F%I;&%B;&4@;VX@86QL('!A<G1S+"!A;F0@<F5F97)S(&9O('1H92!L;V-A
M=&EO;@T*=VET:&EN('1H92!P87)T(&]F('1H92!C96YT<F]I9"XF;F)S<#L@
M5&AE<R!E;G5M8F5R<R!A<F4@86QL(&%L;"!S=&]R960-"F%S(&QO;F<@;G5M
M8F5R<R!I;B!T:&4@8V]D92PF;F)S<#L@5&AE(&]R:6=I;B!I;B!P87)T:6-U
M;&%R(&ES(&%N#0IO9F9S970@9G)O;2!T:&4@9&EM96YS:6]N(&$@<&%R="!W
M87,@8G5I;'0@:6X@=&\@=VAE<F4@:71S('!L86-E;65N=`T*<&]I;G0@:7,N
M)FYB<W`[(%1H:7,@:7,@;F]R;6%L;'D@,"PP('-I;F-E('1H92!P87)T(&ES
M('5S96%L;'D@8G5I;'0-"F9R;VT@:71S('!L86-E;65N="!P;VEN="P@8G5T
M(&ET(&-O=6QD(&)E(&QO8V%T960@=&\@=&AE('-I9&4@;V8@=&AE#0IP87)T
M(&]R(&%T('-O;64@;W1H97(@;&]C871I;VX@:68@=&AI<R!W87,@87!P<F]P
M<FEA=&4@9F]R('-O;64-"G)E87-O;BXF;F)S<#L@3F]T(&%L;"!T;V]L<R!W
M:6QL('-U<'!O<G0@;W(@=7-E('1H92!P:6-K<&]I;G0@86YD('1H90T*9VQU
M961O="XF;F)S<#L@5&AE('-E8W1I;VX@8F5L;W<L($1A=&$L(&ES(&EN(&5A
M8V@@<&%R="XF;F)S<#L@270-"F-O;G1I86YS('-O;64@9F]R;2!O9B!D871A
M)FYB<W`[('1H870@8V]U;&0@8F4@9&ES<&QA>65D(&]R('-T;W)E9"!A8F]U
M#0IT=&AE('!A<G0N)FYB<W`[(%=E('=I;&P@9&5T86EL('-O;64@;V8@=&AE
M(&QI;F5S(&]F('1H:7,@8V]D92!F;W(-"GEO=2XF;F)S<#L@/&)R/@T*#0H@
M("`@("`\8G(^#0H-"B9N8G-P.R9N8G-P.SQS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"D1A=&$F;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L@.B`S,S(\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5&5X="`H3&%Y97(@
M5$]07T%34T5-0DQ9*2`H3W)I9VEN("TV-RXU+"`X-RD@*%1E>'0@(BHB*2`H
M27-6:7-I8FQE#0I4<G5E*2`H2G5S=&EF>2!54%!%4D-%3E1%4BD@*%1E>'13
M='EL92`B2#4P4S,B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5&5X="`H3&%Y
M97(@5$]07U-)3$M30U)%14XI("A/<FEG:6X@+38W+C4L(#@W*2`H5&5X="`B
M*B(I("A)<U9I<VEB;&4-"E1R=64I("A*=7-T:69Y(%504$520T5.5$52*2`H
M5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I0860@
M*$YU;6)E<B`Q*2`H4&EN3F%M92`B,2(I("A08613='EL92`B4E@V,UDQ-$0P
M5"(I("A/<FEG:6YA;%!A9%-T>6QE#0HB4E@V,UDQ-$0P5"(I("A/<FEG:6X@
M+34W+C4L(#0U*2`H3W)I9VEN86Q0:6Y.=6UB97(@,2D@/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QB<CX-
M"@T*16%X:"!L:6YE(&EN('1H92!D871A('-E="!C;VYT86EN<R!A(&YE=R!E
M;G1I='D@9F]R('1H92!P87)T+"!A;F0@=&AE#0IP<F]P97)T:65S('1H870@
M;6%K92!T:&5S92!E;G1I=&EE<R!U<"XF;F)S<#L@5&AE(&1A=&$@;&EN97,@
M8V%N(&%N9`T*;V9T96X@9&\@=7-E('1H92!S86UE(&EN9F]R;6%T:6]N(&%S
M(&]T:&5R(&9O<FUS(&]F(&1A=',N)FYB<W`[(%-O(&9O<@T*97AA;7!L92!A
M(&QI;F4@;6%Y('5S92!T:&4@3W)I9VEN("@@>"QY*2!P<F]P97)T>2!J=7-T
M(&%S('1H92!497AT#0IE;G1I='D@;6%Y('5S92!T:&ES('-A;64@<')O<&5R
M='DN)FYB<W`[($UA;GD@;V8@=&AE('!O<W-I8FQE#0IP<F]P97)T:65S(&-A
M;B!A;F0@87)E('-H87)E9"!A8W)O<W,@=&AE(&1A=&$@='EP97,N)FYB<W`[
M(%-O;64@;V8@=&AE#0IC;VUM;VX@;VYE<R!Y;W4@=VEL;"!S964@:6YI('5S
M92!I<R!2;W1A=&EO;BP@1FQI<'!E9"P@3W)I9VEN+`T*171C+B9N8G-P.R!.
M;W1E('1H870@=&AE('1E>'0@8F5F;W)E('1H92!F:7)S="!B<F%C:V5T(&1E
M;&EN96%T97,@=&AE#0IT>7!E(&]F(&5N=&ET>2!A=F%I;&%B;&4N)FYB<W`[
M(%1H97)E(&%R92!O;FQY(&$@9F5R=R!P97)M:7-S86)L92!T>7!E<PT*870@
M=&AI<R!P;VEN=#HF;F)S<#L@)FYB<W`[)FYB<W`[('!A9"P@;&EN92P@87)C
M+"!C:7)C;&4L(&%T=')I8G5T92P-"G!I8VMP;VEN="P@<&]L>2P@<&]L>6ME
M97!O=70L('!O;'EK965P;W5T7W9I82P@<&]L>6ME97!O=71?8V]M<"P-"G!O
M;'EK965P:6Y?8V]M<"P@=&5X="P@=VEZ87)D+CQB<CX-"@T*("`@("`@/&)R
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!43U!?05-3
M14U"3%DI("A/<FEG:6X@+30Y+"`S.2D@*$5N9%!O:6YT("TT.2P@-3$I(#QB
M<CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@P+"`P+"`P*3LB/DQI;F5S('=I;&P@86QW87ES(')E<75I<F4@870-
M"FQE87-T(&%N(&]R:6=I;B!%;F10;VEN="!A;F0@;&%Y97(@<')O<&5R='DN
M)FYB<W`[($EF('1H97D@9&\@;F]T#0II;F-L=61E('1H92!W:61T:"!P<F]P
M97)T>2P@=&AE>2!W:6QL(&)E(&%S<VEG;F5D(&$@9&5F875L="!W:61T:"!I
M;@T*;W5R(&-O9&4N)FYB<W`[(%1H92!D969A=6QT('=I9'1H(&ES('5S97(@
M87-S:6=N86)L92!I;B!T:&4-"F-O;F9I9W5R871I;VX@<V-R965N+CPO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,"P@,"P@,"D[(CX-"@T*("`@("`@
M/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@
M/"]S<&%N/CQS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%1/4%]!4U-%34),
M62D@*$]R:6=I;B`M-#DL(#4Q*2`H16YD4&]I;G0@+3<U+"`U,2D@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%1/4%]!4U-%34),62D@*$]R
M:6=I;B`M-S4L(#4Q*2`H16YD4&]I;G0@+3<U+`T*,S@N.3DY.3DY.3DY.3DY
M.2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%1/4%]!4U-%
M34),62D@*$]R:6=I;B`M-S4L(#,X+CDY.3DY.3DY.3DY.3DI("A%;F10;VEN
M="`M-#DL#0HS.2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!O;'D@*$QA>65R
M(#-$7T181BD@*$]R:6=I;B`P+"`P*2`H4')O<&5R='D@(DA%24=(5%)!3D=%
M/3$P,"PU,"(I#0HH5VED=&@@-BDF;F)S<#L@*"TT.2P@,SDI("@M-#DL(#4Q
M*2`H+3<U+"`U,2D@*"TW-2P@,S@N.3DY.3DY.3DY.3DY.2D\8G(^#0H-"B`@
M("`@(#QB<CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,"P@
M,"P@,"D[(CY!('!O;'EG;VX@<F5Q=6ER97,@82!L87EE<BP@86X-"D]R9VEN
M(&%N9"!A="!L96%S="!T=V\@861D:71I;VYA;"!P;VEN=',@=&\@8F4@=F%L
M:60N)FYB<W`[($ET(&-A;B!A;'-O#0IC;VYT86EN('=I9'1H+"!F;&EP<&5D
M+"!A;F0@<V5V97)A;"!O=&AE<B!P<F]P97)T:65S+CPO<W!A;CX\8G(^#0H-
M"B`@("`@(#QB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#PO<W!A;CX\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I0860@*$YU;6)E<B`R*2`H
M4&EN3F%M92`B,B(I("A08613='EL92`B4E@V,UDQ-$0P5"(I("A/<FEG:6YA
M;%!A9%-T>6QE#0HB4E@V,UDQ-$0P5"(I("A/<FEG:6X@+34W+C4L(#$U*2`H
M3W)I9VEN86Q0:6Y.=6UB97(@,BD@/&)R('-T>6QE/2)C;VQO<CH@<F=B*#`L
M(#`L(#`I.R(^#0H-"B`@("`@(#QB<B!S='EL93TB8V]L;W(Z(')G8B@P+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@P+"`P
M+"`P*3LB/D$@<&%D(&UU<W0@8V]N=&%I;B!A(&YA;64@86YD#0IA(&YU;6)E
M<BXF;F)S<#L@5&AE(&YA;64@:7,@=VAA="!M;W-T('5S97)S('=I;&P@<V5E
M('=H96X@<F5F97)E;F-I;F<-"G1H92!F;V]T<')I;G0N)FYB<W`[(%1H92!N
M=6UB97(@:7,@87)B:71R87)I;'D@87-S:6=N960@8F%S960N)FYB<W`[#0I%
M86-H(&9O;W1P<FEN="!M=7-T(&AA=F4@:71S('!A9',@;G5M8F5R960@;VYE
M('1O('1H92!A;6]U;G0@;V8@<&%D<PT*8V]N=&EN960@=VET:"!N;R!G87!S
M(&]R(&1U<&QI8V%T97,@:6X@;G5M8F5R:6YG+B9N8G-P.R!!;'-O(')E<75I
M<F5D#0IA<F4@=&AE($]R:6=I;B!A;F0@4&%D<W1Y;&4@<')O<&5R=&EE<RXF
M;F)S<#L@3W1H97(@<')O<&5R=&EE<R!M:6=H="!B90T*=FES:6)L92P@<W5C
M:"!A<R!R;W1A=&EO;B!A;F0@9FQI<'!E9"X\+W-P86X^/&)R/@T*#0H@("`@
M("`\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\+W-P86X^/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*4&%D("A.=6UB97(@,RD@*%!I;DYA
M;64@(C,B*2`H4&%D4W1Y;&4@(E)8-C-9,31$,%0B*2`H3W)I9VEN86Q08613
M='EL90T*(E)8-C-9,31$,%0B*2`H3W)I9VEN("TU-RXU+"`M,34I("A/<FEG
M:6YA;%!I;DYU;6)E<B`S*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*4&%D("A.
M=6UB97(@-"D@*%!I;DYA;64@(C0B*2`H4&%D4W1Y;&4@(E)8-C-9,31$,%0B
M*2`H3W)I9VEN86Q08613='EL90T*(E)8-C-9,31$,%0B*2`H3W)I9VEN("TU
M-RXU+"`M-#4I("A/<FEG:6YA;%!I;DYU;6)E<B`T*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*3&EN92`H3&%Y97(@5$]07T%34T5-0DQ9*2`H3W)I9VEN("TT
M.2P@.2D@*$5N9%!O:6YT("TT.2P@,C$I(#PO<W!A;CX\8G(@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M#0I,:6YE("A,87EE<B!43U!?05-314U"3%DI("A/<FEG:6X@+30Y+"`R,2D@
M*$5N9%!O:6YT("TW-2P@,C$I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE
M("A,87EE<B!43U!?05-314U"3%DI("A/<FEG:6X@+3<U+"`R,2D@*$5N9%!O
M:6YT("TW-2P-"C@N.3DY.3DY.3DY.3DY.3,I(#PO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I,:6YE("A,87EE<B!43U!?05-314U"3%DI("A/<FEG:6X@+3<U+"`X
M+CDY.3DY.3DY.3DY.3DS*2`H16YD4&]I;G0@+30Y+`T*.2D@/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS
M<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"E!O;'D@*$QA>65R(#-$7T181BD@*$]R:6=I;B`P+"`P
M*2`H4')O<&5R='D@(DA%24=(5%)!3D=%/3$P,"PU,"(I#0HH5VED=&@@-BDF
M;F)S<#L@*"TT.2P@.2D@*"TT.2P@,C$I("@M-S4L(#(Q*2`H+3<U+"`X+CDY
M.3DY.3DY.3DY.3DS*3PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE
M<B!43U!?05-314U"3%DI("A/<FEG:6X@+30Y+"`M,C$I("A%;F10;VEN="`M
M-#DL("TY*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@5$]0
M7T%34T5-0DQ9*2`H3W)I9VEN("TT.2P@+3DI("A%;F10;VEN="`M-S4L#0HM
M.2XP,#`P,#`P,#`P,#`P-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@
M*$QA>65R(%1/4%]!4U-%34),62D@*$]R:6=I;B`M-S4L("TY+C`P,#`P,#`P
M,#`P,#`U*2`H16YD4&]I;G0-"BTW-2P@+3(Q+C`P,#`P,#`P,#`P,#$I(#PO
M<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!43U!?05-314U"3%DI
M("A/<FEG:6X@+3<U+"`M,C$N,#`P,#`P,#`P,#`P,2D@*$5N9%!O:6YT#0HM
M-#DL("TR,2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!O;'D@*$QA>65R(#-$
M7T181BD@*$]R:6=I;B`P+"`P*2`H4')O<&5R='D@(DA%24=(5%)!3D=%/3$P
M,"PU,"(I#0HH5VED=&@@-BDF;F)S<#L@*"TT.2P@+3(Q*2`H+30Y+"`M.2D@
M*"TW-2P@+3DN,#`P,#`P,#`P,#`P,#4I("@M-S4L#0HM,C$N,#`P,#`P,#`P
M,#`P,2D\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@5$]07T%3
M4T5-0DQ9*2`H3W)I9VEN("TT."XY.3DY.3DY.3DY.3DY+"`M-3$I("A%;F10
M;VEN=`T*+30Y+"`M,SDI(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,
M87EE<B!43U!?05-314U"3%DI("A/<FEG:6X@+30Y+"`M,SDI("A%;F10;VEN
M="`M-S4L#0HM,SDN,#`P,#`P,#`P,#`P,2D@/"]S<&%N/CQB<B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DQI;F4@*$QA>65R(%1/4%]!4U-%34),62D@*$]R:6=I;B`M-S4L("TS
M.2XP,#`P,#`P,#`P,#`Q*2`H16YD4&]I;G0-"BTW-"XY.3DY.3DY.3DY.3DY
M+"`M-3$N,#`P,#`P,#`P,#`P,2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R(%1/4%]!4U-%34),62D@*$]R:6=I;B`M-S0N.3DY.3DY.3DY
M.3DY.2P@+34Q+C`P,#`P,#`P,#`P,#$I#0HH16YD4&]I;G0@+30X+CDY.3DY
M.3DY.3DY.3DL("TU,2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!O;'D@*$QA
M>65R(#-$7T181BD@*$]R:6=I;B`P+"`P*2`H4')O<&5R='D@(DA%24=(5%)!
M3D=%/3$P,"PU,"(I#0HH5VED=&@@-BDF;F)S<#L@*"TT."XY.3DY.3DY.3DY
M.3DY+"`M-3$I("@M-#DL("TS.2D@*"TW-2P-"BTS.2XP,#`P,#`P,#`P,#`Q
M*2`H+3<T+CDY.3DY.3DY.3DY.3DL("TU,2XP,#`P,#`P,#`P,#`Q*3PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I0860@*$YU;6)E<B`U*2`H4&EN3F%M92`B-2(I
M("A08613='EL92`B4E@V,UDQ-$0P5"(I("A/<FEG:6YA;%!A9%-T>6QE#0HB
M4E@V,UDQ-$0P5"(I("A/<FEG:6X@-3<N-2P@+30U*2`H3W)I9VEN86Q0:6Y.
M=6UB97(@-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!A9"`H3G5M8F5R(#8I
M("A0:6Y.86UE("(V(BD@*%!A9%-T>6QE(")26#8S63$T1#!4(BD@*$]R:6=I
M;F%L4&%D4W1Y;&4-"B)26#8S63$T1#!4(BD@*$]R:6=I;B`U-RXU+"`M,34I
M("A/<FEG:6YA;%!I;DYU;6)E<B`V*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M4&%D("A.=6UB97(@-RD@*%!I;DYA;64@(C<B*2`H4&%D4W1Y;&4@(E)8-C-9
M,31$,%0B*2`H3W)I9VEN86Q08613='EL90T*(E)8-C-9,31$,%0B*2`H3W)I
M9VEN(#4W+C4L(#$U*2`H3W)I9VEN86Q0:6Y.=6UB97(@-RD@/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS
M<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"E!A9"`H3G5M8F5R(#@I("A0:6Y.86UE("(X(BD@*%!A
M9%-T>6QE(")26#8S63$T1#!4(BD@*$]R:6=I;F%L4&%D4W1Y;&4-"B)26#8S
M63$T1#!4(BD@*$]R:6=I;B`U-RXU+"`T-2D@*$]R:6=I;F%L4&EN3G5M8F5R
M(#@I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!43U!?05-3
M14U"3%DI("A/<FEG:6X@-#DL("TS.2D@*$5N9%!O:6YT(#0Y+"`M-3$I(#PO
M<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!43U!?05-314U"3%DI
M("A/<FEG:6X@-#DL("TU,2D@*$5N9%!O:6YT(#<U+"`M-3$I(#PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!43U!?05-314U"3%DI("A/<FEG
M:6X@-S4L("TU,2D@*$5N9%!O:6YT(#<U+`T*+3,X+CDY.3DY.3DY.3DY.3DI
M(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*
M#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!43U!?05-314U"
M3%DI("A/<FEG:6X@-S4L("TS."XY.3DY.3DY.3DY.3DY*2`H16YD4&]I;G0@
M-#DL#0HM,SDI(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I0;VQY("A,87EE<B`S
M1%]$6$8I("A/<FEG:6X@,"P@,"D@*%!R;W!E<G1Y(")(14E'2%1204Y'13TQ
M,#`L-3`B*0T**%=I9'1H(#8I)FYB<W`[("@T.2P@+3,Y*2`H-#DL("TU,2D@
M*#<U+"`M-3$I("@W-2P@+3,X+CDY.3DY.3DY.3DY.3DI/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L-"DQI;F4@*$QA>65R(%1/4%]!4U-%34),62D@*$]R:6=I;B`T
M.2P@+3DI("A%;F10;VEN="`T.2P@+3(Q*2`\+W-P86X^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*3&EN92`H3&%Y97(@5$]07T%34T5-0DQ9*2`H3W)I9VEN(#0Y+"`M,C$I
M("A%;F10;VEN="`W-2P@+3(Q*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN
M92`H3&%Y97(@5$]07T%34T5-0DQ9*2`H3W)I9VEN(#<U+"`M,C$I("A%;F10
M;VEN="`W-2P-"BTX+CDY.3DY.3DY.3DY.3DS*2`\+W-P86X^/&)R('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.PT*3&EN92`H3&%Y97(@5$]07T%34T5-0DQ9*2`H3W)I9VEN(#<U+"`M
M."XY.3DY.3DY.3DY.3DY,RD@*$5N9%!O:6YT(#0Y+`T*+3DI(#PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I0;VQY("A,87EE<B`S1%]$6$8I("A/<FEG:6X@,"P@
M,"D@*%!R;W!E<G1Y(")(14E'2%1204Y'13TQ,#`L-3`B*0T**%=I9'1H(#8I
M)FYB<W`[("@T.2P@+3DI("@T.2P@+3(Q*2`H-S4L("TR,2D@*#<U+"`M."XY
M.3DY.3DY.3DY.3DY,RD\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y
M97(@5$]07T%34T5-0DQ9*2`H3W)I9VEN(#0Y+"`R,2D@*$5N9%!O:6YT(#0Y
M+"`Y*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@5$]07T%3
M4T5-0DQ9*2`H3W)I9VEN(#0Y+"`Y*2`H16YD4&]I;G0@-S4L#0HY+C`P,#`P
M,#`P,#`P,#`Q*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@
M5$]07T%34T5-0DQ9*2`H3W)I9VEN(#<U+"`Y+C`P,#`P,#`P,#`P,#`Q*2`H
M16YD4&]I;G0@-S4L#0HR,2XP,#`P,#`P,#`P,#`Q*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*3&EN92`H3&%Y97(@5$]07T%34T5-0DQ9*2`H3W)I9VEN(#<U
M+"`R,2XP,#`P,#`P,#`P,#`Q*2`H16YD4&]I;G0@-#DL#0HR,2D@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"E!O;'D@*$QA>65R(#-$7T181BD@*$]R:6=I;B`P
M+"`P*2`H4')O<&5R='D@(DA%24=(5%)!3D=%/3$P,"PU,"(I#0HH5VED=&@@
M-BDF;F)S<#L@*#0Y+"`R,2D@*#0Y+"`Y*2`H-S4L(#DN,#`P,#`P,#`P,#`P
M,#$I("@W-2P-"C(Q+C`P,#`P,#`P,#`P,#$I/"]S<&%N/CQB<B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DQI;F4@*$QA>65R(%1/4%]!4U-%34),62D@*$]R:6=I;B`T.2P@-3$I
M("A%;F10;VEN="`T.2P@,SDI(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE
M("A,87EE<B!43U!?05-314U"3%DI("A/<FEG:6X@-#DL(#,Y*2`H16YD4&]I
M;G0@-S4L(#,Y*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@
M5$]07T%34T5-0DQ9*2`H3W)I9VEN(#<U+"`S.2D@*$5N9%!O:6YT(#<T+CDY
M.3DY.3DY.3DY.3DL#0HU,2XP,#`P,#`P,#`P,#`Q*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*3&EN92`H3&%Y97(@5$]07T%34T5-0DQ9*2`H3W)I9VEN(#<T
M+CDY.3DY.3DY.3DY.3DL(#4Q+C`P,#`P,#`P,#`P,#$I#0HH16YD4&]I;G0@
M-#DL(#4Q*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*4&]L>2`H3&%Y97(@,T1?
M1%A&*2`H3W)I9VEN(#`L(#`I("A0<F]P97)T>2`B2$5)1TA44D%.1T4],3`P
M+#4P(BD-"BA7:61T:"`V*29N8G-P.R`H-#DL(#4Q*2`H-#DL(#,Y*2`H-S4L
M(#,Y*2`H-S0N.3DY.3DY.3DY.3DY.2P-"C4Q+C`P,#`P,#`P,#`P,#$I/"]S
M<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@
M("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"E!O;'D@*$QA>65R($-/3E1!0U1?05)%02D@
M*$]R:6=I;B`P+"`P*29N8G-P.R`H+3<U+"`U,2D@*"TW-2P@,SDI("@M-#`L
M#0HS.2D@*"TT,"P@-3$I/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!O;'D@*$QA
M>65R($-/3E1!0U1?05)%02D@*$]R:6=I;B`P+"`P*29N8G-P.R`H+3<U+"`R
M,2D@*"TW-2P@.2D@*"TT,"P-"CDI("@M-#`L(#(Q*3PO<W!A;CX\8G(@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I0;VQY("A,87EE<B!#3TY404-47T%214$I("A/<FEG:6X@,"P@
M,"DF;F)S<#L@*"TW-2P@+3DI("@M-S4L("TR,2D-"B@M-#`L("TR,2D@*"TT
M,"P@+3DI/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!O;'D@*$QA>65R($-/3E1!
M0U1?05)%02D@*$]R:6=I;B`P+"`P*29N8G-P.R`H+3<U+"`M,SDI("@M-S4L
M("TU,2D-"B@M-#`L("TU,2D@*"TT,"P@+3,Y*3PO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I0;VQY("A,87EE<B!#3TY404-47T%214$I("A/<FEG:6X@,"P@,"DF
M;F)S<#L@*#0P+"`M,SDI("@T,"P@+34Q*2`H-S4L#0HM-3$I("@W-2P@+3,Y
M*3PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*
M#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I0;VQY("A,87EE<B!#3TY404-47T%2
M14$I("A/<FEG:6X@,"P@,"DF;F)S<#L@*#0P+"`M.2D@*#0P+"`M,C$I("@W
M-2P-"BTR,2D@*#<U+"`M.2D\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*4&]L>2`H
M3&%Y97(@0T].5$%#5%]!4D5!*2`H3W)I9VEN(#`L(#`I)FYB<W`[("@T,"P@
M,C$I("@T,"P@.2D@*#<U+"`Y*0T**#<U+"`R,2D\+W-P86X^/&)R('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.PT*4&]L>2`H3&%Y97(@0T].5$%#5%]!4D5!*2`H3W)I9VEN(#`L(#`I
M)FYB<W`[("@T,"P@-3$I("@T,"P@,SDI("@W-2P-"C,Y*2`H-S4L(#4Q*3PO
M<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I0;VQY("A,87EE<B!43U!?3D\M4%)/0D4I
M("A/<FEG:6X@,"P@,"D@*%=I9'1H(#8I)FYB<W`[("@M,3`T+"`M.34I#0HH
M+3$P-"P@.34I("@Q,#0L(#DU*2`H,3`T+"`M.34I/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DQI;F4@*$QA>65R(%1/4%]03$%#15]"3U5.1"D@*$]R:6=I;B`M
M.#DL("TX,"D@*$5N9%!O:6YT("TX.2P@.#`I(#PO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I,:6YE("A,87EE<B!43U!?4$Q!0T5?0D]53D0I("A/<FEG:6X@+3@Y
M+"`X,"D@*$5N9%!O:6YT(#@Y+"`X,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-
M"DQI;F4@*$QA>65R(%1/4%]03$%#15]"3U5.1"D@*$]R:6=I;B`X.2P@.#`I
M("A%;F10;VEN="`X.2P@+3@P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN
M92`H3&%Y97(@5$]07U!,04-%7T)/54Y$*2`H3W)I9VEN(#@Y+"`M.#`I("A%
M;F10;VEN="`M.#DL("TX,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!O;'D@
M*$QA>65R(%1/4%]03$%#15]"3U5.1"D@*$]R:6=I;B`P+"`P*2`H5VED=&@@
M-BDF;F)S<#L@*"TX.2P@+3@P*0T**"TX.2P@.#`I("@X.2P@.#`I("@X.2P@
M+3@P*3PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I!='1R:6)U=&4@*$QA>65R(%!2
M3U]%*2`H3W)I9VEN(#`L(#`I("A!='1R(")(96EG:'0B("(Q,#`B*2`H2G5S
M=&EF>0T*0T5.5$52*2`H5&5X=%-T>6QE(")(-3!3,R(I(#QB<CX-"@T*("`@
M("`@/&)R/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@P+"`P
M+"`P*3LB/D%T=')I8G5T97,@;75S="!C;VYT86EN(&$-"FQA>65R+"!A;B!/
M<FEG:6XL(&%N9"!A('1E>'1S='EL92XF;F)S<#L@071T<FEB=71E<R!W:71H
M;W5T(&$-"FIU<W1I9FEC871I;VX@=VEL;"!B92!J=7-T:69I960@(D-%3E1%
M4B(N)FYB<W`[($ET(&UU<W0F;F)S<#L@86QS;PT*8V]N86EN('1H92!A='1R
M:6)U=&4@<')O;7!T(&%S('=E;&P@87,@=F%L=64N)FYB<W`[($EN('1H92!E
M>&%M<&QE#0IA8F]V92!T:&4@<')O;7!T(&ES(")(96EG:'0B(&%N9"!T:&4@
M=F%L=64@:7,@(C$P,"(N)FYB<W`[($YO=&4@=&AA=`T*=&AE('9A;'5E(&ES
M(&%L=V%Y<R!C;VYS:61E<F5D(&$@<W1R:6YG+B9N8G-P.R!!;'=A>7,N/"]S
M<&%N/CQB<CX-"@T*("`@("`@/"]S<&%N/CQB<CX-"@T*2G5S=&EF:6-A=&EO
M;B!I<R!U<V5D(&]N('1E>'0@86YD(&%T=')I8G5T97,N)FYB<W`[($ET<R!A
M=F%I;&%B;&4-"FIU<W1I9FEC871I;VYS(&%R93H@55!015),1494+"!54%!%
M4D-%3E1%4BP@55!015)224=(5"P@3$5&5"P@0T5.5$52+`T*4DE'2%0L($Q/
M5T523$5&5"P@3$]715)#14Y415(L($Q/5T524DE'2%0N/&)R/@T*#0H@("`@
M("`\8G(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CX\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*071T<FEB=71E("A,87EE
M<B!04D]?12D@*$]R:6=I;B`P+"`P*2`H071T<B`B34E.2$5)1TA4(B`B,3`B
M*2`H2G5S=&EF>0T*0T5.5$52*2`H5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!04D]?12D@*$]R:6=I;B`M
M-#DL(#@P*2`H16YD4&]I;G0@+30Y+"`M.#`I("A7:61T:"`V*2`\+W-P86X^
M/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@
M/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4%)/7T4I("A/<FEG:6X@+30Y
M+"`M.#`I("A%;F10;VEN="`T.2P@+3@P*2`H5VED=&@@-BD@/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS
M<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!23U]%*2`H3W)I9VEN(#0Y+"`M
M.#`I("A%;F10;VEN="`T.2P@.#`I("A7:61T:"`V*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*3&EN92`H3&%Y97(@4%)/7T4I("A/<FEG:6X@-#DL(#@P*2`H
M16YD4&]I;G0@+30Y+"`X,"D@*%=I9'1H(#8I(#PO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I!<F,@*$QA>65R(%!23U]%*2`H3W)I9VEN(#`L(#@P*2`H4F%D:75S
M(#@N,38V-C8W*2`H4W1A<G1!;F=L92`Q.#`I#0HH4W=E97!!;F=L92`Q.#`I
M("A7:61T:"`V*2`\8G(^#0H-"B`@("`@(#QB<CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,"P@,"P@,"D[(CY!;B!!<F,@;F5E9',@86QL
M(&]F('1H92!F:65L9',-"F%B;W9E(&5X8V5P="!T:&4@=VED=&@@9FEE;&0N
M)FYB<W`[($AO=V5V97(@:70@;6EG:'0@:&%V92!Q=6ET92!A(&9E=PT*861D
M:71I;VYA;"!F96EL9',@;&EK92!R;W1A=&EO;B!A;F0@9FQI<'!E9"X\+W-P
M86X^/&)R/@T*#0H@("`@("`\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\+W-P86X^/'-P86X@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5&5X="`H
M3&%Y97(@1$E-14Y324].*2`H3W)I9VEN(#`L("TR,S`I("A497AT(")$969A
M=6QT(%!A9'-T>6QE.@T*4E@V,UDQ-$0P5"(I("A)<U9I<VEB;&4@5')U92D@
M*$IU<W1I9GD@55!015)#14Y415(I("A497AT4W1Y;&4@(D@U,%,S(BD-"B`@
M("`@(#QB<CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\<W!A;B!S='EL93TB
M8V]L;W(Z(')G8B@P+"`P+"`P*3LB/E1E>'0@:&%S('1H92!S86UE(')E<75I
M<F5M96YT<PT*87,@86X@071T<FEB=71E+"!E>&-E<'0@=&AA="!R871H97(@
M=&AA;B!A('!R;VUP="!A;F0@82!V86QU92P@:70@:G5S=`T*:&%S(&$@<W1R
M:6YG(')E<')E<V5N=&EN9R!W:&%T('=I;&P@<VAO=R!U<"!A<R!T97AT+B9N
M8G-P.R!);B!T:&ES(&-A<V4-"G1H92!S=')I;F<@:7,B/"]S<&%N/CPO<W!A
M;CX\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@P+"`P+"`P*3LB/D1E9F%U;'0-
M"E!A9'-T>6QE.B!26#8S63$T1#!4(BXF;F)S<#L@270@:7,@86QW87ES('-T
M<FEN9R!I;F9O<FUA=&EO;BXF;F)S<#L@665S#0IA;'=A>7,N/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@P+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/"]S<&%N/CQS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I
M;B`M-#DL(#`I("A%;F10;VEN="`M-#DL(#$W,"D@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`T
M.2P@,"D@*$5N9%!O:6YT(#0Y+"`Q-S`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M#0I,:6YE("A,87EE<B!)3E!55$1)345.4TE/3E,I("A/<FEG:6X@+30Y+"`Q
M-34I("A%;F10;VEN="`M.3DL(#$U-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-
M"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`T.2P@,34U
M*2`H16YD4&]I;G0@.3DL(#$U-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`M-#DL(#$U-2D@
M*$5N9%!O:6YT("TU.2P@,38P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN
M92`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I9VEN("TT.2P@,34U*2`H
M16YD4&]I;G0@+34Y+"`Q-3`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE
M("A,87EE<B!)3E!55$1)345.4TE/3E,I("A/<FEG:6X@+34Y+"`Q-C`I("A%
M;F10;VEN="`M-3DL(#$U,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@
M*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`T.2P@,34U*2`H16YD
M4&]I;G0@-3DL(#$V,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA
M>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`T.2P@,34U*2`H16YD4&]I
M;G0@-3DL(#$U,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R
M($E.4%541$E-14Y324].4RD@*$]R:6=I;B`U.2P@,38P*2`H16YD4&]I;G0@
M-3DL(#$U,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E1E>'0@*$QA>65R($E.
M4%541$E-14Y324].4RD@*$]R:6=I;B`P+"`Q-S4I("A497AT(")!(BD@*$IU
M<W1I9GD-"DQ/5T520T5.5$52*2`H5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!)3E!55$1)345.4TE/3E,I
M("A/<FEG:6X@+3<U+"`P*2`H16YD4&]I;G0@+3<U+"`R-#4I(#PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!)3E!55$1)345.4TE/3E,I("A/
M<FEG:6X@-S4L(#`I("A%;F10;VEN="`W-2P@,C0U*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*3&EN92`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I9VEN
M("TW-2P@,C,P*2`H16YD4&]I;G0@-S4L(#(S,"D@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`M
M-S4L(#(S,"D@*$5N9%!O:6YT("TV-2P@,C,U*2`\+W-P86X^/&)R('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.PT*3&EN92`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I9VEN("TW
M-2P@,C,P*2`H16YD4&]I;G0@+38U+"`R,C4I(#PO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I,:6YE("A,87EE<B!)3E!55$1)345.4TE/3E,I("A/<FEG:6X@+38U
M+"`R,S4I("A%;F10;VEN="`M-C4L(#(R-2D@/"]S<&%N/CQB<B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`W-2P@
M,C,P*2`H16YD4&]I;G0@-C4L(#(S-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-
M"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`W-2P@,C,P
M*2`H16YD4&]I;G0@-C4L(#(R-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`V-2P@,C,U*2`H
M16YD4&]I;G0@-C4L(#(R-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E1E>'0@
M*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`P+"`R-3`I("A497AT
M("),(BD@*$IU<W1I9GD-"DQ/5T520T5.5$52*2`H5&5X=%-T>6QE(")(-3!3
M,R(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!)3E!55$1)
M345.4TE/3E,I("A/<FEG:6X@,"P@.#`I("A%;F10;VEN="`Q-C0L(#@P*2`\
M+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*
M("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@24Y0551$24U%3E-)
M3TY3*2`H3W)I9VEN(#`L("TX,"D@*$5N9%!O:6YT(#$V-"P@+3@P*2`\+W-P
M86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@
M("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@24Y0551$24U%3E-)3TY3
M*2`H3W)I9VEN(#$T.2P@.#`I("A%;F10;VEN="`Q-#DL("TX,"D@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@
M*$]R:6=I;B`Q-#DL(#@P*2`H16YD4&]I;G0@,30T+"`W,"D@/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS
M<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R
M:6=I;B`Q-#DL(#@P*2`H16YD4&]I;G0@,34T+"`W,"D@/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I
M;B`Q-#0L(#<P*2`H16YD4&]I;G0@,34T+"`W,"D@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`Q
M-#DL("TX,"D@*$5N9%!O:6YT(#$T-"P@+3<P*2`\+W-P86X^/&)R('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.PT*3&EN92`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I9VEN(#$T
M.2P@+3@P*2`H16YD4&]I;G0@,34T+"`M-S`I(#PO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I,:6YE("A,87EE<B!)3E!55$1)345.4TE/3E,I("A/<FEG:6X@,30T
M+"`M-S`I("A%;F10;VEN="`Q-30L("TW,"D@/"]S<&%N/CQB<B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"E1E>'0@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`Q-CDL
M(#`I("A497AT(")"(BD@*$IU<W1I9GD@3$5&5"D-"BA497AT4W1Y;&4@(D@U
M,%,S(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R($E.4%54
M1$E-14Y324].4RD@*$]R:6=I;B`M-3<N-2P@-#4I("A%;F10;VEN="`M,3<R
M+C4L(#0U*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@24Y0
M551$24U%3E-)3TY3*2`H3W)I9VEN("TU-RXU+"`Q-2D@*$5N9%!O:6YT("TQ
M-S(N-2P@,34I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!)
M3E!55$1)345.4TE/3E,I("A/<FEG:6X@+3$U-RXU+"`T-2D@*$5N9%!O:6YT
M("TQ-3<N-2P@.34I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE
M<B!)3E!55$1)345.4TE/3E,I("A/<FEG:6X@+3$U-RXU+"`Q-2D@*$5N9%!O
M:6YT("TQ-3<N-2P@+3,U*0T*("`@("`@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-
M"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`M,34W+C4L
M(#0U*2`H16YD4&]I;G0@+3$V,BXU+"`U-2D@/"]S<&%N/CQB<B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`M,34W
M+C4L(#0U*2`H16YD4&]I;G0@+3$U,BXU+"`U-2D@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`M
M,38R+C4L(#4U*2`H16YD4&]I;G0@+3$U,BXU+"`U-2D@/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L-"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I
M;B`M,34W+C4L(#$U*2`H16YD4&]I;G0@+3$V,BXU+"`U*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I
M9VEN("TQ-3<N-2P@,34I("A%;F10;VEN="`M,34R+C4L(#4I(#PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!)3E!55$1)345.4TE/3E,I("A/
M<FEG:6X@+3$V,BXU+"`U*2`H16YD4&]I;G0@+3$U,BXU+"`U*2`\+W-P86X^
M/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@
M/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.PT*5&5X="`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H
M3W)I9VEN("TQ-S<N-2P@,S`I("A497AT(")0(BD@*$IU<W1I9GD-"E))1TA4
M*2`H5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,
M:6YE("A,87EE<B!)3E!55$1)345.4TE/3E,I("A/<FEG:6X@+3<U+"`P*2`H
M16YD4&]I;G0@+3<U+"`M,3<P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN
M92`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I9VEN("TT,"P@,"D@*$5N
M9%!O:6YT("TT,"P@+3$W,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@
M*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`M-S4L("TQ-34I("A%
M;F10;VEN="`M,3(U+"`M,34U*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN
M92`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I9VEN("TT,"P@+3$U-2D@
M*$5N9%!O:6YT(#$P+"`M,34U*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN
M92`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I9VEN("TW-2P@+3$U-2D@
M*$5N9%!O:6YT("TX-2P@+3$U,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`M-S4L("TQ-34I
M("A%;F10;VEN="`M.#4L("TQ-C`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,
M:6YE("A,87EE<B!)3E!55$1)345.4TE/3E,I("A/<FEG:6X@+3@U+"`M,34P
M*2`H16YD4&]I;G0@+3@U+"`M,38P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3&EN92`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I9VEN("TT,"P@+3$U
M-2D@*$5N9%!O:6YT("TS,"P@+3$U,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-
M"DQI;F4@*$QA>65R($E.4%541$E-14Y324].4RD@*$]R:6=I;B`M-#`L("TQ
M-34I("A%;F10;VEN="`M,S`L("TQ-C`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M#0I,:6YE("A,87EE<B!)3E!55$1)345.4TE/3E,I("A/<FEG:6X@+3,P+"`M
M,34P*2`H16YD4&]I;G0@+3,P+"`M,38P*2`\+W-P86X^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*5&5X="`H3&%Y97(@24Y0551$24U%3E-)3TY3*2`H3W)I9VEN("TU-RXU
M+"`M,3<U*2`H5&5X="`B5"(I("A*=7-T:69Y#0I54%!%4D-%3E1%4BD@*%1E
M>'13='EL92`B2#4P4S,B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H
M3&%Y97(@1$E-14Y324].*2`H3W)I9VEN("TT.2P@,"D@*$5N9%!O:6YT("TT
M.2P@,3<P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-
M14Y324].*2`H3W)I9VEN(#0Y+"`P*2`H16YD4&]I;G0@-#DL(#$W,"D@/"]S
M<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@
M("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R($1)345.4TE/3BD@*$]R
M:6=I;B`M-#DL(#$U-2D@*$5N9%!O:6YT("TY.2P@,34U*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN(#0Y
M+"`Q-34I("A%;F10;VEN="`Y.2P@,34U*2`\+W-P86X^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN("TT.2P@,34U*2`H
M16YD4&]I;G0@+34Y+"`Q-C`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE
M("A,87EE<B!$24U%3E-)3TXI("A/<FEG:6X@+30Y+"`Q-34I("A%;F10;VEN
M="`M-3DL(#$U,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R
M($1)345.4TE/3BD@*$]R:6=I;B`M-3DL(#$V,"D@*$5N9%!O:6YT("TU.2P@
M,34P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-14Y3
M24].*2`H3W)I9VEN(#0Y+"`Q-34I("A%;F10;VEN="`U.2P@,38P*2`\+W-P
M86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@
M("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I
M9VEN(#0Y+"`Q-34I("A%;F10;VEN="`U.2P@,34P*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN(#4Y+"`Q
M-C`I("A%;F10;VEN="`U.2P@,34P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M5&5X="`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN(#`L(#$W-2D@*%1E>'0@
M(CDX(BD@*$IU<W1I9GD-"DQ/5T520T5.5$52*2`H5&5X=%-T>6QE(")(-3!3
M,R(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!$24U%3E-)
M3TXI("A/<FEG:6X@+3<U+"`P*2`H16YD4&]I;G0@+3<U+"`R-#4I(#PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!$24U%3E-)3TXI("A/<FEG
M:6X@-S4L(#`I("A%;F10;VEN="`W-2P@,C0U*2`\+W-P86X^/&)R('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.PT*3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN("TW-2P@,C,P
M*2`H16YD4&]I;G0@-S4L(#(S,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R($1)345.4TE/3BD@*$]R:6=I;B`M-S4L(#(S,"D@*$5N9%!O
M:6YT("TV-2P@,C,U*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y
M97(@1$E-14Y324].*2`H3W)I9VEN("TW-2P@,C,P*2`H16YD4&]I;G0@+38U
M+"`R,C4I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!$24U%
M3E-)3TXI("A/<FEG:6X@+38U+"`R,S4I("A%;F10;VEN="`M-C4L(#(R-2D@
M/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R($1)345.4TE/3BD@
M*$]R:6=I;B`W-2P@,C,P*2`H16YD4&]I;G0@-C4L(#(S-2D@/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS
M<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R($1)345.4TE/3BD@*$]R:6=I;B`W
M-2P@,C,P*2`H16YD4&]I;G0@-C4L(#(R-2D@/"]S<&%N/CQB<B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DQI;F4@*$QA>65R($1)345.4TE/3BD@*$]R:6=I;B`V-2P@,C,U*2`H
M16YD4&]I;G0@-C4L(#(R-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E1E>'0@
M*$QA>65R($1)345.4TE/3BD@*$]R:6=I;B`P+"`R-3`I("A497AT("(Q-3`B
M*2`H2G5S=&EF>0T*3$]715)#14Y415(I("A497AT4W1Y;&4@(D@U,%,S(BD@
M/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R($1)345.4TE/3BD@
M*$]R:6=I;B`P+"`X,"D@*$5N9%!O:6YT(#$V-"P@.#`I(#PO<W!A;CX\8G(@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I,:6YE("A,87EE<B!$24U%3E-)3TXI("A/<FEG:6X@,"P@
M+3@P*2`H16YD4&]I;G0@,38T+"`M.#`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M#0I,:6YE("A,87EE<B!$24U%3E-)3TXI("A/<FEG:6X@,30Y+"`X,"D@*$5N
M9%!O:6YT(#$T.2P@+3@P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H
M3&%Y97(@1$E-14Y324].*2`H3W)I9VEN(#$T.2P@.#`I("A%;F10;VEN="`Q
M-#0L(#<P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-
M14Y324].*2`H3W)I9VEN(#$T.2P@.#`I("A%;F10;VEN="`Q-30L(#<P*2`\
M+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*
M("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-14Y324].*2`H
M3W)I9VEN(#$T-"P@-S`I("A%;F10;VEN="`Q-30L(#<P*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN(#$T
M.2P@+3@P*2`H16YD4&]I;G0@,30T+"`M-S`I(#PO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I,:6YE("A,87EE<B!$24U%3E-)3TXI("A/<FEG:6X@,30Y+"`M.#`I
M("A%;F10;VEN="`Q-30L("TW,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R($1)345.4TE/3BD@*$]R:6=I;B`Q-#0L("TW,"D@*$5N9%!O
M:6YT(#$U-"P@+3<P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5&5X="`H3&%Y
M97(@1$E-14Y324].*2`H3W)I9VEN(#$V.2P@,"D@*%1E>'0@(C$V,"(I("A*
M=7-T:69Y($Q%1E0I#0HH5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A;CX\8G(@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I,:6YE("A,87EE<B!$24U%3E-)3TXI("A/<FEG:6X@+34W
M+C4L(#0U*2`H16YD4&]I;G0@+3$W,BXU+"`T-2D@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DQI;F4@*$QA>65R($1)345.4TE/3BD@*$]R:6=I;B`M-3<N-2P@
M,34I("A%;F10;VEN="`M,3<R+C4L(#$U*2`\+W-P86X^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN("TQ-3<N-2P@-#4I
M("A%;F10;VEN="`M,34W+C4L(#DU*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN("TQ-3<N-2P@,34I("A%
M;F10;VEN="`M,34W+C4L("TS-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R($1)345.4TE/3BD@*$]R:6=I;B`M,34W+C4L(#0U*2`H16YD
M4&]I;G0@+3$V,BXU+"`U-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@
M*$QA>65R($1)345.4TE/3BD@*$]R:6=I;B`M,34W+C4L(#0U*2`H16YD4&]I
M;G0@+3$U,BXU+"`U-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA
M>65R($1)345.4TE/3BD@*$]R:6=I;B`M,38R+C4L(#4U*2`H16YD4&]I;G0@
M+3$U,BXU+"`U-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R
M($1)345.4TE/3BD@*$]R:6=I;B`M,34W+C4L(#$U*2`H16YD4&]I;G0@+3$V
M,BXU+"`U*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-
M14Y324].*2`H3W)I9VEN("TQ-3<N-2P@,34I("A%;F10;VEN="`M,34R+C4L
M(#4I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!$24U%3E-)
M3TXI("A/<FEG:6X@+3$V,BXU+"`U*2`H16YD4&]I;G0@+3$U,BXU+"`U*2`\
M+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*
M("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.PT*5&5X="`H3&%Y97(@1$E-14Y324].*2`H
M3W)I9VEN("TQ-S<N-2P@,S`I("A497AT("(S,"(I("A*=7-T:69Y(%))1TA4
M*0T**%1E>'13='EL92`B2#4P4S,B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN("TW-2P@,"D@*$5N9%!O
M:6YT("TW-2P@+3$W,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA
M>65R($1)345.4TE/3BD@*$]R:6=I;B`M-#`L(#`I("A%;F10;VEN="`M-#`L
M("TQ-S`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!$24U%
M3E-)3TXI("A/<FEG:6X@+3<U+"`M,34U*2`H16YD4&]I;G0@+3$R-2P@+3$U
M-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R($1)345.4TE/
M3BD@*$]R:6=I;B`M-#`L("TQ-34I("A%;F10;VEN="`Q,"P@+3$U-2D@/"]S
M<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@
M("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R($1)345.4TE/3BD@*$]R
M:6=I;B`M-S4L("TQ-34I("A%;F10;VEN="`M.#4L("TQ-3`I(#PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!$24U%3E-)3TXI("A/<FEG:6X@
M+3<U+"`M,34U*2`H16YD4&]I;G0@+3@U+"`M,38P*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*3&EN92`H3&%Y97(@1$E-14Y324].*2`H3W)I9VEN("TX-2P@
M+3$U,"D@*$5N9%!O:6YT("TX-2P@+3$V,"D@/"]S<&%N/CQB<B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DQI;F4@*$QA>65R($1)345.4TE/3BD@*$]R:6=I;B`M-#`L("TQ-34I
M("A%;F10;VEN="`M,S`L("TQ-3`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,
M:6YE("A,87EE<B!$24U%3E-)3TXI("A/<FEG:6X@+30P+"`M,34U*2`H16YD
M4&]I;G0@+3,P+"`M,38P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H
M3&%Y97(@1$E-14Y324].*2`H3W)I9VEN("TS,"P@+3$U,"D@*$5N9%!O:6YT
M("TS,"P@+3$V,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E1E>'0@*$QA>65R
M($1)345.4TE/3BD@*$]R:6=I;B`M-3<N-2P@+3$W-2D@*%1E>'0@(C,U(BD@
M*$IU<W1I9GD-"E504$520T5.5$52*2`H5&5X=%-T>6QE(")(-3!3,R(I(#PO
M<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I!='1R:6)U=&4@*$QA>65R(%1/4%]324Q+
M4T-2145.*2`H3W)I9VEN(#`L(#`I("A!='1R(")2969$97,B(")2969$97,B
M*0T**$ES5FES:6)L92!4<G5E*2`H2G5S=&EF>2!#14Y415(I("A497AT4W1Y
M;&4@(D@U,%,S(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"D%T=')I8G5T92`H
M3&%Y97(@5$]07U-)3$M30U)%14XI("A/<FEG:6X@,"P@,"D@*$%T='(@(E1Y
M<&4B(")$158B*0T**$IU<W1I9GD@0T5.5$52*2`H5&5X=%-T>6QE(")(-3!3
M,R(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I!='1R:6)U=&4@*$QA>65R(%1/
M4%]324Q+4T-2145.*2`H3W)I9VEN(#`L(#`I("A!='1R(")03B(@(E!.(BD-
M"BA*=7-T:69Y($-%3E1%4BD@*%1E>'13='EL92`B2#4P4S,B*2`\+W-P86X^
M/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@
M/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.PT*071T<FEB=71E("A,87EE<B!43U!?4TE,2U-#4D5%
M3BD@*$]R:6=I;B`P+"`P*2`H071T<B`B1$56(B`B1$56(BD-"BA*=7-T:69Y
M($-%3E1%4BD@*%1E>'13='EL92`B2#4P4S,B*2`\+W-P86X^/&)R('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.PT*071T<FEB=71E("A,87EE<B!43U!?4TE,2U-#4D5%3BD@*$]R:6=I
M;B`P+"`P*2`H071T<B`B5D%,(B`B5D%,(BD-"BA*=7-T:69Y($-%3E1%4BD@
M*%1E>'13='EL92`B2#4P4S,B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*071T
M<FEB=71E("A,87EE<B!43U!?4TE,2U-#4D5%3BD@*$]R:6=I;B`P+"`P*2`H
M071T<B`B5$],(B`B5$],(BD-"BA*=7-T:69Y($-%3E1%4BD@*%1E>'13='EL
M92`B2#4P4S,B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*071T<FEB=71E("A,
M87EE<B!43U!?05-314U"3%DI("A/<FEG:6X@,"P@,"D@*$%T='(@(E)E9D1E
M<S(B(")2969$97,R(BD-"BA)<U9I<VEB;&4@5')U92D@*$IU<W1I9GD@0T5.
M5$52*2`H5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M#0I!='1R:6)U=&4@*$QA>65R(%5315(Q*2`H3W)I9VEN(#`L(#`I("A!='1R
M(")5<V5R1&5F:6YE9#$B#0HB4UE-7U)%5CU!,"(I("A)<U9I<VEB;&4@5')U
M92D@*$IU<W1I9GD@0T5.5$52*2`H5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I!='1R:6)U=&4@*$QA>65R(%5315(Q*2`H3W)I
M9VEN(#`L(#`I("A!='1R(")5<V5R1&5F:6YE9#(B#0HB0U)%051%1%]$051%
M(BD@*$ES5FES:6)L92!4<G5E*2`H2G5S=&EF>2!#14Y415(I("A497AT4W1Y
M;&4@(D@U,%,S(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"D%T=')I8G5T92`H
M3&%Y97(@55-%4C$I("A/<FEG:6X@,"P@,"D@*$%T='(@(E5S97)$969I;F5D
M,R(-"B)53%1%35!,051%/55N:VYO=VXB*2`H27-6:7-I8FQE(%1R=64I("A*
M=7-T:69Y($-%3E1%4BD@*%1E>'13='EL90T*(D@U,%,S(BD@/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS
M<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@
M,S8V+"`V-S`I("A%;F10;VEN="`R-C8L(#8W,"D@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@,C8V+"`V
M-S`I("A%;F10;VEN="`R,38L(#4W,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-
M"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@,C$V+"`U-S`I("A%
M;F10;VEN="`R-C8L(#0W,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@
M*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@,C8V+"`T-S`I("A%;F10;VEN
M="`S-C8L(#0W,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R
M(%!)3E]$151!24PI("A/<FEG:6X@,C$V+"`U-S`I("A%;F10;VEN="`Q-C8L
M(#4W,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$
M151!24PI("A/<FEG:6X@,38V+"`U-S`I("A%;F10;VEN="`Q,S8L(#0U,"D@
M/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI
M("A/<FEG:6X@,34P+"`T,S`I("A%;F10;VEN="`Q.#`L(#4U,"D@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG
M:6X@,3@P+"`U-3`I("A%;F10;VEN="`R,C8L(#4U,"D@/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@,S8S
M+"`T-#,I("A%;F10;VEN="`S.30L(#4W.2D@/"]S<&%N/CQB<B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@,SDT+"`U-SDI
M("A%;F10;VEN="`S-3`L(#8Q,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@,S4P+"`V,3`I("A%;F10
M;VEN="`S.#,L(#<P."D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA
M>65R(%!)3E]$151!24PI("A/<FEG:6X@,34P+"`T,S`I("A%;F10;VEN="`X
M,"P@-#,P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.
M7T1%5$%)3"D@*$]R:6=I;B`X,"P@-#,P*2`H16YD4&]I;G0@.#`L(#0U,"D@
M/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI
M("A/<FEG:6X@,3,V+"`T-3`I("A%;F10;VEN="`X,"P@-#4P*2`\+W-P86X^
M/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@
M/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I
M;B`Q-S@L(#0S,"D@*$5N9%!O:6YT(#4R+"`T,S`I(#PO<W!A;CX\8G(@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN(#4R+"`T
M,S`I("A%;F10;VEN="`U,BP@-#(P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`U,BP@-#(P*2`H16YD
M4&]I;G0@,3<X+"`T,C`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,
M87EE<B!024Y?1$5404E,*2`H3W)I9VEN(#$W."P@-#(P*2`H16YD4&]I;G0@
M,3<X+"`T,S`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!0
M24Y?1$5404E,*2`H3W)I9VEN(#$U,"P@-#(P*2`H16YD4&]I;G0@,34P+"`S
M.#`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$54
M04E,*2`H3W)I9VEN(#$W."P@-#(P*2`H16YD4&]I;G0@,3<X+"`T,#`I(#PO
M<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H
M3W)I9VEN(#$U,"P@-#`U*2`H16YD4&]I;G0@,3<X+"`T,#4I(#PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I497AT("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN
M(#$V-"P@,SDU*2`H5&5X="`B,30B*2`H2G5S=&EF>0T*55!015),1494*2`H
M5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE
M("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN(#$U,"P@-#`U*2`H16YD4&]I
M;G0@,38P+"`T,#`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE
M<B!024Y?1$5404E,*2`H3W)I9VEN(#$V,"P@-#`P*2`H16YD4&]I;G0@,38P
M+"`T,3`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?
M1$5404E,*2`H3W)I9VEN(#$V,"P@-#$P*2`H16YD4&]I;G0@,34P+"`T,#4I
M(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*
M#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,
M*2`H3W)I9VEN(#$W."P@-#`U*2`H16YD4&]I;G0@,38X+"`T,3`I(#PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I
M9VEN(#$V."P@-#$P*2`H16YD4&]I;G0@,38X+"`T,#`I(#PO<W!A;CX\8G(@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN(#$V
M."P@-#`P*2`H16YD4&]I;G0@,3<X+"`T,#4I(#PO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN(#4R+"`T,C`I
M("A%;F10;VEN="`U,BP@-#`P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN
M92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`X,"P@-#(P*2`H16YD4&]I
M;G0@.#`L(#,X,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R
M(%!)3E]$151!24PI("A/<FEG:6X@-3(L(#0P-2D@*$5N9%!O:6YT(#@P+"`T
M,#4I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I497AT("A,87EE<B!024Y?1$54
M04E,*2`H3W)I9VEN(#8V+"`S.34I("A497AT("(Q-"(I("A*=7-T:69Y#0I5
M4%!%4E))1TA4*2`H5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A;CX\8G(@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN(#4R+"`T
M,#4I("A%;F10;VEN="`V,BP@-#$P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`V,BP@-#$P*2`H16YD
M4&]I;G0@-C(L(#0P,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA
M>65R(%!)3E]$151!24PI("A/<FEG:6X@-C(L(#0P,"D@*$5N9%!O:6YT(#4R
M+"`T,#4I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?
M1$5404E,*2`H3W)I9VEN(#@P+"`T,#4I("A%;F10;VEN="`W,"P@-#`P*2`\
M+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*
M("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@
M*$]R:6=I;B`W,"P@-#`P*2`H16YD4&]I;G0@-S`L(#0Q,"D@/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS
M<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@
M-S`L(#0Q,"D@*$5N9%!O:6YT(#@P+"`T,#4I(#PO<W!A;CX\8G(@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN(#$U,"P@,S@U
M*2`H16YD4&]I;G0@.#`L(#,X-2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E1E
M>'0@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@,3$U+"`S.#`I("A497AT
M("(S-2(I("A*=7-T:69Y#0I54%!%4D-%3E1%4BD@*%1E>'13='EL92`B2#4P
M4S,B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%
M5$%)3"D@*$]R:6=I;B`X,"P@,S@U*2`H16YD4&]I;G0@.3`L(#,X,"D@/"]S
M<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@
M("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/
M<FEG:6X@.3`L(#,X,"D@*$5N9%!O:6YT(#DP+"`S.3`I(#PO<W!A;CX\8G(@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN(#DP
M+"`S.3`I("A%;F10;VEN="`X,"P@,S@U*2`\+W-P86X^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`Q-3`L(#,X-2D@
M*$5N9%!O:6YT(#$T,"P@,SDP*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN
M92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`Q-#`L(#,Y,"D@*$5N9%!O
M:6YT(#$T,"P@,S@P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y
M97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`Q-#`L(#,X,"D@*$5N9%!O:6YT(#$U
M,"P@,S@U*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.
M7T1%5$%)3"D@*$]R:6=I;B`M,C8R+"`T,S`I("A%;F10;VEN="`M,C,X+"`T
M,S`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$54
M04E,*2`H3W)I9VEN("TR,S@L(#0S,"D@*$5N9%!O:6YT("TR,S@L(#4W,"D@
M/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI
M("A/<FEG:6X@+3(V,BP@-#,P*2`H16YD4&]I;G0@+3(V,BP@-3<P*2`\+W-P
M86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@
M("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R
M:6=I;B`M,C8R+"`T-3`I("A%;F10;VEN="`M,C,X+"`T-3`I(#PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN
M("TR.3(L(#4W,"D@*$5N9%!O:6YT("TR,#@L(#4W,"D@/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@+3(V
M,BP@-#<P*2`H16YD4&]I;G0@+3(Y,BP@-#<P*2`\+W-P86X^/&)R('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`M,C,X+"`T
M-S`I("A%;F10;VEN="`M,C`X+"`T-S`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN("TR.3(L(#8W,"D@
M*$5N9%!O:6YT("TR,#@L(#8W,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@+3$Y."P@-S`P*2`H16YD
M4&]I;G0@+3(R."P@-C`P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H
M3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`M,C(X+"`V,#`I("A%;F10;VEN
M="`M,3@X+"`U-#`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE
M<B!024Y?1$5404E,*2`H3W)I9VEN("TQ.#@L(#4T,"D@*$5N9%!O:6YT("TR
M,34L(#0T,2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)
M3E]$151!24PI("A/<FEG:6X@+3(X,BP@-S`P*2`H16YD4&]I;G0@+3,Q,BP@
M-C`P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%
M5$%)3"D@*$]R:6=I;B`M,S$R+"`V,#`I("A%;F10;VEN="`M,C<R+"`U-#`I
M(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*
M#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,
M*2`H3W)I9VEN("TR-S(L(#4T,"D@*$5N9%!O:6YT("TR.3DL(#0T,2D@/"]S
M<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@
M("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/
M<FEG:6X@+3(V,RP@-#,P*2`H16YD4&]I;G0@+3(S-RP@-#,P*2`\+W-P86X^
M/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@
M/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I
M;B`M,C8S+"`T,C`I("A%;F10;VEN="`M,C,W+"`T,C`I(#PO<W!A;CX\8G(@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN("TR
M-C,L(#0S,"D@*$5N9%!O:6YT("TR-C,L(#0R,"D@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@+3(S-RP@
M-#,P*2`H16YD4&]I;G0@+3(S-RP@-#(P*2`\+W-P86X^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`M,C8S+"`T,#`I
M("A%;F10;VEN="`M,C8S+"`T,C`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,
M:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN("TR,S<L(#0P,"D@*$5N
M9%!O:6YT("TR,S<L(#0R,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@
M*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@+3(V,RP@-#`U*2`H16YD4&]I
M;G0@+3(Y,RP@-#`U*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y
M97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`M,C8S+"`T,#4I("A%;F10;VEN="`M
M,C<S+"`T,3`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!0
M24Y?1$5404E,*2`H3W)I9VEN("TR-S,L(#0Q,"D@*$5N9%!O:6YT("TR-S,L
M(#0P,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$
M151!24PI("A/<FEG:6X@+3(W,RP@-#`P*2`H16YD4&]I;G0@+3(V,RP@-#`U
M*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-
M"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)
M3"D@*$]R:6=I;B`M,C,W+"`T,#4I("A%;F10;VEN="`M,C`W+"`T,#4I(#PO
M<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H
M3W)I9VEN("TR,S<L(#0P-2D@*$5N9%!O:6YT("TR,C<L(#0Q,"D@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG
M:6X@+3(R-RP@-#$P*2`H16YD4&]I;G0@+3(R-RP@-#`P*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`M
M,C(W+"`T,#`I("A%;F10;VEN="`M,C,W+"`T,#4I(#PO<W!A;CX\8G(@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I497AT("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN("TQ.3<L
M(#,X-2D@*%1E>'0@(C$T(BD@*$IU<W1I9GD-"DQ/5T523$5&5"D@*%1E>'13
M='EL92`B2#4P4S,B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y
M97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`M,C8R+"`S.#`I("A%;F10;VEN="`M
M,C8R+"`T,C`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!0
M24Y?1$5404E,*2`H3W)I9VEN("TR,S@L(#,X,"D@*$5N9%!O:6YT("TR,S@L
M(#0R,"D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$
M151!24PI("A/<FEG:6X@+3(V,BP@,S@U*2`H16YD4&]I;G0@+3(Y,BP@,S@U
M*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-
M"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)
M3"D@*$]R:6=I;B`M,C8R+"`S.#4I("A%;F10;VEN="`M,C<R+"`S.3`I(#PO
M<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H
M3W)I9VEN("TR-S(L(#,Y,"D@*$5N9%!O:6YT("TR-S(L(#,X,"D@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG
M:6X@+3(W,BP@,S@P*2`H16YD4&]I;G0@+3(V,BP@,S@U*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`M
M,C,X+"`S.#4I("A%;F10;VEN="`M,C`X+"`S.#4I(#PO<W!A;CX\8G(@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I,:6YE("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN("TR,S@L
M(#,X-2D@*$5N9%!O:6YT("TR,C@L(#,Y,"D@/"]S<&%N/CQB<B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"DQI;F4@*$QA>65R(%!)3E]$151!24PI("A/<FEG:6X@+3(R."P@,SDP
M*2`H16YD4&]I;G0@+3(R."P@,S@P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3&EN92`H3&%Y97(@4$E.7T1%5$%)3"D@*$]R:6=I;B`M,C(X+"`S.#`I("A%
M;F10;VEN="`M,C,X+"`S.#4I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I497AT
M("A,87EE<B!024Y?1$5404E,*2`H3W)I9VEN("TQ.3@L(#,X-2D@*%1E>'0@
M(C$R(BD@*$IU<W1I9GD-"E504$523$5&5"D@*%1E>'13='EL92`B2#4P4S,B
M*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-
M"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5&5X="`H3&%Y97(@4$E.7T1%5$%)
M3"D@*$]R:6=I;B`M-3`L(#4W,"D@*%1E>'0@(B@R>"!38V%L92DB*2`H2G5S
M=&EF>0T*0T5.5$52*2`H5&5X=%-T>6QE(")(-3!3,R(I(#PO<W!A;CX\8G(@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I,:6YE("A,87EE<B!43U!?4TE,2U-#4D5%3BD@*$]R:6=I
M;B`M-#DL(#@P*2`H16YD4&]I;G0@+30Y+`T*-C4N,3`P,#`P,S@Q-#8Y-RD@
M*%=I9'1H(#8I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!4
M3U!?4TE,2U-#4D5%3BD@*$]R:6=I;B`M-#DL("TX,"D@*$5N9%!O:6YT(#0Y
M+"`M.#`I("A7:61T:`T*-BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@
M*$QA>65R(%1/4%]324Q+4T-2145.*2`H3W)I9VEN(#0Y+"`M.#`I("A%;F10
M;VEN="`T.2P-"BTV-2XQ,#`P,#`S.#$T-CDW*2`H5VED=&@@-BD@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$QA>65R(%1/4%]324Q+4T-2145.*2`H
M3W)I9VEN(#0Y+"`X,"D@*$5N9%!O:6YT("TT.2P@.#`I("A7:61T:`T*-BD@
M/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!O;'D@*$QA>65R(#-$7T181BD@*$]R
M:6=I;B`P+"`P*2`H4')O<&5R='D@(DA%24=(5%)!3D=%/3$P+#$P,"(I#0HH
M5VED=&@@-BDF;F)S<#L@*"TT.2P@.#`I("@M-#DL("TX,"D@*#0Y+"`M.#`I
M("@T.2P@.#`I/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"D%R8R`H3&%Y97(@5$]0
M7U-)3$M30U)%14XI("A/<FEG:6X@,"P@.#`I("A2861I=7,@,3(I("A3=&%R
M=$%N9VQE(#$X,"D-"BA3=V5E<$%N9VQE(#$X,"D@*%=I9'1H(#8I(#PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A,87EE<B!43U!?05-314U"3%DI("A/
M<FEG:6X@+30Y+"`X,"D@*$5N9%!O:6YT("TT.2P@+3@P*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@5$]07T%34T5-0DQ9*2`H3W)I9VEN
M("TT.2P@+3@P*2`H16YD4&]I;G0@-#DL("TX,"D@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"DQI;F4@*$QA>65R(%1/4%]!4U-%34),62D@*$]R:6=I;B`T.2P@
M+3@P*2`H16YD4&]I;G0@-#DL(#@P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3&EN92`H3&%Y97(@5$]07T%34T5-0DQ9*2`H3W)I9VEN(#0Y+"`X,"D@*$5N
M9%!O:6YT("TT.2P@.#`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I!<F,@*$QA
M>65R(%1/4%]!4U-%34),62D@*$]R:6=I;B`P+"`X,"D@*%)A9&EU<R`Q,BD@
M*%-T87)T06YG;&4@,3@P*0T**%-W965P06YG;&4@,3@P*2`\8G(^#0H-"B`@
M("`@(#PO<W!A;CX\8G(^#0H-"D)E;&]W+"!T:&4@(E=I>F%R9"(@96YT:71Y
M('1Y<&4@:7,@8V]N<VED97)E9"!A('-Y<W1E;2!V87)I86)L92XF;F)S<#L-
M"E1H:7,@=F%R:6%B;&4@=VEL;"!A;'=A>7,@<F5P<F5S96YT('-O;64@=7-E
M<B!E;G1E<F5D(&9I96QD('1H870@=V%S#0IU<V5D(&]N(&-A;&-U;&%T:6YG
M(&]R(&-R96%T:6YG('EO=7(@9F]O='!R:6YT+CQB<CX-"@T*("`@("`@/&)R
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P+"`P
M*2`H5F%R3F%M92`B5$5-4$Q!5$4B*2`H5F%R1&%T82`B041)7U-/7T,R+F%D
M="(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P+"`P
M*2`H5F%R3F%M92`B3D%-12(I("A687)$871A("(B*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(DXB*2`H
M5F%R1&%T82`B."(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R
M:6=I;B`P+"`P*2`H5F%R3F%M92`B02(I("A687)$871A("(Y."(I(#PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P+"`P*2`H5F%R3F%M
M92`B3"(I("A687)$871A("(Q-3`B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M5VEZ87)D("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(DQ-(BD@*%9A<D1A=&$@
M(C`B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@,"P@
M,"D@*%9A<DYA;64@(E`B*2`H5F%R1&%T82`B,S`B*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(D(B*2`H
M5F%R1&%T82`B,38P(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E=I>F%R9"`H
M3W)I9VEN(#`L(#`I("A687).86UE(")4(BD@*%9A<D1A=&$@(C,U(BD@/"]S
M<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@
M("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"E=I>F%R9"`H3W)I9VEN(#`L(#`I("A687).
M86UE(")7(BD@*%9A<D1A=&$@(C$R(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-
M"E=I>F%R9"`H3W)I9VEN(#`L(#`I("A687).86UE(").5"(I("A687)$871A
M(")!<F,B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@
M,"P@,"D@*%9A<DYA;64@(E14(BD@*%9A<D1A=&$@(DYO<FUA;"!-871E<FEA
M;"(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P+"`P
M*2`H5F%R3F%M92`B551/12(I("A687)$871A("(P(BD@/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L-"E=I>F%R9"`H3W)I9VEN(#`L(#`I("A687).86UE(")52$5%
M3"(I("A687)$871A("(P(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E=I>F%R
M9"`H3W)I9VEN(#`L(#`I("A687).86UE(")54TE$12(I("A687)$871A("(P
M(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E=I>F%R9"`H3W)I9VEN(#`L(#`I
M("A687).86UE(")+3R(I("A687)$871A("(P(BD@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#L-"E=I>F%R9"`H3W)I9VEN(#`L(#`I("A687).86UE(")+3U<B*2`H
M5F%R1&%T82`B-S@N-S0B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ87)D
M("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(DM/2"(I("A687)$871A("(W."XW
M-"(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P+"`P
M*2`H5F%R3F%M92`B2%14(BD@*%9A<D1A=&$@(C`B*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(DA45R(I
M("A687)$871A("(X,BXV-S<B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ
M87)D("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(DA42"(I("A687)$871A("(X
M,BXV-S<B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@
M,"P@,"D@*%9A<DYA;64@(D$Q7U!32"(I("A687)$871A(")/8FQO;F<B*2`\
M+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*
M("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@,"P@,"D@*%9A
M<DYA;64@(D$Q7U!!1%<B*2`H5F%R1&%T82`B-C`B*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(D$Q7U!!
M1$@B*2`H5F%R1&%T82`B.3`B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ
M87)D("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(D$Q7T123"(I("A687)$871A
M("(S,"(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P
M+"`P*2`H5F%R3F%M92`B03)?4%-((BD@*%9A<D1A=&$@(D]B;&]N9R(I(#PO
M<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P+"`P*2`H5F%R
M3F%M92`B03)?4$%$5R(I("A687)$871A("(Y,"(I(#PO<W!A;CX\8G(@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P+"`P*2`H5F%R3F%M92`B03)?4$%$
M2"(I("A687)$871A("(V,"(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA
M<F0@*$]R:6=I;B`P+"`P*2`H5F%R3F%M92`B03)?1%),(BD@*%9A<D1A=&$@
M(C,P(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E=I>F%R9"`H3W)I9VEN(#`L
M(#`I("A687).86UE(")04$-+(BD@*%9A<D1A=&$@(C`B*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(E!0
M4%-((BD@*%9A<D1A=&$@(E)O=6YD(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-
M"E=I>F%R9"`H3W)I9VEN(#`L(#`I("A687).86UE(")04%!36B(I("A687)$
M871A("(V,"(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I
M;B`P+"`P*2`H5F%R3F%M92`B4%!$4R(I("A687)$871A("(S-2(I(#PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P+"`P*2`H5F%R3F%M
M92`B4%!'0R(I("A687)$871A("(R(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-
M"E=I>F%R9"`H3W)I9VEN(#`L(#`I("A687).86UE(")04$=2(BD@*%9A<D1A
M=&$@(C(B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@
M,"P@,"D@*%9A<DYA;64@(E!01U`B*2`H5F%R1&%T82`B,3`P(BD@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"E=I>F%R9"`H3W)I9VEN(#`L(#`I("A687).86UE
M(")-5T$B*2`H5F%R1&%T82`B-"(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7
M:7IA<F0@*$]R:6=I;B`P+"`P*2`H5F%R3F%M92`B4E--0B(I("A687)$871A
M("(R(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E=I>F%R9"`H3W)I9VEN(#`L
M(#`I("A687).86UE("))4TU,(BD@*%9A<D1A=&$@(C`B*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*5VEZ87)D("A/<FEG:6X@,"P@,"D@*%9A<DYA;64@(D-(
M1U0B*2`H5F%R1&%T82`B,3`P(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E=I
M>F%R9"`H3W)I9VEN(#`L(#`I("A687).86UE(")#34A'5"(I("A687)$871A
M("(Q,"(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I;B`P
M+"`P*2`H5F%R3F%M92`B4%)/5"(I("A687)$871A("(P(BD@/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS
M<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"E=I>F%R9"`H3W)I9VEN(#`L(#`I("A687).86UE(")2
M159,159%3"(I("A687)$871A(")!,"(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB
M8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M#0I7:7IA<F0@*$]R:6=I;B`P+"`P*2`H5F%R3F%M92`B3W)I9VEN86Q0:6Y#
M;W5N="(I("A687)$871A("(X(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI
M;F4@*$QA>65R(%1/4%]324Q+4T-2145.*2`H3W)I9VEN("TT.2P@+38U+C$P
M,#`P,#,X,30V.3<I("A%;F10;VEN=`T*+30Y+"`M.#`I("A7:61T:"`V*2`\
M+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*
M("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.PT*3&EN92`H3&%Y97(@5$]07U-)3$M30U)%
M14XI("A/<FEG:6X@-#DL(#8U+C$P,#`P,#,X,30V.3<I("A%;F10;VEN="`T
M.2P-"C@P*2`H5VED=&@@-BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"D5N9$1A=&$\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R!%;F10
M871T97)N/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^#0H-"B`@("`@(#QB<CX-"@T*("`@("`@/"]T9#X-"@T*("`@(#PO='(^
M#0H-"B`@("`\='(^#0H-"B`@("`@(#QT9"!S='EL93TB<&%D9&EN9SH@,"XW
M-7!T.R!V97)T:6-A;"UA;&EG;CH@=&]P.R!W:61T:#H@,C`E.R(^/'-P86X@
M<W1Y;&4](F9O;G0M=V5I9VAT.B!B;VQD.R(^4V-H96UA=&EC#0IS>6UB;VQS
M/"]S<&%N/CQB<CX-"@T*("`@("`@/"]T9#X-"@T*("`@("`@/'1D('-T>6QE
M/2)P861D:6YG.B`P+C<U<'0[(CX\8G(^#0H-"E1H92!S>6UB;VP@:7,@;&%I
M9"!O=70@<VEM:6QA<B!T;R!T:&4@9F]O='!R:6YT+B9N8G-P.R!/;FQY(&1E
M=&%I;',@;F]T#0ID969I;F5D(&%B;W9E('=I;&P@8F4@8V]M;65N=&5D(&]N
M+CQB<CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^(U-Y;6)O;',\+W-P86X^/&)R('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/E-Y;6)O;',@.B`Q/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#L@4WEM8F]L#0HB<V\X+7`S,"UA.3@B/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"D]R:6=I;E!O:6YT)FYB
M<W`[("@P+"`P*3PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I/<FEG:6YA;$YA;64@(B(\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.PT*1&%T829N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R`Z(#$T/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L-"E!I;B`H4&EN3G5M(#$I("A/<FEG:6X@+30P,"P@,C`P*2`H
M4&EN3&5N9W1H(#$P,"D@*%)O=&%T92`Q.#`I("A7:61T:`T*."D@*$ES5FES
M:6)L92!4<G5E*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*4&EN1&5S("(Q(B`H+30R,"P@,C4P*2`H5&5X=%-T>6QE
M4F5F(")(.#!S-"(I("A*=7-T:69Y(%)I9VAT*0T**$ES5FES:6)L92!4<G5E
M*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-
M"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*4&EN3F%M92`B,2(@*"TS.#`L(#(P,"D@*%1E>'13='EL95)E9B`B2#@P
M<S0B*2`H2G5S=&EF>2!,969T*0T**$ES5FES:6)L92!4<G5E*2`\+W-P86X^
M/&)R/@T*#0H@("`@("`\8G(^#0H-"E1H92!P:6X@:7,@97%U:79E;&%N="!I
M;B!M86YY('=A>7,@=&\@=&AE(&9O;W1P<FEN="!P860N)FYB<W`[($ET(&UU
M<W0-"FAA=F4@82!N=6UB97(@86YD(&$@9&5S:6=N871O<BXF;F)S<#L@16%C
M:"!S>6UB;VP@;75S="!H879E(&%L;"!O9B!I=',-"G!I;G,@87-S:6=N960@
M82!N=6UB97(@8F5T=V5E;B!O;F4@86YD('1H92!T;W1A;"!N=6UB97(@;V8@
M<&EN<R!W:71H(&YO#0IG87!S(&]R(&1U<&QI8V%T97,@:6X@=&AE(&YU;6)E
M<G,@=7-E9"XF;F)S<#L@16%C:"!P:6X@<F5Q=6ER97,@86X-"D]R9VEN+"!0
M:6Y,96YG=&@@871T<FEB=71E(&%S('=E;&P@87,@=&AE(%!I;D1E<R`H<&EN
M(&1E<VEG;F%T;W(I('1H870-"G=I;&P@87!P96%R('1O('1H92!U<V5R+B9N
M8G-P.R!4:&4@9&5S:6=N871O<B!I<R!!3%=!65,F;F)S<#L-"G1E>'0N)FYB
M<W`[(%EE<RP@86QW87ES+"!E=F5N('=H96X@:70@;&]O:W,@;&EK92!A(&YU
M;6)E<BXF;F)S<#L@5&AE#0I0:6Y.86UE(&ES('1H92!T97AT(&9I96QD('1H
M870@=VEL;"!B92!F:6QL960@;W5T('=I=&@@=&AE('!I;G,-"F9U;F-T:6]N
M(&YA;64N)FYB<W`[(#QB<CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I0:6X@*%!I;DYU;2`R*2`H3W)I9VEN("TT,#`L(#$P,"D@
M*%!I;DQE;F=T:"`Q,#`I("A2;W1A=&4@,3@P*2`H5VED=&@-"C@I("A)<U9I
M<VEB;&4@5')U92D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"E!I;D1E<R`B,B(@*"TT,C`L(#$U,"D@*%1E>'13='EL
M95)E9B`B2#@P<S0B*2`H2G5S=&EF>2!2:6=H="D-"BA)<U9I<VEB;&4@5')U
M92D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#L-"E!I;DYA;64@(C(B("@M,S@P+"`Q,#`I("A497AT4W1Y;&52968@(D@X
M,',T(BD@*$IU<W1I9GD@3&5F="D-"BA)<U9I<VEB;&4@5')U92D@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"E!I;B`H4&EN3G5M(#,I("A/<FEG:6X@+30P,"P@
M,"D@*%!I;DQE;F=T:"`Q,#`I("A2;W1A=&4@,3@P*2`H5VED=&@@."D-"BA)
M<U9I<VEB;&4@5')U92D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"E!I;D1E<R`B,R(@*"TT,C`L(#4P*2`H5&5X=%-T
M>6QE4F5F(")(.#!S-"(I("A*=7-T:69Y(%)I9VAT*2`H27-6:7-I8FQE#0I4
M<G5E*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.PT*4&EN3F%M92`B,R(@*"TS.#`L(#`I("A497AT4W1Y;&52968@(D@X
M,',T(BD@*$IU<W1I9GD@3&5F="D@*$ES5FES:6)L90T*5')U92D@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"E!I;B`H4&EN3G5M(#0I("A/<FEG:6X@+30P,"P@
M+3$P,"D@*%!I;DQE;F=T:"`Q,#`I("A2;W1A=&4@,3@P*2`H5VED=&@-"C@I
M("A)<U9I<VEB;&4@5')U92D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"E!I;D1E<R`B-"(@*"TT,C`L("TU,"D@*%1E
M>'13='EL95)E9B`B2#@P<S0B*2`H2G5S=&EF>2!2:6=H="D-"BA)<U9I<VEB
M;&4@5')U92D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L-"E!I;DYA;64@(C0B("@M,S@P+"`M,3`P*2`H5&5X=%-T>6QE
M4F5F(")(.#!S-"(I("A*=7-T:69Y($QE9G0I#0HH27-6:7-I8FQE(%1R=64I
M(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*
M#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I0:6X@*%!I;DYU;2`U*2`H3W)I9VEN
M(#0P,"P@,C`P*2`H4&EN3&5N9W1H(#$P,"D@*%=I9'1H(#@I("A)<U9I<VEB
M;&4-"E1R=64I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I0:6Y$97,@(C4B("@T,C`L(#$U,"D@*%1E>'13='EL95)E
M9B`B2#@P<S0B*2`H2G5S=&EF>2!,969T*2`H27-6:7-I8FQE#0I4<G5E*2`\
M+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*
M("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M4&EN3F%M92`B-2(@*#,X,"P@,C`P*2`H5&5X=%-T>6QE4F5F(")(.#!S-"(I
M("A*=7-T:69Y(%)I9VAT*0T**$ES5FES:6)L92!4<G5E*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*4&EN("A0:6Y.=6T@-BD@*$]R:6=I;B`T,#`L(#$P,"D@
M*%!I;DQE;F=T:"`Q,#`I("A7:61T:"`X*2`H27-6:7-I8FQE#0I4<G5E*2`\
M+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*
M("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M4&EN1&5S("(V(B`H-#(P+"`U,"D@*%1E>'13='EL95)E9B`B2#@P<S0B*2`H
M2G5S=&EF>2!,969T*2`H27-6:7-I8FQE#0I4<G5E*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*4&EN3F%M92`B-B(@
M*#,X,"P@,3`P*2`H5&5X=%-T>6QE4F5F(")(.#!S-"(I("A*=7-T:69Y(%)I
M9VAT*0T**$ES5FES:6)L92!4<G5E*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M4&EN("A0:6Y.=6T@-RD@*$]R:6=I;B`T,#`L(#`I("A0:6Y,96YG=&@@,3`P
M*2`H5VED=&@@."D@*$ES5FES:6)L90T*5')U92D@/"]S<&%N/CQB<B!S='EL
M93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E!I;D1E<R`B-R(@*#0R
M,"P@+34P*2`H5&5X=%-T>6QE4F5F(")(.#!S-"(I("A*=7-T:69Y($QE9G0I
M("A)<U9I<VEB;&4-"E1R=64I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[#0I0:6Y.86UE("(W(B`H,S@P+"`P*2`H5&5X
M=%-T>6QE4F5F(")(.#!S-"(I("A*=7-T:69Y(%)I9VAT*2`H27-6:7-I8FQE
M#0I4<G5E*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*4&EN("A0:6Y.=6T@."D@
M*$]R:6=I;B`T,#`L("TQ,#`I("A0:6Y,96YG=&@@,3`P*2`H5VED=&@@."D@
M*$ES5FES:6)L90T*5')U92D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G
M8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"E!I;D1E<R`B."(@*#0R,"P@+3$U,"D@*%1E
M>'13='EL95)E9B`B2#@P<S0B*2`H2G5S=&EF>2!,969T*2`H27-6:7-I8FQE
M#0I4<G5E*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@
M,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*4&EN3F%M92`B."(@*#,X,"P@+3$P,"D@*%1E>'13='EL95)E
M9B`B2#@P<S0B*2`H2G5S=&EF>2!2:6=H="D-"BA)<U9I<VEB;&4@5')U92D@
M/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"DQI;F4@*$]R:6=I;B`M-#`P+"`S,#`I
M("A%;F10;VEN="`M-#`P+"`M,C`P*2`H5VED=&@@,3`I(#PO<W!A;CX\8G(@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[#0I,:6YE("A/<FEG:6X@-#`P+"`M,C`P*2`H16YD4&]I;G0@
M+30P,"P@+3(P,"D@*%=I9'1H(#$P*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M3&EN92`H3W)I9VEN(#0P,"P@+3(P,"D@*$5N9%!O:6YT(#0P,"P@,S`P*2`H
M5VED=&@@,3`I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I,:6YE("A/<FEG:6X@
M-#`P+"`S,#`I("A%;F10;VEN="`M-#`P+"`S,#`I("A7:61T:"`Q,"D@/"]S
M<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@
M("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L-"D%T=')I8G5T92`H3W)I9VEN(#`L(#,U,"D@
M*$%T='(@(E)E9D1E<R(@(E)E9D1E<R(I("A)<U9I<VEB;&4@5')U92D-"BA*
M=7-T:69Y($-E;G1E<BD@*%1E>'13='EL95)E9B`B:#$R-7,V(BD@/"]S<&%N
M/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@
M(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#L-"D%T=')I8G5T92`H3W)I9VEN(#`L("TR-S4I("A!
M='1R(")4>7!E(B`B5'EP92(I("A)<U9I<VEB;&4@5')U92D-"BA*=7-T:69Y
M($-E;G1E<BD@*%1E>'13='EL95)E9B`B:#$R-7,V(BD@/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"D5N9$1A=&$\+W-P86X^
M/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@
M/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N
M8G-P.R9N8G-P.R!%;F13>6UB;VP\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@
M<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\+W1D
M/@T*#0H@("`@/"]T<CX-"@T*("`@(#QT<CX-"@T*("`@("`@/'1D('-T>6QE
M/2)P861D:6YG.B`P+C<U<'0[('9E<G1I8V%L+6%L:6=N.B!T;W`[('=I9'1H
M.B`R,"4[(CX\<W!A;B!S='EL93TB9F]N="UW96EG:'0Z(&)O;&0[(CY#;VUP
M;VYE;G0-"E-E8W1I;VX\+W-P86X^/&)R/@T*#0H@("`@("`\+W1D/@T*#0H@
M("`@("`\=&0@<W1Y;&4](G!A9&1I;F<Z(#`N-S5P=#LB/CQB<CX-"@T*02!C
M;VUP;VYE;G0@:7,@=VAA="!T:65S('1H92!F;V]T<')I;G0@86YD('-Y;6)O
M;"!T;V=E=&AE<B!I;B!O=7(-"G1O;VPN)FYB<W`[($ET(&-O;G1A:6YS(&$@
M<&]I;G1E<B!T;R!T:&4@9F]O='!R:6YT(&%N9"!T:&4@<WEM8F]L<R!T:&%T
M#0IA<F4@=7-E9"P@87,@=V5L;"!A<R!D969I;FEN9R!W:&%T('!I;G,@8V%N
M(&)E('-W87!P960@;W(@=VAI8V@@<WEM8F]L<PT*8V%N(&)E('-W87!P960N
M/&)R/@T*#0H@("`@("`\8G(^#0H-"B`@("`@(#QB<CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B-#;VUP;VYE;G1S
M/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CY#
M;VUP;VYE;G1S(#H@,3PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[($-O;7!O;F5N=`T*(G-O
M."UP,S`M83DX(CPO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I0871T97)N3F%M929N8G-P.R9N8G-P.R`B<V\X+7`S,"UA.3@B
M/"]S<&%N/CQB<CX-"@T*("`@("`@/&)R/@T*#0I#=7)R96YT;'D@;VYL>2!O
M;F4@9F]O='!R:6YT(&-A;B!B92!A<W-I9VYE9"!T;R!A(&-O;7!O;F5N="XF
M;F)S<#L@5&AI<PT*87)E82!M87D@8F4@96YH86YC960@:6X@=&AE(&9U='5R
M92!T;R!H879E(&%N(&%R<F%Y(&%V86EL86)L92!F;W(-"F%L=&5R;F%T92!F
M;V]T<')I;G1S+CQB<CX-"@T*("`@("`@/&)R/@T*#0HF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#L\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[#0I/<FEG:6YA;$YA;64F;F)S<#L@(G-O
M."UP,S`M83DX(CPO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I3;W5R8V5,:6)R87)Y("(B/"]S<&%N/CQB<B!S='EL93TB8V]L
M;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E)E9D1E<U!R969I>"9N8G-P.R`B52(\
M+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*
M("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*3G5M
M8F5R;V90:6YS)FYB<W`[(#@\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R
M9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.PT*3G5M4&%R=',F;F)S<#LF;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#L@,3PO<W!A;CX\8G(^#0H-"B`@("`@(#QB<CX-"@T*5&AI<R!R
M969E<G,@=&\@:&]W(&UA;GD@<V-H96UA=&EC('-Y;6)O;',@87)E(')E<75I
M<F5D('1O(&-O;7!L971E;'D-"G)E<')E<V5N="!T:&ES(&-O;7!O;F5N="XF
M;F)S<#L@5&AA="!C;W5L9"!B92!O;F4@<WEM8F]L+"!A<R!I;B!T:&ES#0IC
M87-E+"!O="!I="!C;W5L9"!B92`Q,"!D:69F97)E;G0@<WEM8F]L<RP@;W(@
M:70@8V]U;&0@8F4@9F]U<@T*:61E;G1I8V%L('-Y;6)O;',N/&)R/@T*#0H@
M("`@("`\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I#;VUP
M;W-I=&EO;B9N8G-P.R9N8G-P.R!(971E<F]G96YE;W5S/"]S<&%N/CQB<B!S
M='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QB<CX-
M"@T*5&AI<R!C86X@8F4@:&5T<F]G96YE;W5S+"!A<R!I;B!E86-H('-Y;6)O
M;"!I<R!D:7-T:6YC=&QY(&1I9F9E<F5N="P@;W(-"FAO;6]G96YE;W5S+"!A
M<R!I;B!E86-H('-Y;6)O;"!I<R!A(&1U<&QI8V%T92!O9B!T:&4@;W1H97(@
M*&QI:V4@82`W-#`P#0IW:&EC:"!H87,@-"!I9&5N=&EC86P@<WEM8F]L<R!O
M<B!G871E<RDN/&)R/@T*#0H@("`@("`\8G(^#0H-"B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.SQS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CXF;F)S<#LF;F)S<#LF;F)S<#L-"D%L=$E%144F;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#L@1F%L<V4\+W-P86X^/&)R/@T*#0H@("`@
M("`\8G(^#0H-"DES('1H97)E(&%L<V\@86X@86QT97)N871E('-Y;6)O;"!I
M;B!)145%(&9O<FUA="!A=F%I;&%B;&4_/&)R/@T*#0H@("`@("`\8G(^#0H-
M"B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.SQS<&%N('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#L-"D%L=$1E36]R
M9V%N)FYB<W`[)FYB<W`[($9A;'-E/"]S<&%N/CQB<CX-"@T*("`@("`@/&)R
M/@T*#0I)<R!T:&5R92!A($1E;6]R9V%N('9I97<@;V8@=&AE('-Y;6)O;#\\
M8G(^#0H-"B`@("`@(#QB<CX-"@T*)FYB<W`[)FYB<W`[/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*4&%T=&5R;E!I;G,F;F)S<#LF;F)S<#L@.#PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I2979I<VEO;B!,
M979E;"`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*4F5V:7-I;VX@3F]T929N8G-P.R`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.PT*0V]M<%!I;G,F;F)S<#LF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@.B`X/"]S<&%N/CQB
M<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS
M<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#L-"D-O;7!0:6X@,2`B,2(@*%!A<G1.=6T@,2D@*%-Y;5!I
M;DYU;2`Q*2`H1V%T945Q(#`I("A0:6Y%<2`P*2`H4&EN5'EP90T*06YY*2`H
M4VED92!,969T*2`H1W)O=7`@,2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QB<CX-"@T*5&AE($-O;7!0
M:6X@;G5M8F5R(')E9F5R<R!T;R!T:&4@87)B:71R87)I;'D@;G5M8F5R960@
M;VYE('1O('!I;B!C;W5N=`T*;F\@9V%P<R!N;R!D=7!L:6-A=&5S(&YU;6)E
M<FEN9R!A<W-I9VYE9"XF;F)S<#L@270@:7,@='EP:6-A;&QY('1H90T*<V%M
M92!A<R!T:&4@;G5M8F5R:6YG(&]F(&$@;G5M8F5R960@<&%R="P@8G5T(&1O
M97,@;F]T(&AA=F4@=&\-"F)E+B9N8G-P.R!4:&ES(&YU;6)E<B!I<R!U<V5D
M(&QA=&5R(&EN('1H92!0:6Y-87`@=&\@9&5F:6YE('1H90T*<&%D;G5M8F5R
M('5S960@:6X@=&AE(&9O;W1P<FEN="XF;F)S<#L@26X@=&AE(%!I;DUA<"!A
M<F5A('1H:7,@:7,-"F-A;&QE9"!T:&4@0V]M<%!I;E)E9BXF;F)S<#L@3F5X
M="!T;R!T:&4@0V]M<%!I;B!I<R!T:&4@4&EN($1E<VEG;F%T;W(-"G1H870@
M=&AE('5S97(@=VEL;"!S964@:6X@86QM;W-T(&%L;"!I;G-T86YC97,N)FYB
M<W`[(%1H:7,@:7,@04Q705E3(&$-"G-T<FEN9R`H>65S(&%L=V%Y<RDL(&%N
M9"!I="!C86X@8V]N=&%I;B!A;'!H82!N=6UE<FEC<RXF;F)S<#L@270@<VAO
M=6QD#0IA;'-O(&)E('1H92!S86UE(&%S('=H870@=&AE(&1E<VEG;F%T;W(@
M:7,@;VX@=&AE('-Y;6)O;"!A;F0@=&AE#0IF;V]T<')I;G0L(&)U="!I9B!N
M;W0L('1H:7,@=VEL;"!!3%=!65,@=&%K92!P<F5S:61E;F-E+CQB<CX-"@T*
M("`@("`@/&)R/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I#;VUP4&EN(#(@
M(C(B("A087)T3G5M(#$I("A3>6U0:6Y.=6T@,BD@*$=A=&5%<2`P*2`H4&EN
M17$@,"D@*%!I;E1Y<&4-"D%N>2D@*%-I9&4@3&5F="D@*$=R;W5P(#$I(#PO
M<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@
M("`@("`\8G(^#0H-"E1H92!087)T3G5M('!R;W!E<G1Y(')E9F5R<R!T;R!W
M:&EC:"!S>6UB;VP@:6X@=&AE(&-O;&QE8W1I;VX@;V8-"G-Y;6)O;',@9F]R
M('1H:7,@8V]M<&]N96YT+B9N8G-P.R!4:&ES(&-O;7!O;F5N="!O;FQY(&AA
M<R!O;F4@<WEM8F]L#0IU<V5D+"!S;R!A;&P@;V8@=&AE(')E9F5R965N8V5S
M('1O(%!A<G1.=6T@=VEL;"!B92!O;F4N)FYB<W`[(%-Y;5!I;DYU;0T*:7,@
M=&AE(&YU;6)E<B!O9B!T:&4@<&EN(&EN('1H92!S>6UB;VP@=&AA="!I<R!B
M96EN9R!M87!P960N)FYB<W`[($ET#0IW:6QL(&%L=V%Y<R!B92!A(&YU;6)E
M<BP@86YD('=I;&P@86QW87ES(&)E(&QE<W,@=&AA;B!O<B!E<75A;"!T;R!T
M:&4-"FYU;6)E<B!O9B!P:6YS(&-A<G)I960@;VX@82!S>6UB;VPN/&)R/@T*
M#0H@("`@("`\8G(^#0H-"D=A=&4@97$@86YD('!I;B!E<2!R969E<B!T;R!G
M871E("AS>6UB;VPI(&%N9"!P:6X@<W=A<&%B:6QI='DN)FYB<W`[#0I4:&5S
M92!C86X@8F4@,"P@:6X@=VAI8V@@8V%S92!T:&5Y('-W87`@=VET:"!N;R!O
M;F4L(&]R('1H97D@8V%N(&)E(&$-"G=H;VQE(&YU;6)E<B!T:&%T(&UA=&-H
M97,@=&AO<V4@<&EN<R!A;F0@;W(@9V%T97,@=&AA="!A<F4@<W=A<'!A8FQE
M+CQB<CX-"@T*("`@("`@/&)R/@T*#0I0:6Y4>7!E(&-A;B!B92!A;GD@;V8@
M=&AE(&9O;&QO=VEN9SHF;F)S<#L@26YP=70L($]U=%!U="P-"D)I+41I<F5C
M=&EO;F%L+"!!;GDL)FYB<W`[(%!O=V5R+"!4<FE3=&%T92P@06YA;&]G/&)R
M/@T*#0H@("`@("`\8G(^#0H-"E-I9&5S(&-A;B!B92!4;W`L($)O='1O;2P@
M3&5F="!A;F0@4FEG:'0L(#QB<CX-"@T*("`@("`@/&)R/@T*#0I'<F]U<&EN
M9R!W:6QL(&1E86P@=VET:"!T:&4@<&QA8V5M96YT(&]F('1H92!P:6YS(&EN
M('1H92!S>6UB;VPN)FYB<W`[#0I'<F]U<&EN9W,@=VET:"!T:&4@<V%M92!N
M=6UB97(@=VEL;"!B92!G<F]U<&5D(&]N('1H92!S>6UB;VP@=&]G971H97(-
M"FER<F5G87)D;&5S<R!O9B!H;W<@=&AE>2!A<'!E87(@:6X@=&AE('-P<F5A
M9'-H965T+CQB<CX-"@T*("`@("`@/&)R/@T*#0HF;F)S<#LF;F)S<#L\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I#
M;VUP4&EN(#,@(C,B("A087)T3G5M(#$I("A3>6U0:6Y.=6T@,RD@*$=A=&5%
M<2`P*2`H4&EN17$@,"D@*%!I;E1Y<&4-"D%N>2D@*%-I9&4@3&5F="D@*$=R
M;W5P(#$I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I#;VUP4&EN(#0@(C0B("A0
M87)T3G5M(#$I("A3>6U0:6Y.=6T@-"D@*$=A=&5%<2`P*2`H4&EN17$@,"D@
M*%!I;E1Y<&4-"D%N>2D@*%-I9&4@3&5F="D@*$=R;W5P(#$I(#PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[#0I#;VUP4&EN(#4@(C4B("A087)T3G5M(#$I("A3>6U0
M:6Y.=6T@-2D@*$=A=&5%<2`P*2`H4&EN17$@,"D@*%!I;E1Y<&4-"D%N>2D@
M*%-I9&4@4FEG:'0I("A'<F]U<"`Q*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M0V]M<%!I;B`V("(V(B`H4&%R=$YU;2`Q*2`H4WEM4&EN3G5M(#8I("A'871E
M17$@,"D@*%!I;D5Q(#`I("A0:6Y4>7!E#0I!;GDI("A3:61E(%)I9VAT*2`H
M1W)O=7`@,2D@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@
M,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"D-O;7!0:6X@-R`B-R(@
M*%!A<G1.=6T@,2D@*%-Y;5!I;DYU;2`W*2`H1V%T945Q(#`I("A0:6Y%<2`P
M*2`H4&EN5'EP90T*06YY*2`H4VED92!2:6=H="D@*$=R;W5P(#$I(#PO<W!A
M;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@
M("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[#0I#;VUP4&EN(#@@(C@B("A087)T3G5M(#$I("A3
M>6U0:6Y.=6T@."D@*$=A=&5%<2`P*2`H4&EN17$@,"D@*%!I;E1Y<&4-"D%N
M>2D@*%-I9&4@4FEG:'0I("A'<F]U<"`Q*2`\+W-P86X^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*16YD0V]M<%!I;G,\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*0V]M<$1A=&$F;F)S
M<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L@
M.B`W/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^
M#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E=I>F%R9"`H3W)I9VEN(#`L(#`I
M("A.=6UB97(@,2D@*%9A<DYA;64@(E1%35!,051%(BD@*%9A<D1A=&$-"B)4
M86)L95-Y;6)O;%]$=6%L+F%D<R(I(#QB<CX-"@T*("`@("`@/&)R/@T*#0H@
M("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@P+"`P+"`P*3LB/E1H:7,@
M:6YF;W)M871I;VXL('-I;6EL87(@=&\-"G=H870@=V%S(&EN('1H92!F;V]T
M<')I;G0L(&ES(&EN<'5T(&EN=&\@=&AE('=I>F%R9"!F;W(@<F5B=6EL9&EN
M9R!A#0IS>6UB;VPN)FYB<W`[($EN(&5A8V@@8V%S92P@=&AE(%9A<DYA;64@
M:7,@=&AE(&YA;64@;V8@=&AE('9A<FEA8FQE(&EN#0IT:&4@=&5M<&QA=&4@
M=&\@8F4@9FEL;&5D(&EN+"!A;F0@:7,@96YC;&]S960@:6X@<75O=&5S(&%N
M9"!A;'=A>7,-"G1E>'0N)FYB<W`[(%EE<R!A;'=A>7,N)FYB<W`[(%1H92!6
M87)$871A(&ES('1H92!A8W1U86P@=F%L=64@;V8@=&AE#0IV87)I86)L92X\
M+W-P86X^/&)R/@T*#0H@("`@("`\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/@T*#0H@("`@("`\+W-P86X^/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ
M87)D("A/<FEG:6X@,"P@,"D@*$YU;6)E<B`Q*2`H5F%R3F%M92`B3D%-12(I
M("A687)$871A#0HB<V\X+7`S,"UA.3@B*2`\+W-P86X^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*5VEZ87)D("A/<FEG:6X@,"P@,"D@*$YU;6)E<B`Q*2`H5F%R3F%M92`B
M4$PB*2`H5F%R1&%T82`B,3`P(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z
M(')G8B@R-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E=I
M>F%R9"`H3W)I9VEN(#`L(#`I("A.=6UB97(@,2D@*%9A<DYA;64@(D]6(BD@
M*%9A<D1A=&$@(C$B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*5VEZ87)D("A/
M<FEG:6X@,"P@,"D@*$YU;6)E<B`Q*2`H5F%R3F%M92`B3E-4(BD@*%9A<D1A
M=&$@(E1O<"!$;W=N(BD@/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R
M-34L(#`L(#`I.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B
M*#(U-2P@,"P@,"D[(CXF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF
M;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#LF;F)S<#L-"E=I>F%R9"`H
M3W)I9VEN(#`L(#`I("A.=6UB97(@,2D@*%9A<DYA;64@(E!$(BD@*%9A<D1A
M=&$@(C$P,"(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P
M+"`P*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L
M(#`L(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I7:7IA<F0@*$]R:6=I
M;B`P+"`P*2`H3G5M8F5R(#$I("A687).86UE(")03B(I("A687)$871A("(S
M,#`B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*16YD0V]M<$1A=&$\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U
M-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H
M,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*071T86-H9613>6UB;VQS)FYB<W`[(#H@,3PO<W!A;CX\
M8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[#0I!='1A8VAE9%-Y;6)O;"`H4&%R=$YU;2`Q*2`H06QT5'EP92!.
M;W)M86PI("A3>6UB;VQ.86UE(")S;S@M<#,P+6$Y."(I(#PO<W!A;CX\8G(@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I%;F1!='1A8VAE9%-Y
M;6)O;',\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[
M(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*4&EN36%P)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M(#H@.#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I
M.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[
M)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I0861.=6T@,2`H0V]M<%!I;E)E
M9B`B,2(I(#PO<W!A;CX\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P
M*3LB/@T*#0H@("`@("`\<W!A;B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB
M<W`[)FYB<W`[)FYB<W`[)FYB<W`[)FYB<W`[#0I0861.=6T@,B`H0V]M<%!I
M;E)E9B`B,B(I(#QB<CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\<W!A;B!S
M='EL93TB8V]L;W(Z(')G8B@P+"`P+"`P*3LB/E1H92!P:6Y-87`@:7,@9&5S
M:6=N960@=&\-"FED96YT:69Y('1H92!#;VU04&EN("AI;B!T:&4@<V5C=&EO
M;B!A8F]V92D@=VET:"!T:&4@4&%D3G5M(&EN('1H90T*9F]O='!R:6YT+B9N
M8G-P.R!4:&ES('-E8W1I;VX@:7,@;F]T(&%V86EL86)L92!I9B!T:&5R92!I
M<R!N;R!F;V]T<')I;G0N/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@P
M+"`P+"`P*3LB/@T*#0H@("`@("`\8G(@<W1Y;&4](F-O;&]R.B!R9V(H,C4U
M+"`P+"`P*3LB/@T*#0H@("`@("`\+W-P86X^/'-P86X@<W1Y;&4](F-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*4&%D
M3G5M(#,@*$-O;7!0:6Y2968@(C,B*2`\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*
M4&%D3G5M(#0@*$-O;7!0:6Y2968@(C0B*2`\+W-P86X^/&)R('-T>6QE/2)C
M;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4]
M(F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.PT*4&%D3G5M(#4@*$-O;7!0:6Y2968@(C4B*2`\+W-P86X^/&)R('-T>6QE
M/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.PT*4&%D3G5M(#8@*$-O;7!0:6Y2968@(C8B*2`\+W-P86X^/&)R('-T
M>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P
M.R9N8G-P.PT*4&%D3G5M(#<@*$-O;7!0:6Y2968@(C<B*2`\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P
M86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N8G-P
M.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N
M8G-P.R9N8G-P.PT*4&%D3G5M(#@@*$-O;7!0:6Y2968@(C@B*2`\+W-P86X^
M/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@
M/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B9N8G-P.R9N
M8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.R9N8G-P.PT*16YD4&EN36%P
M/"]S<&%N/CQB<B!S='EL93TB8V]L;W(Z(')G8B@R-34L(#`L(#`I.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CXF
M;F)S<#LF;F)S<#LF;F)S<#L-"D5N9$-O;7!O;F5N=#PO<W!A;CX\8G(@<W1Y
M;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/@T*#0H@("`@("`\8G(^#0H-
M"B`@("`@(#PO=&0^#0H-"B`@("`\+W1R/@T*#0H@("`@/'1R/@T*#0H@("`@
M("`\=&0@<W1Y;&4](G!A9&1I;F<Z(#`N-S5P=#L@=F5R=&EC86PM86QI9VXZ
M('1O<#L@=VED=&@Z(#(P)3LB/CQS<&%N('-T>6QE/2)F;VYT+7=E:6=H=#H@
M8F]L9#LB/D9U='5R90T*17AP96%N<VEO;CPO<W!A;CX\8G(^#0H-"B`@("`@
M(#PO=&0^#0H-"B`@("`@(#QT9"!S='EL93TB<&%D9&EN9SH@,"XW-7!T.R(^
M/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B-7;W)K4W!A
M8V4\+W-P86X^/&)R('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-
M"@T*("`@("`@/'-P86X@<W1Y;&4](F-O;&]R.B!R9V(H,C4U+"`P+"`P*3LB
M/B9N8G-P.R9N8G-P.R9N8G-P.PT*5V]R:U-P86-E4VEZ92`H3&]W97),969T
M(#`L(#`I*%5P<&5R4FEG:'0@,"P@,"D\+W-P86X^/&)R('-T>6QE/2)C;VQO
M<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F-O
M;&]R.B!R9V(H,C4U+"`P+"`P*3LB/B-%;F17;W)K4W!A8V4\+W-P86X^/&)R
M('-T>6QE/2)C;VQO<CH@<F=B*#(U-2P@,"P@,"D[(CX-"@T*("`@("`@/&)R
M/@T*#0H@("`@("`\8G(^#0H-"B`@("`@(#PO=&0^#0H-"B`@("`\+W1R/@T*
M#0H@("`@/'1R/@T*#0H@("`@("`\=&0@<W1Y;&4](G!A9&1I;F<Z(#`N-S5P
M=#L@=F5R=&EC86PM86QI9VXZ('1O<#L@=VED=&@Z(#(P)3L@9F]N="UW96EG
M:'0Z(&)O;&0[(CY&=71U<F4-"D5X<&5A;G-I;VX\+W1D/@T*#0H@("`@("`\
M=&0@<W1Y;&4](G!A9&1I;F<Z(#`N-S5P=#L@8V]L;W(Z(')G8B@R-34L(#`L
M(#`I.R(^0V]M<&]N96YT#0I);G-T86YC97,\8G(^#0H-"D-O;7!O;F5N=$EN
M<W1A;F-E<R`Z(#`\8G(^#0H-"B-%;F1#;VUP;VYE;G1);G-T86YC97,\8G(^
M#0H-"B`@("`@(#QB<CX-"@T*("`@("`@/&)R/@T*#0H@("`@("`\+W1D/@T*
M#0H@("`@/"]T<CX-"@T*("`@(#QT<CX-"@T*("`@("`@/'1D('-T>6QE/2)P
M861D:6YG.B`P+C<U<'0[('9E<G1I8V%L+6%L:6=N.B!T;W`[('=I9'1H.B`R
M,"4[(&9O;G0M=V5I9VAT.B!B;VQD.R(^1G5T=7)E#0I%>'!E86YS:6]N/"]T
M9#X-"@T*("`@("`@/'1D('-T>6QE/2)P861D:6YG.B`P+C<U<'0[(&-O;&]R
M.B!R9V(H,C4U+"`P+"`P*3L@9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB
M/@T*("`@("`@#0H@("`@("`\<"!C;&%S<STB37-O3F]R;6%L(CX\<W!A;B!S
M='EL93TB9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB/B-6:6$-"DEN<W1A
M;F-E<SPO<W!A;CX\8G(@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@
M;7,[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B
M=6-H970@;7,[(CY6:6%);G-T86YC97,@.B`P/"]S<&%N/CQB<B!S='EL93TB
M9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB/@T*#0H@("`@("`\<W!A;B!S
M='EL93TB9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB/B-%;F16:6%);G-T
M86YC97,\+W-P86X^/&)R('-T>6QE/2)F;VYT+69A;6EL>3H@=')E8G5C:&5T
M(&US.R(^#0H-"B`@("`@(#QB<B!S='EL93TB9F]N="UF86UI;'DZ('1R96)U
M8VAE="!M<SLB/@T*#0H@("`@("`\<W!A;B!S='EL93TB9F]N="UF86UI;'DZ
M('1R96)U8VAE="!M<SLB/B-.971,:7-T26YF;SPO<W!A;CX\8G(@<W1Y;&4]
M(F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CY.971S(#H@,#PO
M<W!A;CX\8G(@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CX-
M"@T*("`@("`@/'-P86X@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@
M;7,[(CXC16YD3F5T<SPO<W!A;CX\8G(@<W1Y;&4](F9O;G0M9F%M:6QY.B!T
M<F5B=6-H970@;7,[(CX-"@T*("`@("`@/&)R('-T>6QE/2)F;VYT+69A;6EL
M>3H@=')E8G5C:&5T(&US.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)F;VYT
M+69A;6EL>3H@=')E8G5C:&5T(&US.R(^(U-C:&UA=&EC/"]S<&%N/CQB<B!S
M='EL93TB9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB/@T*#0H@("`@("`\
M<W!A;B!S='EL93TB9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB/E-C:&5M
M871I8T1A=&$@.B`\+W-P86X^/&)R('-T>6QE/2)F;VYT+69A;6EL>3H@=')E
M8G5C:&5T(&US.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)F;VYT+69A;6EL
M>3H@=')E8G5C:&5T(&US.R(^)FYB<W`[)FYB<W`[)FYB<W`[(%5N:71S#0HB
M;6EL(CPO<W!A;CX\8G(@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@
M;7,[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B
M=6-H970@;7,[(CXF;F)S<#LF;F)S<#LF;F)S<#L-"E=O<FM3<&%C92`H3$P@
M,"PP*2`H55(@,"PP*2`H1W)I9"`P*3PO<W!A;CX\8G(@<W1Y;&4](F9O;G0M
M9F%M:6QY.B!T<F5B=6-H970@;7,[(CX-"@T*("`@("`@/&)R('-T>6QE/2)F
M;VYT+69A;6EL>3H@=')E8G5C:&5T(&US.R(^#0H-"B`@("`@(#QS<&%N('-T
M>6QE/2)F;VYT+69A;6EL>3H@=')E8G5C:&5T(&US.R(^(T5N9%-C:&5M871I
M8SPO<W!A;CX\8G(@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[
M(CX-"@T*("`@("`@/&)R('-T>6QE/2)F;VYT+69A;6EL>3H@=')E8G5C:&5T
M(&US.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)F;VYT+69A;6EL>3H@=')E
M8G5C:&5T(&US.R(^(U-C:&5M871I8U-H965T<SPO<W!A;CX\8G(@<W1Y;&4]
M(F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CX-"@T*("`@("`@/'-P86X@
M<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CY3:&5E=',@.B`P
M/"]S<&%N/CQB<B!S='EL93TB9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB
M/@T*#0H@("`@("`\<W!A;B!S='EL93TB9F]N="UF86UI;'DZ('1R96)U8VAE
M="!M<SLB/B-%;F138VAE;6%T:6-3:&5E=',\+W-P86X^/&)R('-T>6QE/2)F
M;VYT+69A;6EL>3H@=')E8G5C:&5T(&US.R(^#0H-"B`@("`@(#QB<B!S='EL
M93TB9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB/@T*#0H@("`@("`\<W!A
M;B!S='EL93TB9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB/B-,87EE<D1A
M=&$\+W-P86X^/&)R('-T>6QE/2)F;VYT+69A;6EL>3H@=')E8G5C:&5T(&US
M.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)F;VYT+69A;6EL>3H@=')E8G5C
M:&5T(&US.R(^3&%Y97)S(#H@,#PO<W!A;CX\8G(@<W1Y;&4](F9O;G0M9F%M
M:6QY.B!T<F5B=6-H970@;7,[(CX-"@T*("`@("`@/'-P86X@<W1Y;&4](F9O
M;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CXC16YD3&%Y97)$871A/"]S<&%N
M/CQB<B!S='EL93TB9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB/@T*#0H@
M("`@("`\8G(@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CX-
M"@T*("`@("`@/'-P86X@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@
M;7,[(CXC3&%Y97)496-H;FEC86Q$871A/"]S<&%N/CQB<B!S='EL93TB9F]N
M="UF86UI;'DZ('1R96)U8VAE="!M<SLB/@T*#0H@("`@("`\<W!A;B!S='EL
M93TB9F]N="UF86UI;'DZ('1R96)U8VAE="!M<SLB/DQA>65R5&5C:&YI8V%L
M1&%T82`Z(#`\+W-P86X^/&)R('-T>6QE/2)F;VYT+69A;6EL>3H@=')E8G5C
M:&5T(&US.R(^#0H-"B`@("`@(#QS<&%N('-T>6QE/2)F;VYT+69A;6EL>3H@
M=')E8G5C:&5T(&US.R(^(T5N9$QA>65R5&5C:&YI8V%L1&%T83PO<W!A;CX\
M8G(@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CX-"@T*("`@
M("`@/&)R('-T>6QE/2)F;VYT+69A;6EL>3H@=')E8G5C:&5T(&US.R(^#0H-
M"B`@("`@(#QS<&%N('-T>6QE/2)F;VYT+69A;6EL>3H@=')E8G5C:&5T(&US
M.R(^16YD(&]F($9I;&4\+W-P86X^/&)R/@T*#0H@("`@("`\+W`^#0H-"B`@
M("`@(#PO=&0^#0H-"B`@("`\+W1R/@T*#0H@(`T*("`\+W1B;V1Y/@T*/"]T
M86)L93X-"@T*/"]D:78^#0H-"CQP/CQA('-T>6QE/2)F;VYT+69A;6EL>3H@
M=')E8G5C:&5T(&US.R(@:')E9CTB:F%V87-C<FEP=#IH:7-T;W)Y+F)A8VLH
M,2DB/E!R979I;W5S("X@+B`N/"]A/CQS<&%N('-T>6QE/2)F;VYT+69A;6EL
M>3H@=')E8G5C:&5T(&US.R(^(#PO<W!A;CX\82!S='EL93TB9F]N="UF86UI
M;'DZ('1R96)U8VAE="!M<SLB(&AR968](F9I;&4Z+R\O0SHO56QT<F%,:6)R
M87)I86XO2&5L<"]I;F1E>"YH=&UL(CY-86EN#0I-96YU("X@+B`N/"]A/CQS
M<&%N('-T>6QE/2)F;VYT+69A;6EL>3H@=')E8G5C:&5T(&US.R(^(#PO<W!A
M;CX\8G(@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CX-"@T*
M/'-P86X@<W1Y;&4](F9O;G0M9F%M:6QY.B!T<F5B=6-H970@;7,[(CY#;W!Y
M<FEG:'0@)F-O<'D[(#$Y.3DM,C`P-PT*06-C96QE<F%T960@1&5S:6=N<RP@
M26YC+B9N8G-P.R!!;&P@4FEG:'1S#0I297-E<G9E9"X\+W-P86X^(#PO<#X-
="@T*/"]D:78^#0H\+V)O9'D^#0H\+VAT;6P^#0IE
`
end
XSHAR_EOF
X  (set 20 08 04 14 18 14 11 'XLR_Format.html'; eval "$shar_touch") &&
X  chmod 0755 'XLR_Format.html'
if test $? -ne 0
then ${echo} 'restore of XLR_Format.html failed'
fi
X  if ${md5check}
X  then (
X       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'XLR_Format.html: MD5 check failed'
X       ) << SHAR_EOF
96f9cef3a180d3a17ec578acb4584f04  XLR_Format.html
XSHAR_EOF
X  else
test `LC_ALL=C wc -c < 'XLR_Format.html'` -ne 127919 && \
X  ${echo} 'restoration warning:  size of XLR_Format.html is not 127919'
X  fi
fi
# ============= XLR_Format.txt ==============
if test -f 'XLR_Format.txt' && test "$first_param" != -c; then
X  ${echo} 'x -SKIPPING XLR_Format.txt (file already exists)'
else
${echo} 'x - extracting XLR_Format.txt (text)'
X  sed 's/^X//' << 'SHAR_EOF' > 'XLR_Format.txt' &&
# XLR Format
# 
#    This document is designed to give the user a clearer understanding of
# the ASCII XLR format used by Accelerated Designs.  This introduction is
# not a specification but is designed to explain the main flow of the
# document, what is contained in the different sections, how they are
# related and some of the syntax requirements.  Normally this file is
# modified and added to as new capabilities are required of the Ultra
# Librarian.  So any use of this file must take  into account the
# possibility of additional information in the same format.
# 
# By default all units in the file are assumed to be english mils.  Other
# units are possibple, and will have :"mm", "cn", "in", etc after the
# size.  Also, numbers are noted without quotes and all text is surrounded
# with quotes so that we can tell the difference.
# 
#   Ultra Librarian Gold 2.0.344 database file
#   Copyright  1999-2005 Accelerated Designs, Inc.
#   http://www.Accelerated-Designs.com
#
# Notice that comments are preceeded by the pound sign.  Anything
# following is ignored by the code.
# Layer information
#Layer Data
LayerData : 62
XX    Layer : 1
XX        Name      TOP_ASSEMBLY
XX        LayerType
XX    Layer : 2
XX        Name      TOP_SILKSCREEN
XX        LayerType
XX    Layer : 3
XX        Name      TOP_SOLDER_PASTE
XX        LayerType
XX    Layer : 4
XX        Name      TOP_SOLDER_MASK
XX        LayerType
XX    Layer : 987
XX        Name      CONTACT_AREA
XX        LayerType
XX    Layer : 5
XX        Name      TOP
XX        LayerType Signal
XX    Layer : 12
XX        Name      TOP_PLACE_BOUND
XX        LayerType
XX    Layer : 6
XX        Name      INNER
XX        LayerType Signal
XX    Layer : 13
XX        Name      BOTTOM_PLACE_BOUND
XX        LayerType
XX    Layer : 7
XX        Name      BOTTOM
XX        LayerType Signal
XX    Layer : 8
XX        Name      BOTTOM_SOLDER_MASK
XX        LayerType
XX    Layer : 9
XX        Name      BOTTOM_SOLDER_PASTE
XX        LayerType
XX    Layer : 10
XX        Name      BOTTOM_SILKSCREEN
XX        LayerType
XX    Layer : 11
XX        Name      BOTTOM_ASSEMBLY
XX        LayerType
XX    Layer : 977
XX        Name      DXF_3D 
XX        LayerType
XX    Layer : 978
XX        Name      PIN1MARKER
XX        LayerType
XX    Layer : 979
XX        Name      PINTEST
XX        LayerType
XX    Layer : 980
XX        Name      TOP_BGA_PLACE_BOARD
XX        LayerType
XX    Layer : 981
XX        Name      ATTRIBUTE4
XX        LayerType
XX    Layer : 982
XX        Name      ATTRIBUTE3
XX        LayerType
XX    Layer : 983
XX        Name      ATTRIBUTE2
XX        LayerType
XX    Layer : 984
XX        Name      ATTRIBUTE1
XX        LayerType
XX    Layer : 985
XX        Name      PIN_NUMBER
XX        LayerType
XX    Layer : 986
XX        Name      CONSTRAINT_AREA
XX        LayerType
XX    Layer : 988
XX        Name      INPUTDIMENSIONS
XX        LayerType
XX    Layer : 989
XX        Name      ROUTE_KEEPOUT
XX        LayerType
XX    Layer : 990
XX        Name      VIA_KEEPOUT
XX        LayerType
XX    Layer : 991
XX        Name      DRILL_FIGURE
XX        LayerType
XX    Layer : 992
XX        Name      TOP_COMP_BOUND
XX        LayerType
XX    Layer : 993
XX        Name      BOTTOM_COMP_BOUND
XX        LayerType
XX    Layer : 994
XX        Name      TOP_NO-PROBE
XX        LayerType
XX    Layer : 995
XX        Name      BOTTOM_NO-PROBE
XX        LayerType
XX    Layer : 996
XX        Name      PRO_E
XX        LayerType
XX    Layer : 997
XX        Name      PIN_DETAIL
XX        LayerType
XX    Layer : 998
XX        Name      DIMENSION
XX        LayerType
XX    Layer : 999
XX        Name      BOARD
XX        LayerType
XX    Layer : 14
XX        Name      INTERNAL1
XX        LayerType
XX    Layer : 15
XX        Name      INTERNAL2
XX        LayerType
XX    Layer : 16
XX        Name      INTERNAL3
XX        LayerType
XX    Layer : 17
XX        Name      INTERNAL4
XX        LayerType
XX    Layer : 18
XX        Name      INTERNAL5
XX        LayerType
XX    Layer : 19
XX        Name      INTERNAL6
XX        LayerType
XX    Layer : 20
XX        Name      INTERNAL7
XX        LayerType
XX    Layer : 21
XX        Name      INTERNAL8
XX        LayerType
XX    Layer : 22
XX        Name      INTERNAL9
XX        LayerType
XX    Layer : 23
XX        Name      INTERNAL10
XX        LayerType
XX    Layer : 24
XX        Name      INTERNAL11
XX        LayerType
XX    Layer : 25
XX        Name      INTERNAL12
XX        LayerType
XX    Layer : 26
XX        Name      INTERNAL13
XX        LayerType
XX    Layer : 27
XX        Name      INTERNAL14
XX        LayerType
XX    Layer : 28
XX        Name      INTERNAL15
XX        LayerType
XX    Layer : 30
XX        Name      INTERNAL16
XX        LayerType
XX    Layer : 31
XX        Name      USER1
XX        LayerType
XX    Layer : 32
XX        Name      USER2
XX        LayerType
XX    Layer : 33
XX        Name      USER3
XX        LayerType
XX    Layer : 34
XX        Name      USER4
XX        LayerType
XX    Layer : 35
XX        Name      USER5
XX        LayerType
XX    Layer : 36
XX        Name      USER6
XX        LayerType
XX    Layer : 37
XX        Name      USER7
XX        LayerType
XX    Layer : 38
XX        Name      USER8
XX        LayerType
XX    Layer : 39
XX        Name      USER9
XX        LayerType
XX    Layer : 40
XX        Name      USER10
XX        LayerType
# 
# Each layer is documented.  Each layer is required to have a number
# between 1 and 1000, and the number must be unique.  Each number is
# associated with a layer name, which again must be unique.  All of the
# data in our code will refer to the layers by number, but will display
# the associated name to the users.  The "UltraLibrarian\Layers.ini" file
# contains the list of default layer names and numbers.
# 
# Layertypes can be blank, Signal, NonSignal and Plane.  Capitals or lower
# case are acceptable.  If Layertype is left blank, it is assumed to be
# NonSignal.   Signal and Power layer types are used primarily in PadStack
# descriptions.
# TextStyle Section
#TextStyles
TextStyles : 3
XX    TextStyle "H50S3" (FontWidth 3) (FontHeight 50) (FontCharWidth 13)
XX    TextStyle "h125s6" (FontWidth 6) (FontHeight 125)
XX    TextStyle "H80s4" (FontWidth 4) (FontHeight 80)
# 
# Each textstyle used in either a footprint or a symbol will have a name
# and at least the FontWidth and FontHeight keywords. 
# 
# PadStyles
#PadStyles
PadStacks : 1
XX    PadStack "RX63Y14D0T" (HoleDiam 0) (Surface True) (Plated False)
XX        Shapes       : 1
XX        PadShape "Rectangle" (Width 63) (Height 14) (PadType 0) (Layer TOP)
XX    EndPadStack
# 
# Usually made up of a name (in quote marks) and then a list of shapes,
# with the specified attributes for each shape.  Again, not all entities
# or descriptors will be used with each shape description.....
# 
# Possible shapes are: "Rectangle, Circle, Oblong. RoundedRectangle,
# Diamond, RoundedDiamond, Thermal, Thermalx and Polygon..  Additional
# shape descriptors include Layer (with the layer always in CAPs), Wide,
# High, SpokeWidth, Shape in quotes as above.  PadTypes are 0 by default.
# Other descriptors include OffsetX, OffsetY rotation, and Points (an
# array of points, each containing an X and Y location.  Used only with
# Polygonal pads shapes)..
# 
# Pattern Section
# 	By far the most complex by far is the pattern.  We are going to break
# this one up into sections to help you understand it better.
# 
# 
#Patterns
Patterns : 1
XX    Pattern "so8-p30-a98"
XX
# The name of the pattern in quotes.  The name can not contain quotes, or
# we will get confused.
XX
XX        OriginPoint (0, 0)
XX        PickPoint   (0, 0)
XX        GluePoint   (0, 0)
XX
# The above data is available on all parts, and refers fo the location
# within the part of the centroid.  Thes enumbers are all all stored as
# long numbers in the code,  The origin in particular is an offset from
# the dimension a part was built in to where its placement point is.  This
# is normally 0,0 since the part is useally built from its placement
# point, but it could be located to the side of the part or at some other
# location if this was appropriate for some reason.  Not all tools will
# support or use the pickpoint and the gluedot.  The section below, Data,
# is in each part.  It contians some form of data  that could be displayed
# or stored abou tthe part.  We will detail some of the lines of this code
# for you. 
# 
XX        Data        : 332
XX            Text (Layer TOP_ASSEMBLY) (Origin -67.5, 87) (Text "*") (IsVisible True) (Justify UPPERCENTER) (TextStyle "H50S3")
XX            Text (Layer TOP_SILKSCREEN) (Origin -67.5, 87) (Text "*") (IsVisible True) (Justify UPPERCENTER) (TextStyle "H50S3")
XX            Pad (Number 1) (PinName "1") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin -57.5, 45) (OriginalPinNumber 1)
# 
# Each line in the data set contains a new entity for the part, and the
# properties that make these entities up.  The data lines can and often do
# use the same information as other forms of dats.  So for example a line
# may use the Origin ( x,y) property just as the Text entity may use this
# same property.  Many of the possible properties can and are shared
# across the data types.  Some of the common ones you will see ini use is
# Rotation, Flipped, Origin, Etc.  Note that the text before the first
# bracket delineates the type of entity available.  There are only a ferw
# permissable types at this point:     pad, line, arc, circle, attribute,
# pickpoint, poly, polykeepout, polykeepout_via, polykeepout_comp,
# polykeepin_comp, text, wizard.
# 
XX            Line (Layer TOP_ASSEMBLY) (Origin -49, 39) (EndPoint -49, 51)
# 
# Lines will always require at least an origin EndPoint and layer
# property.  If they do not include the width property, they will be
# assigned a default width in our code.  The default width is user
# assignable in the configuration screen.
# 
XX            Line (Layer TOP_ASSEMBLY) (Origin -49, 51) (EndPoint -75, 51)
XX            Line (Layer TOP_ASSEMBLY) (Origin -75, 51) (EndPoint -75, 38.9999999999999)
XX            Line (Layer TOP_ASSEMBLY) (Origin -75, 38.9999999999999) (EndPoint -49, 39)
XX            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (-49, 39) (-49, 51) (-75, 51) (-75, 38.9999999999999)
# 
# A polygon requires a layer, an Orgin and at least two additional points
# to be valid.  It can also contain width, flipped, and several other
# properties.
# 
XX            Pad (Number 2) (PinName "2") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin -57.5, 15) (OriginalPinNumber 2)
XX
# A pad must contain a name and a number.  The name is what most users
# will see when referencing the footprint.  The number is arbitrarily
# assigned based.  Each footprint must have its pads numbered one to the
# amount of pads contined with no gaps or duplicates in numbering.  Also
# required are the Origin and Padstyle properties.  Other properties might
# be visible, such as rotation and flipped.
# 
XX            Pad (Number 3) (PinName "3") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin -57.5, -15) (OriginalPinNumber 3)
XX            Pad (Number 4) (PinName "4") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin -57.5, -45) (OriginalPinNumber 4)
XX            Line (Layer TOP_ASSEMBLY) (Origin -49, 9) (EndPoint -49, 21)
XX            Line (Layer TOP_ASSEMBLY) (Origin -49, 21) (EndPoint -75, 21)
XX            Line (Layer TOP_ASSEMBLY) (Origin -75, 21) (EndPoint -75, 8.99999999999993)
XX            Line (Layer TOP_ASSEMBLY) (Origin -75, 8.99999999999993) (EndPoint -49, 9)
XX            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (-49, 9) (-49, 21) (-75, 21) (-75, 8.99999999999993)
XX            Line (Layer TOP_ASSEMBLY) (Origin -49, -21) (EndPoint -49, -9)
XX            Line (Layer TOP_ASSEMBLY) (Origin -49, -9) (EndPoint -75, -9.00000000000005)
XX            Line (Layer TOP_ASSEMBLY) (Origin -75, -9.00000000000005) (EndPoint -75, -21.0000000000001)
XX            Line (Layer TOP_ASSEMBLY) (Origin -75, -21.0000000000001) (EndPoint -49, -21)
XX            Poly (Layer DXF-3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (-49, -21) (-49, -9) (-75, -9.00000000000005) (-75, -21.0000000000001)
XX            Line (Layer TOP_ASSEMBLY) (Origin -48.9999999999999, -51) (EndPoint -49, -39)
XX            Line (Layer TOP_ASSEMBLY) (Origin -49, -39) (EndPoint -75, -39.0000000000001)
XX            Line (Layer TOP_ASSEMBLY) (Origin -75, -39.0000000000001) (EndPoint -74.9999999999999, -51.0000000000001)
XX            Line (Layer TOP_ASSEMBLY) (Origin -74.9999999999999, -51.0000000000001) (EndPoint -48.9999999999999, -51)
XX            Poly (Layer DXF-3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (-48.9999999999999, -51) (-49, -39) (-75, -39.0000000000001) (-74.9999999999999, -51.0000000000001)
XX            Pad (Number 5) (PinName "5") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin 57.5, -45) (OriginalPinNumber 5)
XX            Pad (Number 6) (PinName "6") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin 57.5, -15) (OriginalPinNumber 6)
XX            Pad (Number 7) (PinName "7") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin 57.5, 15) (OriginalPinNumber 7)
XX            Pad (Number 8) (PinName "8") (PadStyle "RX63Y14D0T") (OriginalPadStyle "RX63Y14D0T") (Origin 57.5, 45) (OriginalPinNumber 8)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, -39) (EndPoint 49, -51)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, -51) (EndPoint 75, -51)
XX            Line (Layer TOP_ASSEMBLY) (Origin 75, -51) (EndPoint 75, -38.9999999999999)
XX            Line (Layer TOP_ASSEMBLY) (Origin 75, -38.9999999999999) (EndPoint 49, -39)
XX            Poly (Layer DXF-3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (49, -39) (49, -51) (75, -51) (75, -38.9999999999999)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, -9) (EndPoint 49, -21)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, -21) (EndPoint 75, -21)
XX            Line (Layer TOP_ASSEMBLY) (Origin 75, -21) (EndPoint 75, -8.99999999999993)
XX            Line (Layer TOP_ASSEMBLY) (Origin 75, -8.99999999999993) (EndPoint 49, -9)
XX            Poly (Layer DXF-3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (49, -9) (49, -21) (75, -21) (75, -8.99999999999993)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, 21) (EndPoint 49, 9)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, 9) (EndPoint 75, 9.00000000000001)
XX            Line (Layer TOP_ASSEMBLY) (Origin 75, 9.00000000000001) (EndPoint 75, 21.0000000000001)
XX            Line (Layer TOP_ASSEMBLY) (Origin 75, 21.0000000000001) (EndPoint 49, 21)
XX            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (49, 21) (49, 9) (75, 9.00000000000001) (75, 21.0000000000001)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, 51) (EndPoint 49, 39)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, 39) (EndPoint 75, 39)
XX            Line (Layer TOP_ASSEMBLY) (Origin 75, 39) (EndPoint 74.9999999999999, 51.0000000000001)
XX            Line (Layer TOP_ASSEMBLY) (Origin 74.9999999999999, 51.0000000000001) (EndPoint 49, 51)
XX            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=100,50") (Width 6)  (49, 51) (49, 39) (75, 39) (74.9999999999999, 51.0000000000001)
XX            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (-75, 51) (-75, 39) (-40, 39) (-40, 51)
XX            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (-75, 21) (-75, 9) (-40, 9) (-40, 21)
XX            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (-75, -9) (-75, -21) (-40, -21) (-40, -9)
XX            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (-75, -39) (-75, -51) (-40, -51) (-40, -39)
XX            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (40, -39) (40, -51) (75, -51) (75, -39)
XX            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (40, -9) (40, -21) (75, -21) (75, -9)
XX            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (40, 21) (40, 9) (75, 9) (75, 21)
XX            Poly (Layer CONTACT_AREA) (Origin 0, 0)  (40, 51) (40, 39) (75, 39) (75, 51)
XX            Poly (Layer TOP_NO-PROBE) (Origin 0, 0) (Width 6)  (-104, -95) (-104, 95) (104, 95) (104, -95)
XX            Line (Layer TOP_PLACE_BOUND) (Origin -89, -80) (EndPoint -89, 80)
XX            Line (Layer TOP_PLACE_BOUND) (Origin -89, 80) (EndPoint 89, 80)
XX            Line (Layer TOP_PLACE_BOUND) (Origin 89, 80) (EndPoint 89, -80)
XX            Line (Layer TOP_PLACE_BOUND) (Origin 89, -80) (EndPoint -89, -80)
XX            Poly (Layer TOP_PLACE_BOUND) (Origin 0, 0) (Width 6)  (-89, -80) (-89, 80) (89, 80) (89, -80)
XX            Attribute (Layer PRO_E) (Origin 0, 0) (Attr "Height" "100") (Justify CENTER) (TextStyle "H50S3")
# 
# Attributes must contain a layer, an Origin, and a textstyle.  Attributes
# without a justification will be justified "CENTER".  It must  also
# conain the attribute prompt as well as value.  In the example above the
# prompt is "Height" and the value is "100".  Note that the value is
# always considered a string.  Always.
# 
# Justification is used on text and attributes.  Its available
# justifications are: UPPERLEFT, UPPERCENTER, UPPERRIGHT, LEFT, CENTER, RIGHT, LOWERLEFT, LOWERCENTER, LOWERRIGHT.
#
#
XX            Attribute (Layer PRO_E) (Origin 0, 0) (Attr "MINHEIGHT" "10") (Justify CENTER) (TextStyle "H50S3")
XX            Line (Layer PRO_E) (Origin -49, 80) (EndPoint -49, -80) (Width 6)
XX            Line (Layer PRO_E) (Origin -49, -80) (EndPoint 49, -80) (Width 6)
XX            Line (Layer PRO_E) (Origin 49, -80) (EndPoint 49, 80) (Width 6)
XX            Line (Layer PRO_E) (Origin 49, 80) (EndPoint -49, 80) (Width 6)
XX            Arc (Layer PRO_E) (Origin 0, 80) (Radius 8.166667) (StartAngle 180) (SweepAngle 180) (Width 6)
# 
# An Arc needs all of the fields above except the width field.  However it
# might have quite a few additional feilds like rotation and flipped.
# 
XX            Text (Layer DIMENSION) (Origin 0, -230) (Text "Default Padstyle: RX63Y14D0T") (IsVisible True) (Justify UPPERCENTER) (TextStyle
"H50S3")
# 
# Text has the same requirements as an Attribute, except that rather than
# a prompt and a value, it just has a string representing what will show
# up as text.  In this case the string is"Default Padstyle: RX63Y14D0T". 
# It is always string information.  Yes always.
# 
XX            Line (Layer INPUTDIMENSIONS) (Origin -49, 0) (EndPoint -49, 170)
XX            Line (Layer INPUTDIMENSIONS) (Origin 49, 0) (EndPoint 49, 170)
XX            Line (Layer INPUTDIMENSIONS) (Origin -49, 155) (EndPoint -99, 155)
XX            Line (Layer INPUTDIMENSIONS) (Origin 49, 155) (EndPoint 99, 155)
XX            Line (Layer INPUTDIMENSIONS) (Origin -49, 155) (EndPoint -59, 160)
XX            Line (Layer INPUTDIMENSIONS) (Origin -49, 155) (EndPoint -59, 150)
XX            Line (Layer INPUTDIMENSIONS) (Origin -59, 160) (EndPoint -59, 150)
XX            Line (Layer INPUTDIMENSIONS) (Origin 49, 155) (EndPoint 59, 160)
XX            Line (Layer INPUTDIMENSIONS) (Origin 49, 155) (EndPoint 59, 150)
XX            Line (Layer INPUTDIMENSIONS) (Origin 59, 160) (EndPoint 59, 150)
XX            Text (Layer INPUTDIMENSIONS) (Origin 0, 175) (Text "A") (Justify LOWERCENTER) (TextStyle "H50S3")
XX            Line (Layer INPUTDIMENSIONS) (Origin -75, 0) (EndPoint -75, 245)
XX            Line (Layer INPUTDIMENSIONS) (Origin 75, 0) (EndPoint 75, 245)
XX            Line (Layer INPUTDIMENSIONS) (Origin -75, 230) (EndPoint 75, 230)
XX            Line (Layer INPUTDIMENSIONS) (Origin -75, 230) (EndPoint -65, 235)
XX            Line (Layer INPUTDIMENSIONS) (Origin -75, 230) (EndPoint -65, 225)
XX            Line (Layer INPUTDIMENSIONS) (Origin -65, 235) (EndPoint -65, 225)
XX            Line (Layer INPUTDIMENSIONS) (Origin 75, 230) (EndPoint 65, 235)
XX            Line (Layer INPUTDIMENSIONS) (Origin 75, 230) (EndPoint 65, 225)
XX            Line (Layer INPUTDIMENSIONS) (Origin 65, 235) (EndPoint 65, 225)
XX            Text (Layer INPUTDIMENSIONS) (Origin 0, 250) (Text "L") (Justify LOWERCENTER) (TextStyle "H50S3")
XX            Line (Layer INPUTDIMENSIONS) (Origin 0, 80) (EndPoint 164, 80)
XX            Line (Layer INPUTDIMENSIONS) (Origin 0, -80) (EndPoint 164, -80)
XX            Line (Layer INPUTDIMENSIONS) (Origin 149, 80) (EndPoint 149, -80)
XX            Line (Layer INPUTDIMENSIONS) (Origin 149, 80) (EndPoint 144, 70)
XX            Line (Layer INPUTDIMENSIONS) (Origin 149, 80) (EndPoint 154, 70)
XX            Line (Layer INPUTDIMENSIONS) (Origin 144, 70) (EndPoint 154, 70)
XX            Line (Layer INPUTDIMENSIONS) (Origin 149, -80) (EndPoint 144, -70)
XX            Line (Layer INPUTDIMENSIONS) (Origin 149, -80) (EndPoint 154, -70)
XX            Line (Layer INPUTDIMENSIONS) (Origin 144, -70) (EndPoint 154, -70)
XX            Text (Layer INPUTDIMENSIONS) (Origin 169, 0) (Text "B") (Justify LEFT) (TextStyle "H50S3")
XX            Line (Layer INPUTDIMENSIONS) (Origin -57.5, 45) (EndPoint -172.5, 45)
XX            Line (Layer INPUTDIMENSIONS) (Origin -57.5, 15) (EndPoint -172.5, 15)
XX            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 45) (EndPoint -157.5, 95)
XX            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 15) (EndPoint -157.5, -35)
XX            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 45) (EndPoint -162.5, 55)
XX            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 45) (EndPoint -152.5, 55)
XX            Line (Layer INPUTDIMENSIONS) (Origin -162.5, 55) (EndPoint -152.5, 55)
XX            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 15) (EndPoint -162.5, 5)
XX            Line (Layer INPUTDIMENSIONS) (Origin -157.5, 15) (EndPoint -152.5, 5)
XX            Line (Layer INPUTDIMENSIONS) (Origin -162.5, 5) (EndPoint -152.5, 5)
XX            Text (Layer INPUTDIMENSIONS) (Origin -177.5, 30) (Text "P") (Justify RIGHT) (TextStyle "H50S3")
XX            Line (Layer INPUTDIMENSIONS) (Origin -75, 0) (EndPoint -75, -170)
XX            Line (Layer INPUTDIMENSIONS) (Origin -40, 0) (EndPoint -40, -170)
XX            Line (Layer INPUTDIMENSIONS) (Origin -75, -155) (EndPoint -125, -155)
XX            Line (Layer INPUTDIMENSIONS) (Origin -40, -155) (EndPoint 10, -155)
XX            Line (Layer INPUTDIMENSIONS) (Origin -75, -155) (EndPoint -85, -150)
XX            Line (Layer INPUTDIMENSIONS) (Origin -75, -155) (EndPoint -85, -160)
XX            Line (Layer INPUTDIMENSIONS) (Origin -85, -150) (EndPoint -85, -160)
XX            Line (Layer INPUTDIMENSIONS) (Origin -40, -155) (EndPoint -30, -150)
XX            Line (Layer INPUTDIMENSIONS) (Origin -40, -155) (EndPoint -30, -160)
XX            Line (Layer INPUTDIMENSIONS) (Origin -30, -150) (EndPoint -30, -160)
XX            Text (Layer INPUTDIMENSIONS) (Origin -57.5, -175) (Text "T") (Justify UPPERCENTER) (TextStyle "H50S3")
XX            Line (Layer DIMENSION) (Origin -49, 0) (EndPoint -49, 170)
XX            Line (Layer DIMENSION) (Origin 49, 0) (EndPoint 49, 170)
XX            Line (Layer DIMENSION) (Origin -49, 155) (EndPoint -99, 155)
XX            Line (Layer DIMENSION) (Origin 49, 155) (EndPoint 99, 155)
XX            Line (Layer DIMENSION) (Origin -49, 155) (EndPoint -59, 160)
XX            Line (Layer DIMENSION) (Origin -49, 155) (EndPoint -59, 150)
XX            Line (Layer DIMENSION) (Origin -59, 160) (EndPoint -59, 150)
XX            Line (Layer DIMENSION) (Origin 49, 155) (EndPoint 59, 160)
XX            Line (Layer DIMENSION) (Origin 49, 155) (EndPoint 59, 150)
XX            Line (Layer DIMENSION) (Origin 59, 160) (EndPoint 59, 150)
XX            Text (Layer DIMENSION) (Origin 0, 175) (Text "98") (Justify LOWERCENTER) (TextStyle "H50S3")
XX            Line (Layer DIMENSION) (Origin -75, 0) (EndPoint -75, 245)
XX            Line (Layer DIMENSION) (Origin 75, 0) (EndPoint 75, 245)
XX            Line (Layer DIMENSION) (Origin -75, 230) (EndPoint 75, 230)
XX            Line (Layer DIMENSION) (Origin -75, 230) (EndPoint -65, 235)
XX            Line (Layer DIMENSION) (Origin -75, 230) (EndPoint -65, 225)
XX            Line (Layer DIMENSION) (Origin -65, 235) (EndPoint -65, 225)
XX            Line (Layer DIMENSION) (Origin 75, 230) (EndPoint 65, 235)
XX            Line (Layer DIMENSION) (Origin 75, 230) (EndPoint 65, 225)
XX            Line (Layer DIMENSION) (Origin 65, 235) (EndPoint 65, 225)
XX            Text (Layer DIMENSION) (Origin 0, 250) (Text "150") (Justify LOWERCENTER) (TextStyle "H50S3")
XX            Line (Layer DIMENSION) (Origin 0, 80) (EndPoint 164, 80)
XX            Line (Layer DIMENSION) (Origin 0, -80) (EndPoint 164, -80)
XX            Line (Layer DIMENSION) (Origin 149, 80) (EndPoint 149, -80)
XX            Line (Layer DIMENSION) (Origin 149, 80) (EndPoint 144, 70)
XX            Line (Layer DIMENSION) (Origin 149, 80) (EndPoint 154, 70)
XX            Line (Layer DIMENSION) (Origin 144, 70) (EndPoint 154, 70)
XX            Line (Layer DIMENSION) (Origin 149, -80) (EndPoint 144, -70)
XX            Line (Layer DIMENSION) (Origin 149, -80) (EndPoint 154, -70)
XX            Line (Layer DIMENSION) (Origin 144, -70) (EndPoint 154, -70)
XX            Text (Layer DIMENSION) (Origin 169, 0) (Text "160") (Justify LEFT) (TextStyle "H50S3")
XX            Line (Layer DIMENSION) (Origin -57.5, 45) (EndPoint -172.5, 45)
XX            Line (Layer DIMENSION) (Origin -57.5, 15) (EndPoint -172.5, 15)
XX            Line (Layer DIMENSION) (Origin -157.5, 45) (EndPoint -157.5, 95)
XX            Line (Layer DIMENSION) (Origin -157.5, 15) (EndPoint -157.5, -35)
XX            Line (Layer DIMENSION) (Origin -157.5, 45) (EndPoint -162.5, 55)
XX            Line (Layer DIMENSION) (Origin -157.5, 45) (EndPoint -152.5, 55)
XX            Line (Layer DIMENSION) (Origin -162.5, 55) (EndPoint -152.5, 55)
XX            Line (Layer DIMENSION) (Origin -157.5, 15) (EndPoint -162.5, 5)
XX            Line (Layer DIMENSION) (Origin -157.5, 15) (EndPoint -152.5, 5)
XX            Line (Layer DIMENSION) (Origin -162.5, 5) (EndPoint -152.5, 5)
XX            Text (Layer DIMENSION) (Origin -177.5, 30) (Text "30") (Justify RIGHT) (TextStyle "H50S3")
XX            Line (Layer DIMENSION) (Origin -75, 0) (EndPoint -75, -170)
XX            Line (Layer DIMENSION) (Origin -40, 0) (EndPoint -40, -170)
XX            Line (Layer DIMENSION) (Origin -75, -155) (EndPoint -125, -155)
XX            Line (Layer DIMENSION) (Origin -40, -155) (EndPoint 10, -155)
XX            Line (Layer DIMENSION) (Origin -75, -155) (EndPoint -85, -150)
XX            Line (Layer DIMENSION) (Origin -75, -155) (EndPoint -85, -160)
XX            Line (Layer DIMENSION) (Origin -85, -150) (EndPoint -85, -160)
XX            Line (Layer DIMENSION) (Origin -40, -155) (EndPoint -30, -150)
XX            Line (Layer DIMENSION) (Origin -40, -155) (EndPoint -30, -160)
XX            Line (Layer DIMENSION) (Origin -30, -150) (EndPoint -30, -160)
XX            Text (Layer DIMENSION) (Origin -57.5, -175) (Text "35") (Justify UPPERCENTER) (TextStyle "H50S3")
XX            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "RefDes" "RefDes") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
XX            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "Type" "DEV") (Justify CENTER) (TextStyle "H50S3")
XX            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "PN" "PN") (Justify CENTER) (TextStyle "H50S3")
XX            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "DEV" "DEV") (Justify CENTER) (TextStyle "H50S3")
XX            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "VAL" "VAL") (Justify CENTER) (TextStyle "H50S3")
XX            Attribute (Layer TOP_SILKSCREEN) (Origin 0, 0) (Attr "TOL" "TOL") (Justify CENTER) (TextStyle "H50S3")
XX            Attribute (Layer TOP_ASSEMBLY) (Origin 0, 0) (Attr "RefDes2" "RefDes2") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
XX            Attribute (Layer USER1) (Origin 0, 0) (Attr "UserDefined1" "SYM_REV=A0") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
XX            Attribute (Layer USER1) (Origin 0, 0) (Attr "UserDefined2" "CREATED_DATE") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
XX            Attribute (Layer USER1) (Origin 0, 0) (Attr "UserDefined3" "ULTEMPLATE=Unknown") (IsVisible True) (Justify CENTER) (TextStyle "H50S3")
XX            Line (Layer PIN_DETAIL) (Origin 366, 670) (EndPoint 266, 670)
XX            Line (Layer PIN_DETAIL) (Origin 266, 670) (EndPoint 216, 570)
XX            Line (Layer PIN_DETAIL) (Origin 216, 570) (EndPoint 266, 470)
XX            Line (Layer PIN_DETAIL) (Origin 266, 470) (EndPoint 366, 470)
XX            Line (Layer PIN_DETAIL) (Origin 216, 570) (EndPoint 166, 570)
XX            Line (Layer PIN_DETAIL) (Origin 166, 570) (EndPoint 136, 450)
XX            Line (Layer PIN_DETAIL) (Origin 150, 430) (EndPoint 180, 550)
XX            Line (Layer PIN_DETAIL) (Origin 180, 550) (EndPoint 226, 550)
XX            Line (Layer PIN_DETAIL) (Origin 363, 443) (EndPoint 394, 579)
XX            Line (Layer PIN_DETAIL) (Origin 394, 579) (EndPoint 350, 610)
XX            Line (Layer PIN_DETAIL) (Origin 350, 610) (EndPoint 383, 708)
XX            Line (Layer PIN_DETAIL) (Origin 150, 430) (EndPoint 80, 430)
XX            Line (Layer PIN_DETAIL) (Origin 80, 430) (EndPoint 80, 450)
XX            Line (Layer PIN_DETAIL) (Origin 136, 450) (EndPoint 80, 450)
XX            Line (Layer PIN_DETAIL) (Origin 178, 430) (EndPoint 52, 430)
XX            Line (Layer PIN_DETAIL) (Origin 52, 430) (EndPoint 52, 420)
XX            Line (Layer PIN_DETAIL) (Origin 52, 420) (EndPoint 178, 420)
XX            Line (Layer PIN_DETAIL) (Origin 178, 420) (EndPoint 178, 430)
XX            Line (Layer PIN_DETAIL) (Origin 150, 420) (EndPoint 150, 380)
XX            Line (Layer PIN_DETAIL) (Origin 178, 420) (EndPoint 178, 400)
XX            Line (Layer PIN_DETAIL) (Origin 150, 405) (EndPoint 178, 405)
XX            Text (Layer PIN_DETAIL) (Origin 164, 395) (Text "14") (Justify UPPERLEFT) (TextStyle "H50S3")
XX            Line (Layer PIN_DETAIL) (Origin 150, 405) (EndPoint 160, 400)
XX            Line (Layer PIN_DETAIL) (Origin 160, 400) (EndPoint 160, 410)
XX            Line (Layer PIN_DETAIL) (Origin 160, 410) (EndPoint 150, 405)
XX            Line (Layer PIN_DETAIL) (Origin 178, 405) (EndPoint 168, 410)
XX            Line (Layer PIN_DETAIL) (Origin 168, 410) (EndPoint 168, 400)
XX            Line (Layer PIN_DETAIL) (Origin 168, 400) (EndPoint 178, 405)
XX            Line (Layer PIN_DETAIL) (Origin 52, 420) (EndPoint 52, 400)
XX            Line (Layer PIN_DETAIL) (Origin 80, 420) (EndPoint 80, 380)
XX            Line (Layer PIN_DETAIL) (Origin 52, 405) (EndPoint 80, 405)
XX            Text (Layer PIN_DETAIL) (Origin 66, 395) (Text "14") (Justify UPPERRIGHT) (TextStyle "H50S3")
XX            Line (Layer PIN_DETAIL) (Origin 52, 405) (EndPoint 62, 410)
XX            Line (Layer PIN_DETAIL) (Origin 62, 410) (EndPoint 62, 400)
XX            Line (Layer PIN_DETAIL) (Origin 62, 400) (EndPoint 52, 405)
XX            Line (Layer PIN_DETAIL) (Origin 80, 405) (EndPoint 70, 400)
XX            Line (Layer PIN_DETAIL) (Origin 70, 400) (EndPoint 70, 410)
XX            Line (Layer PIN_DETAIL) (Origin 70, 410) (EndPoint 80, 405)
XX            Line (Layer PIN_DETAIL) (Origin 150, 385) (EndPoint 80, 385)
XX            Text (Layer PIN_DETAIL) (Origin 115, 380) (Text "35") (Justify UPPERCENTER) (TextStyle "H50S3")
XX            Line (Layer PIN_DETAIL) (Origin 80, 385) (EndPoint 90, 380)
XX            Line (Layer PIN_DETAIL) (Origin 90, 380) (EndPoint 90, 390)
XX            Line (Layer PIN_DETAIL) (Origin 90, 390) (EndPoint 80, 385)
XX            Line (Layer PIN_DETAIL) (Origin 150, 385) (EndPoint 140, 390)
XX            Line (Layer PIN_DETAIL) (Origin 140, 390) (EndPoint 140, 380)
XX            Line (Layer PIN_DETAIL) (Origin 140, 380) (EndPoint 150, 385)
XX            Line (Layer PIN_DETAIL) (Origin -262, 430) (EndPoint -238, 430)
XX            Line (Layer PIN_DETAIL) (Origin -238, 430) (EndPoint -238, 570)
XX            Line (Layer PIN_DETAIL) (Origin -262, 430) (EndPoint -262, 570)
XX            Line (Layer PIN_DETAIL) (Origin -262, 450) (EndPoint -238, 450)
XX            Line (Layer PIN_DETAIL) (Origin -292, 570) (EndPoint -208, 570)
XX            Line (Layer PIN_DETAIL) (Origin -262, 470) (EndPoint -292, 470)
XX            Line (Layer PIN_DETAIL) (Origin -238, 470) (EndPoint -208, 470)
XX            Line (Layer PIN_DETAIL) (Origin -292, 670) (EndPoint -208, 670)
XX            Line (Layer PIN_DETAIL) (Origin -198, 700) (EndPoint -228, 600)
XX            Line (Layer PIN_DETAIL) (Origin -228, 600) (EndPoint -188, 540)
XX            Line (Layer PIN_DETAIL) (Origin -188, 540) (EndPoint -215, 441)
XX            Line (Layer PIN_DETAIL) (Origin -282, 700) (EndPoint -312, 600)
XX            Line (Layer PIN_DETAIL) (Origin -312, 600) (EndPoint -272, 540)
XX            Line (Layer PIN_DETAIL) (Origin -272, 540) (EndPoint -299, 441)
XX            Line (Layer PIN_DETAIL) (Origin -263, 430) (EndPoint -237, 430)
XX            Line (Layer PIN_DETAIL) (Origin -263, 420) (EndPoint -237, 420)
XX            Line (Layer PIN_DETAIL) (Origin -263, 430) (EndPoint -263, 420)
XX            Line (Layer PIN_DETAIL) (Origin -237, 430) (EndPoint -237, 420)
XX            Line (Layer PIN_DETAIL) (Origin -263, 400) (EndPoint -263, 420)
XX            Line (Layer PIN_DETAIL) (Origin -237, 400) (EndPoint -237, 420)
XX            Line (Layer PIN_DETAIL) (Origin -263, 405) (EndPoint -293, 405)
XX            Line (Layer PIN_DETAIL) (Origin -263, 405) (EndPoint -273, 410)
XX            Line (Layer PIN_DETAIL) (Origin -273, 410) (EndPoint -273, 400)
XX            Line (Layer PIN_DETAIL) (Origin -273, 400) (EndPoint -263, 405)
XX            Line (Layer PIN_DETAIL) (Origin -237, 405) (EndPoint -207, 405)
XX            Line (Layer PIN_DETAIL) (Origin -237, 405) (EndPoint -227, 410)
XX            Line (Layer PIN_DETAIL) (Origin -227, 410) (EndPoint -227, 400)
XX            Line (Layer PIN_DETAIL) (Origin -227, 400) (EndPoint -237, 405)
XX            Text (Layer PIN_DETAIL) (Origin -197, 385) (Text "14") (Justify LOWERLEFT) (TextStyle "H50S3")
XX            Line (Layer PIN_DETAIL) (Origin -262, 380) (EndPoint -262, 420)
XX            Line (Layer PIN_DETAIL) (Origin -238, 380) (EndPoint -238, 420)
XX            Line (Layer PIN_DETAIL) (Origin -262, 385) (EndPoint -292, 385)
XX            Line (Layer PIN_DETAIL) (Origin -262, 385) (EndPoint -272, 390)
XX            Line (Layer PIN_DETAIL) (Origin -272, 390) (EndPoint -272, 380)
XX            Line (Layer PIN_DETAIL) (Origin -272, 380) (EndPoint -262, 385)
XX            Line (Layer PIN_DETAIL) (Origin -238, 385) (EndPoint -208, 385)
XX            Line (Layer PIN_DETAIL) (Origin -238, 385) (EndPoint -228, 390)
XX            Line (Layer PIN_DETAIL) (Origin -228, 390) (EndPoint -228, 380)
XX            Line (Layer PIN_DETAIL) (Origin -228, 380) (EndPoint -238, 385)
XX            Text (Layer PIN_DETAIL) (Origin -198, 385) (Text "12") (Justify UPPERLEFT) (TextStyle "H50S3")
XX            Text (Layer PIN_DETAIL) (Origin -50, 570) (Text "(2x Scale)") (Justify CENTER) (TextStyle "H50S3")
XX            Line (Layer TOP_SILKSCREEN) (Origin -49, 80) (EndPoint -49, 65.1000003814697) (Width 6)
XX            Line (Layer TOP_SILKSCREEN) (Origin -49, -80) (EndPoint 49, -80) (Width 6)
XX            Line (Layer TOP_SILKSCREEN) (Origin 49, -80) (EndPoint 49, -65.1000003814697) (Width 6)
XX            Line (Layer TOP_SILKSCREEN) (Origin 49, 80) (EndPoint -49, 80) (Width 6)
XX            Poly (Layer DXF_3D) (Origin 0, 0) (Property "HEIGHTRANGE=10,100") (Width 6)  (-49, 80) (-49, -80) (49, -80) (49, 80)
XX            Arc (Layer TOP_SILKSCREEN) (Origin 0, 80) (Radius 12) (StartAngle 180) (SweepAngle 180) (Width 6)
XX            Line (Layer TOP_ASSEMBLY) (Origin -49, 80) (EndPoint -49, -80)
XX            Line (Layer TOP_ASSEMBLY) (Origin -49, -80) (EndPoint 49, -80)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, -80) (EndPoint 49, 80)
XX            Line (Layer TOP_ASSEMBLY) (Origin 49, 80) (EndPoint -49, 80)
XX            Arc (Layer TOP_ASSEMBLY) (Origin 0, 80) (Radius 12) (StartAngle 180) (SweepAngle 180)
# 
# Below, the "Wizard" entity type is considered a system variable.  This
# variable will always represent some user entered field that was used on
# calculating or creating your footprint.
# 
XX            Wizard (Origin 0, 0) (VarName "TEMPLATE") (VarData "ADI_SO_C2.adt")
XX            Wizard (Origin 0, 0) (VarName "NAME") (VarData "")
XX            Wizard (Origin 0, 0) (VarName "N") (VarData "8")
XX            Wizard (Origin 0, 0) (VarName "A") (VarData "98")
XX            Wizard (Origin 0, 0) (VarName "L") (VarData "150")
XX            Wizard (Origin 0, 0) (VarName "LM") (VarData "0")
XX            Wizard (Origin 0, 0) (VarName "P") (VarData "30")
XX            Wizard (Origin 0, 0) (VarName "B") (VarData "160")
XX            Wizard (Origin 0, 0) (VarName "T") (VarData "35")
XX            Wizard (Origin 0, 0) (VarName "W") (VarData "12")
XX            Wizard (Origin 0, 0) (VarName "NT") (VarData "Arc")
XX            Wizard (Origin 0, 0) (VarName "TT") (VarData "Normal Material")
XX            Wizard (Origin 0, 0) (VarName "UTOE") (VarData "0")
XX            Wizard (Origin 0, 0) (VarName "UHEEL") (VarData "0")
XX            Wizard (Origin 0, 0) (VarName "USIDE") (VarData "0")
XX            Wizard (Origin 0, 0) (VarName "KO") (VarData "0")
XX            Wizard (Origin 0, 0) (VarName "KOW") (VarData "78.74")
XX            Wizard (Origin 0, 0) (VarName "KOH") (VarData "78.74")
XX            Wizard (Origin 0, 0) (VarName "HTT") (VarData "0")
XX            Wizard (Origin 0, 0) (VarName "HTW") (VarData "82.677")
XX            Wizard (Origin 0, 0) (VarName "HTH") (VarData "82.677")
XX            Wizard (Origin 0, 0) (VarName "A1_PSH") (VarData "Oblong")
XX            Wizard (Origin 0, 0) (VarName "A1_PADW") (VarData "60")
XX            Wizard (Origin 0, 0) (VarName "A1_PADH") (VarData "90")
XX            Wizard (Origin 0, 0) (VarName "A1_DRL") (VarData "30")
XX            Wizard (Origin 0, 0) (VarName "A2_PSH") (VarData "Oblong")
XX            Wizard (Origin 0, 0) (VarName "A2_PADW") (VarData "90")
XX            Wizard (Origin 0, 0) (VarName "A2_PADH") (VarData "60")
XX            Wizard (Origin 0, 0) (VarName "A2_DRL") (VarData "30")
XX            Wizard (Origin 0, 0) (VarName "PPCK") (VarData "0")
XX            Wizard (Origin 0, 0) (VarName "PPPSH") (VarData "Round")
XX            Wizard (Origin 0, 0) (VarName "PPPSZ") (VarData "60")
XX            Wizard (Origin 0, 0) (VarName "PPDS") (VarData "35")
XX            Wizard (Origin 0, 0) (VarName "PPGC") (VarData "2")
XX            Wizard (Origin 0, 0) (VarName "PPGR") (VarData "2")
XX            Wizard (Origin 0, 0) (VarName "PPGP") (VarData "100")
XX            Wizard (Origin 0, 0) (VarName "MWA") (VarData "4")
XX            Wizard (Origin 0, 0) (VarName "RSMB") (VarData "2")
XX            Wizard (Origin 0, 0) (VarName "ISML") (VarData "0")
XX            Wizard (Origin 0, 0) (VarName "CHGT") (VarData "100")
XX            Wizard (Origin 0, 0) (VarName "CMHGT") (VarData "10")
XX            Wizard (Origin 0, 0) (VarName "PROT") (VarData "0")
XX            Wizard (Origin 0, 0) (VarName "REVLEVEL") (VarData "A0")
XX            Wizard (Origin 0, 0) (VarName "OriginalPinCount") (VarData "8")
XX            Line (Layer TOP_SILKSCREEN) (Origin -49, -65.1000003814697) (EndPoint -49, -80) (Width 6)
XX            Line (Layer TOP_SILKSCREEN) (Origin 49, 65.1000003814697) (EndPoint 49, 80) (Width 6)
XX        EndData
XX    EndPattern
# 
# Schematic symbols
# 	
# The symbol is laid out similar to the footprint.  Only details not
# defined above will be commented on.
# 
#Symbols
Symbols : 1
XX    Symbol "so8-p30-a98"
XX        OriginPoint  (0, 0)
XX        OriginalName ""
XX        Data         : 14
XX            Pin (PinNum 1) (Origin -400, 200) (PinLength 100) (Rotate 180) (Width 8) (IsVisible True)
XX                PinDes "1" (-420, 250) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
XX                PinName "1" (-380, 200) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
# 
# The pin is equivelant in many ways to the footprint pad.  It must have a
# number and a designator.  Each symbol must have all of its pins assigned
# a number between one and the total number of pins with no gaps or
# duplicates in the numbers used.  Each pin requires an Orgin, PinLength
# attribute as well as the PinDes (pin designator) that will appear to the
# user.  The designator is ALWAYS  text.  Yes, always, even when it looks
# like a number.  The PinName is the text field that will be filled out
# with the pins function name. 
# 
XX            Pin (PinNum 2) (Origin -400, 100) (PinLength 100) (Rotate 180) (Width 8) (IsVisible True)
XX                PinDes "2" (-420, 150) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
XX                PinName "2" (-380, 100) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
XX            Pin (PinNum 3) (Origin -400, 0) (PinLength 100) (Rotate 180) (Width 8) (IsVisible True)
XX                PinDes "3" (-420, 50) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
XX                PinName "3" (-380, 0) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
XX            Pin (PinNum 4) (Origin -400, -100) (PinLength 100) (Rotate 180) (Width 8) (IsVisible True)
XX                PinDes "4" (-420, -50) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
XX                PinName "4" (-380, -100) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
XX            Pin (PinNum 5) (Origin 400, 200) (PinLength 100) (Width 8) (IsVisible True)
XX                PinDes "5" (420, 150) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
XX                PinName "5" (380, 200) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
XX            Pin (PinNum 6) (Origin 400, 100) (PinLength 100) (Width 8) (IsVisible True)
XX                PinDes "6" (420, 50) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
XX                PinName "6" (380, 100) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
XX            Pin (PinNum 7) (Origin 400, 0) (PinLength 100) (Width 8) (IsVisible True)
XX                PinDes "7" (420, -50) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
XX                PinName "7" (380, 0) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
XX            Pin (PinNum 8) (Origin 400, -100) (PinLength 100) (Width 8) (IsVisible True)
XX                PinDes "8" (420, -150) (TextStyleRef "H80s4") (Justify Left) (IsVisible True)
XX                PinName "8" (380, -100) (TextStyleRef "H80s4") (Justify Right) (IsVisible True)
XX            Line (Origin -400, 300) (EndPoint -400, -200) (Width 10)
XX            Line (Origin 400, -200) (EndPoint -400, -200) (Width 10)
XX            Line (Origin 400, -200) (EndPoint 400, 300) (Width 10)
XX            Line (Origin 400, 300) (EndPoint -400, 300) (Width 10)
XX            Attribute (Origin 0, 350) (Attr "RefDes" "RefDes") (IsVisible True) (Justify Center) (TextStyleRef "h125s6")
XX            Attribute (Origin 0, -275) (Attr "Type" "Type") (IsVisible True) (Justify Center) (TextStyleRef "h125s6")
XX        EndData
XX    EndSymbol
# 
# Component Section
# 	
# A component is what ties the footprint and symbol together in our tool. 
# It contains a pointer to the footprint and the symbols that are used, as
# well as defining what pins can be swapped or which symbols can be swapped.
# 
#Components
Components : 1
XX    Component "so8-p30-a98"
XX        PatternName   "so8-p30-a98"
# 
# Currently only one footprint can be assigned to a component.  This area
# may be enhanced in the future to have an array available for alternate
# footprints.
# 
XX        OriginalName  "so8-p30-a98"
XX        SourceLibrary ""
XX        RefDesPrefix  "U"
XX        NumberofPins  8
XX        NumParts      1
# 
# This refers to how many schematic symbols are required to completely
# represent this component.  That could be one symbol, as in this case, ot
# it could be 10 different symbols, or it could be four identical symbols.
# 
XX        Composition   Heterogeneous
# 
# This can be hetrogeneous, as in each symbol is distinctly different, or
# homogeneous, as in each symbol is a duplicate of the other (like a 7400
# which has 4 identical symbols or gates).
# 
XX        AltIEEE       False
# 
# Is there also an alternate symbol in IEEE format available?
# 
XX        AltDeMorgan   False
# 
# Is there a Demorgan view of the symbol?
# 
XX        PatternPins   8
XX        Revision Level
XX        Revision Note 
XX        CompPins         : 8
XX            CompPin 1 "1" (PartNum 1) (SymPinNum 1) (GateEq 0) (PinEq 0) (PinType Any) (Side Left) (Group 1)
# 
# The CompPin number refers to the arbitrarily numbered one to pin count
# no gaps no duplicates numbering assigned.  It is typically the same as
# the numbering of a numbered part, but does not have to be.  This number
# is used later in the PinMap to define the padnumber used in the
# footprint.  In the PinMap area this is called the CompPinRef.  Next to
# the CompPin is the Pin Designator that the user will see in almost all
# instances.  This is ALWAYS a string (yes always), and it can contain
# alpha numerics.  It should also be the same as what the designator is on
# the symbol and the footprint, but if not, this will ALWAYS take presidence.
# 
XX            CompPin 2 "2" (PartNum 1) (SymPinNum 2) (GateEq 0) (PinEq 0) (PinType Any) (Side Left) (Group 1)
# 
# The PartNum property refers to which symbol in the collection of symbols
# for this component.  This component only has one symbol used, so all of
# the refereences to PartNum will be one.  SymPinNum is the number of the
# pin in the symbol that is being mapped.  It will always be a number, and
# will always be less than or equal to the number of pins carried on a symbol.
# 
# Gate eq and pin eq refer to gate (symbol) and pin swapability.  These
# can be 0, in which case they swap with no one, or they can be a whole
# number that matches those pins and or gates that are swappable.
# 
# PinType can be any of the following:  Input, OutPut, Bi-Directional,
# Any,  Power, TriState, Analog
# 
# Sides can be Top, Bottom, Left and Right,
# 
# Grouping will deal with the placement of the pins in the symbol. 
# Groupings with the same number will be grouped on the symbol together
# irregardless of how they appear in the spreadsheet.
# 
XX            CompPin 3 "3" (PartNum 1) (SymPinNum 3) (GateEq 0) (PinEq 0) (PinType Any) (Side Left) (Group 1)
XX            CompPin 4 "4" (PartNum 1) (SymPinNum 4) (GateEq 0) (PinEq 0) (PinType Any) (Side Left) (Group 1)
XX            CompPin 5 "5" (PartNum 1) (SymPinNum 5) (GateEq 0) (PinEq 0) (PinType Any) (Side Right) (Group 1)
XX            CompPin 6 "6" (PartNum 1) (SymPinNum 6) (GateEq 0) (PinEq 0) (PinType Any) (Side Right) (Group 1)
XX            CompPin 7 "7" (PartNum 1) (SymPinNum 7) (GateEq 0) (PinEq 0) (PinType Any) (Side Right) (Group 1)
XX            CompPin 8 "8" (PartNum 1) (SymPinNum 8) (GateEq 0) (PinEq 0) (PinType Any) (Side Right) (Group 1)
XX        EndCompPins
XX        CompData         : 7
XX            Wizard (Origin 0, 0) (Number 1) (VarName "TEMPLATE") (VarData "TableSymbol_Dual.ads")
#
# This information, similar to what was in the footprint, is input into
# the wizard for rebuilding a symbol.  In each case, the VarName is the
# name of the variable in the template to be filled in, and is enclosed in
# quotes and always text.  Yes always.  The VarData is the actual value of
# the variable.
# 
XX            Wizard (Origin 0, 0) (Number 1) (VarName "NAME") (VarData "so8-p30-a98")
XX            Wizard (Origin 0, 0) (Number 1) (VarName "PL") (VarData "100")
XX            Wizard (Origin 0, 0) (Number 1) (VarName "OV") (VarData "1")
XX            Wizard (Origin 0, 0) (Number 1) (VarName "NST") (VarData "Top Down")
XX            Wizard (Origin 0, 0) (Number 1) (VarName "PD") (VarData "100")
XX            Wizard (Origin 0, 0) (Number 1) (VarName "PN") (VarData "300")
XX        EndCompData
XX        AttachedSymbols  : 1
XX           AttachedSymbol (PartNum 1) (AltType Normal) (SymbolName "so8-p30-a98")
XX        EndAttachedSymbols
XX        PinMap       : 8
XX            PadNum 1 (CompPinRef "1")
XX            PadNum 2 (CompPinRef "2")
# 
# The pinMap is designed to identify the ComPPin (in the section above)
# with the PadNum in the footprint.  This section is not available if
# there is no footprint.
# 
XX            PadNum 3 (CompPinRef "3")
XX            PadNum 4 (CompPinRef "4")
XX            PadNum 5 (CompPinRef "5")
XX            PadNum 6 (CompPinRef "6")
XX            PadNum 7 (CompPinRef "7")
XX            PadNum 8 (CompPinRef "8")
XX        EndPinMap
XX    EndComponent
# 
# Future Expeansion
#WorkSpace
XX    WorkSpaceSize (LowerLeft 0, 0)(UpperRight 0, 0)
#EndWorkSpace
# 
# 
# Future Expeansion 	Component Instances
ComponentInstances : 0
#EndComponentInstances
# 
# Future Expeansion 	
XX
#Via Instances
ViaInstances : 0
#EndViaInstances
# 
#NetListInfo
Nets : 0
#EndNets
# 
#Schmatic
SchematicData :
XX    Units "mil"
XX    WorkSpace (LL 0,0) (UR 0,0) (Grid 0)
# 
#EndSchematic
# 
#SchematicSheets
Sheets : 0
#EndSchematicSheets
# 
#LayerData
Layers : 0
#EndLayerData
# 
#LayerTechnicalData
LayerTechnicalData : 0
#EndLayerTechnicalData
# 
# End of File
# 
# <file:///C:/UltraLibrarian/Help/index.html>
# Copyright  1999-2007 Accelerated Designs, Inc.  All Rights Reserved.
XSHAR_EOF
X  (set 20 08 04 19 09 41 45 'XLR_Format.txt'; eval "$shar_touch") &&
X  chmod 0644 'XLR_Format.txt'
if test $? -ne 0
then ${echo} 'restore of XLR_Format.txt failed'
fi
X  if ${md5check}
X  then (
X       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'XLR_Format.txt: MD5 check failed'
X       ) << SHAR_EOF
0275a7d193fc765d7409f762139ee2f6  XLR_Format.txt
XSHAR_EOF
X  else
test `LC_ALL=C wc -c < 'XLR_Format.txt'` -ne 48486 && \
X  ${echo} 'restoration warning:  size of XLR_Format.txt is not 48486'
X  fi
fi
# ============= xlr.h ==============
if test -f 'xlr.h' && test "$first_param" != -c; then
X  ${echo} 'x -SKIPPING xlr.h (file already exists)'
else
${echo} 'x - extracting xlr.h (text)'
X  sed 's/^X//' << 'SHAR_EOF' > 'xlr.h' &&
/*
XX * ed.h
XX */
#ifndef E_H
#define E_H
XX
#ifndef global
#define global extern
#endif
XX
#define YYDEBUG 1
XX
#define IDENT_LENGTH            255
#define Malloc(s)               malloc(s)
#define Free(p)                 free(p)
#define ABS(v)                  ((v) < 0 ? -(v) : (v))
#define Getc(s)                 getc(s)
#define Ungetc(c)               ungetc(c,Input);
XX
extern int atoi();
extern int bug;
XX
struct inst {
XX  char          *ins, *sym;
XX  struct inst   *nxt;
};
XX
char *cur_nnam;
XX
struct con  {
XX  char          *ref;
XX  char          *pin;
XX  char          *nnam;
XX  struct con    *nxt;
};
XX
struct FigGrpStruct {
XX        char Name[20];
XX        int  PathWidth, Color, TextHeight, Visible;
XX        struct FigGrpStruct * nxt;
XX        }; 
XX
struct plst { int x, y; struct plst *nxt;};
struct st   { char *s; struct plst *p; int n; struct st *nxt;};
struct pwr  { char *s, *r ; struct pwr *nxt;};
XX
#endif
XX
/*
ViewRef :       VIEWREF ViewNameRef _ViewRef PopC
XX                {
XX                $$=$2; if(bug>2)fprintf(Error,"ViewRef: %25s ", $3);
XX                iptr = (struct inst *)Malloc(sizeof (struct inst));
XX                iptr->sym = $3;
XX                iptr->nxt = insts;
XX                insts = iptr;
XX                }
*/
XSHAR_EOF
X  (set 20 08 04 15 12 46 14 'xlr.h'; eval "$shar_touch") &&
X  chmod 0644 'xlr.h'
if test $? -ne 0
then ${echo} 'restore of xlr.h failed'
fi
X  if ${md5check}
X  then (
X       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'xlr.h: MD5 check failed'
X       ) << SHAR_EOF
832f788e2bc85f35487a96b20e0ff7a8  xlr.h
XSHAR_EOF
X  else
test `LC_ALL=C wc -c < 'xlr.h'` -ne 1230 && \
X  ${echo} 'restoration warning:  size of xlr.h is not 1230'
X  fi
fi
# ============= xlr.y ==============
if test -f 'xlr.y' && test "$first_param" != -c; then
X  ${echo} 'x -SKIPPING xlr.y (file already exists)'
else
${echo} 'x - extracting xlr.y (text)'
X  sed 's/^X//' << 'SHAR_EOF' > 'xlr.y' &&
%{
/************************************************************************
XX *                                                                      *
XX *                           XLR.y                                      *
XX *                                                                      *
XX ************************************************************************/
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "xlr.h"
XX
// #define DEBUG 1
int          yydebug=0;
static FILE *Input = NULL;              /* input stream */
static FILE *Error = NULL;              /* error stream */
static int   LineNumber;                /* current input line number */
XX
int		num;
XX
%}
XX
%union    {
XX            int n;
XX            float f;
XX            struct st   *st;
XX            struct pt   *pt;
XX            struct plst *pl;
XX          }
XX
%type   <n>     Int
XX
%token  <st>    IDENT
%token  <st>    KEYWORD
%token  <st>    STR
%token  <st>    INT
%token          COMMENT
%token  	FLOAT
%token  <pt>	POINT
XX
%token  	LAYERDATA LAYERS LAYER NAME LAYERTYPE
%token  	TEXTSTYLES TEXTSTYLE TEXTSTYLEREF
%token  	FONTWIDTH FONTHEIGHT FONTCHARWIDTH
%token  	PADSTACKS PADSTACK HOLEDIAM SURFACE PLATED SHAPES
XX
%token  	PADSHAPE  RECTANGLE  CIRCLE  OBLONG  ROUNDEDRECTANGLE DIAMOND  
%token  	ROUNDEDDIAMOND  THERMAL  THERMALX POLYGON
XX
%token  	WIDTH HEIGHT
%token  	PADTYPE ENDPADSTACK ENDPATTERN
%token  	PATTERNS PATTERN ORIGINPOINT GLUEPOINT DATA ORIGIN ISVISIBLE
%token  	TRUE FALSE
%token  	JUSTIFY ORIENTATION
%token  	PAD NUMBER PINNAME PADSTYLE ORIGINALPADSTYLE ORIGINALPINNUMBER ENDPOINT
XX
%token  	LINE ARC ATTRIBUTE PICKPOINT POLY PROPERTY
%token  	POLYKEEPOUT POLYKEEPOUT_VIA POLYKEEPOUT_COMP POLYKEEPIN_COMP
%token  	TEXT WIZARD
XX
%token  	ATTR
%token  	RADIUS STARTANGLE SWEEPANGLE
XX
%token  	VARNAME VARDATA
%token  	SYMBOLS SYMBOL ORIGINALNAME
%token  	PIN PINNUM PINDES PINLENGTH ROTATE
%token  	ENDDATA ENDSYMBOL
%token  	COMPONENTS COMPONENT COMPONENTSINSTANCES
%token  	PATTERNNAME
%token  	SOURCELIBRARY
%token  	REFDESPREFIX
%token  	NUMBEROFPINS NUMPARTS
%token  	COMPOSITION ALTIEEE ALTDEMORGAN PATTERNPINS REVISION LEVEL NOTE
%token  	COMPPINS COMPPIN PARTNUM SYMPINNUM
%token  	GATEEQ PINEQ PINTYPE SIDE GROUP
%token  	COMPDATA ENDCOMPDATA
%token  	ATTACHEDSYMBOLS ATTACHEDSYMBOL ALTTYPE SYMBOLNAME ENDATTACHEDSYMBOLS
%token  	PINMAP PADNUM COMPPINREF ENDPINMAP ENDCOMPONENT ENDCOMPPINS
%token  	WORKSPACESIZE COMPONENTINSTANCES VIAINSTANCES NETS SCHEMATICDATA 
%token 		UNITS WORKSPACE GRID SHEETS LAYERTECHNICALDATA
XX
%token  	UPPERLEFT UPPERCENTER UPPERRIGHT LEFT CENTER RIGHT 
%token  	LOWERLEFT LOWERCENTER LOWERRIGHT LL UR
XX
%token  	R0 R180 R270 R90 MX MXR90 MY MYR90
XX
%start xlr
XX
%%
XX
xlr	:
XX	| xlr COMMENT
XX	| xlr LayerSect
XX	| xlr TextStyleSect
XX	| xlr PadStackSect
XX	| xlr PatternSect
XX	| xlr SchematicSymbols
XX	| xlr ComponentSect
XX	| xlr WORKSPACESIZE Corners
XX	| xlr COMPONENTINSTANCES ':' Int 
XX	| xlr VIAINSTANCES ':' Int 
XX	| xlr NETS ':' Int 
XX	| xlr SCHEMATICDATA ':' _SchData
XX	| xlr SHEETS ':' Int 
XX	| xlr LAYERS ':' Int 
XX	| xlr LAYERTECHNICALDATA ':' Int 
XX	;
XX
LayerSect : LAYERDATA ':' Int _layer
XX	;
XX
LayerType : LAYERTYPE
XX	  | LAYERTYPE Ident
XX	  ;
XX
Layer	: LAYER ':' Int NAME Ident LayerType
XX	;
XX
_layer 	:  
XX	| _layer Layer 
XX	;
XX
TextStyleSect : TEXTSTYLES ':' Int _textstyle
XX	;
XX
_textSize  : 
XX	   | _textSize '(' FONTWIDTH Int ')'
XX	   | _textSize '(' FONTHEIGHT Int ')'
XX	   | _textSize '(' FONTCHARWIDTH Int ')'
XX	   ;
XX
TextStyle  : TEXTSTYLE Str _textSize
XX	   ;
XX
_textstyle : 
XX	   | _textstyle TextStyle 
XX	   ;
XX
PadStackSect : PADSTACKS ':' Int _padStacks
XX	;
XX
_shapeAttr :
XX	   | _shapeAttr '(' WIDTH Int ')'
XX	   | _shapeAttr '(' HEIGHT Int ')'
XX	   | _shapeAttr '(' PADTYPE Int ')'
XX	   | _shapeAttr '(' LAYER Ident ')'
XX	   ;
XX
PadShape  : PADSHAPE Str _shapeAttr
XX	  ;
XX
_padShape :
XX	  | _padShape PadShape
XX	  ;
XX
Shapes	: SHAPES ':' Int
XX	;
XX
_padAttr   :
XX	   | _padAttr '(' HOLEDIAM Int ')'
XX	   | _padAttr '(' SURFACE Bool ')'
XX	   | _padAttr '(' PLATED Bool ')'
XX	   ;
XX
PadStack   : PADSTACK Str _padAttr Shapes _padShape ENDPADSTACK
XX	   ;
XX
_padStacks : 
XX	   | _padStacks PadStack
XX	   ;
XX
PatternSect : PATTERNS ':' Int _patterns
XX	;
XX
Justify	:  UPPERLEFT
XX	|  UPPERCENTER
XX	|  UPPERRIGHT
XX	|  LEFT
XX	|  CENTER
XX	|  RIGHT
XX	|  LOWERLEFT
XX	|  LOWERCENTER
XX	|  LOWERRIGHT
XX	;
XX
_tAttr :
XX	  | _tAttr '(' LAYER Ident ')'
XX	  | _tAttr '(' ORIGIN Float ',' Float ')'
XX	  | _tAttr '(' TEXT Str ')'
XX	  | _tAttr '(' ISVISIBLE Bool ')'
XX	  | _tAttr '(' JUSTIFY Justify ')'
XX	  | _tAttr '(' TEXTSTYLE Str ')'
XX	  ;
XX
Text	: TEXT _tAttr
XX	;
XX
_padAttr : _padAttr '(' NUMBER Int ')'
XX	 | _padAttr '(' PINNAME Str ')'
XX	 | _padAttr '(' PADSTYLE Str ')'
XX	 | _padAttr '(' ORIGINALPADSTYLE Str ')'
XX	 | _padAttr '(' ORIGIN Float ',' Float ')'
XX	 | _padAttr '(' ORIGINALPINNUMBER Int ')'
XX	 ;
XX
Pad	: PAD _padAttr
XX	;
XX
_lAttr	:
XX	| _lAttr '(' LAYER Ident ')'
XX	| _lAttr '(' ORIGIN Float ',' Float ')'
XX	| _lAttr '(' WIDTH Int ')'
XX	| _lAttr '(' ENDPOINT Float ',' Float ')'
XX	;
XX
Line	: LINE _lAttr
XX	;
XX
Point	:  '(' Float ',' Float ')'
XX	;
XX
_pAttr	:
XX	| _pAttr '(' LAYER Ident ')'
XX	| _pAttr '(' ORIGIN Float ',' Float ')'
XX	| _pAttr '(' PROPERTY Str ')'
XX	| _pAttr '(' WIDTH Int ')'
XX	| _pAttr Point
XX	;
XX
Poly	: POLY _pAttr
XX	;
XX
_aAttr	: 
XX	| _aAttr '(' LAYER Ident ')'
XX	| _aAttr '(' ORIGIN Float ',' Float ')'
XX	| _aAttr '(' ATTR Str Str ')'
XX	| _aAttr '(' ISVISIBLE Bool ')'
XX	| _aAttr '(' JUSTIFY Justify ')'
XX	| _aAttr '(' TEXTSTYLE Str ')'
XX	| _aAttr '(' TEXTSTYLEREF Str ')'
XX	;
XX
Attribute : ATTRIBUTE _aAttr
XX	  ;
XX
_aProp	:
XX	| _aProp '(' LAYER Ident ')'
XX	| _aProp '(' ORIGIN Float ',' Float ')'
XX	| _aProp '(' RADIUS Float ')'
XX	| _aProp '(' STARTANGLE Int ')'
XX	| _aProp '(' SWEEPANGLE Int ')'
XX	| _aProp '(' WIDTH Int ')'
XX	;
XX
Arc	: ARC _aProp
XX	;
XX
_wAttr	: 
XX	| _wAttr '(' ORIGIN Float ',' Float ')'
XX	| _wAttr '(' VARNAME Str ')'
XX	| _wAttr '(' VARDATA Str ')'
XX	| _wAttr '(' NUMBER Int ')'
XX	| _wAttr COMMENT
XX	;
XX
Wizard	: WIZARD _wAttr
XX	;
XX
_pData	:
XX	| _pData Text
XX	| _pData Pad
XX	| _pData Line
XX	| _pData Poly
XX	| _pData Attribute
XX	| _pData Arc
XX	| _pData Wizard
XX	| _pData COMMENT
XX	;
XX
pData	:  DATA ':' Int _pData ENDDATA
XX	;
XX
_pattData :
XX	     | _pattData COMMENT
XX	     | _pattData ORIGINPOINT '(' Int ',' Int ')'
XX	     | _pattData PICKPOINT '(' Int ',' Int ')'
XX	     | _pattData GLUEPOINT '(' Int ',' Int ')'
XX	     | _pattData pData
XX	     ;
XX
Pattern	: PATTERN Str _pattData ENDPATTERN
XX	;
XX
_patterns  :
XX	   | _patterns Pattern
XX	   ;
XX
_pinVis	:
XX	| _pinVis '(' TEXTSTYLEREF Str ')'
XX	| _pinVis '(' JUSTIFY Justify ')'
XX	| _pinVis '(' ISVISIBLE Bool ')'
XX	;
XX
_pinAttr :
XX	| _pinAttr '(' PINNUM Int ')'
XX	| _pinAttr '(' ORIGIN Int ',' Int ')'
XX	| _pinAttr '(' PINLENGTH Int ')'
XX	| _pinAttr '(' ROTATE Int ')'
XX	| _pinAttr '(' WIDTH Int ')' 
XX	| _pinAttr '(' ISVISIBLE Bool ')'
XX	;
XX
Pin	: PIN _pinAttr 
XX	;
XX
PinDes	: PINDES Str '(' Int ',' Int ')' _pinVis
XX	;
XX
PinName	: PINNAME Str '(' Int ',' Int ')' _pinVis
XX	;
XX
_sData	:
XX	| _sData Pin
XX	| _sData PinDes
XX	| _sData PinName
XX	| _sData Line
XX	| _sData Attribute
XX	| _sData COMMENT
XX	;
XX
sData	: DATA ':' Int _sData ENDDATA
XX	;
XX
_sAttr	:
XX	| _sAttr ORIGINPOINT '(' Int ',' Int ')'
XX	| _sAttr ORIGINALNAME Str
XX	| _sAttr sData
XX	;
XX
Symbol	: SYMBOL Str _sAttr ENDSYMBOL
XX	;
XX
SchematicSymbols : SYMBOLS ':' Int Symbol
XX	;
XX
_cpinAttr :
XX	  | _cpinAttr '(' PARTNUM Int ')'
XX	  | _cpinAttr '(' SYMPINNUM Int ')'
XX	  | _cpinAttr '(' GATEEQ Int ')'
XX	  | _cpinAttr '(' PINEQ Int ')'
XX	  | _cpinAttr '(' PINTYPE Ident ')'
XX	  | _cpinAttr '(' SIDE LEFT ')'
XX	  | _cpinAttr '(' SIDE RIGHT ')'
XX	  | _cpinAttr '(' GROUP Int ')'
XX	  | _cpinAttr COMMENT
XX	  ;
XX
CompPin   :  COMPPIN Int Str _cpinAttr
XX	  ;
XX
_CompPins :
XX	  | _CompPins CompPin 
XX	  ;
XX
CompPins : COMPPINS ':' Int _CompPins ENDCOMPPINS
XX	;
XX
_CompData :
XX	  | _CompData Wizard
XX	  ;
XX
CompData : COMPDATA ':' Int _CompData ENDCOMPDATA
XX	 ;
XX
_AttSym	: 
XX	| _AttSym '(' PARTNUM Int ')'
XX	| _AttSym '(' ALTTYPE Ident ')'
XX	| _AttSym '(' SYMBOLNAME Str ')'
XX	;
XX
AttachedSymbol  : ATTACHEDSYMBOL _AttSym 
XX		;
XX
_AttachedSymbols :
XX		 | _AttachedSymbols AttachedSymbol
XX		 ;
XX
AttachedSymbols : ATTACHEDSYMBOLS ':' Int _AttachedSymbols ENDATTACHEDSYMBOLS
XX		;
XX
PadNum	: PADNUM Int '(' COMPPINREF Str ')'
XX	;
XX
_padnums :
XX	 | _padnums PadNum
XX	 | _padnums COMMENT
XX	 ;
XX
PinMap	: PINMAP ':' Int _padnums ENDPINMAP
XX	;
XX
_cAttr :
XX	| _cAttr PATTERNNAME Str
XX	| _cAttr ORIGINALNAME Str
XX	| _cAttr SOURCELIBRARY Str 
XX	| _cAttr REFDESPREFIX Str 
XX	| _cAttr NUMBEROFPINS Int
XX	| _cAttr NUMPARTS Int
XX	| _cAttr COMPOSITION Ident
XX	| _cAttr ALTIEEE Bool
XX	| _cAttr ALTDEMORGAN Bool
XX	| _cAttr PATTERNPINS Int
XX	| _cAttr REVISION LEVEL
XX	| _cAttr REVISION NOTE
XX	| _cAttr CompPins 
XX	| _cAttr CompData 
XX	| _cAttr AttachedSymbols 
XX	| _cAttr PinMap 
XX	| _cAttr COMMENT 
XX	;
XX
Component : COMPONENT Str _cAttr ENDCOMPONENT
XX	  ;
XX
ComponentSect : COMPONENTS ':' Int Component
XX	;
XX
Corners	: '(' LOWERLEFT Int ',' Int ')' '(' UPPERRIGHT Int ',' Int ')'
XX	| '(' LL Int ',' Int ')' '(' UR Int ',' Int ')'
XX	;
XX
_SchData  :
XX	  | _SchData UNITS Str
XX	  | _SchData WORKSPACE Corners '(' GRID Int ')'
XX	  ;
XX
Ident   :  IDENT
XX        {if(bug>0)fprintf(Error,"%5d IDENT: '%s'\n", LineNumber, $1->s); 
XX	 $1->nxt=NULL;}
XX         ;
XX
Str     :  STR
XX        {if(bug>0)fprintf(Error,"%5d STR: '%s'\n", LineNumber, $1->s); }
XX        ;
XX
Int     :  INT
XX        {sscanf($1->s,"%d",&num); $$=num;  }
XX        ;
XX
Float	: FLOAT
XX	| INT
XX	;
XX
Bool	: TRUE
XX	| FALSE
XX	;
XX
%%
XX 
/*
XX *	Parser state variables.
XX */
extern char *InFile;			/* file name on the input stream */
static char yytext[IDENT_LENGTH + 1];	/* token buffer */
static char CharBuf[IDENT_LENGTH + 1];	/* garbage buffer */
XX
#define HASHSIZE 101
/*
XX *	Token definitions:
XX *
XX *	This associates the '%token' codings with strings which are to
XX *	be free standing tokens. Doesn't have to be in sorted order but the
XX *	strings must be in lower case.
XX */
struct Token {
XX  char *Name;			/* token name */
XX  int   Code;			/* '%token' value */
XX  struct Token *nxt;		/* hash table linkage */
} *htab[HASHSIZE];
XX
static struct Token TokenDef[] = {
XX  {"layer",		LAYER},
XX  {"layerdata",		LAYERDATA},
XX  {"layertype",		LAYERTYPE},
XX  {"name",       	NAME},
XX  {"textstyles",       	TEXTSTYLES},
XX  {"textstyle",       	TEXTSTYLE},
XX  {"fontwidth",       	FONTWIDTH},
XX  {"fontheight",       	FONTHEIGHT},
XX  {"fontcharwidth",    	FONTCHARWIDTH},
XX  {"padstacks",       	PADSTACKS},
XX  {"padstack",       	PADSTACK},
XX  {"holediam",       	HOLEDIAM},
XX  {"surface",       	SURFACE},
XX  {"plated",       	PLATED},
XX  {"shapes",       	SHAPES},
XX  {"padshape",       	PADSHAPE},
XX  {"rectangle",       	RECTANGLE},
XX  {"width",       	WIDTH},
XX  {"height",       	HEIGHT},
XX  {"padtype",       	PADTYPE},
XX  {"endpadstack",      	ENDPADSTACK},
XX  {"patterns",      	PATTERNS},
XX  {"pattern",      	PATTERN},
XX  {"originpoint",      	ORIGINPOINT},
XX  {"pickpoint",      	PICKPOINT},
XX  {"gluepoint",      	GLUEPOINT},
XX  {"data",      	DATA},
XX  {"text",      	TEXT},
XX  {"origin",      	ORIGIN},
XX  {"isvisible",      	ISVISIBLE},
XX  {"pad",      		PAD},
XX  {"number",  		NUMBER},
XX  {"pinname",  		PINNAME},
XX  {"padstyle", 		PADSTYLE},
XX  {"originalpadstyle",  ORIGINALPADSTYLE},
XX  {"originalpinnumber", ORIGINALPINNUMBER},
XX  {"line", 		LINE},
XX  {"endpoint", 		ENDPOINT},
XX  {"poly", 		POLY},
XX  {"property", 		PROPERTY},
XX  {"attribute", 	ATTRIBUTE},
XX  {"attr", 		ATTR},
XX  {"arc", 		ARC},
XX  {"radius", 		RADIUS},
XX  {"startangle", 	STARTANGLE},
XX  {"sweepangle", 	SWEEPANGLE},
XX  {"wizard", 		WIZARD},
XX  {"varname", 		VARNAME},
XX  {"vardata", 		VARDATA},
XX  {"enddata", 		ENDDATA},
XX  {"endpattern", 	ENDPATTERN},
XX  {"symbols", 		SYMBOLS},
XX  {"symbol", 		SYMBOL},
XX  {"originalname", 	ORIGINALNAME},
XX  {"pin", 		PIN},
XX  {"pinnum", 		PINNUM},
XX  {"pinlength",		PINLENGTH},
XX  {"rotate",		ROTATE},
XX  {"pindes", 		PINDES},
XX  {"pinname", 		PINNAME},
XX  {"textstyleref", 	TEXTSTYLEREF},
XX  {"endsymbol", 	ENDSYMBOL},
XX  {"components", 	COMPONENTS},
XX  {"component", 	COMPONENT},
XX  {"patternname", 	PATTERNNAME},
XX  {"sourcelibrary", 	SOURCELIBRARY},
XX  {"refdesprefix", 	REFDESPREFIX},
XX  {"numberofpins", 	NUMBEROFPINS},
XX  {"numparts", 		NUMPARTS},
XX  {"composition", 	COMPOSITION},
XX  {"altieee", 		ALTIEEE},
XX  {"altdemorgan", 	ALTDEMORGAN},
XX  {"patternpins", 	PATTERNPINS},
XX  {"revision", 		REVISION},
XX  {"level", 		LEVEL},
XX  {"note", 		NOTE},
XX
XX  {"comppins", 		COMPPINS},
XX  {"comppin", 		COMPPIN},
XX  {"partnum", 		PARTNUM},
XX  {"sympinnum", 	SYMPINNUM},
XX  {"gateeq", 		GATEEQ},
XX  {"pineq", 		PINEQ},
XX  {"pintype", 		PINTYPE},
XX  {"side", 		SIDE},
XX  {"group", 		GROUP},
XX  {"endcomppins", 	ENDCOMPPINS},
XX  {"compdata", 		COMPDATA},
XX  {"endcompdata", 	ENDCOMPDATA},
XX  {"attachedsymbols", 	ATTACHEDSYMBOLS},
XX  {"attachedsymbol", 	ATTACHEDSYMBOL},
XX  {"alttype", 		ALTTYPE},
XX  {"symbolname", 	SYMBOLNAME},
XX  {"endattachedsymbols",ENDATTACHEDSYMBOLS},
XX  {"pinmap", 		PINMAP},
XX  {"padnum", 		PADNUM},
XX  {"comppinref", 	COMPPINREF},
XX  {"endpinmap",		ENDPINMAP},
XX  {"endcomponent", 	ENDCOMPONENT},
XX  {"workspacesize", 	WORKSPACESIZE},
XX  {"componentinstances",COMPONENTINSTANCES},
XX  {"viainstances",	VIAINSTANCES},
XX  {"nets",		NETS},
XX  {"schematicdata",  	SCHEMATICDATA},
XX  {"units",		UNITS},
XX  {"workspace",		WORKSPACE},
XX  {"grid",		GRID},
XX  {"sheets",		SHEETS},
XX  {"layers",		LAYERS},
XX  {"layertechnicaldata",LAYERTECHNICALDATA},
XX
XX  {"true",       	TRUE},
XX  {"false",       	FALSE},
XX
XX  {"justify",      	JUSTIFY},
XX  {"upperleft",       	UPPERLEFT},
XX  {"uppercenter",     	UPPERCENTER}, 
XX  {"upperright",      	UPPERRIGHT}, 
XX  {"ur",      		UR}, 
XX  {"left",            	LEFT}, 
XX  {"center",          	CENTER}, 
XX  {"right",           	RIGHT}, 
XX  {"lowerleft",         LOWERLEFT}, 
XX  {"ll",         	LL}, 
XX  {"lowercenter",       LOWERCENTER},
XX  {"lowerright",	LOWERRIGHT}
};
static int TokenDefSize = sizeof(TokenDef) / sizeof(struct Token);
XX
/*
XX *	Find keyword:
XX *
XX *	  The passed string is located within the keyword table. If an
XX *	entry exists, then the value of the keyword string is returned. This
XX *	is real useful for doing string comparisons by pointer value later.
XX *	If there is no match, a NULL is returned.
XX */
static int FindKeyword(str)
char *str;
{
XX  register unsigned int hsh;
XX  register char *cp;
XX  char lower[IDENT_LENGTH + 1];
XX  /*
XX   *	Create a lower case copy of the string.
XX   */
XX  for (cp = lower; *str;)
XX    if (isupper(*str))
XX      *cp++ = tolower(*str++);
XX    else
XX      *cp++ = *str++;
XX  *cp = '\0';
XX  /*
XX   *	Search the hash table for a match.
XX   */
XX  return lkup(lower);
}
XX
/*
XX *	yyerror:
XX *
XX *	  Standard error reporter, it prints out the passed string
XX *	preceeded by the current filename and line number.
XX */
yyerror(ers)
char *ers;
{
XX  fprintf(Error,"%s, Line %d: %s\n", InFile, LineNumber, ers);
}
XX
/*
XX *	String bucket definitions.
XX */
#define	BUCKET_SIZE	64
typedef struct Bucket {
XX  struct Bucket *Next;			/* pointer to next bucket */
XX  int 		Index;			/* pointer to next free slot */
XX  char 		Data[BUCKET_SIZE];	/* string data */
} Bucket;
static Bucket *CurrentBucket = NULL;	/* string bucket list */
XX
int StringSize = 0;		/* current string length */
/*
XX *	Push string:
XX *
XX *	  This adds the passed charater to the current string bucket.
XX */
static PushString(chr)
char chr;
{
XX  register Bucket *bck;
XX  /*
XX   *	Make sure there is room for the push.
XX   */
XX  if ((bck = CurrentBucket)->Index >= BUCKET_SIZE){
XX    bck = (Bucket *) Malloc(sizeof(Bucket));
XX    bck->Next = CurrentBucket;
XX    (CurrentBucket = bck)->Index = 0;
XX  }
XX  /*
XX   *	Push the character.
XX   */
XX  bck->Data[bck->Index++] = chr;
XX  StringSize++;
}
/*
XX *	Form string:
XX *
XX *	  This converts the current string bucket into a real live string,
XX *	whose pointer is returned.
XX */
char *FormString()
{
XX  register Bucket *bck;
XX  register char *cp;
XX  /*
XX   *	Allocate space for the string, set the pointer at the end.
XX   */
XX  cp = (char *) Malloc(StringSize + 1);
XX  cp += StringSize;
XX  *cp-- = '\0';
XX  /*
XX   *	Yank characters out of the bucket.
XX   */
XX  for (bck = CurrentBucket; bck->Index || (bck->Next !=NULL) ;){
XX    if (!bck->Index){
XX      CurrentBucket = bck->Next;
XX      Free(bck);
XX      bck = CurrentBucket;
XX    }
XX    *cp-- = bck->Data[--bck->Index];
XX  }
XX  // fprintf(stderr,"FormStr:'%s'\n",cp+1);
XX  StringSize = 0;
XX  return (cp + 1);
}
XX
/*
XX * empty the hash table before using it...
XX *
XX */
clrhash()
{
XX  int i;
XX  for (i=0; i<HASHSIZE; i++) htab[i] = NULL;
}
XX
/*
XX * compute the value of the hash for a symbol
XX *
XX */
hash(name)
char *name;
{
XX  int sum;
XX
XX  for (sum = 0; *name != '\0'; name++) sum += (sum + *name);
XX  sum %= HASHSIZE;                      /* take sum mod hashsize */
XX  if (sum < 0) sum += HASHSIZE;         /* disallow negative hash value */
XX  return(sum);
}
XX
/*
XX * make a private copy of a string...
XX *
XX */
char *
copy(s)
char *s;
{
XX  char *new;
XX
XX  new = (char *) malloc(strlen(s) + 1);
XX  strcpy(new,s);
XX  return(new);
}
XX
/*
XX * find name in the symbol table, return its value.  Returns -1
XX * if not found.
XX *
XX */
lkup(name)
char *name;
{
XX  struct Token *cur;
XX
XX  for (cur = htab[hash(name)]; cur != NULL; cur = cur->nxt)
XX        if (strcmp(cur->Name, name) == 0) return(cur->Code);
XX  return(-1);
}
XX
/*
XX *	Parse XLR:
XX *
XX *	  This builds the context tree and then calls the real parser.
XX *	It is passed two file streams, the first is where the input comes
XX *	from; the second is where error messages get printed.
XX */
ParseXLR(inp,err)
FILE *inp,*err;
{
XX  register int i;
XX  /*
XX   *	Set up the file state to something useful.
XX   */
XX  Input = inp;
XX  Error = err;
XX  LineNumber = 1;
XX
XX  clrhash();
XX  /*
XX   *	Define the tokens.
XX   */
XX  for (i = TokenDefSize; i--; ){
XX      register unsigned int h;
XX      struct Token *cur;
XX
XX      h = hash(TokenDef[i].Name);
XX      cur = (struct Token *)malloc(sizeof (struct Token));
XX      cur->Name = copy(TokenDef[i].Name);
XX      cur->Code = TokenDef[i].Code;
XX      cur->nxt = htab[h];
XX      htab[h] = cur;
XX  }
XX  /*
XX   *	Create an initial, empty string bucket.
XX   */
XX  CurrentBucket = (Bucket *) Malloc(sizeof(Bucket));
XX  CurrentBucket->Next = NULL;
XX  CurrentBucket->Index = 0;
XX  /*
XX   *	Go parse things!
XX   */
XX  yyparse();
XX
XX  // DumpStack();
}
XX
/*
XX *	PopC:
XX *
XX *	  This pops the current context.
XX */
PopC()
{
}
XX
/*
XX *	Lexical analyzer states.
XX */
#define	L_START		0
#define	L_INT		1
#define	L_IDENT		2
#define	L_KEYWORD	3
#define	L_STRING	4
#define	L_KEYWORD2	5
#define	L_ASCIICHAR	6
#define	L_ASCIICHAR2	7
#define	L_FLOAT 	8
#define	L_COMMENT 	9
/*
XX *	yylex:
XX *
XX *	  This is the lexical analyzer called by the YACC/BISON parser.
XX *	It returns a pretty restricted set of token types and does the
XX *	context movement when acceptable keywords are found. The token
XX *	value returned is a NULL terminated string to allocated storage
XX *	(ie - it should get released some time) with some restrictions.
XX *	  The token value for integers is strips a leading '+' if present.
XX *	String token values have the leading and trailing '"'-s stripped.
XX *	'%' conversion characters in string values are passed converted.
XX *	The '(' and ')' characters do not have a token value.
XX */
int yylex()
{
XX  extern YYSTYPE yylval;
XX  struct st  *st;
XX  register int c,s,l,len;
XX  /*
XX   *	Keep on sucking up characters until we find something which
XX   *	explicitly forces us out of this function.
XX   */
XX  for (s = L_START, l = 0; 1; ){
XX    yytext[l++] = c = Getc(Input);
XX    if (c == '\n' && s==L_START){
XX       LineNumber++ ;
XX    }
XX    switch (s){
XX      case L_COMMENT:
XX	if( c == '\n' || c == EOF){
XX	   s = L_START;
XX       	   LineNumber++ ;
XX	   return COMMENT;
XX        }
XX	break;
XX      case L_START:
XX	if( c == '#' )
XX	  s = L_COMMENT;
XX        else if (isdigit(c) || c == '-')
XX          s = L_INT;
XX        else if (isalpha(c) )
XX          s = L_KEYWORD;
XX        else if (isspace(c)){
XX          l = 0;
XX        } else if (c == '(' || c == ')'){
XX          l = 0;
XX          return (c);
XX        } else if (c == '"')
XX          s = L_STRING;
XX        else if (c == '+'){
XX          l = 0;				/* strip '+' */
XX          s = L_INT;
XX        } else if (c == EOF)
XX          return ('\0');
XX        else {
XX          yytext[1] = '\0';
XX          // Stack(yytext, c);
XX          return (c);
XX        }
XX        break;
XX      /*
XX       *	Suck up the integer digits.
XX       */
XX      case L_INT:
XX        if (isdigit(c))
XX          break;
XX	if( c == '.' ) {
XX	   s = L_FLOAT;
XX	   break;
XX	}
XX        Ungetc(c);
XX        yytext[--l] = '\0';
XX	st = (struct st *)Malloc(sizeof (struct st));
XX        st->s = strdup(yytext); 
XX	yylval.st = st ;
XX        // Stack(yytext, INT);
XX        return (INT);
XX      /*
XX       *	Suck up the integer digits.
XX       */
XX      case L_FLOAT:
XX        if (isdigit(c))
XX          break;
XX        Ungetc(c);
XX        yytext[--l] = '\0';
XX	st = (struct st *)Malloc(sizeof (struct st));
XX        st->s = strdup(yytext); 
XX	yylval.st = st ;
XX        // Stack(yytext, FLOAT);
XX        return (FLOAT);
XX      /*
XX       *	Scan until you find the start of an identifier, discard
XX       *	any whitespace found. On no identifier, return a '('.
XX       */
XX      case L_KEYWORD:
XX        if (isalpha(c)){
XX          s = L_KEYWORD2;
XX          break;
XX        } else if (isspace(c)){
XX          l = 0;
XX          break;
XX        }
XX        Ungetc(c);
XX        // Stack("(",'(');
XX        return ('(');
XX      /*
XX       *	Suck up the keyword identifier, if it matches the set of
XX       *	allowable contexts then return its token value and push
XX       *	the context, otherwise just return the identifier string.
XX       */
XX      case L_KEYWORD2:
XX        if (isalpha(c) || isdigit(c) || c == '_' || c=='-')
XX          break;
XX        Ungetc(c);
XX        yytext[--l] = '\0';
XX        if ( (c = FindKeyword(yytext)) >0 ){
XX          // Stack(yytext, c);
XX          return (c);
XX        }
XX	st = (struct st *)Malloc(sizeof (struct st));
XX        st->s = strdup(yytext); 
XX	yylval.st = st ;
XX        // Stack(yytext, KEYWORD);
XX        return (IDENT);
XX      /*
XX       *	Suck up string characters but once resolved they should
XX       *	be deposited in the string bucket because they can be
XX       *	arbitrarily long.
XX       */
XX      case L_STRING:
XX        if (c == '\r' || c == '\n')
XX          ;
XX        else if (c == '"' || c == EOF){
XX	  st = (struct st *)Malloc(sizeof (struct st));
XX          st->s = FormString();  
XX          // st->s = strdup(yytext); 
XX	  yylval.st = st ; 
XX          // Stack(yytext, STR);
XX          return (STR);
XX        } else  if (c == '%'){
XX          s = L_ASCIICHAR;
XX        } else  if (c == ' ')
XX	  PushString('_');
XX        else
XX          PushString(c);
XX        l = 0;
XX        break;
XX      /*
XX       *	Skip white space and look for integers to be pushed
XX       *	as characters.
XX       */
XX      case L_ASCIICHAR:
XX        if (isdigit(c)){
XX          s = L_ASCIICHAR2;
XX          break;
XX        } else if (c == '%' || c == EOF)
XX          s = L_STRING;
XX        l = 0;
XX        break;
XX      /*
XX       *	Convert the accumulated integer into a char and push.
XX       */
XX      case L_ASCIICHAR2:
XX        if (isdigit(c))
XX          break;
XX        Ungetc(c);
XX        yytext[--l] = '\0';
XX        PushString(yytext);
XX        s = L_ASCIICHAR;
XX        l = 0;
XX        break;
XX    }
XX  }
}
XSHAR_EOF
X  (set 20 08 04 18 17 43 42 'xlr.y'; eval "$shar_touch") &&
X  chmod 0644 'xlr.y'
if test $? -ne 0
then ${echo} 'restore of xlr.y failed'
fi
X  if ${md5check}
X  then (
X       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'xlr.y: MD5 check failed'
X       ) << SHAR_EOF
db222ecf97a557c937caae6291d2c301  xlr.y
XSHAR_EOF
X  else
test `LC_ALL=C wc -c < 'xlr.y'` -ne 22834 && \
X  ${echo} 'restoration warning:  size of xlr.y is not 22834'
X  fi
fi
if rm -fr ${lock_dir}
then ${echo} 'x - removed lock directory `'${lock_dir}\''.'
else ${echo} 'x - failed to remove lock directory `'${lock_dir}\''.'
X  exit 1
fi
Xexit 0
SHAR_EOF
  (set 20 10 04 07 21 00 56 'xlr.sh'
   eval "${shar_touch}") && \
  chmod 0644 'xlr.sh'
if test $? -ne 0
then ${echo} "restore of xlr.sh failed"
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'xlr.sh': 'MD5 check failed'
       ) << \SHAR_EOF
cc02140d12cbe411a2991bbf59b20a35  xlr.sh
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'xlr.sh'` -ne 257868 && \
  ${echo} "restoration warning:  size of 'xlr.sh' is not 257868"
  fi
fi
# ============= xlr.y ==============
if test -n "${keep_file}" && test -f 'xlr.y'
then
${echo} "x - SKIPPING xlr.y (file already exists)"
else
${echo} "x - extracting xlr.y (text)"
  sed 's/^X//' << 'SHAR_EOF' > 'xlr.y' &&
%{
/************************************************************************
X *                                                                      *
X *                           XLR.y                                      *
X *                                                                      *
X ************************************************************************/
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "xlr.h"
X
// #define DEBUG 1
int          yydebug=0;
static FILE *Input = NULL;              /* input stream */
static FILE *Error = NULL;              /* error stream */
static int   LineNumber;                /* current input line number */
X
int		num;
X
%}
X
%union    {
X            int n;
X            float f;
X            struct st   *st;
X            struct pt   *pt;
X            struct plst *pl;
X          }
X
%type   <n>     Int
X
%token  <st>    IDENT
%token  <st>    KEYWORD
%token  <st>    STR
%token  <st>    INT
%token          COMMENT
%token  	FLOAT
%token  <pt>	POINT
X
%token  	LAYERDATA LAYERS LAYER NAME LAYERTYPE
%token  	TEXTSTYLES TEXTSTYLE TEXTSTYLEREF
%token  	FONTWIDTH FONTHEIGHT FONTCHARWIDTH
%token  	PADSTACKS PADSTACK HOLEDIAM SURFACE PLATED SHAPES
X
%token  	PADSHAPE  RECTANGLE  CIRCLE  OBLONG  ROUNDEDRECTANGLE DIAMOND  
%token  	ROUNDEDDIAMOND  THERMAL  THERMALX POLYGON
X
%token  	WIDTH HEIGHT
%token  	PADTYPE ENDPADSTACK ENDPATTERN
%token  	PATTERNS PATTERN ORIGINPOINT GLUEPOINT DATA ORIGIN ISVISIBLE
%token  	TRUE FALSE
%token  	JUSTIFY ORIENTATION
%token  	PAD NUMBER PINNAME PADSTYLE ORIGINALPADSTYLE ORIGINALPINNUMBER ENDPOINT
X
%token  	LINE ARC ATTRIBUTE PICKPOINT POLY PROPERTY
%token  	POLYKEEPOUT POLYKEEPOUT_VIA POLYKEEPOUT_COMP POLYKEEPIN_COMP
%token  	TEXT WIZARD
X
%token  	ATTR
%token  	RADIUS STARTANGLE SWEEPANGLE
X
%token  	VARNAME VARDATA
%token  	SYMBOLS SYMBOL ORIGINALNAME
%token  	PIN PINNUM PINDES PINLENGTH ROTATE
%token  	ENDDATA ENDSYMBOL
%token  	COMPONENTS COMPONENT COMPONENTSINSTANCES
%token  	PATTERNNAME
%token  	SOURCELIBRARY
%token  	REFDESPREFIX
%token  	NUMBEROFPINS NUMPARTS
%token  	COMPOSITION ALTIEEE ALTDEMORGAN PATTERNPINS REVISION LEVEL NOTE
%token  	COMPPINS COMPPIN PARTNUM SYMPINNUM
%token  	GATEEQ PINEQ PINTYPE SIDE GROUP
%token  	COMPDATA ENDCOMPDATA
%token  	ATTACHEDSYMBOLS ATTACHEDSYMBOL ALTTYPE SYMBOLNAME ENDATTACHEDSYMBOLS
%token  	PINMAP PADNUM COMPPINREF ENDPINMAP ENDCOMPONENT ENDCOMPPINS
%token  	WORKSPACESIZE COMPONENTINSTANCES VIAINSTANCES NETS SCHEMATICDATA 
%token 		UNITS WORKSPACE GRID SHEETS LAYERTECHNICALDATA
X
%token  	UPPERLEFT UPPERCENTER UPPERRIGHT LEFT CENTER RIGHT 
%token  	LOWERLEFT LOWERCENTER LOWERRIGHT LL UR
X
%token  	R0 R180 R270 R90 MX MXR90 MY MYR90
X
%start xlr
X
%%
X
xlr	:
X	| xlr COMMENT
X	| xlr LayerSect
X	| xlr TextStyleSect
X	| xlr PadStackSect
X	| xlr PatternSect
X	| xlr SchematicSymbols
X	| xlr ComponentSect
X	| xlr WORKSPACESIZE Corners
X	| xlr COMPONENTINSTANCES ':' Int 
X	| xlr VIAINSTANCES ':' Int 
X	| xlr NETS ':' Int 
X	| xlr SCHEMATICDATA ':' _SchData
X	| xlr SHEETS ':' Int 
X	| xlr LAYERS ':' Int 
X	| xlr LAYERTECHNICALDATA ':' Int 
X	;
X
LayerSect : LAYERDATA ':' Int _layer
X	;
X
LayerType : LAYERTYPE
X	  | LAYERTYPE Ident
X	  ;
X
Layer	: LAYER ':' Int NAME Ident LayerType
X	;
X
_layer 	:  
X	| _layer Layer 
X	;
X
TextStyleSect : TEXTSTYLES ':' Int _textstyle
X	;
X
_textSize  : 
X	   | _textSize '(' FONTWIDTH Int ')'
X	   | _textSize '(' FONTHEIGHT Int ')'
X	   | _textSize '(' FONTCHARWIDTH Int ')'
X	   ;
X
TextStyle  : TEXTSTYLE Str _textSize
X	   ;
X
_textstyle : 
X	   | _textstyle TextStyle 
X	   ;
X
PadStackSect : PADSTACKS ':' Int _padStacks
X	;
X
_shapeAttr :
X	   | _shapeAttr '(' WIDTH Int ')'
X	   | _shapeAttr '(' HEIGHT Int ')'
X	   | _shapeAttr '(' PADTYPE Int ')'
X	   | _shapeAttr '(' LAYER Ident ')'
X	   ;
X
PadShape  : PADSHAPE Str _shapeAttr
X	  ;
X
_padShape :
X	  | _padShape PadShape
X	  ;
X
Shapes	: SHAPES ':' Int
X	;
X
_padAttr   :
X	   | _padAttr '(' HOLEDIAM Int ')'
X	   | _padAttr '(' SURFACE Bool ')'
X	   | _padAttr '(' PLATED Bool ')'
X	   ;
X
PadStack   : PADSTACK Str _padAttr Shapes _padShape ENDPADSTACK
X	   ;
X
_padStacks : 
X	   | _padStacks PadStack
X	   ;
X
PatternSect : PATTERNS ':' Int _patterns
X	;
X
Justify	:  UPPERLEFT
X	|  UPPERCENTER
X	|  UPPERRIGHT
X	|  LEFT
X	|  CENTER
X	|  RIGHT
X	|  LOWERLEFT
X	|  LOWERCENTER
X	|  LOWERRIGHT
X	;
X
_tAttr :
X	  | _tAttr '(' LAYER Ident ')'
X	  | _tAttr '(' ORIGIN Float ',' Float ')'
X	  | _tAttr '(' TEXT Str ')'
X	  | _tAttr '(' ISVISIBLE Bool ')'
X	  | _tAttr '(' JUSTIFY Justify ')'
X	  | _tAttr '(' TEXTSTYLE Str ')'
X	  ;
X
Text	: TEXT _tAttr
X	;
X
_padAttr : _padAttr '(' NUMBER Int ')'
X	 | _padAttr '(' PINNAME Str ')'
X	 | _padAttr '(' PADSTYLE Str ')'
X	 | _padAttr '(' ORIGINALPADSTYLE Str ')'
X	 | _padAttr '(' ORIGIN Float ',' Float ')'
X	 | _padAttr '(' ORIGINALPINNUMBER Int ')'
X	 ;
X
Pad	: PAD _padAttr
X	;
X
_lAttr	:
X	| _lAttr '(' LAYER Ident ')'
X	| _lAttr '(' ORIGIN Float ',' Float ')'
X	| _lAttr '(' WIDTH Int ')'
X	| _lAttr '(' ENDPOINT Float ',' Float ')'
X	;
X
Line	: LINE _lAttr
X	;
X
Point	:  '(' Float ',' Float ')'
X	;
X
_pAttr	:
X	| _pAttr '(' LAYER Ident ')'
X	| _pAttr '(' ORIGIN Float ',' Float ')'
X	| _pAttr '(' PROPERTY Str ')'
X	| _pAttr '(' WIDTH Int ')'
X	| _pAttr Point
X	;
X
Poly	: POLY _pAttr
X	;
X
_aAttr	: 
X	| _aAttr '(' LAYER Ident ')'
X	| _aAttr '(' ORIGIN Float ',' Float ')'
X	| _aAttr '(' ATTR Str Str ')'
X	| _aAttr '(' ISVISIBLE Bool ')'
X	| _aAttr '(' JUSTIFY Justify ')'
X	| _aAttr '(' TEXTSTYLE Str ')'
X	| _aAttr '(' TEXTSTYLEREF Str ')'
X	;
X
Attribute : ATTRIBUTE _aAttr
X	  ;
X
_aProp	:
X	| _aProp '(' LAYER Ident ')'
X	| _aProp '(' ORIGIN Float ',' Float ')'
X	| _aProp '(' RADIUS Float ')'
X	| _aProp '(' STARTANGLE Int ')'
X	| _aProp '(' SWEEPANGLE Int ')'
X	| _aProp '(' WIDTH Int ')'
X	;
X
Arc	: ARC _aProp
X	;
X
_wAttr	: 
X	| _wAttr '(' ORIGIN Float ',' Float ')'
X	| _wAttr '(' VARNAME Str ')'
X	| _wAttr '(' VARDATA Str ')'
X	| _wAttr '(' NUMBER Int ')'
X	| _wAttr COMMENT
X	;
X
Wizard	: WIZARD _wAttr
X	;
X
_pData	:
X	| _pData Text
X	| _pData Pad
X	| _pData Line
X	| _pData Poly
X	| _pData Attribute
X	| _pData Arc
X	| _pData Wizard
X	| _pData COMMENT
X	;
X
pData	:  DATA ':' Int _pData ENDDATA
X	;
X
_pattData :
X	     | _pattData COMMENT
X	     | _pattData ORIGINPOINT '(' Int ',' Int ')'
X	     | _pattData PICKPOINT '(' Int ',' Int ')'
X	     | _pattData GLUEPOINT '(' Int ',' Int ')'
X	     | _pattData pData
X	     ;
X
Pattern	: PATTERN Str _pattData ENDPATTERN
X	;
X
_patterns  :
X	   | _patterns Pattern
X	   ;
X
_pinVis	:
X	| _pinVis '(' TEXTSTYLEREF Str ')'
X	| _pinVis '(' JUSTIFY Justify ')'
X	| _pinVis '(' ISVISIBLE Bool ')'
X	;
X
_pinAttr :
X	| _pinAttr '(' PINNUM Int ')'
X	| _pinAttr '(' ORIGIN Int ',' Int ')'
X	| _pinAttr '(' PINLENGTH Int ')'
X	| _pinAttr '(' ROTATE Int ')'
X	| _pinAttr '(' WIDTH Int ')' 
X	| _pinAttr '(' ISVISIBLE Bool ')'
X	;
X
Pin	: PIN _pinAttr 
X	;
X
PinDes	: PINDES Str '(' Int ',' Int ')' _pinVis
X	;
X
PinName	: PINNAME Str '(' Int ',' Int ')' _pinVis
X	;
X
_sData	:
X	| _sData Pin
X	| _sData PinDes
X	| _sData PinName
X	| _sData Line
X	| _sData Attribute
X	| _sData COMMENT
X	;
X
sData	: DATA ':' Int _sData ENDDATA
X	;
X
_sAttr	:
X	| _sAttr ORIGINPOINT '(' Int ',' Int ')'
X	| _sAttr ORIGINALNAME Str
X	| _sAttr sData
X	;
X
Symbol	: SYMBOL Str _sAttr ENDSYMBOL
X	;
X
SchematicSymbols : SYMBOLS ':' Int Symbol
X	;
X
_cpinAttr :
X	  | _cpinAttr '(' PARTNUM Int ')'
X	  | _cpinAttr '(' SYMPINNUM Int ')'
X	  | _cpinAttr '(' GATEEQ Int ')'
X	  | _cpinAttr '(' PINEQ Int ')'
X	  | _cpinAttr '(' PINTYPE Ident ')'
X	  | _cpinAttr '(' SIDE LEFT ')'
X	  | _cpinAttr '(' SIDE RIGHT ')'
X	  | _cpinAttr '(' GROUP Int ')'
X	  | _cpinAttr COMMENT
X	  ;
X
CompPin   :  COMPPIN Int Str _cpinAttr
X	  ;
X
_CompPins :
X	  | _CompPins CompPin 
X	  ;
X
CompPins : COMPPINS ':' Int _CompPins ENDCOMPPINS
X	;
X
_CompData :
X	  | _CompData Wizard
X	  ;
X
CompData : COMPDATA ':' Int _CompData ENDCOMPDATA
X	 ;
X
_AttSym	: 
X	| _AttSym '(' PARTNUM Int ')'
X	| _AttSym '(' ALTTYPE Ident ')'
X	| _AttSym '(' SYMBOLNAME Str ')'
X	;
X
AttachedSymbol  : ATTACHEDSYMBOL _AttSym 
X		;
X
_AttachedSymbols :
X		 | _AttachedSymbols AttachedSymbol
X		 ;
X
AttachedSymbols : ATTACHEDSYMBOLS ':' Int _AttachedSymbols ENDATTACHEDSYMBOLS
X		;
X
PadNum	: PADNUM Int '(' COMPPINREF Str ')'
X	;
X
_padnums :
X	 | _padnums PadNum
X	 | _padnums COMMENT
X	 ;
X
PinMap	: PINMAP ':' Int _padnums ENDPINMAP
X	;
X
_cAttr :
X	| _cAttr PATTERNNAME Str
X	| _cAttr ORIGINALNAME Str
X	| _cAttr SOURCELIBRARY Str 
X	| _cAttr REFDESPREFIX Str 
X	| _cAttr NUMBEROFPINS Int
X	| _cAttr NUMPARTS Int
X	| _cAttr COMPOSITION Ident
X	| _cAttr ALTIEEE Bool
X	| _cAttr ALTDEMORGAN Bool
X	| _cAttr PATTERNPINS Int
X	| _cAttr REVISION LEVEL
X	| _cAttr REVISION NOTE
X	| _cAttr CompPins 
X	| _cAttr CompData 
X	| _cAttr AttachedSymbols 
X	| _cAttr PinMap 
X	| _cAttr COMMENT 
X	;
X
Component : COMPONENT Str _cAttr ENDCOMPONENT
X	  ;
X
ComponentSect : COMPONENTS ':' Int Component
X	;
X
Corners	: '(' LOWERLEFT Int ',' Int ')' '(' UPPERRIGHT Int ',' Int ')'
X	| '(' LL Int ',' Int ')' '(' UR Int ',' Int ')'
X	;
X
_SchData  :
X	  | _SchData UNITS Str
X	  | _SchData WORKSPACE Corners '(' GRID Int ')'
X	  ;
X
Ident   :  IDENT
X        {if(bug>0)fprintf(Error,"%5d IDENT: '%s'\n", LineNumber, $1->s); 
X	 $1->nxt=NULL;}
X         ;
X
Str     :  STR
X        {if(bug>0)fprintf(Error,"%5d STR: '%s'\n", LineNumber, $1->s); }
X        ;
X
Int     :  INT
X        {sscanf($1->s,"%d",&num); $$=num;  }
X        ;
X
Float	: FLOAT
X	| INT
X	;
X
Bool	: TRUE
X	| FALSE
X	;
X
%%
X 
/*
X *	Parser state variables.
X */
extern char *InFile;			/* file name on the input stream */
static char yytext[IDENT_LENGTH + 1];	/* token buffer */
static char CharBuf[IDENT_LENGTH + 1];	/* garbage buffer */
X
#define HASHSIZE 101
/*
X *	Token definitions:
X *
X *	This associates the '%token' codings with strings which are to
X *	be free standing tokens. Doesn't have to be in sorted order but the
X *	strings must be in lower case.
X */
struct Token {
X  char *Name;			/* token name */
X  int   Code;			/* '%token' value */
X  struct Token *nxt;		/* hash table linkage */
} *htab[HASHSIZE];
X
static struct Token TokenDef[] = {
X  {"layer",		LAYER},
X  {"layerdata",		LAYERDATA},
X  {"layertype",		LAYERTYPE},
X  {"name",       	NAME},
X  {"textstyles",       	TEXTSTYLES},
X  {"textstyle",       	TEXTSTYLE},
X  {"fontwidth",       	FONTWIDTH},
X  {"fontheight",       	FONTHEIGHT},
X  {"fontcharwidth",    	FONTCHARWIDTH},
X  {"padstacks",       	PADSTACKS},
X  {"padstack",       	PADSTACK},
X  {"holediam",       	HOLEDIAM},
X  {"surface",       	SURFACE},
X  {"plated",       	PLATED},
X  {"shapes",       	SHAPES},
X  {"padshape",       	PADSHAPE},
X  {"rectangle",       	RECTANGLE},
X  {"width",       	WIDTH},
X  {"height",       	HEIGHT},
X  {"padtype",       	PADTYPE},
X  {"endpadstack",      	ENDPADSTACK},
X  {"patterns",      	PATTERNS},
X  {"pattern",      	PATTERN},
X  {"originpoint",      	ORIGINPOINT},
X  {"pickpoint",      	PICKPOINT},
X  {"gluepoint",      	GLUEPOINT},
X  {"data",      	DATA},
X  {"text",      	TEXT},
X  {"origin",      	ORIGIN},
X  {"isvisible",      	ISVISIBLE},
X  {"pad",      		PAD},
X  {"number",  		NUMBER},
X  {"pinname",  		PINNAME},
X  {"padstyle", 		PADSTYLE},
X  {"originalpadstyle",  ORIGINALPADSTYLE},
X  {"originalpinnumber", ORIGINALPINNUMBER},
X  {"line", 		LINE},
X  {"endpoint", 		ENDPOINT},
X  {"poly", 		POLY},
X  {"property", 		PROPERTY},
X  {"attribute", 	ATTRIBUTE},
X  {"attr", 		ATTR},
X  {"arc", 		ARC},
X  {"radius", 		RADIUS},
X  {"startangle", 	STARTANGLE},
X  {"sweepangle", 	SWEEPANGLE},
X  {"wizard", 		WIZARD},
X  {"varname", 		VARNAME},
X  {"vardata", 		VARDATA},
X  {"enddata", 		ENDDATA},
X  {"endpattern", 	ENDPATTERN},
X  {"symbols", 		SYMBOLS},
X  {"symbol", 		SYMBOL},
X  {"originalname", 	ORIGINALNAME},
X  {"pin", 		PIN},
X  {"pinnum", 		PINNUM},
X  {"pinlength",		PINLENGTH},
X  {"rotate",		ROTATE},
X  {"pindes", 		PINDES},
X  {"pinname", 		PINNAME},
X  {"textstyleref", 	TEXTSTYLEREF},
X  {"endsymbol", 	ENDSYMBOL},
X  {"components", 	COMPONENTS},
X  {"component", 	COMPONENT},
X  {"patternname", 	PATTERNNAME},
X  {"sourcelibrary", 	SOURCELIBRARY},
X  {"refdesprefix", 	REFDESPREFIX},
X  {"numberofpins", 	NUMBEROFPINS},
X  {"numparts", 		NUMPARTS},
X  {"composition", 	COMPOSITION},
X  {"altieee", 		ALTIEEE},
X  {"altdemorgan", 	ALTDEMORGAN},
X  {"patternpins", 	PATTERNPINS},
X  {"revision", 		REVISION},
X  {"level", 		LEVEL},
X  {"note", 		NOTE},
X
X  {"comppins", 		COMPPINS},
X  {"comppin", 		COMPPIN},
X  {"partnum", 		PARTNUM},
X  {"sympinnum", 	SYMPINNUM},
X  {"gateeq", 		GATEEQ},
X  {"pineq", 		PINEQ},
X  {"pintype", 		PINTYPE},
X  {"side", 		SIDE},
X  {"group", 		GROUP},
X  {"endcomppins", 	ENDCOMPPINS},
X  {"compdata", 		COMPDATA},
X  {"endcompdata", 	ENDCOMPDATA},
X  {"attachedsymbols", 	ATTACHEDSYMBOLS},
X  {"attachedsymbol", 	ATTACHEDSYMBOL},
X  {"alttype", 		ALTTYPE},
X  {"symbolname", 	SYMBOLNAME},
X  {"endattachedsymbols",ENDATTACHEDSYMBOLS},
X  {"pinmap", 		PINMAP},
X  {"padnum", 		PADNUM},
X  {"comppinref", 	COMPPINREF},
X  {"endpinmap",		ENDPINMAP},
X  {"endcomponent", 	ENDCOMPONENT},
X  {"workspacesize", 	WORKSPACESIZE},
X  {"componentinstances",COMPONENTINSTANCES},
X  {"viainstances",	VIAINSTANCES},
X  {"nets",		NETS},
X  {"schematicdata",  	SCHEMATICDATA},
X  {"units",		UNITS},
X  {"workspace",		WORKSPACE},
X  {"grid",		GRID},
X  {"sheets",		SHEETS},
X  {"layers",		LAYERS},
X  {"layertechnicaldata",LAYERTECHNICALDATA},
X
X  {"true",       	TRUE},
X  {"false",       	FALSE},
X
X  {"justify",      	JUSTIFY},
X  {"upperleft",       	UPPERLEFT},
X  {"uppercenter",     	UPPERCENTER}, 
X  {"upperright",      	UPPERRIGHT}, 
X  {"ur",      		UR}, 
X  {"left",            	LEFT}, 
X  {"center",          	CENTER}, 
X  {"right",           	RIGHT}, 
X  {"lowerleft",         LOWERLEFT}, 
X  {"ll",         	LL}, 
X  {"lowercenter",       LOWERCENTER},
X  {"lowerright",	LOWERRIGHT}
};
static int TokenDefSize = sizeof(TokenDef) / sizeof(struct Token);
X
/*
X *	Find keyword:
X *
X *	  The passed string is located within the keyword table. If an
X *	entry exists, then the value of the keyword string is returned. This
X *	is real useful for doing string comparisons by pointer value later.
X *	If there is no match, a NULL is returned.
X */
static int FindKeyword(str)
char *str;
{
X  register unsigned int hsh;
X  register char *cp;
X  char lower[IDENT_LENGTH + 1];
X  /*
X   *	Create a lower case copy of the string.
X   */
X  for (cp = lower; *str;)
X    if (isupper(*str))
X      *cp++ = tolower(*str++);
X    else
X      *cp++ = *str++;
X  *cp = '\0';
X  /*
X   *	Search the hash table for a match.
X   */
X  return lkup(lower);
}
X
/*
X *	yyerror:
X *
X *	  Standard error reporter, it prints out the passed string
X *	preceeded by the current filename and line number.
X */
yyerror(ers)
char *ers;
{
X  fprintf(Error,"%s, Line %d: %s\n", InFile, LineNumber, ers);
}
X
/*
X *	String bucket definitions.
X */
#define	BUCKET_SIZE	64
typedef struct Bucket {
X  struct Bucket *Next;			/* pointer to next bucket */
X  int 		Index;			/* pointer to next free slot */
X  char 		Data[BUCKET_SIZE];	/* string data */
} Bucket;
static Bucket *CurrentBucket = NULL;	/* string bucket list */
X
int StringSize = 0;		/* current string length */
/*
X *	Push string:
X *
X *	  This adds the passed charater to the current string bucket.
X */
static PushString(chr)
char chr;
{
X  register Bucket *bck;
X  /*
X   *	Make sure there is room for the push.
X   */
X  if ((bck = CurrentBucket)->Index >= BUCKET_SIZE){
X    bck = (Bucket *) Malloc(sizeof(Bucket));
X    bck->Next = CurrentBucket;
X    (CurrentBucket = bck)->Index = 0;
X  }
X  /*
X   *	Push the character.
X   */
X  bck->Data[bck->Index++] = chr;
X  StringSize++;
}
/*
X *	Form string:
X *
X *	  This converts the current string bucket into a real live string,
X *	whose pointer is returned.
X */
char *FormString()
{
X  register Bucket *bck;
X  register char *cp;
X  /*
X   *	Allocate space for the string, set the pointer at the end.
X   */
X  cp = (char *) Malloc(StringSize + 1);
X  cp += StringSize;
X  *cp-- = '\0';
X  /*
X   *	Yank characters out of the bucket.
X   */
X  for (bck = CurrentBucket; bck->Index || (bck->Next !=NULL) ;){
X    if (!bck->Index){
X      CurrentBucket = bck->Next;
X      Free(bck);
X      bck = CurrentBucket;
X    }
X    *cp-- = bck->Data[--bck->Index];
X  }
X  // fprintf(stderr,"FormStr:'%s'\n",cp+1);
X  StringSize = 0;
X  return (cp + 1);
}
X
/*
X * empty the hash table before using it...
X *
X */
clrhash()
{
X  int i;
X  for (i=0; i<HASHSIZE; i++) htab[i] = NULL;
}
X
/*
X * compute the value of the hash for a symbol
X *
X */
hash(name)
char *name;
{
X  int sum;
X
X  for (sum = 0; *name != '\0'; name++) sum += (sum + *name);
X  sum %= HASHSIZE;                      /* take sum mod hashsize */
X  if (sum < 0) sum += HASHSIZE;         /* disallow negative hash value */
X  return(sum);
}
X
/*
X * make a private copy of a string...
X *
X */
char *
copy(s)
char *s;
{
X  char *new;
X
X  new = (char *) malloc(strlen(s) + 1);
X  strcpy(new,s);
X  return(new);
}
X
/*
X * find name in the symbol table, return its value.  Returns -1
X * if not found.
X *
X */
lkup(name)
char *name;
{
X  struct Token *cur;
X
X  for (cur = htab[hash(name)]; cur != NULL; cur = cur->nxt)
X        if (strcmp(cur->Name, name) == 0) return(cur->Code);
X  return(-1);
}
X
/*
X *	Parse XLR:
X *
X *	  This builds the context tree and then calls the real parser.
X *	It is passed two file streams, the first is where the input comes
X *	from; the second is where error messages get printed.
X */
ParseXLR(inp,err)
FILE *inp,*err;
{
X  register int i;
X  /*
X   *	Set up the file state to something useful.
X   */
X  Input = inp;
X  Error = err;
X  LineNumber = 1;
X
X  clrhash();
X  /*
X   *	Define the tokens.
X   */
X  for (i = TokenDefSize; i--; ){
X      register unsigned int h;
X      struct Token *cur;
X
X      h = hash(TokenDef[i].Name);
X      cur = (struct Token *)malloc(sizeof (struct Token));
X      cur->Name = copy(TokenDef[i].Name);
X      cur->Code = TokenDef[i].Code;
X      cur->nxt = htab[h];
X      htab[h] = cur;
X  }
X  /*
X   *	Create an initial, empty string bucket.
X   */
X  CurrentBucket = (Bucket *) Malloc(sizeof(Bucket));
X  CurrentBucket->Next = NULL;
X  CurrentBucket->Index = 0;
X  /*
X   *	Go parse things!
X   */
X  yyparse();
X
X  // DumpStack();
}
X
/*
X *	PopC:
X *
X *	  This pops the current context.
X */
PopC()
{
}
X
/*
X *	Lexical analyzer states.
X */
#define	L_START		0
#define	L_INT		1
#define	L_IDENT		2
#define	L_KEYWORD	3
#define	L_STRING	4
#define	L_KEYWORD2	5
#define	L_ASCIICHAR	6
#define	L_ASCIICHAR2	7
#define	L_FLOAT 	8
#define	L_COMMENT 	9
/*
X *	yylex:
X *
X *	  This is the lexical analyzer called by the YACC/BISON parser.
X *	It returns a pretty restricted set of token types and does the
X *	context movement when acceptable keywords are found. The token
X *	value returned is a NULL terminated string to allocated storage
X *	(ie - it should get released some time) with some restrictions.
X *	  The token value for integers is strips a leading '+' if present.
X *	String token values have the leading and trailing '"'-s stripped.
X *	'%' conversion characters in string values are passed converted.
X *	The '(' and ')' characters do not have a token value.
X */
int yylex()
{
X  extern YYSTYPE yylval;
X  struct st  *st;
X  register int c,s,l,len;
X  /*
X   *	Keep on sucking up characters until we find something which
X   *	explicitly forces us out of this function.
X   */
X  for (s = L_START, l = 0; 1; ){
X    yytext[l++] = c = Getc(Input);
X    if (c == '\n' && s==L_START){
X       LineNumber++ ;
X    }
X    switch (s){
X      case L_COMMENT:
X	if( c == '\n' || c == EOF){
X	   s = L_START;
X       	   LineNumber++ ;
X	   return COMMENT;
X        }
X	break;
X      case L_START:
X	if( c == '#' )
X	  s = L_COMMENT;
X        else if (isdigit(c) || c == '-')
X          s = L_INT;
X        else if (isalpha(c) )
X          s = L_KEYWORD;
X        else if (isspace(c)){
X          l = 0;
X        } else if (c == '(' || c == ')'){
X          l = 0;
X          return (c);
X        } else if (c == '"')
X          s = L_STRING;
X        else if (c == '+'){
X          l = 0;				/* strip '+' */
X          s = L_INT;
X        } else if (c == EOF)
X          return ('\0');
X        else {
X          yytext[1] = '\0';
X          // Stack(yytext, c);
X          return (c);
X        }
X        break;
X      /*
X       *	Suck up the integer digits.
X       */
X      case L_INT:
X        if (isdigit(c))
X          break;
X	if( c == '.' ) {
X	   s = L_FLOAT;
X	   break;
X	}
X        Ungetc(c);
X        yytext[--l] = '\0';
X	st = (struct st *)Malloc(sizeof (struct st));
X        st->s = strdup(yytext); 
X	yylval.st = st ;
X        // Stack(yytext, INT);
X        return (INT);
X      /*
X       *	Suck up the integer digits.
X       */
X      case L_FLOAT:
X        if (isdigit(c))
X          break;
X        Ungetc(c);
X        yytext[--l] = '\0';
X	st = (struct st *)Malloc(sizeof (struct st));
X        st->s = strdup(yytext); 
X	yylval.st = st ;
X        // Stack(yytext, FLOAT);
X        return (FLOAT);
X      /*
X       *	Scan until you find the start of an identifier, discard
X       *	any whitespace found. On no identifier, return a '('.
X       */
X      case L_KEYWORD:
X        if (isalpha(c)){
X          s = L_KEYWORD2;
X          break;
X        } else if (isspace(c)){
X          l = 0;
X          break;
X        }
X        Ungetc(c);
X        // Stack("(",'(');
X        return ('(');
X      /*
X       *	Suck up the keyword identifier, if it matches the set of
X       *	allowable contexts then return its token value and push
X       *	the context, otherwise just return the identifier string.
X       */
X      case L_KEYWORD2:
X        if (isalpha(c) || isdigit(c) || c == '_' || c=='-')
X          break;
X        Ungetc(c);
X        yytext[--l] = '\0';
X        if ( (c = FindKeyword(yytext)) >0 ){
X          // Stack(yytext, c);
X          return (c);
X        }
X	st = (struct st *)Malloc(sizeof (struct st));
X        st->s = strdup(yytext); 
X	yylval.st = st ;
X        // Stack(yytext, KEYWORD);
X        return (IDENT);
X      /*
X       *	Suck up string characters but once resolved they should
X       *	be deposited in the string bucket because they can be
X       *	arbitrarily long.
X       */
X      case L_STRING:
X        if (c == '\r' || c == '\n')
X          ;
X        else if (c == '"' || c == EOF){
X	  st = (struct st *)Malloc(sizeof (struct st));
X          st->s = FormString();  
X          // st->s = strdup(yytext); 
X	  yylval.st = st ; 
X          // Stack(yytext, STR);
X          return (STR);
X        } else  if (c == '%'){
X          s = L_ASCIICHAR;
X        } else  if (c == ' ')
X	  PushString('_');
X        else
X          PushString(c);
X        l = 0;
X        break;
X      /*
X       *	Skip white space and look for integers to be pushed
X       *	as characters.
X       */
X      case L_ASCIICHAR:
X        if (isdigit(c)){
X          s = L_ASCIICHAR2;
X          break;
X        } else if (c == '%' || c == EOF)
X          s = L_STRING;
X        l = 0;
X        break;
X      /*
X       *	Convert the accumulated integer into a char and push.
X       */
X      case L_ASCIICHAR2:
X        if (isdigit(c))
X          break;
X        Ungetc(c);
X        yytext[--l] = '\0';
X        PushString(yytext);
X        s = L_ASCIICHAR;
X        l = 0;
X        break;
X    }
X  }
}
SHAR_EOF
  (set 20 08 04 18 17 43 42 'xlr.y'
   eval "${shar_touch}") && \
  chmod 0644 'xlr.y'
if test $? -ne 0
then ${echo} "restore of xlr.y failed"
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'xlr.y': 'MD5 check failed'
       ) << \SHAR_EOF
db222ecf97a557c937caae6291d2c301  xlr.y
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'xlr.y'` -ne 22834 && \
  ${echo} "restoration warning:  size of 'xlr.y' is not 22834"
  fi
fi
if rm -fr ${lock_dir}
then ${echo} "x - removed lock directory ${lock_dir}."
else ${echo} "x - failed to remove lock directory ${lock_dir}."
     exit 1
fi
exit 0
