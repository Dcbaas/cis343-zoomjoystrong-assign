%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "zoomjoystrong.tab.h"
  #include "zoomjoystrong.h"
  void white_space(char* lex);
%}

%option yylineno
%option noyywrap 

%%
(END|end)                       { return END; }
;                           { return END_STATEMENT; } 
(POINT|point)               { return POINT; }
(LINE|line)                 { return LINE; }
(CIRCLE|circle)             { return CIRCLE; }
(RECTANGLE|rectangle)       { return RECTANGLE; }
(SET_COLOR|set_color)       { return SET_COLOR; }
[0-9]+                      { yylval.iVal = atoi(yytext); return INT; }
[0-9]+\.[0-9]+              { return FLOAT; }
-[0-9]                      { printf("ERROR: NEGETIVE NUMBER ON LINE %d\n", yylineno); }
[\n|\t| ]+                 ; 
.                           { printf("ERROR: INVALID SYNTAX AT LINE %d\n", yylineno); }
%%


/**********************************************************************
 * The lexems above are prescribed by the assignment specification.
 * The main function simply runs yylex() which will always parrot. 
 * The given keyword or type. If white space is found then a check is
 * made for the new line to advance yylineno. 
 *********************************************************************/

/**********************************************************************
 * Looks at a white space char and checks if it is a new line. If it 
 * is, the line number is advanced.
 * 
 * Param: lex the string of white space.
 *********************************************************************/
