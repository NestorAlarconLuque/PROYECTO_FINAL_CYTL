/* Parte 1: Definiciones */
%option noyywrap
%{
#include <stdio.h>
#include <string.h>

/* Esta sección es crucial para la integración con Bison (la parte de Jhon).
  Bison generará un archivo 'parser.tab.h' con las definiciones de los tokens 
  (como 'CLASE', 'ENTERO', 'IDENTIFICADOR', etc.). Por ahora, podemos definirlos 
  manualmente para probar el lexer, pero luego deberás incluir el archivo de Bison.
*/
// #include "parser.tab.h" // Descomentar cuando Jhon cree el parser.
// Para probar ahora, definimos los tokens manualmente:
#define CLASE 258
#define ESTATICO 259
#define SI 260
#define SINO 261
#define MIENTRAS 262
#define PARA 263
#define RETORNAR 264
#define NUEVO 265
#define PRINCIPAL 266
#define IMPRIMIR 267
#define LEER 268
#define VERDADERO 269
#define FALSO 270
#define HACER 271
#define ENTERO 272
#define REAL 273
#define CADENA_TIPO 274
#define BOOLEANO 275
#define VACIO 276
#define CARACTER_TIPO 277
#define IDENTIFICADOR 278
#define NUMERO 279
#define CADENA 280
#define CARACTER 281
#define OP_IGUALDAD 282 // ==
#define OP_DISTINTO 283 // !=
#define OP_MENOR_IGUAL 284 // <=
#define OP_MAYOR_IGUAL 285 // >=
#define OP_AND 286 // &&
#define OP_OR 287 // ||

int line_num = 1;
%}

/* Expresiones regulares para los tipos de token */
letra_o_guion   [a-zA-Z_]
digito          [0-9]
identificador   {letra_o_guion}({letra_o_guion}|{digito})*
numero_entero   [-+]?{digito}+
numero_decimal  {numero_entero}(\.{digito}+)?([eE]{numero_entero})?
cadena_literal  \"[^"]*\"
caracter_literal \'[^\']\'

%%
/* Parte 2: Reglas (Patrón-Acción) */

/* Palabras Reservadas */
"CLASE"         { return CLASE; }
"ESTATICO"      { return ESTATICO; }
"SI"            { return SI; }
"SINO"          { return SINO; }
"MIENTRAS"      { return MIENTRAS; }
"PARA"          { return PARA; }
"RETORNAR"      { return RETORNAR; }
"NUEVO"         { return NUEVO; }
"PRINCIPAL"     { return PRINCIPAL; }
"IMPRIMIR"      { return IMPRIMIR; }
"LEER"          { return LEER; }
"VERDADERO"     { return VERDADERO; }
"FALSO"         { return FALSO; }
"HACER"         { return HACER; }

/* Tipos de Dato */
"ENTERO"        { return ENTERO; }
"REAL"          { return REAL; }
"CADENA"        { return CADENA_TIPO; }
"BOOLEANO"      { return BOOLEANO; }
"VACIO"         { return VACIO; }
"CARACTER"      { return CARACTER_TIPO; }

/* Identificadores, Literales y Números */
{identificador}   { /* yylval.sval = strdup(yytext); */ return IDENTIFICADOR; }
{numero_decimal}  { /* yylval.fval = atof(yytext); */ return NUMERO; }
{cadena_literal}  { /* yylval.sval = strdup(yytext); */ return CADENA; }
{caracter_literal} { /* yylval.cval = yytext[1]; */ return CARACTER; }

/* Operadores */
"=="            { return OP_IGUALDAD; }
"!="            { return OP_DISTINTO; }
"<="            { return OP_MENOR_IGUAL; }
">="            { return OP_MAYOR_IGUAL; }
"&&"            { return OP_AND; }
"||"            { return OP_OR; }
"="             { return '='; }
"<"             { return '<'; }
">"             { return '>'; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"%"             { return '%'; }
"!"             { return '!'; }

/* Delimitadores */
";"             { return ';'; }
","             { return ','; }
"("             { return '('; }
")"             { return ')'; }
"{"             { return '{'; }
"}"             { return '}'; }
"["             { return '['; }
"]"             { return ']'; }


/* Reglas para ignorar y manejar errores */
[ \t\r]+        { /* Ignorar espacios en blanco y tabulaciones */ }
\n              { line_num++; }
.               { fprintf(stderr, "Error léxico en línea %d: Caracter inesperado '%s'\n", line_num, yytext); }

%%
/* Parte 3: Código de Usuario en C */

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Error al abrir el archivo");
            return 1;
        }
        yyin = file;
    }

    int token;
    while ((token = yylex())) {
        // La variable yytext contiene el texto del token encontrado
        printf("Token: %d, Texto: '%s'\n", token, yytext);
    }

    if (argc > 1) {
        fclose(yyin);
    }
    return 0;
}
