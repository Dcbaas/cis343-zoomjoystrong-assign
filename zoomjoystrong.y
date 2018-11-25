%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <errno.h>
  #include "zoomjoystrong.h"

  #define TRUE 1
  #define FALSE 0
  void yyerror(const char* err);
  void line_check(int x1, int y1, int x2 ,int y2);
  void point_check(int x, int y);
  void circle_check(int x, int y, int r);
  void rectangle_check(int x, int y, int w, int h);
  void color_check(int c1, int c2, int c3);
  int checkX(int x);
  int checkY(int y);
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

program:  statement_list end 
       ;
statement_list: statement
              | statement statement_list
              ;
statement:  line
         |  point
         |  circle
         |  rectangle
         |  set_color
         ;
line: LINE INT INT INT INT END_STATEMENT                    { line_check($2, $3, $4, $5); }
    ;
point:  POINT INT INT END_STATEMENT                         { point_check($2, $3); }
     |  POINT FLOAT FLOAT END_STATEMENT                     { printf("point cmd\n"); }
     ;
circle: CIRCLE INT INT INT END_STATEMENT                    { circle_check($2, $3, $4); }
      | CIRCLE FLOAT FLOAT FLOAT END_STATEMENT              { printf("circle cmd\n"); }
      ;
rectangle:  RECTANGLE INT INT INT INT END_STATEMENT         { rectangle_check($2, $3, $4, $5); }
         |  RECTANGLE FLOAT FLOAT FLOAT FLOAT END_STATEMENT { printf("rect cmd\n"); }
         ;
set_color:  SET_COLOR INT INT INT END_STATEMENT             { color_check($2, $3, $4); }
         ;
end:  END                                                   { return 0; }
   ;
%%

//I was unsure if the main function was supposed to go here or in the lex file. I checked 
//Jarreds code to make sure I was correct after I didn't get an answer from you on slack 
//immediatly. I don't however follow strictly what he put in the main.
//I also refrenced Jarreds code for the end statement in the grammer definition.
//I kept getting an error at the end of the yyparse. I knew that yyparse
//returned 0 upon valid parsing and 1 if there was an error. I guess
//it returns a 0 or one for everything it parses and that the 
//return 0 has to be explicitly defined. Again I did ask you about it but 
//I recived no response during the break.
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

  setup();
  do{
    yyparse();
  }while(!feof(yyin));

  printf("Press any key to exit"); 
  getc(stdin);

  finish();
  
  return 0;
}

//This yyerror function is a
void yyerror(const char* err){
  fprintf(stderr, "ERROR! %s\n", err);
}

/**********************************************************************
 * Checks the input for the line and ensures that they are within the
 * correct bounds if they are not then an error is sent to yyerror 
 * and the line isn't drawn.
 * Param: x1 the first x coordinate.
 * Param: y1 the first y coordinate.
 * Param: x2 the second x coordinate.
 * Param: y2 The second y coordinate.
 *********************************************************************/
void line_check(int x1, int y1, int x2 ,int y2){
  int failed = 0;
  int xs[2] = { x1, x2 };
  int ys[2] = { y1, y2 };
  //check the x and y vals in the loop
  for(int i = 0; i < 2; ++i){
    if(!checkX(xs[i]) || !checkY(ys[i])){
      failed = 1;
    }
  }
  //Perform the draw if the failure was not triggered
  if(!failed){
    line(x1, y1, x2, y2);
  }
  else{
    yyerror("Parameters for line were out of bounds\n");
  }
}

/**********************************************************************
 * Checks the inputs for a point change and and verifies that they fit
 * within the correct bounds. If they don't then an error is printed 
 * and the point isn't displayed.
 * Param: x The x coordinate
 * Param: y The y coordinate
 *********************************************************************/
void point_check(int x, int y){
  if(checkX(x) && checkY(y)){
    point(x,y);
  }
  else{
    yyerror("Parameters for point were out of bounds\n");
  }
}

/**********************************************************************
 * Checks to see if the inputs for the circle were correct. If they 
 * were not then an error is printed and the circle isn't drawn. For 
 * the radius, the checkY function is used to verify as the max value
 * for the radius can only be the height of the screen.
 * Param x The x coordinate being checked.
 * Param y The y coordinate being checked.
 * Param r The radius being checked.
 *********************************************************************/
void circle_check(int x, int y, int r){
  if(checkX(x) && checkY(y) && checkY(r)){
    circle(x, y, r);
  }
  else{
    yyerror("Parameters for circle were out of bounds");
  }
}

/**********************************************************************
 * Checks to see if the rectangle inputs are corrects. if not, then
 * an error is printed out and the rectangle is not displayed.
 *
 * Param x The x coordinate being validated
 * Param y They y coordinate being validated.
 * Param w The width being validated.
 * Param h The height being validated.
 *********************************************************************/
void rectangle_check(int x, int y, int w, int h){
  if(checkX(x) && checkY(y)){
    if(checkX(x + w) && checkY(y + h)){
      rectangle(x, y, w, h);
    }
    else{
      yyerror("The Rectangle goes off the screen.");
    }
  }
  else{
    yyerror("Starting coordinates are out of bounds");
  }
}

void color_check(int c1, int c2, int c3){ 
  int failed = 0;
  int colors[3] = {c1, c2, c3};
  for(int i = 0; i < 3; ++i){
    if(!(colors[i] >= 0 && colors[i] <= 255)){
     failed = 1; 
    }
  }
  if(!failed){
    set_color(c1,c2,c3);
  }
  else{
    yyerror("The color parameters were invalid");
  }
}

/**********************************************************************
 * Checks an x coordinate to see if it is valid.
 * Param: x The x coordinate being checked
 * Returns: True if valid False otherwise.
 *********************************************************************/
int checkX(int x){
  if(x < 0 || x > WIDTH){
    return FALSE;
  }
  return TRUE;
}

/**********************************************************************
 * Checks a y coordinate to see if it is valid.
 * Param y The y coordinate being checked.
 * Returns: True if its valid. False otherwise.
 *********************************************************************/
int checkY(int y){
  if(y < 0 || y > HEIGHT){
    return FALSE;
  }
  return TRUE;
}
