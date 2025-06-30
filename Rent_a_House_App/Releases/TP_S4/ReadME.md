#### Sprint 4

Por enquanto todos updates principais para estabilizar o aplicativo estão em [TP_S3](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/tree/main/Rent_a_House_App/Releases/TP_S3)
<br>
<br>As prévias estáveis serão disponilizadas aqui, com a devida descrição.

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

##### Vídeos

<br>[Vídeo de Execução do Update 3-14-05-2025](https://youtu.be/44vCFUcQ23Q?si=FvgQR0V_4eoXEt3R)
<br>
<br>[Prévia Teste 1-19-05-2025 SQLite e Firebase](https://youtube.com/shorts/I83i9OQeXbE?si=3WUE7ed4KtduvM7T)
<br>
<br>[Prévia do Update 1.1-26-05-2025](https://youtube.com/shorts/uixEUY6NESA?si=AtZYFfWHYFflWtW9)
