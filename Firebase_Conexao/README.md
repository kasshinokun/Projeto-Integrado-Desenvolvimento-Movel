#### Processo de Integração ao Firebase 

Esta etapa vincula-se a Sprint 3 apresentando um passo-a-passo de como conectar a aplicação Flutter ao Firebase.
Sendo integrante da Sprint 3.

###### Sprint 3 - Etapas 

- 13-04-2025: Upload de documentação Google para conexão em pdf
- 20-04-2025: Arquivo-teste conexão (pode conter erros, apenas lógica implementada)
- 21-04-2025: Arquivo-teste login-registro (pode conter erros, apenas lógica implementada)

### Conexão com o Firebase

#### Criar ou escolher Conta Google

Para conectar ao Firebase é necessário criar ou usar uma Conta Google.

#### Criar ou adequar o aplicativo
- Se for criar use o código no Powershell ou VS Code(faça já na pasta que deseja fica mais fácil): ```flutter create --org com.<<nome_do_desenvolvedor> ou <nome_da_empresa_desenvolvedora>> --platform<liguagens_deploy> --project-name <nome_projeto> ./<path_da_pasta_do_app>```

no caso de nosso grupo foi: ```flutter create --org com.grupo.rentahouse --platform android,web,windows --project-name rent_a_house ./```

- Se for adequar execute:
  
  Por precaução faça um backup antes de rodar os códigos abaixo.
  - ```flutter clean```
  - ```flutter pub get```
  - ```flutter create --org com.<<nome_do_desenvolvedor> ou <nome_da_empresa_desenvolvedora>> ./<path_da_pasta_do_app>```
    
#### Conectar Firebase ao aplicativo
##### CLI e CI do Firebase (Apenas passos iniciais)
- Por favor pesquise no Google por ```firebase flutter```
- Por favor clique no link ```Add Firebase to your Flutter app``` 
  - Ou se iOS, acesse ```https://firebase.google.com/docs/flutter/setup?hl=pt&platform=ios```
  - Ou se Android, acesse ```https://firebase.google.com/docs/flutter/setup?hl=pt&platform=android```
  - Ou se Web, acesse ```https://firebase.google.com/docs/flutter/setup?hl=pt&platform=web```
- Por favor siga ou observe as etapas de pré-requisitos
- Por favor ``` instale a CLI Firebase de acordo com seu sistema operacional``` link: ```https://firebase.google.com/docs/cli?hl=pt#setup_update_cli```
 - inicialmente, será Linux(Manjaro Linux): abra o terminal e cole ```curl -sL https://firebase.tools | bash```
 -posteriormente, poderá ser adicionado Windows(mas leia a documentação referente ao seu sistema operacional por gentileza)
- Deixe a conta Google logada no(s) navegadores do computador em uso e prossiga para fazer login e testar a CLI: ```firebase login```
![Apos Login](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S3/aposloginterminalbrowser.jpg)
- Execute: ```firebase projects:list```
- Atualizar versão: ```curl -sL https://firebase.tools | upgrade=true```
- Pode ser feito pelo npm do NodeJS([siga os passos necessários para instalar o npm](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Firebase_Conexao/NodeJS_Install.md)), rode: ```npm install -g firebase-tools```
- Quanto ao mais leia os processos de conexão, configuração do CLI e CI do Firebase
##### Firebase Realtime Database
- Clique em: ```https://firebase.google.com/products/realtime-database?hl=pt```
- Clique em: ```Go to console```
- Clique em: ```Criar um projeto```
- Digite um nome, poreḿ se o sistema sugerir um identificador exclusivo global do seu projeto, por favor o escolha também.
- Clique em ```Continuar``` até aparecer ```Configurar o Google Analytics```, por favor escolha o ```Brasil ou seu pais de origem```.
- Clique em: ```Criar um projeto```
- Clique em ```Continuar```
  ![Apos Login](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S3/projetoconcluido.png)
- Clique em: ```Realtime Database``` na lista lateral no item ```Criação```, se já houver o atalho no topo clique sobre ```Realtime Database```.
- Ou acesse: ```https://console.firebase.google.com/u/0/project/<identificador_exclusivo_global_do_projeto>/database?hl=pt```
- Clique em: ```Criar banco de dados```, siga tutoriais para este processo por gentileza.
###### Estrutura Inicial para teste
--> Usuario do aplicativo:
    
    --> Email do Usuario do aplicativo;
    
    --> Senha do Usuario do aplicativo;
    
    --> Nome de Usuario do aplicativo;

##### Conexão com aplicativo
- Siga as etapas descritas em:
  - Ou se iOS, acesse ```https://firebase.google.com/docs/flutter/setup?hl=pt&platform=ios```
  - Ou se Android, acesse ```https://firebase.google.com/docs/flutter/setup?hl=pt&platform=android```
  - Ou se Web, acesse ```https://firebase.google.com/docs/flutter/setup?hl=pt&platform=web```
##### Etapa final
- Realize testes para verificar

