import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/s1/pages/manage/renthouse.dart';

List<String> searchImagesItems = [
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

class CustomSearchDelegate extends SearchDelegate<String> {
  //Buscará em uma lista(pode ser List<Strings>) => addressItens

  //---> Objetivos em aberto
  //Deixar searchdelegate transparente sem destruir a página anterior
  //---> Fim dos objetivos em aberto

  //Customizando o SearchDelegate
  final String? hintText;
  final List<String> listAddress;

  CustomSearchDelegate({
    required this.hintText,
    required this.listAddress,
    //required this.searchController, //teste retorno
  }) : super(
         //searchFieldLabel: hintText, // Descomente em caso derro
         keyboardType: TextInputType.text,
         textInputAction: TextInputAction.search,
         searchFieldStyle: TextStyle(
           color: Colors.black,
           fontWeight: FontWeight.bold,
         ),
       );

  TextEditingController searchController =
      TextEditingController(); //teste retorno

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
        //este trecho estava repetido na versão 1.4-04-04-2025
        //e pode ser a causa da tela vermelha ao sair da busca
        //(pois somente este processo gerencia a saída da busca)
        close(context, query); //retorno da busca
        //close(context, searchController.text); //retorno da busca
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
            //close(context, searchController.text);
            close(context, matchQuery[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Construindo o sistema de busca de sugestões.
    List<String> suggestionList = [];
    List<String> imageSuggestionList = [];
    for (int i = 0; i < listAddress.length; i++) {
      if (listAddress[i].toLowerCase().contains(query.toLowerCase())) {
        //Pega o endereço correspondente
        suggestionList.add(listAddress[i]);
        //Pega a url da imagem principal correspondente
        imageSuggestionList.add(searchImagesItems[i]);
      }
    }

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            // Mostrar os resultados da pesquisa com base na sugestão selecionada.
            query = suggestionList[index];
            //atribui a url da imagem principal correspondente
            searchController.text = imageSuggestionList[index];
            //Objetivo: ao receber o valor busca
            //o índice e envia a um Scafold que
            //carregará todos os dados do imóvel
            //a ser alugado
            Navigator.push(
              //=========> Envia a query a uma página
              //=========> especializada para tratar
              //=========> o resultado da busca (RentScreen)
              context,
              MaterialPageRoute(
                builder:
                    (context) => RentScreen(
                      title: 'Busca - Imovel',
                      url: searchController.text,
                      query: query,
                    ),
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
