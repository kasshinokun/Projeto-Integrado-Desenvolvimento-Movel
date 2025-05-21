# Sprint 3 
#### Etapas
- 02-05-2025: Template Login Firebase estagio inicial
- 02-05-2025: Tela de Login com Firebase - Inicio
  - Apêndice 2: Código teste de uso do Firebase
- 03-05-2025: Template Chat via Firebase - Início
- 04-05-2025: Código Teste - Igor Leao
  - Merge Codigo Login e Conexão - Gabriel Cassino e Igor Leao
- 05-05-2025: Adaptação Merge Update 04-05-2025-2 - Início
  - Update 2.1-05-05-2025 - descrição:
  - Merge Concluído
  - Esqueleto de Páginas pronto e dentro de um<br>CurvedLabeledNavigationBar
  - Adaptação para checagem de conexão - início
  - Página para ausência de Internet - início
  - Página de Chat no Firebase - início
- 07-05-2025: Mudança na persistência do Firebase<br>para permitir verificação se o usuário<br>foi armazenado no SQLite - início
  - Código de exemplo para criação de banco de dados
   <br>em SQLite - início, caminho abaixo:<br> (/Rent_a_house_app/Releases/TP_S3/Teste_Igor/startdatadb.dart)
- 08-05-2025: Update 1 até o último do dia - Upload de códigos
  <br>de teste para tabela Logradouro e request de idToken do Firebase
  <br>focado em processos a serem implantados como o chat
- 10-05-2025: Preparação de classes para receber <br>request de idToken do Firebase e preparação do banco de dados
 local<br>para receber valores e armazenar
- 12-05-2025: Descrição (todos os Updates até o 2.2)
  - Criação das Classes Model e Classes DAO para gerir o SQLite
  - Reformulação da página de registro de imovel com ImagePicker e vinculo com SQLite em teste
  - Ajuste da tela de perfil para receber a chamada da página de registro de imóveis 
  - Preparação da tela Inicial com SQLite - início (não está disponível, mas Gabriel Cassino já iniciou)
  - Criação de classe para gerir permissões em tempo de execução - teste inicial(não está completa,<br>carece análise de viabilidade)
- Update 1-14_05_2025: Código exemplo de Página de Páginas com SQLite
  - Estabilização da Página Inicial com SQLite
  - Disponibilização do exemplo funcional para integrantes do grupo por Gabriel Cassino
    <br>nos caminhos:
    <br>Para Igor Avelar em: ```Rent_a_House_App/Releases/TP_S3/Teste_Igor/teste_para_igor.dart```
    <br>
    <br>Para Gabriel Batista em: ```Rent_a_House_App/Releases/TP_S3/Gabriel_Batista_Teste/teste_gabriel_batista.dart```
  - Migração para TP_S4
  - Preparação para código ESP32
- 17-05-2025: Update para análise feito por Igor Leão  
- 19-05-2025: Teste de Firebase e SQLite em processo de feedback antes do upload(apenas vídeo disponível abaixo)
##### Bugs e erros
- em 20-05-2025, houve mudança em:
  <br>Flutter SDK para 3.3.2 e o Dart SDK para 3.8.0
  <br>Tal mudança, quebrou o código a princípio em partes que usem CardTheme e TabBarTheme,
  <br>pois agora se deve usar CardThemeData e TabBarThemeData conforme pesquisa inicial,
  <br>por está razão foi carregado o update de teste, possivelmente espera-se que
  <br>o update 1-21-05-2025 estabilize, mas pode haver mais erros devido a mudança de SDK's.

##### Preparação 
[Conexão com Firebase e dicas](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Firebase_Conexao/README.md)

[Conexão com SQFLite e dicas](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/tree/main/SQFLite_Conexao)

#### Preview - Etapas
Tela Login/ Registro<br>
![loginv1](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S3/paginaslogin.jpg)
<br>Tela Registro de Imóveis<br>
![imovel_reg](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S3/registro_imovel_images.jpg)

<br>Transição entre Categorias - Página Inicial com SQLite<br>
<img src="https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S4/Home_Slider.jpg" alt="etapa1" width="200"/>

<img src="https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S4/Home_Slider2.jpg" alt="etapa2" width="200"/>
<br>


<br>Bug no Android Studio e VS Code(Use o celualr para rodar)
<br>

<img src="https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S3/erro_android_studio_sqlite_vs_code.gif" alt="etapa3" />

##### Vídeos
[Vídeo de execução em dispositivo Update 2.1-05-05-2025](https://youtube.com/shorts/m4vbd-UxF-Q?si=mVjFNLSvkFdNYx9k)
<br>
[Vídeo de Execução do Update 3-14-05-2025](https://youtu.be/44vCFUcQ23Q?si=FvgQR0V_4eoXEt3R)
<br>[Prévia Teste 1-19-05-2025 SQLite e Firebase](https://youtube.com/shorts/I83i9OQeXbE?si=3WUE7ed4KtduvM7T)
