import 'package:flutter/material.dart'

class CustomSearchDelegate extends SearchDelegate<String>{
  //Buscará em uma lista(pode ser List<Strings>) => addressItens

  //---> Objetivos em aberto 
  //Deixar searchdelegate transparente sem destruir a página anterior
  //---> Fim dos objetivos em aberto 
  
  //Customizando o SearchDelegate
  final String? hintText;
  final List<String>? listAddress;
  String resultado;//coleta do valor selecionado 
  
  CustomSearchDelegate({this.hintText, this.listAddress}): super(
          //searchFieldLabel: hintText, // Descomente em caso derro
          keyboardType: TextInputType.text,
          searchFieldStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        );
  
  ///* Em caso de erro, deixe este trecho comentado
  @override
  String? get searchFieldLabel => hintText;
  //*/Fim do trecho 
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
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
        },
        icon: Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, resultado); //retorno da busca 
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = []; //Coleta os resultados
    for (var address in listAddress) {
      if (address.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(address);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap(){
            resultado=result;
            close(context, resultado);
          }
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = []; //Coleta os resultados
    for (var address in listAddress) {
      if (address.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(address);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap(){
            query=result;
          }
        );
      },
    );
  }
}
    
    
    
    
    
    
    
    
    
    
//================================================================================    
    
