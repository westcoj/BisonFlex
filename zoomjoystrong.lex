%{
#include <stdio.h>
#include "zoomjoystrong.tab.h"
int c;
%}

%option noyywrap
%option yylineno
%option nodefault
%%
		
point		{return(POINT);}
[0-9]+		{
			c = yytext[0];
			yylval.a = atoi(yytext);
			//printf("%d",c);
			return(INT);
		}
circle		{return(CIRCLE);}
line		{return(LINE);}
rectangle	{return(RECTANGLE);}
end		{return(END);}
set_color	{return(SET_COLOR);}
[ \t\r\n]+	{	}
;		{return(END_STATEMENT);}
[0-9]*\.[0-9]+	{
		c = yytext[0];
		yylval.a = c - '0';
		return(FLOAT);
		}
.		{printf("Invalid Statement\n");}
%%
