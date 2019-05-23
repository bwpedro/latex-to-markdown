%{
    #include <stdio.h>
    FILE *yyin;
    FILE *yyout;
    int flagA = 0;
    int flagB = 0;
%}

%token NAME
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

    classe: CLASS OC NAME CC EOL { fprintf(yyout, "[//]: <> (Classe: %d)\n\n", $3); }

    pacote: PACKAGE OC NAME CC EOL { fprintf(yyout, "[//]: <> (Pacote: %d)\n\n", $3); }

    identificacao: titulo autor |
        titulo ;

    titulo: TITLE OC NAME CC EOL { fprintf(yyout, "Título: %d\n\n", $3); } ;

    autor: AUTHOR OC NAME CC EOL { fprintf(yyout, "Autor: %d\n\n", $3); }

    principal: inicio corpolista fim ;

    inicio: BEGINDOCUMENT EOL { fprintf(yyout, "[//]: <> (Inicio do Documento)\n\n"); } ;

    corpolista: capitulo corpo secao corpo subsecao corpo |
        corpo ;

    fim: ENDDOCUMENT EOL { fprintf(yyout, "\n\n[//]: <> (Fim do Documento)"); } ;

    capitulo: CHAPTER OC NAME CC EOL { fprintf(yyout, "## Capítulo %d\n\n", $3); } ;

    secao: SECTION OC NAME CC EOL { fprintf(yyout, "### Seção %d\n\n", $3); } ;

    subsecao: SUBSECTION OC NAME CC EOL { fprintf(yyout, "#### Sub-Seção %d\n\n", $3); } ;

    corpo: texto |
        texto corpo |
        textoEstilo corpo |
        listas corpo;

    texto: |
        PARAGRAPH OC NAME CC EOL { fprintf(yyout, "\n\nParagrafo: %d\n\n", $3); } ;
    
    textoEstilo: BF OC NAME CC EOL { fprintf(yyout, "Negrito: **%d**\n\n", $3); } |
        UNDERLINE OC NAME CC EOL { fprintf(yyout, "Underline: %d\n\n", $3); } |
        IT OC NAME CC EOL { fprintf(yyout, "Itálico: *%d*\n\n", $3); } ;

    listas: listaNumerada texto listaItens |
        listaNumerada |
        listaItens texto listaNumerada |
        listaItens ;

    listaNumerada: inicioenumerate itensLNumerada fimenumerate ;

    inicioenumerate: BEGINENUMERATE EOL ;

    fimenumerate: ENDENUMERATE EOL ;

    itensLNumerada: itemN |
        itemN itensLNumerada ;

    itemN: ITEMMIZE OC NAME CC EOL { if(flagA == 0){ fprintf(yyout, "\n1. %d", $3); } else { fprintf(yyout, "\n 1. %d\n", $3); } } |
        itemN {flagA=1;} listaNumerada;

    listaItens: inicioitem itensLItens fimitem ;

    inicioitem: BEGINITEM EOL ;

    fimitem: ENDITEM EOL ;

    itensLItens: itemI |
        itemI itensLItens ;
    
    itemI: ITEMMIZE OC NAME CC EOL { if(flagB == 0){ fprintf(yyout, "\n* %d", $3); } else { fprintf(yyout, "\n * %d\n", $3); } } |
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