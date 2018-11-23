%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <errno.h>
  #include "zoomjoystrong.h"
  void yyerror(const char* err);
  extern int yylex();
  extern FILE* yyin;
%}

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
line: LINE INT INT INT INT                    { printf("line cmd"); }
    | LINE FLOAT FLOAT FLOAT FLOAT            { printf("line cmd"); }
    ;
point:  POINT INT INT                         { printf("point cmd"); }
     |  POINT FLOAT FLOAT                     { printf("point cmd"); }
     ;
circle: CIRCLE INT INT INT                    { printf("circle cmd"); }
      | CIRCLE FLOAT FLOAT FLOAT              { printf("circle cmd"); }
      ;
rectangle:  RECTANGLE INT INT INT INT         { printf("color cmd"); }
         |  RECTANGLE FLOAT FLOAT FLOAT FLOAT { printf("color cmd"); }
         ;
set_color:  SET_COLOR INT INT INT             {  }

%%

//I was unsure if the main function was supposed to go here or in the lex file. I checked 
//Jarreds code to make sure I was correct after I didn't get an answer from you on slack 
//immediatly. I don't however follow strictly what he put in the main.
int main(int argc, char** argv){
  if(argc != 2){
    yyerror("./zsj <filename>");
  }

  yyin = fopen(argv[1], "r"); 
  if(!yyin){
    fclose(yyin);
    yyerror("Error Opening file");
  }

  //This while loop is a modified example I found at 
  //https://github.com/meyerd/flex-bison-example/blob/master/calc.y
  while(!feof(yyin)){
    yyparse();
  }
  
  return 0;
}

//This yyerror function is a
void yyerror(const char* err){
  fprintf(stderr, "ERROR! %s\n", err);
  exit(1);
}
