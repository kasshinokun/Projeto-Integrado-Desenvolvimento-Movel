## Criando App Android no Flutter com VS Code (PT-BR)
Revisão 1 13-02-2025 

### --> Usando o Powershell como Administrador:
Para facilitar use o comando cd "<Path_da_pasta_do_app>"

exemplo: ```cd "C:\Users\User\Documents\flutter-app"```

Digite ```flutter create --project-name <nome_projeto> --platform <android,ios>(ou apenas <android>)  ./```

Exemplo ```flutter create --project-name flutter-app --platform android  ./```

### --> Para abrir no VS Code:

Digite ```code .\```

![Tela ao abrir](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/Tela%20VS%20Code.jpg)

### --> Dentro do VS Code (um pouco mais profissional - Sem o PowerShell):

IMPORTANTE: Instale as extensões do Dart e do Flutter no VS Code Antes.

---> Abra o ```VS Code```

---> Clique Sobre ```Ver``` ou ```View(se estiver em inglês)```

---> Clique Sobre ```Paleta de Comandos``` ou ```Command Pallete(se estiver em inglês)```

---> Digite ```Flutter``` e depois clique sobre ```Flutter: New Project```

---> No menu que aparece clique sobre ```Application```

---> Com ```Windows Explorer``` escolha a pasta desejada e clique sobre ```Select a folder to create project in```

---> Clique sobre a ```engrenagem ao lado da barra de texto```, role para baixo e selecione ```Platforms all```

---> Deixe selecionado apenas ```android``` e clique sobre ```OK```

---> Clique sobre ```Organization``` dê um nome ficticio que o identificará como desenvolvedor para a loja de aplicativos por exemplo ```com.projectdev```

---> Clique sobre ```Android Language``` e selecione ```Java``` ou ```Kotlin```

---> Dê um nome para o projeto por exemplo, ```"flutter_vscode" ou algum nome sugestivo para o projeto```

---> E por fim aperte ```Enter``` no teclado.

```IMPORTANTE: ALGUNS SMARTPHONES RODAM APENAS JAVA, SE USAR KOTLIN NÃO FUNCIONARÁ CORRETAMENTE. EM GERAL, O ANDROID STUDIO INFORMA DURANTE A CONFIGURAÇÃO DE EMULAÇÃO SE O DISPOSITIVO É SOMENTE JAVA(JAVA ONLY) OU NÃO.```
![Tela](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/emul_and.jpg)

```IMPORTANTE PARA NOVATOS:```

```Para maior praticidade, e ausência de erros(sou novato no Flutter) use o Android Studio para criar a aplicação flutter, pois tornar mais fácil, caso haja erros com bibliotecas e pacotes.```

### --> Use o Powershell como Administrador(um pouco mais profissional - Similar ao VS Code acima):

Para facilitar use o comando cd "<Path_da_pasta_do_app>"

exemplo: ```cd "C:\Users\User\Documents\flutter-app"```

Digite ```flutter create --org <com.<grupo_dev_nome>.<nome_package_do_projeto>> <--platform <android,ios>(ou apenas <android>)>(ou <-a kotlin> ou <-a java>) --project-name <nome_projeto> ./```

Exemplo 1: ```flutter create --org com.kasshinokun.fluttervscode -a kotlin --project-name flutter_vscode ./```

Exemplo 2: ```flutter create --org com.kasshinokun.fluttervscode --platform android --project-name flutter_vscode ./```

E Para abrir no VS Code, digite ```code .\```

### ---> Maiores detalhes

[Rodrigo Rahman - A forma certa de criar um projeto Flutter pelo VSCode](https://www.youtube.com/watch?v=AI_QZ-LEh1I)

[Presets via terminal - StackOverlow](https://stackoverflow.com/questions/49047411/flutter-how-to-create-a-new-project)
(Está direcionado ao iOS, mas as sintaxes são aplicáveis a demais projetos)
