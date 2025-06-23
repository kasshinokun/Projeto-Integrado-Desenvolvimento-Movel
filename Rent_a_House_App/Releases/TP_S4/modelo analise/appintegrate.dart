// main.dart
// This file contains a consolidated version of the Real Estate App,
// combining all screens, models, and services into a single Dart file
// for simplicity and easy sharing.
//
// Note: In a real-world Flutter application, it's highly recommended
// to organize code into multiple files and directories for better
// maintainability, readability, and scalability.

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
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart'; // Import local_auth for biometric authentication

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform, // Uncomment and set your actual Firebase options
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
          // property_detail and add_property use arguments, so routes need to be adapted
          // '/property_detail': (context) => const PropertyDetailScreen(), // Handled by direct navigation
          '/add_property': (context) => const AddPropertyScreen(),
          '/rental_history': (context) => const RentalHistoryScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/about_app': (context) => const AboutAppScreen(),
          '/pix_payment': (context) => const PagamentoPixPage(),
          '/settings': (context) => const SettingsScreen(),
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
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              // Fetch all properties to pass to the search delegate
              // In a real app, you might only pass a subset or implement server-side search
              final allProperties = await _fetchProperties();
              final result = await showSearch<House?>(
                context: context,
                delegate: CustomSearchDelegate(allProperties: allProperties),
              );
              if (result != null) {
                // Navigate to property detail screen if a property is selected
                if (!mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailScreen(property: result),
                  ),
                );
              }
            },
          ),
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
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/settings');
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
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _chatCollection =
  FirebaseFirestore.instance.collection('chat_messages');
  final user = FirebaseAuth.instance.currentUser;

  void _addMessage(String text) {
    if (text.trim().isEmpty || user == null) return;

    _chatCollection.add({
      'text': text.trim(),
      'timestamp': Timestamp.now(),
      'author': user!.email ?? user!.uid, // usa e-mail ou UID
    });

    _controller.clear();
  }

  String _formatTimestamp(Timestamp ts) {
    final dt = ts.toDate();
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirebaseDatabase>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Digite sua mensagem',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _addMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _addMessage(_controller.text),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatCollection
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar mensagens'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(child: Text('Nenhuma mensagem ainda'));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index];
                      return ChatMessageTile(
                        text: data['text'],
                        timestamp: _formatTimestamp(data['timestamp']),
                        author: data['author'] ?? 'Desconhecido',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageTile extends StatelessWidget {
  final String text;
  final String timestamp;
  final String author;

  const ChatMessageTile({
    required this.text,
    required this.timestamp,
    required this.author,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        timestamp,
        style: const TextStyle(color: Colors.grey),
      ),
      title: Text(text),
      subtitle: Text('Enviado por: $author'),
    );
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
  final LocalAuthentication _localAuth = LocalAuthentication(); // Initialize LocalAuthentication

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

  Future<void> _authenticateBiometrics() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        try {
          bool authenticated = await _localAuth.authenticate(
            localizedReason: 'Please authenticate to proceed with this action.',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
            ),
          );
          if (authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Biometric authentication successful!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Biometric authentication failed or canceled.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during biometric authentication: $e')),
          );
          print('Error during biometric authentication: $e');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No biometrics enrolled on this device.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication not available on this device.')),
      );
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
            ElevatedButton.icon(
              onPressed: _authenticateBiometrics,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Authenticate with Biometrics'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
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
class PropertyDetailScreen extends StatefulWidget {
  final House property;

  const PropertyDetailScreen({Key? key, required this.property}) : super(key: key);

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  double _calculatedPrice = 0.0;
  final ScrollController _imageCarouselController = ScrollController(); // For image carousel

  @override
  void dispose() {
    _imageCarouselController.dispose();
    super.dispose();
  }

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

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // If start date is after end date, reset end date
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = null;
          }
        } else {
          // Ensure end date is not before start date
          if (_startDate != null && picked.isBefore(_startDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('End date cannot be before start date.')),
            );
            return;
          }
          _endDate = picked;
        }
        _calculatePrice();
      });
    }
  }

  void _calculatePrice() {
    if (_startDate != null && _endDate != null) {
      final Duration duration = _endDate!.difference(_startDate!);
      // Assuming a daily price, adjust as needed
      setState(() {
        _calculatedPrice = widget.property.price * duration.inDays;
      });
    } else {
      setState(() {
        _calculatedPrice = 0.0;
      });
    }
  }

  Future<void> _rentHouse() async {
    final firestore = Provider.of<FirebaseFirestore>(context, listen: false);
    final firebaseAuth = Provider.of<FirebaseAuth>(context, listen: false);
    final currentUser = firebaseAuth.currentUser;

    if (currentUser == null) {
      _showLoginRequiredSnackBar(context, 'rent');
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates.')),
      );
      return;
    }

    if (currentUser.uid == widget.property.ownerId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot rent your own property.')),
      );
      return;
    }

    try {
      final newRent = Rent(
        id: '', // Firestore will generate this
        houseId: widget.property.id,
        clientId: currentUser.uid,
        startDate: _startDate!,
        endDate: _endDate!,
        calculatedPrice: _calculatedPrice,
      );

      await firestore.collection('rents').add(newRent.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully rented ${widget.property.title} for \$${_calculatedPrice.toStringAsFixed(2)}!')),
      );
      // Optionally navigate to pix payment
      Navigator.of(context).pushNamed('/pix_payment');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error renting property: $e')),
      );
      print('Rent property error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.property.imageUrls.isNotEmpty)
              SizedBox(
                height: 250,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal, // Ensure horizontal scrolling
                  controller: _imageCarouselController,
                  itemCount: widget.property.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.property.imageUrls[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 250,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Center(child: Icon(Icons.broken_image, size: 50)),
                          ),
                        ),
                      ),
                    );
                  },
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
              widget.property.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${widget.property.price.toStringAsFixed(2)} / night', // Clarify price is per night
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.green[700]),
            ),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.property.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Category: ${widget.property.category}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Rooms: ${widget.property.numberOfRooms}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Address: ${widget.property.street}, ${widget.property.houseNumber} ${widget.property.complement.isNotEmpty ? ' - ${widget.property.complement}' : ''}, ${widget.property.neighborhood}, ${widget.property.city} - ${widget.property.state}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            // Date pickers for rental
            Text(
              'Select Rental Dates:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_startDate == null
                        ? 'Start Date'
                        : 'Start: ${(_startDate!).toLocal().toString().split(' ')[0]}'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_endDate == null
                        ? 'End Date'
                        : 'End: ${(_endDate!).toLocal().toString().split(' ')[0]}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Total Rental Price: \$${_calculatedPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.deepOrange),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _rentHouse,
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
                          SnackBar(content: Text('Opening chat for ${widget.property.title} (Not implemented)')),
                        );
                        print('Message owner for property: ${widget.property.title}');
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      imageFile,
                                      fit: BoxFit.cover,
                                      width: 1000.0,
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

// screens/history/rental_history_screen.dart
class RentalHistoryScreen extends StatefulWidget {
  const RentalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<RentalHistoryScreen> createState() => _RentalHistoryScreenState();
}

class _RentalHistoryScreenState extends State<RentalHistoryScreen> {
  User? _currentUser;
  List<Rent> _rentalHistory = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _fetchRentalHistory();
  }

  Future<void> _fetchRentalHistory() async {
    if (_currentUser == null) {
      setState(() {
        _errorMessage = 'Please log in to view your rental history.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final firestore = Provider.of<FirebaseFirestore>(context, listen: false);
      final querySnapshot = await firestore
          .collection('rents')
          .where('clientId', isEqualTo: _currentUser!.uid)
          .orderBy('startDate', descending: true)
          .get();

      final List<Rent> fetchedRents = [];
      for (var doc in querySnapshot.docs) {
        fetchedRents.add(Rent.fromMap(doc.data(), doc.id));
      }

      setState(() {
        _rentalHistory = fetchedRents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load rental history: $e';
        _isLoading = false;
      });
      print('Error fetching rental history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rental History')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rental History')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
        ),
      );
    }

    if (_rentalHistory.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rental History')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'You have no rental history yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  'Rent a house to see it appear here!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental History'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _rentalHistory.length,
        itemBuilder: (context, index) {
          final rent = _rentalHistory[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rental ID: ${rent.id}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<House?>(
                    future: _fetchHouseDetails(rent.houseId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading house details: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                      }
                      final house = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            house?.title ?? 'House (Deleted or N/A)',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Category: ${house?.category ?? 'N/A'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Address: ${house?.street ?? 'N/A'}, ${house?.city ?? 'N/A'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Start Date: ${DateFormat('dd MMM yyyy').format(rent.startDate)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'End Date: ${DateFormat('dd MMM yyyy').format(rent.endDate)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total Price: \$${rent.calculatedPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green[700], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<House?> _fetchHouseDetails(String houseId) async {
    try {
      final firestore = Provider.of<FirebaseFirestore>(context, listen: false);
      final docSnapshot = await firestore.collection('properties').doc(houseId).get();
      if (docSnapshot.exists) {
        return House.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Error fetching house details for $houseId: $e');
      return null;
    }
  }
}

// screens/profile/profile_screen.dart
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

// screens/about/about_app_screen.dart
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

// screens/payment/pix_payment_screen.dart
class PagamentoPixPage extends StatefulWidget {
  const PagamentoPixPage({Key? key}) : super(key: key);

  @override
  State<PagamentoPixPage> createState() => _PagamentoPixPageState();
}

class _PagamentoPixPageState extends State<PagamentoPixPage> {
  bool pagamentoConfirmado = false;
  String? codigoPix;

  void gerarCodigoPix() {
    setState(() {
      // Simula um código Pix gerado
      codigoPix = '00020126330014BR.GOV.BCB.PIX0114+558199999999520400005303986540510.005802BR5925Fulano ou Ciclano de tal Pix6009Sao Paulo62070503***6304ABCD';
      pagamentoConfirmado = false;
    });
  }

  void confirmarPagamento() {
    setState(() {
      pagamentoConfirmado = true; // simula confirmação
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento via Pix (Simulado)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code),
              label: const Text('Gerar código Pix'),
              onPressed: gerarCodigoPix,
            ),
            const SizedBox(height: 16),
            if (codigoPix != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Código Pix gerado:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(codigoPix!),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: Text(pagamentoConfirmado
                        ? 'Pagamento confirmado!'
                        : 'Confirmar pagamento'),
                    onPressed: pagamentoConfirmado ? null : confirmarPagamento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pagamentoConfirmado ? Colors.green : null,
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
      neighborhood: data['neighborhood'] as String? ?? '',
      city: data['city'] as String? ?? '',
      state: data['state'] as String? ?? '',
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

// screens/property/custom_search_delegate.dart
class CustomSearchDelegate extends SearchDelegate<House?> {
  final List<House> allProperties;

  CustomSearchDelegate({required this.allProperties})
      : super(
          searchFieldLabel: 'Search by address or title...',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          searchFieldStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Return null when closing without selecting
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<House> matchQuery = allProperties.where((property) {
      final propertyAddress =
          '${property.street}, ${property.neighborhood}, ${property.city} - ${property.state}'
              .toLowerCase();
      final propertyTitle = property.title.toLowerCase();
      final lowerCaseQuery = query.toLowerCase();

      return propertyAddress.contains(lowerCaseQuery) ||
          propertyTitle.contains(lowerCaseQuery);
    }).toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final property = matchQuery[index];
        return ListTile(
          title: Text(property.title),
          subtitle: Text(
              '${property.street}, ${property.city}, ${property.state}'),
          onTap: () {
            close(context, property); // Return the selected House object
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<House> suggestionList = allProperties.where((property) {
      final propertyAddress =
          '${property.street}, ${property.neighborhood}, ${property.city} - ${property.state}'
              .toLowerCase();
      final propertyTitle = property.title.toLowerCase();
      final lowerCaseQuery = query.toLowerCase();

      return propertyAddress.contains(lowerCaseQuery) ||
          propertyTitle.contains(lowerCaseQuery);
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final property = suggestionList[index];
        return ListTile(
          title: Text(property.title),
          subtitle: Text(
              '${property.street}, ${property.city}, ${property.state}'),
          onTap: () {
            // When a suggestion is tapped, update the query and show results
            query = property.title; // Or property.street, etc.
            showResults(context);
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent, // Consistent app bar color
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 20.0, color: Colors.white), // Style for the query text
      ),
    );
  }
}

// screens/settings/settings_screen.dart
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  LocalUser? _localUser;
  bool _isLoggedIn = false; // Track login state

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    auth.authStateChanges().listen((User? user) async {
      setState(() {
        _isLoggedIn = user != null;
      });
      if (user != null) {
        final localAuthService = Provider.of<LocalAuthService>(context, listen: false);
        _localUser = await localAuthService.getUserDataLocally(user.uid);
        setState(() {}); // Update UI after fetching local user
      } else {
        _localUser = null;
      }
    });
  }

  Future<void> _authenticateBiometrics() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        try {
          bool authenticated = await _localAuth.authenticate(
            localizedReason: 'Please authenticate to enable smart lock functions.',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
            ),
          );
          if (authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Biometric authentication enabled for smart lock.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Biometric authentication failed or canceled.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during biometric authentication: $e')),
          );
          print('Error during biometric authentication: $e');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No biometrics enrolled on this device.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication not available on this device.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isOwner = _localUser?.role == 'owner';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              title: Text(
                "General",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              leading: const Icon(Icons.settings),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Functions - Description:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(
                    "Configure application language (Not implemented)",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(
                    "Organize security (Smart Lock Control)",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(
                    "Search for your Active MyHouse (Not implemented)",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const Divider(),
            ExpansionTile(
              title: Text(
                "Language",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              leading: const Icon(Icons.language_rounded),
              children: <Widget>[
                ListTile(
                  title: const Text('English (Not implemented)'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Language change not implemented.')),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Portuguese (Not implemented)'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Language change not implemented.')),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            ExpansionTile(
              title: Text(
                "Security",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              leading: const Icon(Icons.security),
              children: <Widget>[
                if (!_isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Please log in to enable security services.",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                  )
                else
                  Column(
                    children: [
                      ListTile(
                        title: const Text("Enable Biometric Authentication"),
                        leading: const Icon(Icons.fingerprint),
                        onTap: _authenticateBiometrics,
                      ),
                      ListTile(
                        title: const Text("Access Smart Lock Control"),
                        leading: const Icon(Icons.bluetooth_outlined),
                        onTap: () {
                          Navigator.of(context).pushNamed('/bluetooth_control');
                        },
                      ),
                      if (isOwner)
                        Column(
                          children: [
                            ListTile(
                              title: const Text("Manager - Activate MyHouse (Conceptual)"),
                              leading: const Icon(Icons.admin_panel_settings),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Manager Activate MyHouse (Conceptual)')),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text("Manager - Open MyHouse (Conceptual)"),
                              leading: const Icon(Icons.lock_open_rounded),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Manager Open MyHouse (Conceptual)')),
                                );
                              },
                            ),
                          ],
                        )
                      else
                        ListTile(
                          title: const Text("Client Access"),
                          leading: const Icon(Icons.person),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Client access features (Conceptual)')),
                            );
                          },
                        ),
                    ],
                  ),
              ],
            ),
            const Divider(),
            ExpansionTile(
              title: Text(
                "Help & Support",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              leading: const Icon(Icons.help_outline),
              children: <Widget>[
                ListTile(
                  title: const Text('Contact Support (Not implemented)'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact support functionality not implemented.')),
                    );
                  },
                ),
                ListTile(
                  title: const Text('FAQ (Not implemented)'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('FAQ functionality not implemented.')),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            ExpansionTile(
              title: Text(
                "About",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              leading: const Icon(Icons.info_outline_rounded),
              children: <Widget>[
                ListTile(
                  title: const Text('About This App'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/about_app');
                  },
                ),
                ListTile(
                  title: const Text('Terms of Service'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms of Service (Not implemented)')),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy Policy (Not implemented)')),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Security Policies'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Security Policies (Not implemented)')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// screens/about/about_app_screen.dart
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
            _buildFeaturePoint('Responsive UI adapting to device obfuscate.'),
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

// screens/payment/pix_payment_screen.dart
class PagamentoPixPage extends StatefulWidget {
  const PagamentoPixPage({Key? key}) : super(key: key);

  @override
  State<PagamentoPixPage> createState() => _PagamentoPixPageState();
}

class _PagamentoPixPageState extends State<PagamentoPixPage> {
  bool pagamentoConfirmado = false;
  String? codigoPix;

  void gerarCodigoPix() {
    setState(() {
      // Simula um código Pix gerado
      codigoPix = '00020126330014BR.GOV.BCB.PIX0114+558199999999520400005303986540510.005802BR5925Fulano ou Ciclano de tal Pix6009Sao Paulo62070503***6304ABCD';
      pagamentoConfirmado = false;
    });
  }

  void confirmarPagamento() {
    setState(() {
      pagamentoConfirmado = true; // simula confirmação
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento via Pix (Simulado)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code),
              label: const Text('Gerar código Pix'),
              onPressed: gerarCodigoPix,
            ),
            const SizedBox(height: 16),
            if (codigoPix != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Código Pix gerado:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(codigoPix!),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: Text(pagamentoConfirmado
                        ? 'Pagamento confirmado!'
                        : 'Confirmar pagamento'),
                    onPressed: pagamentoConfirmado ? null : confirmarPagamento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pagamentoConfirmado ? Colors.green : null,
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
      neighborhood: data['neighborhood'] as String? ?? '',
      city: data['city'] as String? ?? '',
      state: data['state'] as String? ?? '',
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

// screens/property/custom_search_delegate.dart
class CustomSearchDelegate extends SearchDelegate<House?> {
  final List<House> allProperties;

  CustomSearchDelegate({required this.allProperties})
      : super(
          searchFieldLabel: 'Search by address or title...',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          searchFieldStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Return null when closing without selecting
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<House> matchQuery = allProperties.where((property) {
      final propertyAddress =
          '${property.street}, ${property.neighborhood}, ${property.city} - ${property.state}'
              .toLowerCase();
      final propertyTitle = property.title.toLowerCase();
      final lowerCaseQuery = query.toLowerCase();

      return propertyAddress.contains(lowerCaseQuery) ||
          propertyTitle.contains(lowerCaseQuery);
    }).toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final property = matchQuery[index];
        return ListTile(
          title: Text(property.title),
          subtitle: Text(
              '${property.street}, ${property.city}, ${property.state}'),
          onTap: () {
            close(context, property); // Return the selected House object
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<House> suggestionList = allProperties.where((property) {
      final propertyAddress =
          '${property.street}, ${property.neighborhood}, ${property.city} - ${property.state}'
              .toLowerCase();
      final propertyTitle = property.title.toLowerCase();
      final lowerCaseQuery = query.toLowerCase();

      return propertyAddress.contains(lowerCaseQuery) ||
          propertyTitle.contains(lowerCaseQuery);
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final property = suggestionList[index];
        return ListTile(
          title: Text(property.title),
          subtitle: Text(
              '${property.street}, ${property.city}, ${property.state}'),
          onTap: () {
            // When a suggestion is tapped, update the query and show results
            query = property.title; // Or property.street, etc.
            showResults(context);
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent, // Consistent app bar color
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 20.0, color: Colors.white), // Style for the query text
      ),
    );
  }
}
