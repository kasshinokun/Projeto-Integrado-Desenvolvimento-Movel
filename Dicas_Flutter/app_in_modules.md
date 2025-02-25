### Criar e editar em Módulos (PT-BR)
- Usarei como exemplo o aplicativo padrão gerado por ```flutter create```
#### Criando o aplicativo
OBS.: Realize por favor os passos iniciais descritos em [Dicas Iniciais](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/Hints.md)

--> A inclusão de ```--org <com.<grupo_dev_nome>.<nome_package_do_projeto>> ``` é necessário principalmente se for usar serviços como a autenticação pelo Firebase que exige justamente ```--org <com.<grupo_dev_nome>.<nome_package_do_projeto>> ``` para conseguir interpretar se quem está pedindo a requisição é autorizado ou não;

Escolha e crie uma pasta para o projeto conforme [Criar app](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/criar_app.md);

Apague os comentários no código;
![Apague os comentários no código](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/after_remove_1.jpg)

### Criando as pastas dos modulos:

- Crie as seguintes pastas a seguir nos path descritos abaixo no VS Code:
  
- Crie uma nova pasta em ```/lib```, por exemplo, ```/lib/pages``` e o arquivo ```/lib/pages/myapp.dart```;

- Para facilitar o entendimento crie também em ```/lib/pages```, por exemplo, o arquivo ```/lib/pages/myhomepage.dart```;

- Crie uma nova pasta em ```/lib/pages```, por exemplo, ```/lib/pages/pagina1``` e o arquivo ```/lib/pages/pagina1/pagina1.dart```;

- Crie uma nova pasta em ```/lib/pages```, por exemplo, ```/lib/pages/pagina2``` e o arquivo ```/lib/pages/pagina2/pagina2.dart```;

- Elimine a pasta ```/test```.

![Após o processo 2](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/after_remove_2.png)

### Iniciando modularização:
- Tudo que estiver após o procedimento ```void main()```, recorte e cole em ```/lib/pages/myapp.dart```;

- Adicione no cabeçalho de: ```/lib/pages/myapp.dart```, ```/lib/pages/pagina1/pagina1.dart``` e ```/lib/pages/pagina2/pagina2.dart```,o seguinte import: ```import 'package:flutter/material.dart';```;

- Adicione no cabeçalho de: ```/lib/main.dart```,o seguinte import: ```import 'package:exemplo/pages/myapp.dart';```;
  
- Adicione no cabeçalho de: ```/lib/pages/myapp.dart```,os seguinte imports:
  
  ```import 'package:exemplo/pages/myhomepage.dart';```;

  ```import 'package:exemplo/pages/pagina1/pagina1.dart';```;

  ```import 'package:exemplo/pages/pagina2/pagina2.dart';```;


-----> Resultado final parte 1:
![resultado final1a](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/after_remove_3.jpg)

### Criando classes modularizadas:

- Tudo o que está abaixo de ```class MyApp extends StatelessWidget{}``` recorte e cole em:

  ```lib/pages/myhomepage.dart```;

  ```lib/pages/pagina1/pagina1.dart```;

  ```lib/pages/pagina2/pagina2.dart```;
  
- Em ```lib/pages/myapp.dart``` altere ``` home: const (title: 'Flutter Demo Home Page'),``` e coloque no lugar:
  
```initialRoute: '/', //Rotas```

```   routes: {```

```     '/': (context) => MyHomePage(), //Página Inicial```

```     '/first': (context) => MyFirstPage(), //Página 1```

```     '/second': (context) => MySecondPage(), //Página 2```

```   },```

- Nos arquivos use os nomes sugestivos para alteração seguir:

  ```lib/pages/myhomepage.dart```; -----> PT-BR: ```Página Inicial``` e EN-US: ```Home```

  ```lib/pages/pagina1/pagina1.dart```;-----> PT-BR: ```Primeira``` e EN-US: ```First```

  ```lib/pages/pagina2/pagina2.dart```;-----> PT-BR: ```Segunda``` e EN-US: ```Second```

Altere com os nomes sugeridos no código abaixo de cada arquivo como acima descrito:
```
class My<Nome_Pagina_EN_US>Page extends StatefulWidget {
  const My<Nome_Pagina_EN_US>Page({super.key});
  @override
  State<My<Nome_Pagina_EN_US>Page> createState() => _My<Nome_Pagina_EN_US>PageState();
}
class _My<Nome_Pagina_EN_US>PageState extends State<My<Nome_Pagina_EN_US>Page> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

  //OBSERVAÇÂO IMPORTANTE:
  //===> O campo [title] em lib/pages/myhomepage.dart
	title: Text('Minha Página Inicial'),  
	
	//===> O campo [title] nos demais arquivos:
	title: Text('Minha <Nome_Pagina_PT_BR> Página'),  

```

Resultado final 2:

![myapp](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/module_1.png)

![homepage](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/module_2.png)

![firtpage](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/module_3.png)

![secondpage](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/module_4.png)

### Possibilidade de Modularização de Widget

O flutter permite que criemos row, column, listview, dentre outros Widgets de Widget em módulos similar a um array de fucções ou objetos em Python sendo coletados nas telas por retornos no body principalmente mas há customizações para appBar e similares.

Exemplo de Modularização para reuso de Widget:

![Modularização para reuso de Widget](https://github.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/blob/main/Dicas_Flutter/module_5.png)

