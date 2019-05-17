# latex-to-markdown
Pequeno tradutor de LATEX para MARKDOWN feito em Flex e Bison para a disciplina de Compiladores do curso de Ciência da Computação da UTFPR/PG

Para rodar você deve possui o flex e o bison instalado.

    brew install flex (Mac) sudo apt-get flex (Linux)
    brew install bison (Mac) sudo apt-get flex (Linux)

No terminal, digite os comandos:

    bison -d textomd.y
    flex textomd.l
    gcc textomd.tab.c lex.yy.c -ll (Mac) -lfl (Linux)
    ./a.out

Um arquivo "saida.md" será gerado com o código latex "entrada.tex" traduzido para markdown.
