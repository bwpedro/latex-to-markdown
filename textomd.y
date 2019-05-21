%{
    #include <stdio.h>
    FILE *yyin;
    FILE *yyout;
%}

%token NAME
%token CONTEUDO
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

    configuracao: CLASS OC NAME CC EOL PACKAGE OC NAME CC EOL { fprintf(yyout, "[//]: <> (Classe: %d)\n\n[//]: <> (Pacote: %d)\n\n", $3, $8); } | 
        CLASS OC NAME CC EOL { fprintf(yyout, "[//]: <> Classe: %d\n", $3); } ;

    identificacao: TITLE OC NAME CC EOL AUTHOR OC NAME CC EOL { fprintf(yyout, "Título: %d\n\nAutor: %d\n\n", $3, $8); } | 
        TITLE OC NAME CC EOL { fprintf(yyout, "Título: %d\n\n", $3); } ;

    principal: inicio corpolista fim ;

    inicio: BEGINDOCUMENT EOL { fprintf(yyout, "[//]: <> (Inicio do Documento)\n\n"); } ;

    corpolista: capitulo corpo secao corpo subsecao corpolista |
        corpo ;

    fim: ENDDOCUMENT EOL { fprintf(yyout, "[//]: <> (Fim do Documento)\n\n"); } ;

    capitulo: CHAPTER OC NAME CC EOL { fprintf(yyout, "## Capítulo %d\n\n", $3); } ;

    secao: SECTION OC NAME CC EOL { fprintf(yyout, "### Seção %d\n\n", $3); } ;

    subsecao: SUBSECTION OC NAME CC EOL { fprintf(yyout, "#### Sub-Seção %d\n\n", $3); } ;

    corpo: texto |
        texto corpo |
        textoEstilo corpo |
        listas ;

    texto: PARAGRAPH OC NAME CC EOL { fprintf(yyout, "Paragrafo: %d\n\n", $3); } ;
    
    textoEstilo: BF OC NAME CC EOL { fprintf(yyout, "Negrito: **%d**\n\n", $3); } |
        UNDERLINE OC NAME CC EOL { fprintf(yyout, "Underline: %d\n\n", $3); } |
        IT OC NAME CC EOL { fprintf(yyout, "Itálico: *%d*\n\n", $3); } ;

    listas: listaNumerada listaItens |
        listaNumerada |
        listaItens listaNumerada |
        listaItens ;

    listaNumerada: inicioenumerate itensLNumerada fimenumerate ;

    inicioenumerate: BEGINENUMERATE EOL { fprintf(yyout, "[//]: <> (Inicio da Lista Enumerada)\n\n"); } ;

    fimenumerate: ENDENUMERATE EOL { fprintf(yyout, "\n[//]: <> (Fim da Lista Enumerada)\n\n"); } ;

    itensLNumerada: ITEMMIZE OC NAME CC EOL { fprintf(yyout, "1. %d\n", $3); } |
        ITEMMIZE OC NAME CC EOL itensLNumerada { fprintf(yyout, "1. %d\n", $3); } ;

    listaItens: inicioitem itensLItens fimitem ;

    inicioitem: BEGINITEM EOL { fprintf(yyout, "[//]: <> (Inicio da Lista Normal)\n\n"); } ;

    fimitem: ENDITEM EOL { fprintf(yyout, "\n[//]: <> (Fim da Lista Normal)\n\n"); } ;

    itensLItens: ITEMMIZE OC NAME CC EOL { fprintf(yyout, "* %d\n", $3); } |
        ITEMMIZE OC NAME CC EOL itensLItens { fprintf(yyout, "* %d\n", $3); } ;
%%

int main(int nArgs , char* szArgs []){
    yyin = fopen(szArgs[1], "r");
    yyout = fopen(szArgs[2], "w");
    yyparse();
}

yyerror(char *s){
    fprintf(stderr, "error: %s\n", s);
}