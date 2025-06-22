import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  late final FirebaseAuth _auth;
  late final Future<Database> _database;
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _database = _initDatabase();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
      if (user != null) {
        _storeUserInDatabase(user);
      } else {
        _setLoading(false);
      }
    });
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'rentahouse.db');
    return openDatabase(
      databasePath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users (uid TEXT PRIMARY KEY, email TEXT, displayName TEXT, idToken TEXT)', // Added idToken
        );
      },
      version: 1,
    );
  }

  Future<void> _storeUserInDatabase(User user) async {
    _setLoading(true);
    try {
      final db = await _database;
      // Get the ID token.  This is the key change.
      final idToken = await user.getIdToken();

      await db.insert('users', {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'idToken': idToken, // Store the ID token
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      _showToast('User data stored successfully!');
    } catch (e) {
      _showToast('Failed to store user data: $e');
      print('Error storing user data: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
  }

  Future<void> _signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _showToast('Error signing in: ${e.message}');
      print('Firebase Auth Error: ${e.code} - ${e.message}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    _setLoading(true);
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _storeUserInDatabase(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      _showToast('Error signing up: ${e.message}');
      print('Firebase Auth Error (Sign Up): ${e.code} - ${e.message}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _signOut() async {
    _setLoading(true);
    try {
      await _auth.signOut();
      _showToast('Signed out successfully!');
    } catch (e) {
      _showToast('Error signing out: $e');
      print('Error signing out: $e');
    } finally {
      _setLoading(false);
    }
  }

  void executeLogin(String email, String password) {
    _signInWithEmailAndPassword(email, password);
  }

  void executeRegister(String email, String password) {
    _signUpWithEmailAndPassword(email, password);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.threeArchedCircle(
            color: Colors.blue,
            size: 50,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Authentication'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _user != null
                    ? 'Signed in as ${_user?.email ?? 'Unknown'}'
                    : 'Not signed in',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //Login/Registro sobre a tela
                  showDialog(
                    context: context,
                    builder: (context) {
                      String email = '';
                      String password = '';
                      bool isLogin = true;

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text(isLogin ? 'Login' : 'Sign Up'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) => email = value,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                  ),
                                ),
                                TextField(
                                  obscureText: true,
                                  onChanged: (value) => password = value,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).popAndPushNamed('/auth');
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (isLogin) {
                                    executeLogin(email, password);
                                  } else {
                                    executeRegister(email, password);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text(isLogin ? 'Login' : 'Sign Up'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                                child: Text(
                                  isLogin ? 'Go to Sign Up' : 'Go to Login',
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Text(
                  _user != null ? 'Switch Account' : 'Login / Sign Up',
                ),
              ),
              SizedBox(height: 10),
              if (_user != null)
                ElevatedButton(
                  onPressed: _signOut,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Sign Out'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
