# Rent a House

### Desenvolvido por:

[Diego Vitor Pinto Mariano Portella](https://github.com/diegovitorportella)

[Gabriel Batista de Almeida](https://github.com/GabrielBatistadeAlmeida)

[Gabriel da Silva Cassino](https://github.com/kasshinokun)

### Objetivo do app:
 O aplicativo Rent a House tem como objetivo facilitar o
 aluguel de imóveis por temporada, conectando locatários e
 localizadores em uma plataforma digital intuitiva e segura.
 Além da funcionalidade tradicional de listagem e reserva
 de imóveis, o sistema se diferencia ao integrar um hardware
 de prototipagem (ESP32 ou Arduino), permitindo a
 automação e monitoramento remoto dos imóveis por meio
 de sensores e atuadores .
 
 Os dados coletados pelos dispositivos serão armazenados
 e gerenciados em uma base de dados na nuvem , como o
 Firebase ou outro SGBD, garantindo acessibilidade,
 segurança e eficiência na comunicação entre os usuários e
 o sistema. Dessa forma, o Rent a House oferece mais
 praticidade e inovação ao setor de aluguel por temporada.

 ### Publico-alvo
 O público-alvo do Rent a House é composto por dois principais grupos de usuários:
 
 - Inquilinos/viajantes : Pessoas que procuram alugar imóveis por temporada, seja para viagens a trabalho, lazer ou
 estadias temporárias. Esse grupo inclui turistas, profissionais em deslocamento, estudantes e famílias que residem em
 uma residência provisória. Eles valorizam praticidade, segurança e um processo de locação simplificado;
 - Proprietários/Anfitriões : Donos de imóveis que desejam disponibilizá-los para aluguel por temporada de forma segura
 e eficiente. Esse grupo inclui desde pequenos proprietários até investidores do setor imobiliário, que buscam uma
 plataforma confiável para gerenciar seus aluguéis e otimizar a ocupação de imóveis.

### Principais funcionalidades que planejamos implementar:
 - Para Inquilinos:
   
✔Busca e Filtros de Imóveis – Pesquisa avançada por localização, preço, comodidades e disponibilidade;
 
✔Visualização de Imóveis – Lista com imagens, descrição detalhada, endereço e avaliações de outros usuários;

✔Reserva e Pagamento Online – Processo rápido e seguro para alugar um imóvel diretamente pelo app;

✔Gerenciamento de Locações – Histórico de reservas, status de locação e notificações sobre prazos;

✔Acesso Inteligente ao Imóvel – Integração com hardware (ESP32/Arduino) para controle de fechaduras eletrônicas e
 sensores.
 
 - Para Proprietários (Anfitriões):

✔Cadastro de Imóveis – Inclusão de fotos (com Image Picker e carrossel), descrição, localização (CEP) e valores;

✔Gerenciamento de Anúncios – Ativação, edição e remoção de imóveis reservados;

✔Monitoramento Inteligente – Sensores para controle de acesso, temperatura, iluminação e consumo de energia;

✔Gestão de Reservas – Controle de ocupação, calendário de disponibilidade e comunicação com locatários;

✔Notificações e Alertas – Avisos sobre novas reservas, pagamentos e status do imóvel.

- Funcionalidades Gerais:

✔Cadastro e Login – Autenticação via e-mail, Google ou redes sociais;

✔Chat Integrado – Comunicação direta entre locatário e localizador dentro do app;

✔Avaliações e Feedback – Sistema de avaliações e notas para imóveis e usuários;

✔Integração com Firebase ou outro SGBD – Armazenamento seguro e sincronização em tempo real;

✔Painel de Controle – Dashboard com estatísticas sobre locações, faturamento e desempenho dos imóveis.

### Observações sobre a pasta /build

As pastas:

- app

- flutter_plugin_android_lifecycle

- native_assets

- windows

- além do arquivo ````cache.dill.track.dill```.

Precisarão ser providos via comando durante a reconstrução da aplicação, pois eram grandes em alguns casos (acima de 25Mb) 
ou foram identificados como ```hidden```, o que impediu o upload para este repositório.

---> Solução: Rodar o código-base para o código-fonte e adicionar as pastas que aqui estiverem presentes (exceto a pasta /build(mantida para apenas exemplificar a estrutura local da aplicação.)).

[Copie os códigos dentro do arquivo .bat ou execute o arquivo .bat para recriar o programa.](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Exemplos/create_app_folder.bat)

### Protótipos de Telas objetivadas inicialmente para o projeto:
![Tela de Login](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S1/imagens_envio/tela_login.jpg)

![Usuário Offline](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S1/imagens_envio/useroffline.jpg)

![Usuário Online](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S1/imagens_envio/useronline.jpg)

![Configurações](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S1/imagens_envio/settings.jpg)

![Cadastro de Imóveis para Alugar](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S1/imagens_envio/registerhouse.jpg)

![Casas Alugadas](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S1/imagens_envio/myhouses.jpg)

#### Previas de desenvolvimento 
[Versão 1-11-03-2025](https://youtube.com/shorts/cTVmHEY7E44?si=hPk19S3dxK42wJA1)

[Versão 1-14-03-2025](https://youtube.com/shorts/QjVhkhm4xPc?si=zLrbdjWetz8AhRfF)
