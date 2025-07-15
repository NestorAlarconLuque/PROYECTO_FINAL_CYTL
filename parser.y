%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int line_num;

void yyerror(const char *s);
%}

%token CLASE ESTATICO SI SINO MIENTRAS PARA RETORNAR NUEVO PRINCIPAL
%token IMPRIMIR LEER VERDADERO FALSO HACER ENTERO REAL CADENA_TIPO
%token BOOLEANO VACIO CARACTER_TIPO IDENTIFICADOR NUMERO CADENA CARACTER
%token OP_IGUALDAD OP_DISTINTO OP_MENOR_IGUAL OP_MAYOR_IGUAL OP_AND OP_OR

%start programa

%%

programa : clase
    ;

clase : CLASE IDENTIFICADOR '{' miembros_clase '}'
    ;

miembros_clase : 
    | miembro miembros_clase
    ;

miembro : declaracion_variable
    | metodo
    ;

declaracion_variable : tipo_dato IDENTIFICADOR ';'
    | tipo_dato IDENTIFICADOR '=' expresion ';'
    ;

tipo_dato : ENTERO
    | REAL
    | CADENA_TIPO
    | BOOLEANO
    | VACIO
    | CARACTER_TIPO
    ;

metodo : ESTATICO tipo_dato IDENTIFICADOR '(' parametros ')' '{' sentencias '}'
    ;

parametros : 
    | parametro_lista
    ;

parametro_lista : parametro
    | parametro ',' parametro_lista
    ;

parametro : tipo_dato IDENTIFICADOR
    ;

sentencias : 
    | sentencia sentencias
    ;

sentencia : declaracion_variable
    | asignacion
    | estructura_control
    | invocacion_metodo ';'
    | RETORNAR expresion ';'
    | IMPRIMIR '(' expresion ')' ';'
    | LEER '(' IDENTIFICADOR ')' ';'
    ;

asignacion : IDENTIFICADOR '=' expresion ';'
    ;

estructura_control : si
    | mientras
    | para
    ;

si : SI '(' expresion ')' '{' sentencias '}' si_opcional
    ;

si_opcional : 
    | SINO '{' sentencias '}'
    ;

mientras : MIENTRAS '(' expresion ')' '{' sentencias '}'
    ;

para : PARA '(' asignacion_simple ';' expresion ';' asignacion_simple ')' '{' sentencias '}'
    ;

asignacion_simple : IDENTIFICADOR '=' expresion
    ;

invocacion_metodo : IDENTIFICADOR '(' lista_argumentos ')'
    ;

lista_argumentos : 
    | expresion_lista
    ;

expresion_lista : expresion
    | expresion ',' expresion_lista
    ;

expresion : expresion_logica
    ;

expresion_logica : expresion_relacional
    | expresion_logica OP_AND expresion_relacional
    | expresion_logica OP_OR expresion_relacional
    ;

expresion_relacional : expresion_aritmetica
    | expresion_aritmetica OP_IGUALDAD expresion_aritmetica
    | expresion_aritmetica OP_DISTINTO expresion_aritmetica
    | expresion_aritmetica OP_MENOR_IGUAL expresion_aritmetica
    | expresion_aritmetica OP_MAYOR_IGUAL expresion_aritmetica
    | expresion_aritmetica '<' expresion_aritmetica
    | expresion_aritmetica '>' expresion_aritmetica
    ;

expresion_aritmetica : termino
    | expresion_aritmetica '+' termino
    | expresion_aritmetica '-' termino
    ;

termino : factor
    | termino '*' factor
    | termino '/' factor
    | termino '%' factor
    ;

factor : NUMERO
    | CADENA
    | CARACTER
    | VERDADERO
    | FALSO
    | IDENTIFICADOR
    | invocacion_metodo
    | '(' expresion ')'
    | '!' factor
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error sintactico en linea %d: %s\n", line_num, s);
    exit(1);
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error al abrir el archivo");
            return 1;
        }
    }
    
    if (yyparse() == 0) {
        printf("El analisis sintactico fue exitoso.\n");
    }
    
    if (argc > 1) {
        fclose(yyin);
    }
    return 0;
}
