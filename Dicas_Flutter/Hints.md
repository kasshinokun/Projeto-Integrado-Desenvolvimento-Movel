---->POSTERIORES REVISÕES ADICIONAREI SE PRECISO

---->18-02-2025   Rev.3

# Orientações para o uso de Dart, Android Studio e Flutter no Windows 11
Visando facilitar o processo almejado.

Estas orientações destinam-se a pessoas que instalarão( ou já instalaram 
e tiveram dificuldade no processo, principalmente, por erros do instalador,
tais como: 
- erro de ASCII pelo fato de nome do usuário conter espaço/acento/caracter especial;
- android-sdk instalado e android studio também mas durante o processo "flutter doctor",
tiveram erros de localização das pastas;
- e outros problemas similares.). 
  
## Dados do PC em uso:
### Processador: 
AMD Ryzen 3 3300X
### Mémoria Ram:
12 GB DDR4 2666 Mhz
### OS em uso:
Windows 11 Education 23H2(22631.4317) com Windows Feature Experience Pack 1000.22700.1041.0
## Agradecimentos:
Marcos Duarte:             
[Canal Stack Mobile - (Instalação do Android Studio)](https://www.youtube.com/watch?v=Zp7yChRkbK0&list=PLizN3WA8HR1wURqopT5gwZHwG-5qC-Iyz) 

[Canal Stack Mobile - (Debug no smartphone - Pré-configuração)](https://www.youtube.com/watch?v=aRFmmByY7k8)

Usuários do post StackOverflow:
              
[post sobre erros do flutter doctor](https://stackoverflow.com/questions/60475481/flutter-doctor-error-android-sdkmanager-tool-not-found-windows)

André Baltieri:

[Flutter - Instalação e Configuração do Android no Windows](https://balta.io/blog/flutter-instalacao-configuracao-android-windows)
### Links Importantes:
---->[Chocolatey Install](https://chocolatey.org/install)

---->[Dart](https://dart.dev)

-------->[Dart Docs - Homepage](https://dart.dev/docs)

------------>[Docs Dart Install](https://dart.dev/get-dart)

---->[Android Studio - Homepage](https://developer.android.com/studio)

-------->[Android Studio - Install](https://developer.android.com/studio/install)

---->[Git - Windows Download](https://git-scm.com/downloads/win)

---->[Git - Outros OS Download](https://git-scm.com/downloads)

---->[Flutter - Homepage](https://flutter.dev/)

-------->[Flutter Docs - Homepage](https://docs.flutter.dev/)

------------>[Docs Flutter - Android App Windows](https://docs.flutter.dev/get-started/install/windows/mobile)

### OBSERVAÇÂO IMPORTANTE

Se um usuário do Sistema Operacional já possuir o Flutter-SDK não execute os processos a seguir citados, pois pode haver erros que exigiram a exclusão de todas as pastas contendo o Flutter-SDK e a reinstalação do Flutter-SDK do zero, além de uma grande perca de tempo no decorrer dos problemas gerados e na busca por solução, quanto ao Dart-SDK, até agora não houve algo similar.

## Passos Iniciais:

- [Acesse a documentação do dart](https://dart.dev/get-dart)  para saber como instalar pelo chocolatey (poder ser também via arquivo .zip) por favor;
- Em outra aba do navegador, abra o [chocolatey](https://chocolatey.org/) e vá em [Install](https://chocolatey.org/install) por favor;
- Rode os comandos no terminal como Administrador conforme solicitado por favor;

---->IMPORTANTE: - SE NÃO FOR COMO ADMINISTRADOR O TERMINAL PODE FECHAR DURANTE A EXECUÇÃO DE COMANDOS;

- Volte a página do Dart e rode o comando ```choco install dart-sdk``` por favor;
- Adicione o Dart-SDK ao PATH;
- Feche o CMD ou PowerShell e abra novamente, e rode por favor ```dart --version``` para checar se o ```Dart SDK``` está ativo;
- [Baixe o Android Studio](https://developer.android.com/studio) e siga as [instruções do vídeo por favor](https://www.youtube.com/watch?v=Zp7yChRkbK0&list=PLizN3WA8HR1wURqopT5gwZHwG-5qC-Iyz);
- [Prepare o smartphone para fazer debug no mesmo](https://www.youtube.com/watch?v=aRFmmByY7k8) por favor;


---->IMPORTANTE: - teste um aplicativo qualquer com o Android Studio para verificar a conexão ADB

- [Baixe o Git](https://git-scm.com/downloads/win) e instale por favor;
### Instalação do Flutter-SDK
#### Via Git
- Acesse o [site para iniciar o processo de instalação do Flutter](https://balta.io/blog/flutter-instalacao-configuracao-android-windows);
- Rode o comando na pasta deseja no terminal ```git clone https://github.com/flutter/flutter.git -b stable``` por favor;
- Adicione e verifique se o Flutter já está no PATH por favor;

#### Via arquivo .zip
- baixe o arquivo no [site da instalação](https://docs.flutter.dev/get-started/install), selecione o seu sistema operacional:
- Se [Windows](https://docs.flutter.dev/get-started/install/windows) ;
- Se [MacOS](https://docs.flutter.dev/get-started/install/macos);
- Se [Linux](https://docs.flutter.dev/get-started/install/linux);
- Ou se [ChromeOS](https://docs.flutter.dev/get-started/install/chromeos).

- Selecione o tipo:
- Android, Web ou Desktop;

- Adotarei o Windows e desenvolvimento Mobile para os processos a seguir
- Baixe o zip, e crie a pasta ```Dev``` ou ```dev``` em ```C:\>``` ou ```C:\Users\<nome_usuario>\>``` por favor;
- Descompacte o arquivo baixado na pasta ```<caminho_ate_a_pasta>\Dev```;

#### Indexando no PATH
- Digite ```Variaveis``` na ```Barra de tarefas do Windows``` e clique em ```Editar as variaveis de ambiente do sistema```;
- Clique em ```Variaveis de Ambiente``` e depois clique em ```Path``` no quadro inferior ```Variaveis do sistema``` por favor;
- Adicione um ```Novo``` caminho que será ```C:\<caminho_da_pasta_DEV>\flutter\bin``` e por fim clique em ```OK``` por favor;

#### Checagem da Instalação do SDK e adição de Dependências
- Rode o comando ```flutter --version``` no ```PowerShell``` ou ```Prompt de Comando``` como ```Adminstrador```, este comando permite checar a instalação se usou o comando git, ou realizar a adição de dependências caso seja via zip.
![Tela após rodar o código](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/powershell.png)

 ### Após instalação e indexação no PATH 
- Rode o comando no terminal ```flutter doctor``` por favor;
- Se houver os erros descritos acima no inicio deste tutorial, [veja as dicas no post do StackOverflow](https://stackoverflow.com/questions/60475481/flutter-doctor-error-android-sdkmanager-tool-not-found-windows) por favor;
- Rode o comando no terminal ```flutter doctor --android-licenses``` e aceite todas por favor;
- Se tudo estiver certo, rode mais uma vez o comando no terminal ```flutter doctor``` por favor;
![Resultado esperado](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/flutter_doctor.png)




