# Guia de instrução básica SQFLite 
Revisão 1-12-05-2025
<br>Atualizações serão feitas no decorrer dos próximos dias 
<br>Por hora está em desenvolvimento 
#### Objetivo:

Apresentar como criar um banco de dados local 
<br>para persistir informações locais e provenientes 
<br>da internet ou do Firebase, o qual será integrado 
<br>a aplicação em Flutter desenvolvida pelo grupo.

#### Criação da classe modelo 

A classe modelo serve de referência para a criação de tabelas.
<br>Então, antes criarmos o banco de dados em SQLite, precisamos
<br>pensar em como será, como instanciar, como atribuir(Insert/Update)
<br>gerir(Delete) e acessar(Read One/Read All).
<br>
<br>Como exemplo, a classe ```Usuario``` precisaria ter:
<br>Id
<br>Nome
<br>Senha
<br>Token
<br>no contexto de receber ```Usuario do Firebase``` e persistir no SQLite.
<br>
```
//Model
class UsersFirebase{
  int? idUser; //o termo "?" permite ser iniciado nulo ou não
  String? nameUser;  //Evitando erros de interpretação pela IDE
  String? passwordUser; //que exige um valor associado na instancia
  String? tokenUser; //da variável em alguns casos
}
```

#### Preparação do banco de dados 

Para usar o SQLite no Flutter, primeiro adicione ao ```pubspec.yaml```
<br>as seguintes bibliotecas:
<br>```path```, basta escrever que o VS Code completa o restante das informações
<br>```path_provider```, basta escrever que o VS Code completa o restante das informações
<br>
<br>```sqflite```, esta biblioteca exige que rode:
<br>```flutter pub add sqflite```
<br>

#### Criação do banco de dados 
Crie o arquivo e adicione os seguintes imports:

O banco de dados é criado como uma classe, 
<br>para deixar dinâmico e facilitar mudanças
<br>farei a criação baseada em variáveis e não em texto
<br>propriamente dito
```
//DAO
class UsersFirebaseDBHelper {
  /*
  //------------------------------------OBSERVAÇÃO IMPORTANTE------------------------------------------\\
    A criação do banco de dados deve ocorrer apenas na primeira vez que o programa iniciar, não deixe
    alguns metodos publicos para evitar erros, e o contrutor deve ser privado.
  \\---------------------------------------------------------------------------------------------------//
  */
  //Use nome iguais inicialmente entre as classes para facilitar a identificação
  //e atribuição
  UsersFirebaseDBHelper._(); //Construtor privado

  static const tableName = 'usersFirebase';//Nome da Tabela

  static const columnIdUser = 'idUser';
  static const columnNameUser = 'nameUser';
  static const columnPasswordUser = 'passwordUser';
  static const columnTokenUser = 'tokenUser';

  //Atribui uma variável estática da classe          
  static final UsersFirebaseDBHelper instance = UsersFirebaseDBHelper._();

  //Demais detalhes do banco de dados
  static const _dbName = 'rentahouse.db'; //o sufixo do arquivo SQLite em geral
                                          //é sempre ".db"
  static const _dbVersion = 1;//versão é importante em processos como fetch e similares

  Database? _database;//Istancia a variável estática

  Future<Database> get database async {//Como é um processo assícrono, precisamos usar 
    //"Future<CLASSE_OBJETO>" e terminar com "async", o metodo get é importante para
    //checagem e criação do banco em tempo de execução(runtime)
    if (_database != null) {
      return _database!;//Se não for nulo retorna o banco
    }
    _database = await _initDatabase();//Inicia a criação do banco de dados
    return _database!;//E retorna o banco
  }

  Future<Database> _initDatabase() async {//Processo de criação do banco
    String directory = await getDatabasesPath();//Pasta padrão da aplicação
    String path = join(directory, _dbName);//variavel para caminho do arquivo 
                                           //baseada na pasta e nome do arquivo
    return openDatabase(
      path,//Caminho
      version: _dbVersion,//versão
      onCreate: _onCreate,//SQL de Criação de tabela
      //pode ser criar várias, basta adicionar a "await"'s a função
      onConfigure: _onConfigure,//Configurações adicionais e importantes
    );
  }

  Future _onCreate(Database db, int version) async {//Processo de criação da tabela similar ao SQL
    await db.execute('''
      CREATE TABLE $tableName (
      $columnIdUser         INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnNameUser       TEXT    NOT NULL,
      $columnPasswordUser   TEXT    NOT NULL,
      $columnTokenUser      TEXT    NOT NULL)
      ''');
  }
  //SQLite só aceita:
  //----------------->INTEGER(usá-se Int também para data, pois o SQLite não trabalha com DateTime)
  //----------------->REAL(para Float e Double)
  //----------------->TEXT

Future _onConfigure(Database db) async {//Configurações adicionais e importantes
    await db.execute('PRAGMA foreign_keys = ON');
  }

//------------------------------------->Processos CRUD Banco de Dados 
//Create:
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return db.insert(tableName, row);
  }```

//Read All:
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return db.query(tableName);
  }```

//Read One:
  Future<Map<String, dynamic>> queryById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results =
        await db.query(tableName, where: '$columnId = ?', whereArgs: [id]);

    return results.single;
  }

//Update:
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return db.update(
      tableName,
      row,
      where: '$columnId = ?',
      whereArgs: [row[columnId]],
    );
  }

//Delete:
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
```

#### Classe Ponte entre Classe Modelo e Classe Banco de Dados

```
//DAO Helper
class UsersFirebaseHelper {
  //Variavel da Classe Banco de Dados
  final UsersFirebaseDBHelper _dbHelper = UsersFirebaseDBHelper.instance;
  
  //------------------------------------->Processos CRUD Banco de Dados 
  //Create:
  Future<int> insert(UsersFirebase usersfirebase) async {
    return _dbHelper.insert(toMap(message));
  }
  //Read One:
  Future<UsersFirebase> queryById(int id) async {
    return fromMap(await _dbHelper.queryById(id));
  }

  //Read All:
  Future<List<UsersFirebase>> queryAll() async {
    List<Map<String, dynamic>> usersFirebaseMapList = await _dbHelper.queryAll();
    return usersFirebaseMapList.map((e) => fromMap(e)).toList();
  }
  //Delete:
  Future<int> delete(int id) async {
    return _dbHelper.delete(id);
  }
  //Update
  Future<int> update(UsersFirebase usersfirebase) async {
    return _dbHelper.update(toMap(Message));
  }

  //--------------------------------------> Processos Modelo-Banco e Banco-Modelo
  //Envio do Modelo ao Banco de Dados
  Map<String, dynamic> toMap(UsersFirebase usersfirebase) {
    return {
         
      UsersFirebaseDBHelper.columnIdUser: usersfirebase.idUser,
      UsersFirebaseDBHelper.columnNameUser: usersfirebase.nameUser,
      UsersFirebaseDBHelper.columnPasswordUser: usersfirebase.passwordUser,
      UsersFirebaseDBHelper.columnTokenUser: usersfirebase.tokenUser,
      
    };
  }
  //Envio do Banco de Dados ao Modelo
  Message fromMap(Map<String, dynamic> map) {
    return UsersFirebase()
      ..idUser = map[UsersFirebaseDBHelper.columnIdUser] as int
      ..nameUser = map[UsersFirebaseDBHelper.columnNameUser] as String
      ..passwordUser = map[UsersFirebaseDBHelper.columnPasswordUser] as String
      ..tokenUser = map[UsersFirebaseDBHelper.columnTokenUser] as String;
  }
}
```
<br>Caso ouvesse ```DateTime```, por exemplo, a data do último acesso,
<br>teriamos as seguinte alterações adicionadas:
<br>//-----------------> Classe Modelo:
<br>DateTime? dateLastAccess;
<br>
<br>//-----------------> Classe Banco de Dados:
<br>static const columnDateLastAccess = 'dateLastAccess';
<br>
<br>em ```_onCreate```---> $columnDateLastAccess      INTEGER NOT NULL,)
<br>
<br>//-----------------> Classe Auxiliar Banco de Dados-Modelo:
<br>em ```toMap```---> UsersFirebaseDBHelper.columnDateLastAccess: usersfirebase.dateLastAccess?.millisecondsSinceEpoch,
<br>
<br>em ```fromMap```---> ..dateLastAccess = DateTime.fromMillisecondsSinceEpoch(map[UsersFirebaseDBHelper.columnDateLastAccess] as int);
<br>
<br>Para maiores detalhes, por gentileza a documentação do Flutter e do Dart acerca do assunto, este tutorial foi elaborado com base no
<br>código criado por [Muhammad Oktoluqman Fakhrianto](https://lepiku.medium.com/) para o site Medium, [neste post.](https://lepiku.medium.com/flutter-with-sqlite-cf58268a6782)
