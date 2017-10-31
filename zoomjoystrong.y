%{
#include <stdio.h>
#include <stdlib.h>
#include "zoomjoystrong.h"
#define YYDEBUG 1
void yyerror(const char *s);
extern int yylineno;
extern int yydebug;
%}

%union {int a; float b;}
%start program
%token<a> INT
%token<b> FLOAT
%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR

%left '|'

%%
program: statement_list
	|
	error statement_list
	{
	//Error statement for recovery
	printf("error PSL\n");
	}
	|
	error
	{
	//Other error statement for recovery
	printf("error P\n");
	}
	;
	
statement_list:statement
	|
	statement statement_list
	{
	//printf("got statement and list\n");
	}
	error statement_list '\n'
	{
	//printf("error ESL\n");
	}
	error ';'
	{
	//printf("error ; \n");
	}
	error
	{
	//printf("error\n");
	}
	error END_STATEMENT
	{
	//printf("error SLES\n");
	}
	error '\n'
	{
	//printf("error SLnl\n");
	}
	;
statement:POINT INT INT END_STATEMENT
	{
	//Take integers from line and make sure they are valid.
	//Integers are passed to c code as a coordinate.
	//$2 is the x, $3 is y
	printf("Making a point\n");
	if($2>=0&&$2<1025&&$3>=0&&$3<769) point($2,$3);
	else printf("Invalid Numbers\n");
	}
	|
	LINE INT INT INT INT END_STATEMENT
	{
	//Take integers from line and make sure they are valid.
	//Integers are passes as 2 coordinates.
	//($2,$3)->($4,$5)
	if($2>=0&&$2<=1024&&$3>=0&&$3<=768&&$4>=0&&$4<=1024&&$5>=0&&$5<=768)
	line($2,$3,$4,$5);
	else printf("Invalid Numbers\n");
	}
	|
	CIRCLE INT INT INT END_STATEMENT
	{
	//Take ints from line and make sure they are valid
	//Integers used as a center point and radius
	//($2,$3) radius = $4
	if($2>=0&&$2<=1024&&$3>=0&&$3<=768) circle($2,$3,$4);
	else printf("Invalid Numbers\n");
	}
	|
	RECTANGLE INT INT INT INT END_STATEMENT
	{
	//Take ints from line and make sure they are valid.
	//Ints are used as a point and rectangles height and width
	//($2,$3) H = $4, W = $5
	if($2>=0&&$2<=1024&&$3>=0&&$3<=768) 	
	rectangle($2,$3,$4,$5);
	else printf("Invalid Numbers\n");
	}
	|
	SET_COLOR INT INT INT END_STATEMENT
	{
	//Take ints from line and make sure they are valid
	//Ints are used a color tuple settings.
	//red = $2, green = $3, blue = $4
	if($2>=0&&$2<=255&&$3>=0&&$3<=255&&$4>=0&&$4<=255) 	
	set_color($2,$3,$4);
	else printf("Invlaid Numbers\n");
	}
	|
	END END_STATEMENT
	{
	//Close the window and cease parsing
	printf("Exiting Program\n");
	finish();
	YYABORT;
	}
	error END_STATEMENT
	{
	//yyclearin;
	//yyerrok;
	//printf("error state:ES\n");
	}
	error
	{
	//printf("error state:\n");
	}
	error '\n'
	{
	//printf("error stnl\n");
	}
	; 
%%

main()
{
	yydebug=1;
	setup();
	yyparse();
}

void yyerror(const char *s)
{
	fprintf(stderr, "Error | Line: %d\n%s\n",yylineno,s);
	//yyclearin;
}

yywrap()
{
	return(1);
}
