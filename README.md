# latex-to-markdown
Pequeno tradutor de LATEX para MARKDOWN feito em Flex e Bison para a disciplina de Compiladores do curso de Ciência da Computação da UTFPR/PG

No terminal, execute os seguintes comandos:

**Lembre-se de trocar sua_entrada.tex para seu arquivo de latex de entrada e sua_saida.md para ser seu arquivo traduzido para markdown.**

### Mac

* Instalação

      brew install flex
      brew install bison
      
* Execução
      
      bison -d textomd.y
      flex textomd.l
      gcc textomd.tab.c lex.yy.c -ll
      ./a.out sua_entrada.tex sua_saida.md

### Linux

* Instalação

      sudo apt-get flex
      sudo apt-get bison
      
* Execução
      
      bison -d textomd.y
      flex textomd.l
      gcc textomd.tab.c lex.yy.c -lfl
      ./a.out sua_entrada.tex sua_saida.md

Um arquivo "saida.md" será gerado com o código latex "entrada.tex" traduzido para markdown.
