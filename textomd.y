%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #define YYSTYPE char const *
    FILE *yyin;
    FILE *yyout;
    int flagA = 0;
    int flagB = 0;
%}

%token STRING
%token CLASS
%token PACKAGE
%token AUTHOR
%token TITLE
%token PARAGRAPH
%token CHAPTER SECTION SUBSECTION
%token BF UNDERLINE IT
%token ITEMMIZE
%token BEGINDOCUMENT ENDDOCUMENT
%token BEGINENUMERATE ENDENUMERATE
%token BEGINITEM ENDITEM
%token OC CC
%token EOL

%%
    docLatex: | 
        configuracao identificacao principal;

    configuracao: classe pacote | 
        classe ;

    classe: CLASS OC STRING CC EOL { fprintf(yyout, "[//]: <> (Classe: %s)\n\n", $3); }

    pacote: PACKAGE OC STRING CC EOL { fprintf(yyout, "[//]: <> (Pacote: %s)\n\n", $3); }

    identificacao: titulo autor |
        titulo ;

    titulo: TITLE OC STRING CC EOL { fprintf(yyout, "Título: %s\n\n", $3); } ;

    autor: AUTHOR OC STRING CC EOL { fprintf(yyout, "Autor: %s\n\n", $3); }

    principal: inicio corpolista fim ;

    inicio: BEGINDOCUMENT EOL { fprintf(yyout, "[//]: <> (Inicio do Documento)\n\n"); } ;

    corpolista: capitulo corpo secao corpo subsecao corpo |
        corpo ;

    fim: ENDDOCUMENT { fprintf(yyout, "[//]: <> (Fim do Documento)"); } ;

    capitulo: CHAPTER OC STRING CC EOL { fprintf(yyout, "## %s\n\n", $3); } ;

    secao: |
        SECTION OC STRING CC EOL { fprintf(yyout, "### %s\n\n", $3); } ;

    subsecao: | 
        SUBSECTION OC STRING CC EOL { fprintf(yyout, "#### %s\n\n", $3); } ;

    corpo: texto |
        texto corpo |
        textoEstilo corpo |
        listas corpo;

    texto: |
        PARAGRAPH OC STRING CC EOL { fprintf(yyout, "\n\n%s\n\n", $3); } ;
    
    textoEstilo: BF OC STRING CC EOL { fprintf(yyout, "**%s**\n\n", $3); } |
        UNDERLINE OC STRING CC EOL { fprintf(yyout, "%s\n\n", $3); } |
        IT OC STRING CC EOL { fprintf(yyout, "*%s*\n\n", $3); } ;

    listas: listaNumerada texto listaItens |
        listaNumerada |
        listaItens texto listaNumerada |
        listaItens ;

    listaNumerada: inicioenumerate itensLNumerada fimenumerate ;

    inicioenumerate: BEGINENUMERATE EOL ;

    fimenumerate: ENDENUMERATE EOL ;

    itensLNumerada: itemN |
        itemN itensLNumerada ;

    itemN: ITEMMIZE OC STRING CC EOL { if(flagA == 0){ fprintf(yyout, "\n1. %s", $3); } 
                                     else { fprintf(yyout, "\n 1. %s\n", $3); } } |
        itemN {flagA=1;} listaNumerada;

    listaItens: inicioitem itensLItens fimitem ;

    inicioitem: BEGINITEM EOL ;

    fimitem: ENDITEM EOL ;

    itensLItens: itemI |
        itemI itensLItens ;
    
    itemI: ITEMMIZE OC STRING CC EOL { if(flagB == 0){ fprintf(yyout, "\n* %s", $3); } 
                                     else { fprintf(yyout, "\n * %s\n", $3); } } |
        itemI {flagB=1;} listaItens;

%%

int main(int nArgs , char* szArgs []){
    yyin = fopen(szArgs[1], "r");
    yyout = fopen(szArgs[2], "w");
    yyparse();
}

int yyerror(char *s){
    fprintf(stderr, "error: %s\n", s);
}