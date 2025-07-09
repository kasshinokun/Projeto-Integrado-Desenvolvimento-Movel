#### Sprint 4
```Revisão 2-09-07-2025```<br>
- Observações sobre a estrutura de pastas na Sprint 4(/TP_S4)
  - ```Até o final de Junho de 2025:```<br>Todos updates iniciais para estabilizar o aplicativo estão em [TP_S3](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/tree/main/Rent_a_House_App/Releases/TP_S3)<br>As prévias estáveis serão disponilizadas aqui, com a devida descrição.
  - ```Após o final de Junho de 2025:```<br>As prévias estáveis estão disponíveis conforme descrição de caminho da referida pasta.
##### Prévias
-  Update 3-14-05-2025: Versão de Login com Páginal inicial em teste(Pasta: /TP_S4_App)
- 15-05-2025: Template para ESP32 e Flutter com ESP32(Análise de código)
- Update 1-19-05-2025: Versão Prévia de Login SQLite com FireBase(apenas para análise de funcionalidade)
- 21-05-2025: Correção do erro provindo de metódos se tornarem obsoletos na mudança para Flutter SDK 3.3.2
  - Atualização de manutenção em: ```Rent_a_House_App/Releases/TP_S4/update 19-05-2025 1```
  - ```Rent_a_House_App/Releases/TP_S4/TP_S4_App``` continuará por hora com o código anterior(backup).
<br>Adição de código de checagem de internet apresenta instabilidades, é apenas um teste de funcionalidade por hora
<br>está no caminho: ```Rent_a_House_App/Releases/TP_S4/teste conexao```
- 24-05-2025: Adição de código de checagem de internet apresenta instabilidades, é apenas um teste de funcionalidade
<br>por hora - teste de permissões(AndroidManifest refeito do zero).
- 26-05-2025 Descrição (até o Update Update 1.1)
  - ```Update 1 - Permissões Ativas (Rent_a_House_App/Releases/TP_S4/alpha):```
  - Acesso ao Bluettoth
  - Acesso a Memoria
  - Acesso a Camera
  - Acesso a Galeria
  - Acesso a Localização
  - Acesso a Biometria (Protótipo por enquanto)
  - Acesso a Status da Internet do dispositivo
  - Acesso a Status do Wifi do dispositivo
  - ```Update 1.1 - Permissões Ativas (Rent_a_House_App/Releases/TP_S4/beta):```
  - Adição do protótipo de ```Provider```,```ChangeNotifier```e ```Consumer```
  - Ao longo do dia, será divulgado o vídeo-prévia para análise dos integrantes
- Amostra de código 1-02-06-2025: 2 providers para analisar a conexão, 1 listener e a aplicação como consumer
   - objetivo: se houver internet em algum modo de conexão o SQLite recebe o snapshot do Firebase Realtime Database, se estiver completamente offline realizará o login pelo SQLite e permitirá o acesso a casa tanto pelo proprietário quanto pelo inquilino.
   - os dados usados nesta amostra são genéricos não representando os originais.
- Upload de moldes  de chat por Gabriel Batista em 09-06-2025
- Upload de moldes gerais por Igor Leao em 17-06-2025
- Refatoração por erro de servidor de 20-06-2025 a 23-06-2025
- Proposição de modelo para trabalhar com Firebase Auth e Firestore por Gabriel Batista e Igor Avelar em 23-06-2025<br>(não está presente, porem parte está na base de código adaptada por Gabriel Cassino em 27-06-2025)
- Previa 1 de remodelagem para trabalhar com Firebase Auth e Firestore em 27-06-2025 (```Rent_a_House_App/Releases/TP_S4/revisao_app_27_06_2025```)
- Previa 2 de remodelagem para trabalhar com Firebase Auth e Firestore em 28-06-2025 (```Rent_a_House_App/Releases/TP_S4/revisao_app_28_06_2025```)
- Previa 3 revisão 9 de remodelagem(```Rent_a_House_App/Releases/TP_S4/revisao_app_30_06_2025```):
  - login SQLite, Firestore e Firebase Auth
  - registro de casa e usuario no Firestore
  - uso de providers e consumers
  - Aprimoramento do código de Gabriel Batista por Gabriel Cassino:
    - mensagens entre vendedor e cliente no Realtime Database
    - checkout de pagamento
- Atualização 01-07-2025:
  - Login e registro estável
  - Cadastro de Imóvel estável
  - Melhorias no perfil de usuário
  - Melhorias no chat
  - Adição e otimização do Ceheck-Out
  - Código Final em ```Rent_a_House_App\Releases\TP_S4\entrega\```
  - Código desenvolvido por Gabriel Batista em ```Rent_a_House_App\Releases\TP_S4\Codigo_Gabriel_B\Review Sprint 4\```
  - Postagem da documentação entregue em ```Rent_a_House_App\Documentação```   
  - Há alguns bugs ver seção abaixo.

##### Vídeos

<br>[Vídeo de Execução do Update 3-14-05-2025](https://youtu.be/44vCFUcQ23Q?si=FvgQR0V_4eoXEt3R)
<br>
<br>[Prévia Teste 1-19-05-2025 SQLite e Firebase](https://youtube.com/shorts/I83i9OQeXbE?si=3WUE7ed4KtduvM7T)
<br>
<br>[Prévia do Update 1.1-26-05-2025](https://youtube.com/shorts/uixEUY6NESA?si=AtZYFfWHYFflWtW9)
<br>
<br>```Vídeos da entrega da Sprint 4 - Início de Julho de 2025```
<br>
<br>[Apresentação ao Professor Sprint 4 A - Aplicação Geral](https://www.youtube.com/watch?v=6UIz8lo0ejQ)
<br>
<br>[Apresentação ao Professor Sprint 4 B - Check-Out](https://www.youtube.com/shorts/XoF1uw6EW_c)

##### Bugs
<br>```Sprint 4 - Entrega:```
- Salva a imagem do usuário no Firestore e no SQLite, porém não carrega no perfil
- Ao terminar de registrar um imóvel, pode haver tela vermelha, pois não há um hot reload para atualizar o estado da tela principal

##### Planos Futuros(Caso o projeto continue)
- Melhorias de Interface
- Salvamento do objeto Aluguel no Firestore
- Adição e Otimização de processos não implementados
- Possibilidade de uso offline, caso haja usuário logado(usando SQLite)
- Uso do Bluetooth para comunicação com dispositivos IoT
- Integração de chave SHA para comunicação com ESP32
