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
line: LINE INT INT INT INT END_STATEMENT                    { printf("line cmd\n"); }
    | LINE FLOAT FLOAT FLOAT FLOAT END_STATEMENT            { printf("line cmd\n"); }
    ;
point:  POINT INT INT END_STATEMENT                         { printf("point cmd\n"); }
     |  POINT FLOAT FLOAT END_STATEMENT                     { printf("point cmd\n"); }
     ;
circle: CIRCLE INT INT INT END_STATEMENT                    { printf("circle cmd\n"); }
      | CIRCLE FLOAT FLOAT FLOAT END_STATEMENT              { printf("circle cmd\n"); }
      ;
rectangle:  RECTANGLE INT INT INT INT END_STATEMENT         { printf("rect cmd\n"); }
         |  RECTANGLE FLOAT FLOAT FLOAT FLOAT END_STATEMENT { printf("rect cmd\n"); }
         ;
set_color:  SET_COLOR INT INT INT END_STATEMENT             { printf("color cmd\n");  }

%%

//I was unsure if the main function was supposed to go here or in the lex file. I checked 
//Jarreds code to make sure I was correct after I didn't get an answer from you on slack 
//immediatly. I don't however follow strictly what he put in the main.
int main(int argc, char** argv){
  if(argc != 2){
    yyerror("./zsj <filename>");
    return 1;
  }

  yyin = fopen(argv[1], "r"); 
  if(!yyin){
    fclose(yyin);
    yyerror("Error Opening file");
    return 1;
  }

  do{
    yyparse();
  }while(!feof(yyin));
  
  return 0;
}

//This yyerror function is a
void yyerror(const char* err){
  fprintf(stderr, "ERROR! %s\n", err);
}
