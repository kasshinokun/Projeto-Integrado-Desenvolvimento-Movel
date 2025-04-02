# Rent a House

### Desenvolvido por:

[Diego Vitor Pinto Mariano Portella](https://github.com/diegovitorportella)

[Gabriel Batista de Almeida](https://github.com/GabrielBatistadeAlmeida)

[Gabriel da Silva Cassino](https://github.com/kasshinokun)

[Igor Cesar Avelar Leao](https://github.com/Igor-leao)

[Sobre o Projeto - Página Inicial](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/)

#### Etapas Modo Descritivo

26-03-2025 Inicio --> Layout adaptativo e responsivo teste
  - 29-03-2025 --> Correção
  - 31-03-2025 --> Adição Sistema de Chat
  - 01-04-2025:
     -  --> Inicio Sistema de Notificação: Testes
     -  --> Inicio Adaptação da página Home(página Inicial)
  - 02-04-2025:
    - --> Correção de rotas duplicadas nas Classes Inicializadoras 
      -- A classe de Cadastro de casas possuía o mesmo nome da classe de Registro de usuário (ambas eram ```RegisterScreen```), seu novo nome é: ```RegisterHouseScreen```
    - --> Teste de Layout com MyCurvedLabeledNavBar
    - --> Adição de inicializadores do tipo ```void main runApp()``` para conseguir redesenhar as páginas sem a necessidade de chamar a aplicação por completo
      - -->Aplicado em:
        - MyCurvedLabeledNavBar : ```lib/pages/s1/pages/test/curvedlabeled.dart```
        - Cadastrar House: ```lib/pages/s1/pages/manage/registerhouse.dart```
        - Homepage da Aplicação: ```lib/pages/s1/pages/home/home.dart```
        - MyHouses: ```lib/pages/s1/pages/client/clienthouse.dart```
    - --> Início do teste das páginas como objetos para conseguir fazer reuso em outras páginas e layouts
      - --> Aplicado em MyHouses: ```lib/pages/s1/pages/client/clienthouse.dart```

#### Previas de desenvolvimento Sprint 2 - vídeos e imagens

 [Versão 1-26-03-2025 Teste layout adaptativo](https://www.youtube.com/watch?v=TkVjUKvodDA&list=PLBiA8fTn3ssumAiK2gg7J8_bXRNuP2DKf)

 [Versão 1-29-03-2025](https://youtu.be/o3Bmsndpx0k?si=zyZ8cqco6g-9_yZ0)

 Versão 1-31-03-2025 (código já disponível em ```/Releases/TP_S2/lib/pages/s1/pageges/client/clienthouse.dart```, o update foi fundido ao update 2-31-03-2025)

 [Página de Chat e update MyHouses 2-31-03-2025 - Diego Portella e Gabriel Cassino](https://youtu.be/tILwWaeay54?feature=shared)
 
 ##### Layout area de casas alugadas MyHouses - Imagens

 Portrait Layout
 
 ![Versão 1-29-03-2025 A](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S2/portrait_s2.png) 

 Landscape layout

 ![Versão 1-29-03-2025 B](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S2/landscape_s2.jpg) 

 Nova estrutura de pasta (Sprints 1 e 2 unidas)

 ![Nova estrutura](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S2/organizacao_pasta_s2.jpg)

#### Bugs detectado por versão:
 - Versão 1-29-03-2025
   Por ser uma estrutura generica há erros ainda no tamanho de widgets e overflow em alguns casos, execução no chrome está estável, já no smartphone  apresenta as falhas descritas.

  
