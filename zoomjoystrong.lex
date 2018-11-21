%{
  #include <stdio.h>
  #include <string.h>
  #include "zoomjoystrong.tab.h"
  void white_space(char* lex);
%}

%option yylineno

%%
(END)                       { return END; }
;                           { return END_STATEMENT; } 
(POINT|point)               { return POINT; }
(LINE|line)                 { return LINE; }
(CIRCLE|circle)             { return CIRCLE; }
(RECTANGLE|rectangle)       { return RECTANGLE; }
(SET_COLOR|set_color)       { return SET_COLOR; }
[0-9]+                      { return INT; }
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
int main(int argc, char** argv){
  yylex();
  return 0;
}

/**********************************************************************
 * Looks at a white space char and checks if it is a new line. If it 
 * is, the line number is advanced.
 * 
 * Param: lex the string of white space.
 *********************************************************************/
