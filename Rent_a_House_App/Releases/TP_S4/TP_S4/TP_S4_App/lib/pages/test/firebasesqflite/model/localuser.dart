class LocalUser {
  String? uid;
  String email;
  String displayname;
  String idtoken;

  LocalUser({
    this.uid,
    required this.email,
    required this.displayname,
    required this.idtoken,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayname': displayname,
      'idtoken': idtoken,
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      uid: map['uid'],
      email: map['email'],
      displayname: map['displayname'],
      idtoken: map['idtoken'],
    );
  }
}
