%{
/************************************************************************
 *                                                                      *
 *                           XLR.y                                      *
 *                                                                      *
 ************************************************************************/
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "xlr.h"

// #define DEBUG 1
int          yydebug=0;
static FILE *Input = NULL;              /* input stream */
static FILE *Error = NULL;              /* error stream */
static int   LineNumber;                /* current input line number */

int		num;

%}

%union    {
            int n;
            float f;
            struct st   *st;
            struct pt   *pt;
            struct plst *pl;
          }

%type   <n>     Int

%token  <st>    IDENT
%token  <st>    KEYWORD
%token  <st>    STR
%token  <st>    INT
%token          COMMENT
%token  	FLOAT
%token  <pt>	POINT

%token  	LAYERDATA LAYERS LAYER NAME LAYERTYPE
%token  	TEXTSTYLES TEXTSTYLE TEXTSTYLEREF
%token  	FONTWIDTH FONTHEIGHT FONTCHARWIDTH
%token  	PADSTACKS PADSTACK HOLEDIAM SURFACE PLATED SHAPES

%token  	PADSHAPE  RECTANGLE  CIRCLE  OBLONG  ROUNDEDRECTANGLE DIAMOND  
%token  	ROUNDEDDIAMOND  THERMAL  THERMALX POLYGON

%token  	WIDTH HEIGHT
%token  	PADTYPE ENDPADSTACK ENDPATTERN
%token  	PATTERNS PATTERN ORIGINPOINT GLUEPOINT DATA ORIGIN ISVISIBLE
%token  	TRUE FALSE
%token  	JUSTIFY ORIENTATION
%token  	PAD NUMBER PINNAME PADSTYLE ORIGINALPADSTYLE ORIGINALPINNUMBER ENDPOINT

%token  	LINE ARC ATTRIBUTE PICKPOINT POLY PROPERTY
%token  	POLYKEEPOUT POLYKEEPOUT_VIA POLYKEEPOUT_COMP POLYKEEPIN_COMP
%token  	TEXT WIZARD

%token  	ATTR
%token  	RADIUS STARTANGLE SWEEPANGLE

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

%token  	UPPERLEFT UPPERCENTER UPPERRIGHT LEFT CENTER RIGHT 
%token  	LOWERLEFT LOWERCENTER LOWERRIGHT LL UR

%token  	R0 R180 R270 R90 MX MXR90 MY MYR90

%start xlr

%%

xlr	:
	| xlr COMMENT
	| xlr LayerSect
	| xlr TextStyleSect
	| xlr PadStackSect
	| xlr PatternSect
	| xlr SchematicSymbols
	| xlr ComponentSect
	| xlr WORKSPACESIZE Corners
	| xlr COMPONENTINSTANCES ':' Int 
	| xlr VIAINSTANCES ':' Int 
	| xlr NETS ':' Int 
	| xlr SCHEMATICDATA ':' _SchData
	| xlr SHEETS ':' Int 
	| xlr LAYERS ':' Int 
	| xlr LAYERTECHNICALDATA ':' Int 
	;

LayerSect : LAYERDATA ':' Int _layer
	;

LayerType : LAYERTYPE
	  | LAYERTYPE Ident
	  ;

Layer	: LAYER ':' Int NAME Ident LayerType
	;

_layer 	:  
	| _layer Layer 
	;

TextStyleSect : TEXTSTYLES ':' Int _textstyle
	;

_textSize  : 
	   | _textSize '(' FONTWIDTH Int ')'
	   | _textSize '(' FONTHEIGHT Int ')'
	   | _textSize '(' FONTCHARWIDTH Int ')'
	   ;

TextStyle  : TEXTSTYLE Str _textSize
	   ;

_textstyle : 
	   | _textstyle TextStyle 
	   ;

PadStackSect : PADSTACKS ':' Int _padStacks
	;

_shapeAttr :
	   | _shapeAttr '(' WIDTH Int ')'
	   | _shapeAttr '(' HEIGHT Int ')'
	   | _shapeAttr '(' PADTYPE Int ')'
	   | _shapeAttr '(' LAYER Ident ')'
	   ;

PadShape  : PADSHAPE Str _shapeAttr
	  ;

_padShape :
	  | _padShape PadShape
	  ;

Shapes	: SHAPES ':' Int
	;

_padAttr   :
	   | _padAttr '(' HOLEDIAM Int ')'
	   | _padAttr '(' SURFACE Bool ')'
	   | _padAttr '(' PLATED Bool ')'
	   ;

PadStack   : PADSTACK Str _padAttr Shapes _padShape ENDPADSTACK
	   ;

_padStacks : 
	   | _padStacks PadStack
	   ;

PatternSect : PATTERNS ':' Int _patterns
	;

Justify	:  UPPERLEFT
	|  UPPERCENTER
	|  UPPERRIGHT
	|  LEFT
	|  CENTER
	|  RIGHT
	|  LOWERLEFT
	|  LOWERCENTER
	|  LOWERRIGHT
	;

_tAttr :
	  | _tAttr '(' LAYER Ident ')'
	  | _tAttr '(' ORIGIN Float ',' Float ')'
	  | _tAttr '(' TEXT Str ')'
	  | _tAttr '(' ISVISIBLE Bool ')'
	  | _tAttr '(' JUSTIFY Justify ')'
	  | _tAttr '(' TEXTSTYLE Str ')'
	  ;

Text	: TEXT _tAttr
	;

_padAttr : _padAttr '(' NUMBER Int ')'
	 | _padAttr '(' PINNAME Str ')'
	 | _padAttr '(' PADSTYLE Str ')'
	 | _padAttr '(' ORIGINALPADSTYLE Str ')'
	 | _padAttr '(' ORIGIN Float ',' Float ')'
	 | _padAttr '(' ORIGINALPINNUMBER Int ')'
	 ;

Pad	: PAD _padAttr
	;

_lAttr	:
	| _lAttr '(' LAYER Ident ')'
	| _lAttr '(' ORIGIN Float ',' Float ')'
	| _lAttr '(' WIDTH Int ')'
	| _lAttr '(' ENDPOINT Float ',' Float ')'
	;

Line	: LINE _lAttr
	;

Point	:  '(' Float ',' Float ')'
	;

_pAttr	:
	| _pAttr '(' LAYER Ident ')'
	| _pAttr '(' ORIGIN Float ',' Float ')'
	| _pAttr '(' PROPERTY Str ')'
	| _pAttr '(' WIDTH Int ')'
	| _pAttr Point
	;

Poly	: POLY _pAttr
	;

_aAttr	: 
	| _aAttr '(' LAYER Ident ')'
	| _aAttr '(' ORIGIN Float ',' Float ')'
	| _aAttr '(' ATTR Str Str ')'
	| _aAttr '(' ISVISIBLE Bool ')'
	| _aAttr '(' JUSTIFY Justify ')'
	| _aAttr '(' TEXTSTYLE Str ')'
	| _aAttr '(' TEXTSTYLEREF Str ')'
	;

Attribute : ATTRIBUTE _aAttr
	  ;

_aProp	:
	| _aProp '(' LAYER Ident ')'
	| _aProp '(' ORIGIN Float ',' Float ')'
	| _aProp '(' RADIUS Float ')'
	| _aProp '(' STARTANGLE Int ')'
	| _aProp '(' SWEEPANGLE Int ')'
	| _aProp '(' WIDTH Int ')'
	;

Arc	: ARC _aProp
	;

_wAttr	: 
	| _wAttr '(' ORIGIN Float ',' Float ')'
	| _wAttr '(' VARNAME Str ')'
	| _wAttr '(' VARDATA Str ')'
	| _wAttr '(' NUMBER Int ')'
	| _wAttr COMMENT
	;

Wizard	: WIZARD _wAttr
	;

_pData	:
	| _pData Text
	| _pData Pad
	| _pData Line
	| _pData Poly
	| _pData Attribute
	| _pData Arc
	| _pData Wizard
	| _pData COMMENT
	;

pData	:  DATA ':' Int _pData ENDDATA
	;

_pattData :
	     | _pattData COMMENT
	     | _pattData ORIGINPOINT '(' Int ',' Int ')'
	     | _pattData PICKPOINT '(' Int ',' Int ')'
	     | _pattData GLUEPOINT '(' Int ',' Int ')'
	     | _pattData pData
	     ;

Pattern	: PATTERN Str _pattData ENDPATTERN
	;

_patterns  :
	   | _patterns Pattern
	   ;

_pinVis	:
	| _pinVis '(' TEXTSTYLEREF Str ')'
	| _pinVis '(' JUSTIFY Justify ')'
	| _pinVis '(' ISVISIBLE Bool ')'
	;

_pinAttr :
	| _pinAttr '(' PINNUM Int ')'
	| _pinAttr '(' ORIGIN Int ',' Int ')'
	| _pinAttr '(' PINLENGTH Int ')'
	| _pinAttr '(' ROTATE Int ')'
	| _pinAttr '(' WIDTH Int ')' 
	| _pinAttr '(' ISVISIBLE Bool ')'
	;

Pin	: PIN _pinAttr 
	;

PinDes	: PINDES Str '(' Int ',' Int ')' _pinVis
	;

PinName	: PINNAME Str '(' Int ',' Int ')' _pinVis
	;

_sData	:
	| _sData Pin
	| _sData PinDes
	| _sData PinName
	| _sData Line
	| _sData Attribute
	| _sData COMMENT
	;

sData	: DATA ':' Int _sData ENDDATA
	;

_sAttr	:
	| _sAttr ORIGINPOINT '(' Int ',' Int ')'
	| _sAttr ORIGINALNAME Str
	| _sAttr sData
	;

Symbol	: SYMBOL Str _sAttr ENDSYMBOL
	;

SchematicSymbols : SYMBOLS ':' Int Symbol
	;

_cpinAttr :
	  | _cpinAttr '(' PARTNUM Int ')'
	  | _cpinAttr '(' SYMPINNUM Int ')'
	  | _cpinAttr '(' GATEEQ Int ')'
	  | _cpinAttr '(' PINEQ Int ')'
	  | _cpinAttr '(' PINTYPE Ident ')'
	  | _cpinAttr '(' SIDE LEFT ')'
	  | _cpinAttr '(' SIDE RIGHT ')'
	  | _cpinAttr '(' GROUP Int ')'
	  | _cpinAttr COMMENT
	  ;

CompPin   :  COMPPIN Int Str _cpinAttr
	  ;

_CompPins :
	  | _CompPins CompPin 
	  ;

CompPins : COMPPINS ':' Int _CompPins ENDCOMPPINS
	;

_CompData :
	  | _CompData Wizard
	  ;

CompData : COMPDATA ':' Int _CompData ENDCOMPDATA
	 ;

_AttSym	: 
	| _AttSym '(' PARTNUM Int ')'
	| _AttSym '(' ALTTYPE Ident ')'
	| _AttSym '(' SYMBOLNAME Str ')'
	;

AttachedSymbol  : ATTACHEDSYMBOL _AttSym 
		;

_AttachedSymbols :
		 | _AttachedSymbols AttachedSymbol
		 ;

AttachedSymbols : ATTACHEDSYMBOLS ':' Int _AttachedSymbols ENDATTACHEDSYMBOLS
		;

PadNum	: PADNUM Int '(' COMPPINREF Str ')'
	;

_padnums :
	 | _padnums PadNum
	 | _padnums COMMENT
	 ;

PinMap	: PINMAP ':' Int _padnums ENDPINMAP
	;

_cAttr :
	| _cAttr PATTERNNAME Str
	| _cAttr ORIGINALNAME Str
	| _cAttr SOURCELIBRARY Str 
	| _cAttr REFDESPREFIX Str 
	| _cAttr NUMBEROFPINS Int
	| _cAttr NUMPARTS Int
	| _cAttr COMPOSITION Ident
	| _cAttr ALTIEEE Bool
	| _cAttr ALTDEMORGAN Bool
	| _cAttr PATTERNPINS Int
	| _cAttr REVISION LEVEL
	| _cAttr REVISION NOTE
	| _cAttr CompPins 
	| _cAttr CompData 
	| _cAttr AttachedSymbols 
	| _cAttr PinMap 
	| _cAttr COMMENT 
	;

Component : COMPONENT Str _cAttr ENDCOMPONENT
	  ;

ComponentSect : COMPONENTS ':' Int Component
	;

Corners	: '(' LOWERLEFT Int ',' Int ')' '(' UPPERRIGHT Int ',' Int ')'
	| '(' LL Int ',' Int ')' '(' UR Int ',' Int ')'
	;

_SchData  :
	  | _SchData UNITS Str
	  | _SchData WORKSPACE Corners '(' GRID Int ')'
	  ;

Ident   :  IDENT
        {if(bug>0)fprintf(Error,"%5d IDENT: '%s'\n", LineNumber, $1->s); 
	 $1->nxt=NULL;}
         ;

Str     :  STR
        {if(bug>0)fprintf(Error,"%5d STR: '%s'\n", LineNumber, $1->s); }
        ;

Int     :  INT
        {sscanf($1->s,"%d",&num); $$=num;  }
        ;

Float	: FLOAT
	| INT
	;

Bool	: TRUE
	| FALSE
	;

%%
 
/*
 *	Parser state variables.
 */
extern char *InFile;			/* file name on the input stream */
static char yytext[IDENT_LENGTH + 1];	/* token buffer */
static char CharBuf[IDENT_LENGTH + 1];	/* garbage buffer */

#define HASHSIZE 101
/*
 *	Token definitions:
 *
 *	This associates the '%token' codings with strings which are to
 *	be free standing tokens. Doesn't have to be in sorted order but the
 *	strings must be in lower case.
 */
struct Token {
  char *Name;			/* token name */
  int   Code;			/* '%token' value */
  struct Token *nxt;		/* hash table linkage */
} *htab[HASHSIZE];

static struct Token TokenDef[] = {
  {"layer",		LAYER},
  {"layerdata",		LAYERDATA},
  {"layertype",		LAYERTYPE},
  {"name",       	NAME},
  {"textstyles",       	TEXTSTYLES},
  {"textstyle",       	TEXTSTYLE},
  {"fontwidth",       	FONTWIDTH},
  {"fontheight",       	FONTHEIGHT},
  {"fontcharwidth",    	FONTCHARWIDTH},
  {"padstacks",       	PADSTACKS},
  {"padstack",       	PADSTACK},
  {"holediam",       	HOLEDIAM},
  {"surface",       	SURFACE},
  {"plated",       	PLATED},
  {"shapes",       	SHAPES},
  {"padshape",       	PADSHAPE},
  {"rectangle",       	RECTANGLE},
  {"width",       	WIDTH},
  {"height",       	HEIGHT},
  {"padtype",       	PADTYPE},
  {"endpadstack",      	ENDPADSTACK},
  {"patterns",      	PATTERNS},
  {"pattern",      	PATTERN},
  {"originpoint",      	ORIGINPOINT},
  {"pickpoint",      	PICKPOINT},
  {"gluepoint",      	GLUEPOINT},
  {"data",      	DATA},
  {"text",      	TEXT},
  {"origin",      	ORIGIN},
  {"isvisible",      	ISVISIBLE},
  {"pad",      		PAD},
  {"number",  		NUMBER},
  {"pinname",  		PINNAME},
  {"padstyle", 		PADSTYLE},
  {"originalpadstyle",  ORIGINALPADSTYLE},
  {"originalpinnumber", ORIGINALPINNUMBER},
  {"line", 		LINE},
  {"endpoint", 		ENDPOINT},
  {"poly", 		POLY},
  {"property", 		PROPERTY},
  {"attribute", 	ATTRIBUTE},
  {"attr", 		ATTR},
  {"arc", 		ARC},
  {"radius", 		RADIUS},
  {"startangle", 	STARTANGLE},
  {"sweepangle", 	SWEEPANGLE},
  {"wizard", 		WIZARD},
  {"varname", 		VARNAME},
  {"vardata", 		VARDATA},
  {"enddata", 		ENDDATA},
  {"endpattern", 	ENDPATTERN},
  {"symbols", 		SYMBOLS},
  {"symbol", 		SYMBOL},
  {"originalname", 	ORIGINALNAME},
  {"pin", 		PIN},
  {"pinnum", 		PINNUM},
  {"pinlength",		PINLENGTH},
  {"rotate",		ROTATE},
  {"pindes", 		PINDES},
  {"pinname", 		PINNAME},
  {"textstyleref", 	TEXTSTYLEREF},
  {"endsymbol", 	ENDSYMBOL},
  {"components", 	COMPONENTS},
  {"component", 	COMPONENT},
  {"patternname", 	PATTERNNAME},
  {"sourcelibrary", 	SOURCELIBRARY},
  {"refdesprefix", 	REFDESPREFIX},
  {"numberofpins", 	NUMBEROFPINS},
  {"numparts", 		NUMPARTS},
  {"composition", 	COMPOSITION},
  {"altieee", 		ALTIEEE},
  {"altdemorgan", 	ALTDEMORGAN},
  {"patternpins", 	PATTERNPINS},
  {"revision", 		REVISION},
  {"level", 		LEVEL},
  {"note", 		NOTE},

  {"comppins", 		COMPPINS},
  {"comppin", 		COMPPIN},
  {"partnum", 		PARTNUM},
  {"sympinnum", 	SYMPINNUM},
  {"gateeq", 		GATEEQ},
  {"pineq", 		PINEQ},
  {"pintype", 		PINTYPE},
  {"side", 		SIDE},
  {"group", 		GROUP},
  {"endcomppins", 	ENDCOMPPINS},
  {"compdata", 		COMPDATA},
  {"endcompdata", 	ENDCOMPDATA},
  {"attachedsymbols", 	ATTACHEDSYMBOLS},
  {"attachedsymbol", 	ATTACHEDSYMBOL},
  {"alttype", 		ALTTYPE},
  {"symbolname", 	SYMBOLNAME},
  {"endattachedsymbols",ENDATTACHEDSYMBOLS},
  {"pinmap", 		PINMAP},
  {"padnum", 		PADNUM},
  {"comppinref", 	COMPPINREF},
  {"endpinmap",		ENDPINMAP},
  {"endcomponent", 	ENDCOMPONENT},
  {"workspacesize", 	WORKSPACESIZE},
  {"componentinstances",COMPONENTINSTANCES},
  {"viainstances",	VIAINSTANCES},
  {"nets",		NETS},
  {"schematicdata",  	SCHEMATICDATA},
  {"units",		UNITS},
  {"workspace",		WORKSPACE},
  {"grid",		GRID},
  {"sheets",		SHEETS},
  {"layers",		LAYERS},
  {"layertechnicaldata",LAYERTECHNICALDATA},

  {"true",       	TRUE},
  {"false",       	FALSE},

  {"justify",      	JUSTIFY},
  {"upperleft",       	UPPERLEFT},
  {"uppercenter",     	UPPERCENTER}, 
  {"upperright",      	UPPERRIGHT}, 
  {"ur",      		UR}, 
  {"left",            	LEFT}, 
  {"center",          	CENTER}, 
  {"right",           	RIGHT}, 
  {"lowerleft",         LOWERLEFT}, 
  {"ll",         	LL}, 
  {"lowercenter",       LOWERCENTER},
  {"lowerright",	LOWERRIGHT}
};
static int TokenDefSize = sizeof(TokenDef) / sizeof(struct Token);

/*
 *	Find keyword:
 *
 *	  The passed string is located within the keyword table. If an
 *	entry exists, then the value of the keyword string is returned. This
 *	is real useful for doing string comparisons by pointer value later.
 *	If there is no match, a NULL is returned.
 */
static int FindKeyword(str)
char *str;
{
  register unsigned int hsh;
  register char *cp;
  char lower[IDENT_LENGTH + 1];
  /*
   *	Create a lower case copy of the string.
   */
  for (cp = lower; *str;)
    if (isupper(*str))
      *cp++ = tolower(*str++);
    else
      *cp++ = *str++;
  *cp = '\0';
  /*
   *	Search the hash table for a match.
   */
  return lkup(lower);
}

/*
 *	yyerror:
 *
 *	  Standard error reporter, it prints out the passed string
 *	preceeded by the current filename and line number.
 */
yyerror(ers)
char *ers;
{
  fprintf(Error,"%s, Line %d: %s\n", InFile, LineNumber, ers);
}

/*
 *	String bucket definitions.
 */
#define	BUCKET_SIZE	64
typedef struct Bucket {
  struct Bucket *Next;			/* pointer to next bucket */
  int 		Index;			/* pointer to next free slot */
  char 		Data[BUCKET_SIZE];	/* string data */
} Bucket;
static Bucket *CurrentBucket = NULL;	/* string bucket list */

int StringSize = 0;		/* current string length */
/*
 *	Push string:
 *
 *	  This adds the passed charater to the current string bucket.
 */
static PushString(chr)
char chr;
{
  register Bucket *bck;
  /*
   *	Make sure there is room for the push.
   */
  if ((bck = CurrentBucket)->Index >= BUCKET_SIZE){
    bck = (Bucket *) Malloc(sizeof(Bucket));
    bck->Next = CurrentBucket;
    (CurrentBucket = bck)->Index = 0;
  }
  /*
   *	Push the character.
   */
  bck->Data[bck->Index++] = chr;
  StringSize++;
}
/*
 *	Form string:
 *
 *	  This converts the current string bucket into a real live string,
 *	whose pointer is returned.
 */
char *FormString()
{
  register Bucket *bck;
  register char *cp;
  /*
   *	Allocate space for the string, set the pointer at the end.
   */
  cp = (char *) Malloc(StringSize + 1);
  cp += StringSize;
  *cp-- = '\0';
  /*
   *	Yank characters out of the bucket.
   */
  for (bck = CurrentBucket; bck->Index || (bck->Next !=NULL) ;){
    if (!bck->Index){
      CurrentBucket = bck->Next;
      Free(bck);
      bck = CurrentBucket;
    }
    *cp-- = bck->Data[--bck->Index];
  }
  // fprintf(stderr,"FormStr:'%s'\n",cp+1);
  StringSize = 0;
  return (cp + 1);
}

/*
 * empty the hash table before using it...
 *
 */
clrhash()
{
  int i;
  for (i=0; i<HASHSIZE; i++) htab[i] = NULL;
}

/*
 * compute the value of the hash for a symbol
 *
 */
hash(name)
char *name;
{
  int sum;

  for (sum = 0; *name != '\0'; name++) sum += (sum + *name);
  sum %= HASHSIZE;                      /* take sum mod hashsize */
  if (sum < 0) sum += HASHSIZE;         /* disallow negative hash value */
  return(sum);
}

/*
 * make a private copy of a string...
 *
 */
char *
copy(s)
char *s;
{
  char *new;

  new = (char *) malloc(strlen(s) + 1);
  strcpy(new,s);
  return(new);
}

/*
 * find name in the symbol table, return its value.  Returns -1
 * if not found.
 *
 */
lkup(name)
char *name;
{
  struct Token *cur;

  for (cur = htab[hash(name)]; cur != NULL; cur = cur->nxt)
        if (strcmp(cur->Name, name) == 0) return(cur->Code);
  return(-1);
}

/*
 *	Parse XLR:
 *
 *	  This builds the context tree and then calls the real parser.
 *	It is passed two file streams, the first is where the input comes
 *	from; the second is where error messages get printed.
 */
ParseXLR(inp,err)
FILE *inp,*err;
{
  register int i;
  /*
   *	Set up the file state to something useful.
   */
  Input = inp;
  Error = err;
  LineNumber = 1;

  clrhash();
  /*
   *	Define the tokens.
   */
  for (i = TokenDefSize; i--; ){
      register unsigned int h;
      struct Token *cur;

      h = hash(TokenDef[i].Name);
      cur = (struct Token *)malloc(sizeof (struct Token));
      cur->Name = copy(TokenDef[i].Name);
      cur->Code = TokenDef[i].Code;
      cur->nxt = htab[h];
      htab[h] = cur;
  }
  /*
   *	Create an initial, empty string bucket.
   */
  CurrentBucket = (Bucket *) Malloc(sizeof(Bucket));
  CurrentBucket->Next = NULL;
  CurrentBucket->Index = 0;
  /*
   *	Go parse things!
   */
  yyparse();

  // DumpStack();
}

/*
 *	PopC:
 *
 *	  This pops the current context.
 */
PopC()
{
}

/*
 *	Lexical analyzer states.
 */
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
 *	yylex:
 *
 *	  This is the lexical analyzer called by the YACC/BISON parser.
 *	It returns a pretty restricted set of token types and does the
 *	context movement when acceptable keywords are found. The token
 *	value returned is a NULL terminated string to allocated storage
 *	(ie - it should get released some time) with some restrictions.
 *	  The token value for integers is strips a leading '+' if present.
 *	String token values have the leading and trailing '"'-s stripped.
 *	'%' conversion characters in string values are passed converted.
 *	The '(' and ')' characters do not have a token value.
 */
int yylex()
{
  extern YYSTYPE yylval;
  struct st  *st;
  register int c,s,l,len;
  /*
   *	Keep on sucking up characters until we find something which
   *	explicitly forces us out of this function.
   */
  for (s = L_START, l = 0; 1; ){
    yytext[l++] = c = Getc(Input);
    if (c == '\n' && s==L_START){
       LineNumber++ ;
    }
    switch (s){
      case L_COMMENT:
	if( c == '\n' || c == EOF){
	   s = L_START;
       	   LineNumber++ ;
	   return COMMENT;
        }
	break;
      case L_START:
	if( c == '#' )
	  s = L_COMMENT;
        else if (isdigit(c) || c == '-')
          s = L_INT;
        else if (isalpha(c) )
          s = L_KEYWORD;
        else if (isspace(c)){
          l = 0;
        } else if (c == '(' || c == ')'){
          l = 0;
          return (c);
        } else if (c == '"')
          s = L_STRING;
        else if (c == '+'){
          l = 0;				/* strip '+' */
          s = L_INT;
        } else if (c == EOF)
          return ('\0');
        else {
          yytext[1] = '\0';
          // Stack(yytext, c);
          return (c);
        }
        break;
      /*
       *	Suck up the integer digits.
       */
      case L_INT:
        if (isdigit(c))
          break;
	if( c == '.' ) {
	   s = L_FLOAT;
	   break;
	}
        Ungetc(c);
        yytext[--l] = '\0';
	st = (struct st *)Malloc(sizeof (struct st));
        st->s = strdup(yytext); 
	yylval.st = st ;
        // Stack(yytext, INT);
        return (INT);
      /*
       *	Suck up the integer digits.
       */
      case L_FLOAT:
        if (isdigit(c))
          break;
        Ungetc(c);
        yytext[--l] = '\0';
	st = (struct st *)Malloc(sizeof (struct st));
        st->s = strdup(yytext); 
	yylval.st = st ;
        // Stack(yytext, FLOAT);
        return (FLOAT);
      /*
       *	Scan until you find the start of an identifier, discard
       *	any whitespace found. On no identifier, return a '('.
       */
      case L_KEYWORD:
        if (isalpha(c)){
          s = L_KEYWORD2;
          break;
        } else if (isspace(c)){
          l = 0;
          break;
        }
        Ungetc(c);
        // Stack("(",'(');
        return ('(');
      /*
       *	Suck up the keyword identifier, if it matches the set of
       *	allowable contexts then return its token value and push
       *	the context, otherwise just return the identifier string.
       */
      case L_KEYWORD2:
        if (isalpha(c) || isdigit(c) || c == '_' || c=='-')
          break;
        Ungetc(c);
        yytext[--l] = '\0';
        if ( (c = FindKeyword(yytext)) >0 ){
          // Stack(yytext, c);
          return (c);
        }
	st = (struct st *)Malloc(sizeof (struct st));
        st->s = strdup(yytext); 
	yylval.st = st ;
        // Stack(yytext, KEYWORD);
        return (IDENT);
      /*
       *	Suck up string characters but once resolved they should
       *	be deposited in the string bucket because they can be
       *	arbitrarily long.
       */
      case L_STRING:
        if (c == '\r' || c == '\n')
          ;
        else if (c == '"' || c == EOF){
	  st = (struct st *)Malloc(sizeof (struct st));
          st->s = FormString();  
          // st->s = strdup(yytext); 
	  yylval.st = st ; 
          // Stack(yytext, STR);
          return (STR);
        } else  if (c == '%'){
          s = L_ASCIICHAR;
        } else  if (c == ' ')
	  PushString('_');
        else
          PushString(c);
        l = 0;
        break;
      /*
       *	Skip white space and look for integers to be pushed
       *	as characters.
       */
      case L_ASCIICHAR:
        if (isdigit(c)){
          s = L_ASCIICHAR2;
          break;
        } else if (c == '%' || c == EOF)
          s = L_STRING;
        l = 0;
        break;
      /*
       *	Convert the accumulated integer into a char and push.
       */
      case L_ASCIICHAR2:
        if (isdigit(c))
          break;
        Ungetc(c);
        yytext[--l] = '\0';
        PushString(yytext);
        s = L_ASCIICHAR;
        l = 0;
        break;
    }
  }
}
