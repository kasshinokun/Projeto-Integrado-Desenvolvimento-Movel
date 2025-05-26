import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

//Biometria---------------------------------------------------/
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class InternetScreen extends StatefulWidget {
  const InternetScreen({super.key});

  @override
  State<InternetScreen> createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
  //Biometria---------------------------------------------------/
  var _title = "Pronto";
  var _message = "Toque no botão para iniciar a autenticação";
  var _icone = Icons.settings_power;
  var _colorIcon = Colors.yellow;
  var _colorButton = Colors.blue;

  final LocalAuthentication _localAuth = LocalAuthentication();
  //------------------------------------------------------------/
  final List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  int _currentImageIndex = 0; // Tracks the current page for the dot indicator
  final PageController _pageController = PageController(
    viewportFraction: 0.85, // Slightly adjust for better card visibility
  );

  @override
  void dispose() {
    _pageController.dispose(); // Important: dispose of the controller
    super.dispose();
  }

  // --- Biometria -------------------------
  Future<void> _checkBiometricSensor() async {
    //--ações futuras--
    try {
      var authenticate = await _localAuth.authenticate(
        localizedReason: 'Por favor autentique-se para continuar',
      );
      setState(() {
        if (authenticate) {
          _title = "Ótimo";
          _message = "Verificação biométrica funcionou!!";
          _icone = Icons.beenhere;
          _colorIcon = Colors.green;
          _colorButton = Colors.green;
        } else {
          _title = "Ops";
          _message = "Tente novamente!";
          _icone = Icons.clear;
          _colorIcon = Colors.red;
          _colorButton = Colors.red;
        }
      });
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        setState(() {
          _title = "Desculpe";
          _message = "Não conseguimos encontrar o sensor biométrico :(";
          _icone = Icons.clear;
          _colorIcon = Colors.red;
          _colorButton = Colors.red;
        });
      }
    }
  }
  // --- Utility Methods for Permissions ---

  /// Generic handler for permission requests.
  /// It requests the permission and shows appropriate dialogs based on the status.
  Future<void> _requestPermission(
    Permission permission,
    String permissionName, {
    Function? onGranted,
  }) async {
    final status = await permission.status;
    if (status.isGranted) {
      if (onGranted != null) {
        onGranted(); // Execute callback if provided
      } else {
        _showSnackBar('$permissionName permission already granted!');
      }
    } else if (status.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        if (onGranted != null) {
          onGranted();
        } else {
          _showSnackBar('$permissionName permission granted!');
        }
      } else {
        _showPermissionDeniedDialog(permissionName);
        print(
          """\n------------------------------------------------------------------------
          
                      PermissionDenied
                      
                ------------------------------------------------------------------------\n""",
        );
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog(permissionName);
      print(
        """\n------------------------------------------------------------------------
          
                      PermissionPermanentlyDenied
                      
                ------------------------------------------------------------------------\n""",
      );
    }
  }

  /// Displays a SnackBar message.
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// Shows an AlertDialog when a permission is denied.
  void _showPermissionDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('$permissionName Permission Denied'),
          content: Text(
            'Please grant $permissionName permission to use this feature.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows an AlertDialog when a permission is permanently denied, offering to open app settings.
  void _showPermissionPermanentlyDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('$permissionName Permission Permanently Denied'),
          content: Text(
            'Please enable $permissionName permission from app settings to use this feature.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings(); // Opens the app's settings page
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // --- Image Handling Methods ---

  /// Opens the camera to take a photo.
  Future<void> _openCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        _addImage(File(pickedFile.path), 'Image captured successfully!');
      } else {
        _showSnackBar('No image captured.');
      }
    } catch (e) {
      _showSnackBar('Error opening camera: $e');
    }
  }

  /// Opens the gallery to pick a photo.
  Future<void> _pickImageFromGallery() async {
    print(
      """\n------------------------------------------------------------------------
        
                    Entrei
                    
              ------------------------------------------------------------------------\n""",
    );

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        _addImage(File(pickedFile.path), 'Image picked from gallery!');
      } else {
        _showSnackBar('No image picked from gallery.');
      }
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        _showPermissionDeniedDialog('Photo Library');
      } else {
        _showSnackBar('Failed to pick image: ${e.message}');
      }
    } catch (e) {
      _showSnackBar('Error picking image from gallery: $e');
    }
  }

  /// Adds an image to the list and updates the UI.
  void _addImage(File imageFile, String successMessage) {
    setState(() {
      _imageFiles.add(imageFile);
    });
    _showSnackBar(successMessage);
    // After the UI rebuilds, animate to the newly added image in the PageView
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_imageFiles.isNotEmpty) {
        _pageController.animateToPage(
          _imageFiles.length - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions & Image Slider'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Section for image display
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        _imageFiles.isEmpty
                            ? 'No images captured yet.'
                            : 'Captured Images',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      _imageFiles.isEmpty
                          ? Container(
                              height: 200,
                              alignment: Alignment.center,
                              child: Text(
                                'Tap a button below to add an image.',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            )
                          : SizedBox(
                              height: 250.0, // Fixed height for the PageView
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _imageFiles.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade600,
                                          spreadRadius: 3,
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.file(
                                        _imageFiles[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  );
                                },
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                              ),
                            ),
                      const SizedBox(height: 10),
                      // Dot indicator for the PageView
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _imageFiles.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _pageController.animateToPage(
                              entry.key,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            ),
                            child: Container(
                              width: _currentImageIndex == entry.key
                                  ? 10.0
                                  : 8.0,
                              height: _currentImageIndex == entry.key
                                  ? 10.0
                                  : 8.0,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(shape: BoxShape.circle),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Section for permission buttons
              Text(
                'Request Device Permissions:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _PermissionButton(
                    onPressed: () => _requestPermission(
                      Permission.camera,
                      'Camera',
                      onGranted: _openCamera,
                    ),
                    text: 'Open Camera & Take Photo',
                    icon: Icons.camera_alt,
                  ),

                  _PermissionButton(
                    onPressed: () => _requestPermission(
                      Permission.photos,
                      'Photo Library',
                      onGranted: _pickImageFromGallery,
                    ),
                    text: 'Pick from Gallery',
                    icon: Icons.photo_library,
                  ),

                  _PermissionButton(
                    onPressed: () => _requestPermission(
                      Permission.locationWhenInUse,
                      'Location',
                    ),
                    text: 'Request Location',
                    icon: Icons.location_on,
                  ),
                  _PermissionButton(
                    onPressed: () => _requestPermission(
                      Platform.isAndroid
                          ? Permission.manageExternalStorage
                          : Permission.photos,
                      'Storage',
                    ),
                    text: 'Request Storage',
                    icon: Icons.storage,
                  ),
                  _PermissionButton(
                    onPressed: () => _requestPermission(
                      Permission.bluetoothScan,
                      'Bluetooth',
                    ),
                    text: 'Request Bluetooth',
                    icon: Icons.bluetooth,
                  ),
                  _PermissionButton(
                    onPressed: _checkBiometricSensor,
                    text: 'Request Biometric',
                    icon: Icons.fingerprint,
                  ),
                ],
              ),
              const SizedBox(height: 20), // Spacing below buttons
              // NEW: Button to open app settings
              ElevatedButton.icon(
                onPressed: () {
                  openAppSettings(); // This opens the app's settings screen
                },
                icon: const Icon(Icons.settings),
                label: const Text('Open App Settings'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(180, 48), // Consistent button size
                ),
              ),
              const SizedBox(height: 20), // Spacing below the new button
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Button Widget for Permissions
class _PermissionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const _PermissionButton({
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(180, 48),
      ),
    );
  }
}
