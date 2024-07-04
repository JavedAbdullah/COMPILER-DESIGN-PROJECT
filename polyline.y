%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define MAX_POINTS 100
#define MAX_VARS 100

typedef struct {
    double x, y;
} Point;

typedef struct {
    Point points[MAX_POINTS];
    int point_count;
} Polyline;

Polyline polylines[MAX_VARS];
int var_names[MAX_VARS];
int var_count = 0;

Polyline current_polyline;


//memset(var_names, null, sizeof(var_names));

void add_point(double x, double y) {
    if (current_polyline.point_count < MAX_POINTS) {
        current_polyline.points[current_polyline.point_count].x = x;
        current_polyline.points[current_polyline.point_count].y = y;
        current_polyline.point_count++;
    } else {
        printf("Too many points\n");
    }
}

double calculate_length(Polyline polyline) {

    double length = 0.0;
    for (int i = 0; i < polyline.point_count - 1; i++) {
        double dx = polyline.points[i+1].x - polyline.points[i].x;
        double dy = polyline.points[i+1].y - polyline.points[i].y;
        length += sqrt(dx * dx + dy * dy);
    }
    return length;
}
int is_open(Polyline polyline) {
    if (polyline.point_count == 1) {
        return 1;
    }
    double init_x = polyline.points[0].x;
    double init_y = polyline.points[0].y;
    for (int i = 1; i < polyline.point_count; i++) {
        if (polyline.points[i].x == init_x && polyline.points[i].y == init_y) {
            return 1;
        }
    }
    return 0;
}


void tell_if_open(Polyline polyline){
        if(is_open(polyline) == 0){
           printf("VERO! polylinea aperta\n");
        }else{
            printf("FALSO! polylinea chiusa\n");
   }

}

void close(Polyline polyline){
	if( polyline.point_count  == 1){
		printf("polylinea gia' chiusa\n");
	}
    double init_x = polyline.points[0].x;
    double init_y = polyline.points[0].y;

    add_point(init_x, init_y );
    printf("new length: %f\n",calculate_length(polyline) );

}


Polyline* find_polyline(int var_name) {

    for (int i = 0; i < var_count; i++) {
	//printf("variabile salvata = %s\n", var_names[i]);

	if(var_names[i] == var_name) {
		return &polylines[i];
	}


        printf("errivo qui\n");
    }
    return NULL;
}

Polyline find_polyline_for_open(int var_name) {
	Polyline pol;
    for (int i = 0; i < var_count; i++) {
	//printf("variabile salvata = %s\n", var_names[i]);

	if(var_names[i] == var_name) {
		return polylines[i];
	}


        printf("errivo qui\n");
    }
    return pol;
}

void save_polyline(int var_name) {
    Polyline* existing_polyline = find_polyline(var_name);

    if (existing_polyline) {
        *existing_polyline = current_polyline;
    } else {

        if (var_count < MAX_VARS) {
            var_names[var_count] = var_name;
            printf("var_name = %i\n", var_names[var_count]);
            polylines[var_count] = current_polyline;
            //devo azzerare anche l'array
            current_polyline.point_count = 0;
            var_count++;
        } else {
            printf("Too many variables\n");
        }
    }
}




%}

%token NUMBER SIM0 SIMX SIMY ISOPEN CLOSE VARIABLE EOL SEMICOLON LPAR RPAR LEN QUIT PLUS ASSIGN

%%

commands:
    commands command EOL
    | /* empty */
    ;

command:
    polyline SEMICOLON { printf("Length: %f\n", calculate_length(current_polyline)); }
    | isOpen_command SEMICOLON { /* ... */ }
    | close_command SEMICOLON { /*...  */ }
    | LEN { printf("Length: %f\n", calculate_length(current_polyline)); tell_if_open(current_polyline);}
    | QUIT {exit(0);}
    | assignment SEMICOLON
    | length_command SEMICOLON
    | open_command SEMICOLON
    | close_var_command SEMICOLON
    | concat_command SEMICOLON
    |
    ;

assignment:
    VARIABLE ASSIGN polyline { save_polyline($1); }
    ;

length_command:
    VARIABLE { Polyline* p = find_polyline($1); if (p != NULL) { printf("Length: %f\n", calculate_length(*p)); } else { printf("Variable not found\n"); } }
    ;

open_command:
    ISOPEN VARIABLE { tell_if_open(find_polyline_for_open($2)); }
    ;

close_var_command:
    CLOSE VARIABLE { }
    ;

concat_command:
    VARIABLE ASSIGN VARIABLE PLUS VARIABLE { }
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
        SIMX '(' point point polyline ')' { add_point($3, -$4); }
        | SIMY '(' point point polyline ')' { add_point(-$3, $4);}
        | SIM0 '(' point point polyline ')' { add_point(-$3, -$4); }
        ;


isOpen_command:
    ISOPEN polyline { tell_if_open(current_polyline); }
    ;

close_command:
    CLOSE polyline { if(is_open(current_polyline) == 0){close(current_polyline); }else{printf("gia chiuso!\n");}}
    ;

%%

int main() {
// for (int i = 0; i < MAX_VARS; i++) {
//        var_names[i] = -1;
//    }
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}