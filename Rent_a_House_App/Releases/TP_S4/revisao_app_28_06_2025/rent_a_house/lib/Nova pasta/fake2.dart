import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
// Updated import for MasonryGridView
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';
import 'dart:io'; // For file manipulation
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:path_provider/path_provider.dart'; // For getting directories
import 'package:path/path.dart' as p; // For path manipulation

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes Firebase in the application
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generate and Register Users',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Provides the UserGenerator instance to the widget tree
      home: ChangeNotifierProvider(
        create: (_) => UserGenerator(),
        child: UserGenerationScreen(),
      ),
    );
  }
}

// --- Data Model for User ---
class UserData {
  final String uid; // UID generated locally before Firebase Auth
  final String name;
  final String email;
  final String password;
  final String profileImageLocalPath; // Local path where the image was saved
  final String profileImageUrlRemote; // Original remote URL of the image
  final String gender;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.profileImageLocalPath,
    required this.profileImageUrlRemote,
    required this.gender,
  });

  // Converts UserData to a Map to be saved as JSON
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'profileImageLocalPath': profileImageLocalPath,
        'profileImageUrlRemote': profileImageUrlRemote,
        'gender': gender,
      };

  // Converts a JSON Map back to UserData
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        profileImageLocalPath: json['profileImageLocalPath'],
        profileImageUrlRemote: json['profileImageUrlRemote'],
        gender: json['gender'],
      );
}

// --- User Generator and Local File Manager ---
class UserGenerator extends ChangeNotifier {
  List<UserData> generatedUsers = [];
  List<String> maleNames = ['João', 'Pedro', 'Lucas', 'Gabriel', 'Rafael', 'Mateus', 'Guilherme', 'Gustavo', 'Felipe', 'Bruno'];
  List<String> femaleNames = ['Maria', 'Ana', 'Julia', 'Sofia', 'Isabela', 'Laura', 'Beatriz', 'Manuela', 'Helena', 'Valentina'];
  Random _random = Random();

  static const int numUSERSTOGENERATE = 15; // Fixed number of users to generate
  static const String usersDataSubDir = 'users_data'; // Subdirectory to save data and images
  static const String userJsonFilename = 'generated_users.json'; // Name of the local JSON file

  String _baseStoragePath = ''; // Base path for the app's documents directory + subdirectory

  UserGenerator() {
    _initializeStoragePath(); // Starts the initialization of the storage path
  }

  // Initializes the storage directory path and creates the folder if it doesn't exist
  Future<void> _initializeStoragePath() async {
    final directory = await getApplicationDocumentsDirectory(); // Gets the app's documents directory
    _baseStoragePath = p.join(directory.path, usersDataSubDir); // Creates the full path to the subfolder
    await Directory(_baseStoragePath).create(recursive: true); // Creates the folder recursively
    print('Storage directory: $_baseStoragePath');
    notifyListeners(); // Notifies that the path has been initialized (important for _checkExistingGeneratedData)
  }

  // --- Random Data Generation Functions ---
  String _generateRandomUid() {
    // Simple UUID v4 generator (use a 'uuid' package in production for robustness)
    return "$_randomHex(8)'-'$_randomHex(4)'-4'$_randomHex(3)'-'$_randomHex(4)'-'$_randomHex(12)";
  }

  String _randomHex(int length) {
    return List.generate(length, (_) => _random.nextInt(16).toRadixString(16)).join();
  }

  String _generateRandomName(String gender) {
    if (gender == 'male') {
      return '${maleNames[_random.nextInt(maleNames.length)]} ${femaleNames[_random.nextInt(femaleNames.length)]}';
    } else {
      return '${femaleNames[_random.nextInt(femaleNames.length)]} ${maleNames[_random.nextInt(maleNames.length)]}';
    }
  }

  String _generateRandomEmail(String name) {
    // Generates a basic email based on the name and a random number
    return '${name.toLowerCase().replaceAll(' ', '').substring(0, min(name.length, 5))}${_random.nextInt(9999)}@fake.com';
  }

  String _generateRandomPassword() {
    // Generates a random password with special characters, digits, etc.
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    return List.generate(12, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  // --- Local Data Download and Verification Functions ---

  // Checks if the data directory and JSON already exist and contain the expected number of users
  Future<bool> _checkExistingGeneratedData() async {
    if (_baseStoragePath.isEmpty) return false; // If the path has not been initialized, there is no data

    final jsonFile = File(p.join(_baseStoragePath, userJsonFilename));
    if (!await jsonFile.exists()) {
      print('JSON file not found at local path.');
      return false;
    }

    try {
      final String content = await jsonFile.readAsString();
      final List<dynamic> jsonList = json.decode(content);
      if (jsonList.length == numUSERSTOGENERATE) {
        // If the number of users in the JSON matches, check if the images exist locally
        bool allImagesExist = true;
        for (var userDataJson in jsonList) {
          final user = UserData.fromJson(userDataJson);
          // If the image path does not start with 'assets/', it means it is a local file
          if (!user.profileImageLocalPath.startsWith('assets/')) {
            final imageFile = File(user.profileImageLocalPath);
            if (!await imageFile.exists()) {
              print('Image ${user.profileImageLocalPath} referenced in JSON not found.');
              allImagesExist = false;
              break;
            }
          }
        }
        return allImagesExist;
      }
      print('Number of users in JSON is ${jsonList.length}, expected $numUSERSTOGENERATE.');
      return false; // Number of users does not match
    } catch (e) {
      print('Error reading or parsing existing JSON: $e');
      return false;
    }
  }

  // Downloads an image from the URL and saves it to the app's local data directory
  Future<String?> _downloadAndSaveImage(String imageUrl, String uid) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final fileName = '$uid.jpg'; // Uses the user's UID as the file name for uniqueness
        final File file = File(p.join(_baseStoragePath, fileName)); // Full file path
        await file.writeAsBytes(response.bodyBytes); // Writes the image bytes to the file
        print('Image saved to: ${file.path}');
        return file.path; // Returns the local path where the image was saved
      } else {
        print('Failed to download image: Status ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading or saving image: $e');
      return null;
    }
  }

  // --- Main User Generation Function (with download and existence check) ---
  Future<void> generateUsersWithImages() async {
    // Ensures the storage path is initialized
    if (_baseStoragePath.isEmpty) {
      print('Storage directory not yet initialized. Trying to initialize again.');
      await _initializeStoragePath();
      if (_baseStoragePath.isEmpty) {
        print('Critical failure initializing storage directory. Aborting generation.');
        return;
      }
    }

    // 1. Checks if data already exists locally to avoid repeated downloads
    if (await _checkExistingGeneratedData()) {
      print('User data already exists and is complete locally. Loading it into cards...');
      final jsonFile = File(p.join(_baseStoragePath, userJsonFilename));
      final String content = await jsonFile.readAsString();
      final List<dynamic> jsonList = json.decode(content);
      generatedUsers = jsonList.map((data) => UserData.fromJson(data)).toList();
      notifyListeners(); // Updates the UI with loaded data
      return;
    }

    // 2. If data does not exist or is incomplete, generates new users and downloads images
    generatedUsers.clear(); // Clears the list for new generation
    print('Generating new users and downloading profile images...');

    for (int i = 0; i < numUSERSTOGENERATE; i++) {
      final gender = _random.nextDouble() < 0.5 ? 'male' : 'female';
      final uid = _generateRandomUid();
      final name = _generateRandomName(gender);
      final email = _generateRandomEmail(name);
      final password = _generateRandomPassword();

      String? imageUrlRemote;
      String? imageLocalPath;

      try {
        // Fetches the image URL from the RandomUser.me API
        final response = await http.get(Uri.parse('https://randomuser.me/api/?gender=$gender'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          imageUrlRemote = data['results'][0]['picture']['large'];
          // Downloads and saves the image locally
          imageLocalPath = await _downloadAndSaveImage(imageUrlRemote!, uid);
        } else {
          print('Failed to get image URL for $name. Status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching image for $name: $e');
      }

      // Uses a placeholder image from assets/ if download fails
      if (imageLocalPath == null) {
        imageLocalPath = 'assets/placeholder.png'; // Ensure 'assets/placeholder.png' exists in your pubspec.yaml
        print('Using placeholder image for $name due to download failure.');
      }

      generatedUsers.add(UserData(
        uid: uid,
        name: name,
        email: email,
        password: password,
        profileImageLocalPath: imageLocalPath,
        profileImageUrlRemote: imageUrlRemote ?? '', // Can be empty if download failed
        gender: gender,
      ));
      notifyListeners(); // Notifies the UI for each added user (incremental feedback)
    }

    // 3. Saves all generated data to a local JSON file upon completion
    try {
      final jsonFile = File(p.join(_baseStoragePath, userJsonFilename));
      // Converts the list of UserData to a list of Maps and then to JSON String
      final String jsonContent = jsonEncode(generatedUsers.map((u) => u.toJson()).toList());
      await jsonFile.writeAsString(jsonContent); // Saves the JSON to the file
      print('Data of ${generatedUsers.length} users saved to: ${jsonFile.path}');
    } catch (e) {
      print('Error saving users JSON: $e');
    }
    notifyListeners(); // Notifies one last time at the end of generation
  }
}

// --- Application Screen ---
class UserGenerationScreen extends StatefulWidget {
  const UserGenerationScreen({super.key});
  @override
  State<UserGenerationScreen> createState() => _UserGenerationScreenState();
}

class _UserGenerationScreenState extends State<UserGenerationScreen> {
  String _registrationStatus = ''; // Status message for Firebase registration
  bool _isRegistering = false; // Indicates if the Firebase registration process is active
  bool _isGenerating = true; // Indicates if initial data generation/loading is in progress

  @override
  void initState() {
    super.initState();
    // Starts user generation as soon as the screen is created (after the frame is rendered)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() { _isGenerating = true; }); // Starts the generation state
      await Provider.of<UserGenerator>(context, listen: false).generateUsersWithImages();
      setState(() { _isGenerating = false; }); // Ends the generation state
    });
  }

  // Function to register users in Firebase Authentication and save data to Firestore
  Future<void> _registerUsers(List<UserData> users) async {
    setState(() {
      _isRegistering = true; // Activates the registration state
      _registrationStatus = 'Registering users in Firebase... This may take a while.';
    });

    int successCount = 0;
    int failureCount = 0;
    List<String> failures = []; // List to store failure details
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    for (var user in users) {
      try {
        // 1. Create user in Firebase Authentication (email and password)
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
        User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          // 2. Save additional user data to Firestore
          await firestore.collection('users').doc(firebaseUser.uid).set({
            'name': user.name,
            'email': user.email,
            'profileImageLocalPath': user.profileImageLocalPath, // Saved local path
            'profileImageUrlRemote': user.profileImageUrlRemote, // Saved original remote URL
            'gender': user.gender,
            'createdAt': FieldValue.serverTimestamp(), // Server timestamp
          });
          successCount++;
          print('User ${user.email} registered with UID: ${firebaseUser.uid}');
        } else {
          // Case where userCredential.user is null (unlikely after successful createUserWithEmailAndPassword)
          failureCount++;
          failures.add('Unexpected failure to get UID for ${user.email} after Auth registration.');
        }
      } on FirebaseAuthException catch (e) {
        failureCount++;
        failures.add('Failed to register ${user.email}: ${e.message ?? 'Unknown error'}');
        print('FirebaseAuth error for ${user.email}: ${e.message}');
      } on FirebaseException catch (e) {
        failureCount++;
        failures.add('Failed to save Firestore for ${user.email}: ${e.message ?? 'Unknown error'}');
        print('Firestore error for ${user.email}: ${e.message}');
      } catch (e) {
        failureCount++;
        failures.add('General error registering ${user.email}: $e');
        print('General error for ${user.email}: $e');
      }
    }

    setState(() {
      _isRegistering = false; // Deactivates the registration state
      _registrationStatus = 'Registration completed.\nSuccess: $successCount, Failures: $failureCount\n\nFailure details:\n${failures.join('\n')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final userGenerator = Provider.of<UserGenerator>(context);
    // Condition to show the register button: not generating, not registering,
    // and the number of generated users matches the expected.
    bool showRegisterButton = !_isGenerating && !_isRegistering &&
                              userGenerator.generatedUsers.length == UserGenerator.numUSERSTOGENERATE;

    return Scaffold(
      appBar: AppBar(title: const Text('Generate and Register Users')),
      body: 
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: 
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isGenerating // If generating/loading, show an indicator
                    ? Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Generating data and downloading images...', textAlign: TextAlign.center),
                          ],
                        ))
                    : userGenerator.generatedUsers.isEmpty // If no users generated
                        ? const Center(child: Text('No users generated. Check logs.'))
                        : MasonryGridView.count( // Displays user cards
                            crossAxisCount: 2, // 2 cards per row
                            itemCount: userGenerator.generatedUsers.length,
                            itemBuilder: (BuildContext context, int index) {
                              final user = userGenerator.generatedUsers.elementAt(index);
                              return Card(
                                elevation: 4, // Card elevation for shadowing
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Displays the image, checking if it's an asset or a local file
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(40), // Rounded corners for the image
                                        child: user.profileImageLocalPath.startsWith('assets/')
                                            ? Image.asset(user.profileImageLocalPath, height: 80, width: 80, fit: BoxFit.cover)
                                            : Image.file(
                                                File(user.profileImageLocalPath),
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                                // Visual fallback for broken image
                                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80, color: Colors.red),
                                              ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(user.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text(user.email, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            // staggeredTileBuilder is removed for MasonryGridView
                            mainAxisSpacing: 8.0, // Vertical spacing between cards
                            crossAxisSpacing: 8.0, // Horizontal spacing between cards
                          ),
              ),
            ),
            // Conditionally shows the register button
            if (showRegisterButton)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _isRegistering
                      ? null // Disables the button if registration is in progress
                      : () => _registerUsers(userGenerator.generatedUsers), // Calls the registration function
                  icon: _isRegistering
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) // Progress indicator
                      : const Icon(Icons.send), // Default icon
                  label: Text(_isRegistering ? 'Registering...' : 'Register to Firebase'), // Button text
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Full width and fixed height button
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_registrationStatus, textAlign: TextAlign.center), // Displays registration status
            ),
          ],
        ),
      ),
      // Original FloatingActionButton was removed as the button is now in the screen body
    );
  }
}
