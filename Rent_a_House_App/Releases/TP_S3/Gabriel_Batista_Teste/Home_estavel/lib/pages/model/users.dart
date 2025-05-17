class User {
  String username;
  String password;
  String token; //Solicitar do Firebase
  int id;

  User(this.id, this.username, this.password, this.token);

  String get _username => username;
  String get _password => password;
  String get _token => token;
  int get _id => id;

  // Convert a user into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> fromMap() {
    return {
      'id': _id,
      'username': _username,
      'password': _password,
      'token': _token,
    };
  }

  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() {
    return 'User{id: $_id, username: $_username, password: $_password, token: $_token}';
  }
}
