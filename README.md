# latex-to-markdown
Pequeno tradutor de LATEX para MARKDOWN feito em Flex e Bison para a disciplina de Compiladores do curso de Ciência da Computação da UTFPR/PG

No terminal, execute os seguintes comandos:

### Mac

* Instalação

      brew install flex
      brew install bison
      
* Execução
      
      bison -d textomd.y
      flex textomd.l
      gcc textomd.tab.c lex.yy.c -ll
      ./a.out

### Linux

* Instalação

      sudo apt-get flex
      sudo apt-get bison
      
* Execução
      
      bison -d textomd.y
      flex textomd.l
      gcc textomd.tab.c lex.yy.c -lfl
      ./a.out

Um arquivo "saida.md" será gerado com o código latex "entrada.tex" traduzido para markdown.
