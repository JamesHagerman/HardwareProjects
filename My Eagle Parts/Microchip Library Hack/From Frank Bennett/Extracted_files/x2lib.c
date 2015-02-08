/*
 * xlr2lib - XLR to KiCad library
 */
#define global

#include <stdio.h>
#include <string.h>

int bug=0;  		// debug level: 

char *InFile = "-";

char  FileNameNet[64], FileNameLib[64], FileNameEESchema[64], FileNameKiPro[64];
FILE *FileEdf, *FileNet, *FileEESchema=NULL, *FileLib=NULL, *FileKiPro=NULL;

main(int argc, char *argv[])
{
  char * version      = "0.97";
  char * progname;

  progname = strrchr(argv[0],'/');
  if (progname)
    progname++;
  else
    progname = argv[0];

  fprintf(stderr,"*** %s Version %s ***\n", progname, version);

  if( argc != 2 ) {
     fprintf(stderr, " usage: XLRfile \n") ; return(1);
  }

  InFile= argv[1];
  if( (FileEdf = fopen( InFile, "r" )) == NULL ) {
       fprintf(stderr, " '%s' doesn't exist\n", InFile);
       return(-1);
  }

  fprintf(stderr, "Parsing %s \n", InFile);
  ParseXLR(FileEdf, stderr);

  fprintf(stderr, "Writting Lib \n");

  fprintf(stderr, "BonJour!\n");
  return(0);
}

