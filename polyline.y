%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define MAX_POINTS 100

typedef struct {
    double x, y;
} Point;

Point points[MAX_POINTS];
int point_count = 0;

void add_point(double x, double y) {
    if (point_count < MAX_POINTS) {
        points[point_count].x = x;
        points[point_count].y = y;
        point_count++;
    } else {
        printf("Too many points\n");
    }
}

double calculate_length() {
    double length = 0.0;
    for (int i = 0; i < point_count - 1; i++) {
        double dx = points[i+1].x - points[i].x;
        double dy = points[i+1].y - points[i].y;
        length += sqrt(dx * dx + dy * dy);
    }
    return length;
}
void is_open(){
    double init_x = points[0].x;
    double init_y = points[0].y;
     for (int i = 1; i < point_count - 1; i++) {
            if( points[i].x == init_x && points[i].y == init_y){
                printf("FALSO! polylinea chiusa\n");
                return;
            }
       }
      printf("VERO! polylinea aperta\n");


}

void close(){
    double init_x = points[0].x;
    double init_y = points[0].y;

    add_point(init_x, init_y );
    printf("new length: %f\n",calculate_length() );

}




%}

%token NUMBER SIM0 SIMX SIMY ISOPEN CLOSE VARIABLE EOL SEMICOLON LPAR RPAR LEN

%%

commands:
    commands command EOL
    | /* empty */
    ;

command:
    polyline SEMICOLON { printf("Length: %f\n", calculate_length()); }
    | isOpen_command SEMICOLON { /* handle isOpen command */ }
    | close_command SEMICOLON { /* handle close command */ }
    | LEN SEMICOLON { printf("Length: %f\n", calculate_length()); }
    ;

polyline:
    points
    | sym_point points
    ;

points:
    point point points { add_point($1, $2); }
    |
    ;

point:
    NUMBER { $$ = $1; }
    | '-' NUMBER { $$ = -$2; }
    ;

sym_point:
        SIMX '(' point point points ')' { add_point($3, -$4); }
        | SIMY '(' point point points ')' { add_point(-$3, $4);}
        | SIM0 '(' point point points ')' { add_point(-$3, -$4); }
        ;


isOpen_command:
    ISOPEN polyline { is_open(); }
    ;

close_command:
    CLOSE polyline { close(); }
    ;

%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}