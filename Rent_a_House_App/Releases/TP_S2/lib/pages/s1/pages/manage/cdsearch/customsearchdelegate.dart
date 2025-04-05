import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/s1/pages/manage/renthouse.dart';

/*
List<String> imagesItems = [
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-3.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-4.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-5.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-6.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-7.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-3.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-4.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-5.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-6.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-7.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-3.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-4.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-5.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-6.jpg',
];
*/
class CustomSearchDelegate extends SearchDelegate<String> {
  //Buscará em uma lista(pode ser List<Strings>) => addressItens

  //---> Objetivos em aberto
  //Deixar searchdelegate transparente sem destruir a página anterior
  //---> Fim dos objetivos em aberto

  //Customizando o SearchDelegate
  final String? hintText;
  final List<String> listAddress;
  String resultado = "";
  //final TextEditingController searchController;//teste retorno

  CustomSearchDelegate({required this.hintText, 
    required this.listAddress,
    //required this.searchController //teste retorno 
    })
    : super(
        //searchFieldLabel: hintText, // Descomente em caso derro
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        searchFieldStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );
  //coleta do valor selecionado
  ///* Em caso de erro, deixe este trecho comentado
  @override
  String? get searchFieldLabel => hintText;
  //*/Fim do trecho

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // Constroi o botao limpar.
      ElevatedButton.icon(
        label: Text(
          "Limpar",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          query = '';
          // Quando pressionado a query limpa a partir da search bar.
        },
        icon: Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Constroi o icone no inicio do TextField
    return IconButton(
      // Saindo da tela de pesquisa
      //onPressed: () => Navigator.of(context).pop(),
      onPressed: () {
        close(context, resultado); //retorno da busca //retorno da busca
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Construindo o sistema de busca de resultados.
    final List<String> matchQuery =
        query.isEmpty
            ? []
            : listAddress
                .where(
                  (item) => item.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchQuery[index]),
          onTap: () {
            // Manipula o resultado da pesquisa selecionado.
            //searchController.text = matchQuery[index];
            close(context, matchQuery[index]);
            //close(context, searchController.text);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Construindo o sistema de busca de sugestões.
    final List<String> suggestionList =
        query.isEmpty
            ? []
            : listAddress
                .where(
                  (item) => item.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            // Mostrar os resultados da pesquisa com base na sugestão selecionada.
            query = suggestionList[index];

            //========> Teste de retorno 
            //Exemplo-base: https://stackoverflow.com/questions/61048477/flutter-return-search-delegate-result-string-to-a-textfield
            //
            // Manipula o resultado da pesquisa selecionado.
            //searchController.text = matchQuery[index];
            //close(context, matchQuery[index]);
            //close(context, searchController.text);

            //Objetivo: ao receber o valor busca
            //o índice e envia a um Scafold que
            //carregará todos os dados do imóvel
            //a ser alugado
            Navigator.push(//=========> Futuramente, se possível,
                           //=========> será enviado a página 
                           //=========> especializada para tratar
                           //=========> o resultado da busca 
              context,
              MaterialPageRoute(
                builder:
                    (context) => RentScreen(
                      title: 'Busca - Imovel',
                      index: index,
                      query: query,
                    ),
                //builder: (context) => myScaffold(context, index, query),
              ),
            );
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
        // Use this to change the query's text style
        headlineMedium: TextStyle(fontSize: 20.0, color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,

        // Use this change the placeholder's text style
        hintStyle: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
/*
Widget myScaffold(context, int indexImage, String query) {
  return Scaffold(
    appBar: AppBar(
      //------------------------------------> AppBar
      backgroundColor: Colors.green,
      title: Text('Busca - Imovel'), //Text
    ), //Appbar
    extendBody: true,
    body: GestureDetector(
      onTap: () => Navigator.of(context).pop(),

      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //
        child:
            MediaQuery.of(context).size.width < 600
                //If ternario nos filhos do container
                ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      myContainerSearch(context, indexImage, query),
                      myContainerSearch(context, indexImage, query),
                      myContainerSearch(context, indexImage, query),
                    ],
                  ),
                )
                : Row(
                  children: [
                    myContainerSearch(context, indexImage, query),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          myContainerSearch(context, indexImage, query),
                          myContainerSearch(context, indexImage, query),
                        ],
                      ),
                    ),
                  ],
                ),
        //
      ),
    ),
  );
}

//================================================================================
Widget myContainerSearch(context, int index, String resultado) {
  return Container(
    color: Colors.pink.shade50,
    child: Column(
      children: [
        myPaddingText(
          context,
          "Clique sobre a imagem para voltar",
          Colors.pink,
        ),
        myImageSearch(context, index),
        myPaddingText(context, resultado, Colors.pink),
      ],
    ),
  );
}

Widget myPaddingText(context, String information, Color cor) {
  return Padding(
    padding: EdgeInsets.all(4.0),
    child: Container(
      width:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2.05,
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(9.0),
      ), //
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Center(
          child: Text(
            information,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20.0,
            ), //
          ), //
        ), //
      ),
    ), //
  );
}

Widget myImageSearch(context, int index) {
  return Image.network(
    imagesItems[index],
    fit: BoxFit.cover,
    height:
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height / 2.2
            : MediaQuery.of(context).size.height / 1.55,
    width:
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 2.6,
  );
}
*/