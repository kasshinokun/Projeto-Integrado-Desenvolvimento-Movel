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
    - --> Continuação: Adaptação da página Home(página Inicial) e adição Sistema de Pesquisa na Home Page (Update 2-02-04-2025)

 - Updates 1-03-04-2025 e 1.1-03-04-2025
    - Adequação e globalização do CustomSearchDelegate
    - Criação de página para exibir os detalhes do item buscado dentro do sistema de busca
    - Adaptação Inicial para layout responsivo-adaptativo
  
  - Updates 1-04-04-2025 até 1.4-04-04-2025
    - Continuação: Adequação e globalização do CustomSearchDelegate
    - Adequação: página para exibir os detalhes do item buscado dentro do sistema de busca
    - Continuação: Adaptação Inicial para layout responsivo-adaptativo
    - Adequação: Configuração de Segurança baseada em estado de login (sem login, logado e gestor)
  
  - Updates 1-05-04-2025 e 1.2-05-04-2025
    - Continuação: Adequação e globalização da Página RentScreen
    - Adequação: página de registro para receber resultados da API de CEP
    - Continuação: Adaptação Inicial para layout responsivo-adaptativo
    - Correção: Tela vermelha ao sair da busca para a página inicial
    - Pequenos ajustes baseados em dispositivo físico
    - Bibliotecas de CEP adicionadas ao ```pubspec.yaml```

  - Updates 1-07-04-2025 e 1.4-07-04-2025 e micro-atualizações de 1.2-05-04-2025 até a atual
    - Continuação: Adaptação Inicial para layout responsivo-adaptativo
    - Sistema de busca de CEP via API ViaCEP dos Correios por meio de requisição HTTP
    - Correção de erros de rotas provenientes das micro-atualizações
    - Criação de Sistema de Notificação vinculado ao Chat - Diego, Gabriel Batista e Igor Avelar <\br>(em desenvolvimento, podendo haver erros(Estágio pre-alpha_0.1))

#### Previas de desenvolvimento Sprint 2 - vídeos e imagens

 [Versão 1-26-03-2025 Teste layout adaptativo](https://www.youtube.com/watch?v=TkVjUKvodDA&list=PLBiA8fTn3ssumAiK2gg7J8_bXRNuP2DKf)

 [Versão 1-29-03-2025](https://youtu.be/o3Bmsndpx0k?si=zyZ8cqco6g-9_yZ0)

 Versão 1-31-03-2025 (código já disponível em ```/Releases/TP_S2/lib/pages/s1/pageges/client/clienthouse.dart```, o update foi fundido ao update 2-31-03-2025)

 [Página de Chat e update MyHouses 2-31-03-2025 - Diego Portella e Gabriel Cassino](https://youtu.be/tILwWaeay54?feature=shared)

  [Versão 1-02-04-2025 - Adaptação Home Page da aplicação e Sistema de busca de endereços](https://youtu.be/3GIdiQnqh3g?si=kvKT8S0u0Pq-enQD)

  [Versão 1-03-04-2025](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S2/Update%201-03-04-2025.pdf)
  
  [Versão 1.4-04-04-2025](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S2/Update%201.4-04-04-2025.pdf)
  
 [Versão 1.4-07-04-2025](https://youtu.be/1x30DdtBpNg?si=k2VWGyo6NEmoNe3J)
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

 - Versão 1-02-04-2025 e micro-atualizações
   
   Overflow de widgets(falhas em estudo) e sem retorno de função(apenas não está implementado).

 - Versão 1-04-04-2025 e micro-atualizações
   
   Tela vermelha ao finalizar a pesquisa e tentar voltar a página inicial

- Versão 1-07-04-2025 e micro-atualizações
   
   Overflow no login e não solicita ao usuário as permissões.
