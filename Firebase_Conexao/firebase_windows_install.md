versão 1-28-04-2025
## Firebase CLI no Windows
---> Sistema operacional: <br>
&emsp;&emsp;Windows 11 Education x64 23H2<br>
&emsp;&emsp;Compilação do SO: 22631.4317<br>
&emsp;&emsp;Feature Experience Pack 1000.22700.1041.0<br>

### Use o npm (Gerenciador de pacotes do Node.js) para instalar a CLI do Firebase:
```Comandos no PowerShell:```
<br> Rode ```npm install -g firebase-tools```
<br> se precisar atualizar, rode: ```npm install npm@latest -g```

#### Fazer login e testar a CLI do Firebase
<br> Rode ```firebase login```
<br> Irá abrir o navegador, faça login ana conta do Google desejada ou criada conforme o 
[tutorial-base](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Firebase_Conexao/README.md)
<br> Após logar ficará no PowerShell similar ao visto no Manjaro Linux abaixo:
![Apos Login](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S3/aposloginterminalbrowser.jpg)

#### Testar CLI
<br>Para testar se a CLI está instalada corretamente e acessando sua conta, 
<br>liste seus projetos do Firebase. Execute este comando:
<br>```firebase projects:list```
![Projects](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Rent_a_House_App/Imagens_S3/listprojects.jpg)

#### CLI com sistemas de CI
<br>Caso seja usado pelo grupo, será postado o tutorial

