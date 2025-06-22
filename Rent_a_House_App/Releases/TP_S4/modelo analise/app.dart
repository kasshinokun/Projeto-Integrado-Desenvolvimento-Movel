// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart'; // For simple hashing demonstration (NOT for passwords!)
import 'dart:convert'; // For utf8.encode

import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/bluetooth/bluetooth_control_screen.dart';
import 'screens/property/property_detail_screen.dart';
import 'screens/property/add_property_screen.dart';
import 'screens/history/rental_history_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/about/about_app_screen.dart';
import 'services/local_auth_service.dart';
// import 'firebase_options.dart'; // Uncomment and set your actual Firebase options
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:real_estate_app/services/local_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  final database = openDatabase(
    join(await getDatabasesPath(), 'real_estate_app.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE properties(id TEXT PRIMARY KEY, title TEXT, price REAL, description TEXT, imageUrl TEXT)',
      );
      await db.execute(
        '''
        CREATE TABLE users(
          uid TEXT PRIMARY KEY,
          email TEXT NOT NULL,
          passwordHash TEXT,
          role TEXT NOT NULL,
          ownerPublicKey TEXT,
          clientKey TEXT,
          rentedHouseId TEXT,
          lastSync INTEGER
        )
        ''',
      );
    },
    version: 1,
  );

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Future<Database> database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),
        Provider<FirebaseFirestore>(create: (_) => FirebaseFirestore.instance),
        Provider<FirebaseDatabase>(create: (_) => FirebaseDatabase.instance),
        Provider<Future<Database>>(create: (_) => database),
        ProxyProvider<Future<Database>, LocalAuthService>(
          update: (context, dbFuture, previousService) =>
              LocalAuthService(dbFuture),
        ),
      ],
      child: MaterialApp(
        title: 'Real Estate App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Inter',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
          ),
          cardTheme: CardTheme(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 3,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.blue.withOpacity(0.05),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return FutureBuilder(
                future: Provider.of<LocalAuthService>(context, listen: false)
                    .syncUserDataWithFirestore(
                        snapshot.data!, Provider.of<FirebaseFirestore>(context, listen: false)),
                builder: (context, syncSnapshot) {
                  if (syncSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Synchronizing user data...'),
                          ],
                        ),
                      ),
                    );
                  }
                  return const HomeScreen();
                },
              );
            }
            return const AuthScreen();
          },
        ),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/chat': (context) => const ChatScreen(),
          '/bluetooth_control': (context) => const BluetoothControlScreen(),
          '/property_detail': (context) => const PropertyDetailScreen(),
          '/add_property': (context) => const AddPropertyScreen(),
          '/rental_history': (context) => const RentalHistoryScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/about_app': (context) => const AboutAppScreen(),
        },
      ),
    );
  }
}

// services/local_auth_service.dart

class LocalUser {
  final String uid;
  final String email;
  final String? passwordHash;
  final String role;
  final String? ownerPublicKey;
  final String? clientKey;
  final String? rentedHouseId;
  final DateTime? lastSync;

  LocalUser({
    required this.uid,
    required this.email,
    this.passwordHash,
    required this.role,
    this.ownerPublicKey,
    this.clientKey,
    this.rentedHouseId,
    this.lastSync,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'passwordHash': passwordHash,
      'role': role,
      'ownerPublicKey': ownerPublicKey,
      'clientKey': clientKey,
      'rentedHouseId': rentedHouseId,
      'lastSync': lastSync?.millisecondsSinceEpoch,
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      uid: map['uid'],
      email: map['email'],
      passwordHash: map['passwordHash'],
      role: map['role'],
      ownerPublicKey: map['ownerPublicKey'],
      clientKey: map['clientKey'],
      rentedHouseId: map['rentedHouseId'],
      lastSync: map['lastSync'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSync'])
          : null,
    );
  }
}

class LocalAuthService {
  final Future<Database> database;

  LocalAuthService(this.database);

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> saveUserDataLocally(User firebaseUser,
      {String? password, String? role, String? ownerPublicKey, String? clientKey, String? rentedHouseId}) async {
    final db = await database;
    final hashedPassword = password != null ? _hashPassword(password) : null;

    final userData = LocalUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      passwordHash: hashedPassword,
      role: role ?? 'client',
      ownerPublicKey: ownerPublicKey,
      clientKey: clientKey,
      rentedHouseId: rentedHouseId,
      lastSync: DateTime.now(),
    ).toMap();

    await db.insert(
      'users',
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('User data saved/updated locally for ${firebaseUser.email}');
  }

  Future<LocalUser?> authenticateLocally(String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND passwordHash = ?',
      whereArgs: [email, hashedPassword],
    );

    if (maps.isNotEmpty) {
      print('Offline login successful for $email');
      return LocalUser.fromMap(maps.first);
    }
    print('Offline login failed for $email');
    return null;
  }

  Future<LocalUser?> getUserDataLocally(String uid) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'uid = ?',
      whereArgs: [uid],
    );

    if (maps.isNotEmpty) {
      return LocalUser.fromMap(maps.first);
    }
    return null;
  }

  Future<void> clearLocalUserData() async {
    final db = await database;
    await db.delete('users');
    print('Local user data cleared.');
  }

  Future<void> syncUserDataWithFirestore(User firebaseUser, FirebaseFirestore firestore) async {
    try {
      final userDoc = await firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final role = userData['role'] as String? ?? 'client';
        final ownerPublicKey = userData['ownerPublicKey'] as String?;
        final clientKey = userData['clientKey'] as String?;
        final rentedHouseId = userData['rentedHouseId'] as String?;

        await saveUserDataLocally(
          firebaseUser,
          role: role,
          ownerPublicKey: ownerPublicKey,
          clientKey: clientKey,
          rentedHouseId: rentedHouseId,
        );
        print('User data synced from Firestore to SQFLite.');
      } else {
        print('User profile not found in Firestore. Saving basic data locally.');
        await saveUserDataLocally(firebaseUser);
      }
    } catch (e) {
      print('Error syncing user data with Firestore: $e');
    }
  }
}

// screens/auth/auth_screen.dart

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  String? _errorMessage;
  bool _isLoading = false;

  Future<bool> _isTrulyOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    final bool hasNetworkInterface = connectivityResult != ConnectivityResult.none;

    if (!hasNetworkInterface) {
      return false;
    }

    bool hasInternet = await InternetConnection().hasInternetAccess;
    return hasInternet;
  }

  Future<void> _submitAuthForm() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    final firestore = Provider.of<FirebaseFirestore>(context, listen: false);
    final localAuthService = Provider.of<LocalAuthService>(context, listen: false);

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final bool isTrulyOnline = await _isTrulyOnline();

    try {
      if (_isLogin) {
        if (isTrulyOnline) {
          try {
            final userCredential = await auth.signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );
            await localAuthService.syncUserDataWithFirestore(userCredential.user!, firestore);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'network-request-failed' || !isTrulyOnline) {
              print('Network issue detected. Attempting offline login...');
              final localUser = await localAuthService.authenticateLocally(
                _emailController.text,
                _passwordController.text,
              );
              if (localUser != null) {
                setState(() => _errorMessage = 'Logged in offline. Data may be outdated.');
              } else {
                setState(() => _errorMessage = 'No internet connection and no cached login found. Please connect to the internet or check credentials.');
              }
            } else {
              setState(() => _errorMessage = e.message);
            }
          }
        } else {
          print('Device is truly offline. Attempting offline login...');
          final localUser = await localAuthService.authenticateLocally(
            _emailController.text,
            _passwordController.text,
          );
          if (localUser != null) {
            setState(() => _errorMessage = 'Logged in offline. Data may be outdated.');
          } else {
            setState(() => _errorMessage = 'No internet connection and no cached login found. Please connect to the internet or check credentials.');
          }
        }
      } else {
        if (!isTrulyOnline) {
          setState(() => _errorMessage = 'Sign up requires an internet connection.');
          return;
        }
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'role': 'client',
          'createdAt': FieldValue.serverTimestamp(),
        });
        await localAuthService.saveUserDataLocally(
          userCredential.user!,
          password: _passwordController.text,
          role: 'client',
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
      print('General Error: $_errorMessage');
    } finally {
      setState(() {
        _isLoading = false;
      });
      if (_errorMessage == null || _errorMessage!.contains('Logged in offline')) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isLogin ? 'Welcome Back!' : 'Join Us!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submitAuthForm,
                              child: Text(_isLogin ? 'Login' : 'Sign Up'),
                            ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                            _errorMessage = null;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have an account'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// screens/home/home_screen.dart


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocalUser? _localUser;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _houseCategories = [
    'Apartment',
    'House',
    'Beach House',
    'Country House',
  ];

  @override
  void initState() {
    super.initState();
    _loadLocalUserData();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadLocalUserData() async {
    final localAuthService = Provider.of<LocalAuthService>(context, listen: false);
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final user = await localAuthService.getUserDataLocally(firebaseUser.uid);
      setState(() {
        _localUser = user;
      });
    }
  }

  Future<bool> _isTrulyOnline() async {
    return await InternetConnection().hasInternetAccess;
  }

  Future<List<House>> _fetchProperties([String? category]) async {
    final firestore = Provider.of<FirebaseFirestore>(context, listen: false);
    final db = await Provider.of<Future<Database>>(context, listen: false);
    List<House> properties = [];

    final bool online = await _isTrulyOnline();

    if (online) {
      try {
        Query query = firestore.collection('properties');
        if (category != null) {
          query = query.where('category', isEqualTo: category);
        }
        final querySnapshot = await query.get();
        properties = querySnapshot.docs.map((doc) => House.fromMap(doc.data(), doc.id)).toList();

      } catch (e) {
        print('Error fetching from Firestore: $e');
        if (category != null) {
          final List<Map<String, dynamic>> cachedPropertiesMaps =
              await db.query('properties', where: 'category = ?', whereArgs: [category]);
          properties = cachedPropertiesMaps.map((map) => House.fromMap(map, map['id'])).toList();
          print('Loaded properties for category "$category" from local cache.');
        } else {
          final List<Map<String, dynamic>> cachedPropertiesMaps = await db.query('properties');
          properties = cachedPropertiesMaps.map((map) => House.fromMap(map, map['id'])).toList();
          print('Loaded all properties from local cache.');
        }
      }
    } else {
      if (category != null) {
        final List<Map<String, dynamic>> cachedPropertiesMaps =
            await db.query('properties', where: 'category = ?', whereArgs: [category]);
        properties = cachedPropertiesMaps.map((map) => House.fromMap(map, map['id'])).toList();
        print('Offline: Loaded properties for category "$category" from local cache.');
      } else {
        final List<Map<String, dynamic>> cachedPropertiesMaps = await db.query('properties');
        properties = cachedPropertiesMaps.map((map) => House.fromMap(map, map['id'])).toList();
        print('Offline: Loaded all properties from local cache.');
      }
    }
    return properties;
  }

  Widget _buildPropertyListView(List<House> properties, BuildContext context) {
    if (properties.isEmpty) {
      return const Center(child: Text('No properties available for this category.'));
    }
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    property.imageUrls.isNotEmpty
                        ? property.imageUrls[0]
                        : 'https://placehold.co/600x400/CCCCCC/FFFFFF?text=No+Image',
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  property.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${property.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  property.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PropertyDetailScreen(property: property),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuth>(context);
    final bool isLoggedIn = auth.currentUser != null;
    final bool isOwner = _localUser?.role == 'owner';
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Estate Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () {
              Navigator.of(context).pushNamed('/bluetooth_control');
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              if (!isLoggedIn) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please log in to access chat.')),
                );
              } else {
                Navigator.of(context).pushNamed('/chat');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              Provider.of<LocalAuthService>(context, listen: false).clearLocalUserData();
            },
          ),
        ],
      ),
      drawer: orientation == Orientation.landscape
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _localUser?.email ?? 'Guest User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Role: ${_localUser?.role ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        if (_localUser?.rentedHouseId != null && _localUser!.rentedHouseId!.isNotEmpty)
                          Text(
                            'Rented House: ${_localUser!.rentedHouseId}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.app_registration),
                    title: const Text('Property Registry'),
                    onTap: () {
                      Navigator.pop(context);
                      if (!isLoggedIn || !isOwner) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Only owners can register properties.')),
                        );
                      } else {
                        Navigator.of(context).pushNamed('/add_property');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Rental History'),
                    onTap: () {
                      Navigator.pop(context);
                      if (!isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please log in to view rental history.')),
                        );
                      } else {
                        Navigator.of(context).pushNamed('/rental_history');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      if (!isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please log in to view your profile.')),
                        );
                      } else {
                        Navigator.of(context).pushNamed('/profile');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bluetooth),
                    title: const Text('Smart Lock Control'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/bluetooth_control');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About App'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/about_app');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      Navigator.pop(context);
                      await auth.signOut();
                      Provider.of<LocalAuthService>(context, listen: false).clearLocalUserData();
                    },
                  ),
                ],
              ),
            )
          : null,
      body: orientation == Orientation.portrait
          ? Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _houseCategories.length,
                    itemBuilder: (context, index) {
                      final category = _houseCategories[index];
                      return FutureBuilder<List<House>>(
                        future: _fetchProperties(category),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No properties of type "$category" available.'));
                          }
                          return _buildPropertyListView(snapshot.data!, context);
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          : FutureBuilder<List<House>>(
              future: _fetchProperties(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No properties available.'));
                }
                return _buildPropertyListView(snapshot.data!, context);
              },
            ),
      bottomNavigationBar: orientation == Orientation.portrait
          ? BottomNavigationBar(
              currentIndex: _currentPage,
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              items: _houseCategories.map((category) {
                IconData icon;
                switch (category) {
                  case 'Apartment':
                    icon = Icons.apartment;
                    break;
                  case 'House':
                    icon = Icons.home;
                    break;
                  case 'Beach House':
                    icon = Icons.beach_access;
                    break;
                  case 'Country House':
                    icon = Icons.nature_people;
                    break;
                  default:
                    icon = Icons.category;
                }
                return BottomNavigationBarItem(
                  icon: Icon(icon),
                  label: category,
                );
              }).toList(),
            )
          : null,
      floatingActionButton: isLoggedIn && isOwner && orientation == Orientation.portrait
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/add_property');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// screens/chat/chat_screen.dart


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
  final String _chatId = 'example_chat_id';

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final database = Provider.of<FirebaseDatabase>(context, listen: false);
    final messageText = _messageController.text;
    _messageController.clear();

    final newMessageRef = database.ref('chats/$_chatId/messages').push();
    await newMessageRef.set({
      'senderId': _currentUserId,
      'text': messageText,
      'timestamp': ServerValue.timestamp,
    });

    await database.ref('chats/$_chatId').update({
      'lastMessage': messageText,
      'lastMessageTimestamp': ServerValue.timestamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirebaseDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: database.ref('chats/$_chatId/messages').onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messagesData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                final messages = messagesData.entries.map((e) {
                  return {
                    'id': e.key,
                    ...(e.value as Map<dynamic, dynamic>),
                  };
                }).toList()
                  ..sort((a, b) => (a['timestamp'] as num).compareTo(b['timestamp'] as num));

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == _currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Card(
                        color: isMe ? Colors.blue[100] : Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['text'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTimestamp(message['timestamp']),
                                style: const TextStyle(fontSize: 10, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// screens/bluetooth/bluetooth_control_screen.dart


class BluetoothControlScreen extends StatefulWidget {
  const BluetoothControlScreen({Key? key}) : super(key: key);

  @override
  State<BluetoothControlScreen> createState() => _BluetoothControlScreenState();
}

class _BluetoothControlScreenState extends State<BluetoothControlScreen> {
  String _bluetoothStatus = 'Not Connected';
  String _lastCommandStatus = '';
  LocalUser? _localUser;

  @override
  void initState() {
    super.initState();
    _loadLocalUserData();
    _initBluetooth();
  }

  Future<void> _loadLocalUserData() async {
    final localAuthService = Provider.of<LocalAuthService>(context, listen: false);
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final user = await localAuthService.getUserDataLocally(firebaseUser.uid);
      setState(() {
        _localUser = user;
      });
    }
  }

  void _initBluetooth() async {
    setState(() => _bluetoothStatus = 'Bluetooth Not Implemented (Conceptual)');
  }

  Future<void> _sendCommand(String command) async {
    try {
      final data = command.codeUnits;
      setState(() => _lastCommandStatus = 'Sent command: "$command"');
      print('Simulating command "$command" sent to ESP32');
    } catch (e) {
      setState(() => _lastCommandStatus = 'Failed to send command: $e');
      print('Simulating command "$command" failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null || _localUser != null;
    final bool isOwner = _localUser?.role == 'owner';

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Smart Lock Control')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Please log in to access smart lock control features.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Lock Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bluetooth Status:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(_bluetoothStatus, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text('Last Command Status:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(_lastCommandStatus, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Send Commands:',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (isOwner) ...[
              ElevatedButton.icon(
                onPressed: () => _sendCommand('ADD_OWNER_CMD:USER_ID_XYZ'),
                icon: const Icon(Icons.person_add),
                label: const Text('Add Owner'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _sendCommand('OPEN_DOOR_OWNER_CMD'),
                icon: const Icon(Icons.lock_open),
                label: const Text('Open Door (Owner)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
              const SizedBox(height: 12),
            ],
            ElevatedButton.icon(
              onPressed: () => _sendCommand('OPEN_DOOR_CLIENT_CMD:TEMP_TOKEN_123'),
              icon: const Icon(Icons.vpn_key),
              label: const Text('Open Door (Client)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Note: Bluetooth functionality is conceptual. Requires `flutter_blue_plus` and ESP32 firmware.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// screens/property/property_detail_screen.dart


class PropertyDetailScreen extends StatelessWidget {
  final House property;

  const PropertyDetailScreen({Key? key, required this.property}) : super(key: key);

  void _showLoginRequiredSnackBar(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please log in or register to $action this property.'),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () {
            Navigator.of(context).pushNamed('/auth');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (property.imageUrls.isNotEmpty)
              property.imageUrls.length > 1
                  ? SizedBox(
                      height: 250,
                      child: PageView.builder(
                        itemCount: property.imageUrls.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              property.imageUrls[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 250,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: const Center(child: Icon(Icons.broken_image, size: 50)),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        property.imageUrls[0],
                        fit: BoxFit.cover,
                        height: 250,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.broken_image, size: 50)),
                        ),
                      ),
                    )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://placehold.co/600x400/CCCCCC/FFFFFF?text=No+Image',
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image, size: 50)),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              property.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${property.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.green[700]),
            ),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              property.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Category: ${property.category}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Rooms: ${property.numberOfRooms}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Address: ${property.street}, ${property.houseNumber} ${property.complement.isNotEmpty ? ' - ${property.complement}' : ''}, ${property.neighborhood}, ${property.city} - ${property.state}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!isLoggedIn) {
                        _showLoginRequiredSnackBar(context, 'rent');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Attempting to rent ${property.title} (Not implemented)')),
                        );
                        print('Rent property: ${property.title}');
                      }
                    },
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('Rent This House'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!isLoggedIn) {
                        _showLoginRequiredSnackBar(context, 'message the owner/agent about');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening chat for ${property.title} (Not implemented)')),
                        );
                        print('Message owner for property: ${property.title}');
                      }
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Message Owner'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// screens/property/add_property_screen.dart


class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({Key? key}) : super(key: key);

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _hasComplement = false;
  String? _selectedCategory;
  List<File> _selectedImages = [];
  bool _isLoading = false;
  final PageController _imageCarouselController = PageController();

  final List<String> _houseCategories = [
    'Apartment',
    'House',
    'Beach House',
    'Country House',
  ];

  @override
  void dispose() {
    _cepController.dispose();
    _streetController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _houseNumberController.dispose();
    _complementController.dispose();
    _roomsController.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _imageCarouselController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only select up to 5 images.')),
      );
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _fetchAddressFromCep() async {
    final cep = _cepController.text.replaceAll('-', '');
    if (cep.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 8-digit CEP.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('erro')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('CEP not found or invalid.')),
          );
          _clearAddressFields();
        } else {
          _streetController.text = data['logradouro'] ?? '';
          _neighborhoodController.text = data['bairro'] ?? '';
          _cityController.text = data['localidade'] ?? '';
          _stateController.text = data['uf'] ?? '';
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching address: ${response.statusCode}')),
        );
        _clearAddressFields();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to Viacep API: $e')),
      );
      _clearAddressFields();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearAddressFields() {
    _streetController.clear();
    _neighborhoodController.clear();
    _cityController.clear();
    _stateController.clear();
  }

  Future<void> _registerProperty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final firestore = Provider.of<FirebaseFirestore>(context, listen: false);
    final firebaseAuth = Provider.of<FirebaseAuth>(context, listen: false);
    final currentUser = firebaseAuth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to register a property.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      List<String> imageUrls = [];
      for (int i = 0; i < _selectedImages.length; i++) {
        final file = _selectedImages[i];
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('property_images')
            .child('${currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
        await storageRef.putFile(file);
        final downloadUrl = await storageRef.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      final newProperty = House(
        id: '',
        ownerId: currentUser.uid,
        title: _titleController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        cep: _cepController.text.trim(),
        street: _streetController.text.trim(),
        neighborhood: _neighborhoodController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        houseNumber: int.parse(_houseNumberController.text.trim()),
        complement: _hasComplement ? _complementController.text.trim() : '',
        category: _selectedCategory!,
        numberOfRooms: int.parse(_roomsController.text.trim()),
        description: _descriptionController.text.trim(),
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
      );

      await firestore.collection('properties').add(newProperty.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property registered successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering property: $e')),
      );
      print('Property registration error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Property'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Property Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a property title.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cepController,
                      decoration: InputDecoration(
                        labelText: 'CEP (e.g., 01001000)',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _fetchAddressFromCep,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 9,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a CEP.';
                        }
                        if (value.replaceAll('-', '').length != 8) {
                          return 'CEP must be 8 digits.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _streetController,
                      decoration: const InputDecoration(labelText: 'Street'),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _neighborhoodController,
                      decoration: const InputDecoration(labelText: 'Neighborhood'),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(labelText: 'City'),
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: const InputDecoration(labelText: 'State'),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _houseNumberController,
                      decoration: const InputDecoration(labelText: 'House Number'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter house number.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _hasComplement,
                          onChanged: (bool? value) {
                            setState(() {
                              _hasComplement = value ?? false;
                              if (!_hasComplement) {
                                _complementController.clear();
                              }
                            });
                          },
                        ),
                        const Text('Has Complement?'),
                      ],
                    ),
                    if (_hasComplement)
                      TextFormField(
                        controller: _complementController,
                        decoration: const InputDecoration(labelText: 'Complement'),
                      ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: _houseCategories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _roomsController,
                      decoration: const InputDecoration(labelText: 'Number of Rooms'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter number of rooms.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Brief Description'),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a brief description.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Property Images (Max 5):',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Add Image'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedImages.isNotEmpty)
                      SizedBox(
                        height: 200.0,
                        child: PageView.builder(
                          controller: _imageCarouselController,
                          itemCount: _selectedImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final imageFile = _selectedImages[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      imageFile,
                                      fit: BoxFit.cover,
                                      width: 1000.0,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.red.withOpacity(0.7),
                                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    if (_selectedImages.isEmpty)
                      const Center(
                        child: Text('No images selected.', style: TextStyle(color: Colors.grey)),
                      ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _registerProperty,
                        icon: const Icon(Icons.upload_file),
                        label: Text(_isLoading ? 'Registering...' : 'Register Property'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// screens/history/rental_history_screen.dart (Placeholder)


class RentalHistoryScreen extends StatelessWidget {
  const RentalHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental History'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                'Your rental history will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                'This screen is a placeholder. Future development will include fetching and displaying past rentals.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// screens/profile/profile_screen.dart (Placeholder)

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LocalUser? _localUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final localAuthService = Provider.of<LocalAuthService>(context, listen: false);
      final user = await localAuthService.getUserDataLocally(firebaseUser.uid);
      setState(() {
        _localUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _localUser == null && firebaseUser == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: const Icon(Icons.person, size: 80, color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User Information', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(height: 20, thickness: 1),
                          _buildProfileInfoRow('Email:', _localUser?.email ?? firebaseUser?.email ?? 'N/A'),
                          _buildProfileInfoRow('User ID:', _localUser?.uid ?? firebaseUser?.uid ?? 'N/A'),
                          _buildProfileInfoRow('Role:', _localUser?.role ?? 'N/A'),
                          if (_localUser?.rentedHouseId != null && _localUser!.rentedHouseId!.isNotEmpty)
                            _buildProfileInfoRow('Rented House ID:', _localUser!.rentedHouseId!),
                          if (_localUser?.ownerPublicKey != null && _localUser!.ownerPublicKey!.isNotEmpty)
                            _buildProfileInfoRow('Owner Public Key:', _localUser!.ownerPublicKey!),
                          if (_localUser?.clientKey != null && _localUser!.clientKey!.isNotEmpty)
                            _buildProfileInfoRow('Client Key:', _localUser!.clientKey!),
                          _buildProfileInfoRow('Last Sync:', _localUser?.lastSync?.toLocal().toString() ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit Profile (Not implemented)')),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// screens/about/about_app_screen.dart (Placeholder)

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Real Estate App'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.real_estate_agent, size: 100, color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            Text(
              'Real Estate App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Real Estate App, your ultimate companion for finding, listing, and managing properties with ease. Our application seamlessly integrates property browsing with advanced features like in-app chat and smart lock control for a modern real estate experience.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildFeaturePoint('Browse a wide range of property listings.'),
            _buildFeaturePoint('Advanced search and filtering options.'),
            _buildFeaturePoint('Direct in-app messaging with property owners/agents.'),
            _buildFeaturePoint('Secure smart lock control via ESP32 Bluetooth integration (for authorized users).'),
            _buildFeaturePoint('Offline login and data caching for seamless experience.'),
            _buildFeaturePoint('Responsive UI adapting to device orientation.'),
            SizedBox(height: 20),
            Text(
              'Developed by: Gemini AI',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            Text(
              'Contact: support@realestateapp.com',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                '© 2024 Real Estate App. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFeaturePoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

// models/property_models.dart


/// Represents a single real estate property listing.
class House {
  final String id; // Document ID from Firestore
  final String ownerId;
  final String title;
  final double price;
  final String cep;
  final String street;
  final String neighborhood;
  final String city;
  final String state;
  final int houseNumber;
  final String complement; // Empty string if no complement
  final String category;
  final int numberOfRooms;
  final String description;
  final List<String> imageUrls; // List of image URLs
  final DateTime createdAt;

  House({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.price,
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.houseNumber,
    this.complement = '', // Default to empty string
    required this.category,
    required this.numberOfRooms,
    required this.description,
    required this.imageUrls,
    required this.createdAt,
  });

  /// Factory constructor to create a House object from a Firestore document snapshot.
  factory House.fromMap(Map<String, dynamic> data, String documentId) {
    return House(
      id: documentId,
      ownerId: data['ownerId'] as String? ?? '',
      title: data['title'] as String? ?? 'N/A Title',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      cep: data['cep'] as String? ?? '',
      street: data['street'] as String? ?? '',
      neighborhood: data['bairro'] as String? ?? '', // Corrected key for neighborhood
      city: data['cidade'] as String? ?? '', // Assuming 'cidade' might be used from Viacep too
      state: data['uf'] as String? ?? '',     // Corrected key for state
      houseNumber: (data['houseNumber'] as num?)?.toInt() ?? 0,
      complement: data['complement'] as String? ?? '',
      category: data['category'] as String? ?? 'Other',
      numberOfRooms: (data['numberOfRooms'] as num?)?.toInt() ?? 0,
      description: data['description'] as String? ?? 'No description available.',
      imageUrls: List<String>.from(data['imageUrls'] as List<dynamic>? ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converts a House object to a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'title': title,
      'price': price,
      'cep': cep,
      'street': street,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'houseNumber': houseNumber,
      'complement': complement,
      'category': category,
      'numberOfRooms': numberOfRooms,
      'description': description,
      'imageUrls': imageUrls,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

/// Represents a rental transaction for a house.
class Rent {
  final String id; // Document ID from Firestore
  final String houseId;
  final String clientId;
  final DateTime startDate;
  final DateTime endDate;
  final double calculatedPrice; // Price based on duration

  Rent({
    required this.id,
    required this.houseId,
    required this.clientId,
    required this.startDate,
    required this.endDate,
    required this.calculatedPrice,
  });

  /// Factory constructor to create a Rent object from a Firestore document snapshot.
  factory Rent.fromMap(Map<String, dynamic> data, String documentId) {
    return Rent(
      id: documentId,
      houseId: data['houseId'] as String? ?? '',
      clientId: data['clientId'] as String? ?? '',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      calculatedPrice: (data['calculatedPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts a Rent object to a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'houseId': houseId,
      'clientId': clientId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'calculatedPrice': calculatedPrice,
    };
  }
}
