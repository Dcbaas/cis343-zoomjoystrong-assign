%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "zoomjoystrong.h"
%}

void yyerror(const char* err);

%union{
  int iVal;
  float fVal;
}

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token <iVal> INT
%token <fVal> FLOAT
%%

program:  statement_list END;

statement_list: statement
              | statement statement_list
              ;
statement:  line
         |  point
         |  circle
         |  rectangle
         |  set_color
         ;
line: LINE INT INT INT INT                    { line($2, $3, $4, $5); }
    | LINE FLOAT FLOAT FLOAT FLOAT            { line($2, $3, $4, $5); }
    ;
point:  POINT INT INT                         { point($2, $3); }
     |  POINT FLOAT FLOAT                     { point($2, $3); }
     ;
circle: CIRCLE INT INT INT                    { circle($2, $3, $4); }
      | CIRCLE FLOAT FLOAT FLOAT              { circle($2, $3, $4); }
      ;
rectangle:  RECTANGLE INT INT INT INT         { rectangle($2, $3, $4, $5); }
         |  RECTANGLE FLOAT FLOAT FLOAT FLOAT { rectangle($2, $3, $4, $5); }
         ;
set_color:  SET_COLOR INT INT INT             { set_color($2, $3, $4); }

%%

//I was unsure if the main function was supposed to go here or in the lex file. I checked 
//Jarreds code to make sure I was correct after I didn't get an answer from you on slack 
//immediatly. I don't however follow strictly what he put in the main.
int main(int argc, char** argv){

}
