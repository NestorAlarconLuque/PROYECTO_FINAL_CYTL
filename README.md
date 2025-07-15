# PROYECTO_FINAL_CYTL
Proyecto final del curso Compiladores y Teoria de Lenguajes

Compilación del analizador léxico:
1. Una vez descargados los archivos necesarios:"la carpeta código de prueba" y el "lex.yy.c" (antes debería tener el compilador de c++/c)
2. Para compilar el programa: accedemos a la terminal de la misma ruta que el "lex.yy.c" en donde agregaremos en la terminal:
"g++ lex.yy.c -o mi_lexer" el cual nos generará un archivo "mi_lexer.exe".
3. Luego colocar en la terminal: "mi_lexer eje1.txt", aqui tendras que cambiar el "eje1.txt" por los diferentes archivos que quieras probar para poder ver la lista de tokens válidos y los que no lo son.

Compilación del parser:
```bash
bison -d parser.y
flex lexer.l
gcc lex.yy.c parser.tab.c -o parser -lm

# Ejecutar pruebas:

./parser tests/parser/test_valido.txt
./parser tests/parser/test_invalido.txt
