import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class InternetScreen extends StatefulWidget {
  const InternetScreen({super.key});

  @override
  State<InternetScreen> createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
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
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog(permissionName);
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
                      Platform.isAndroid
                          ? Permission.photos
                          : Permission.photos,
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
/*










*/
/*-----------------------------------------------------------------------Backup código

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class InternetScreen extends StatefulWidget {
  const InternetScreen({super.key});
  @override
  State<InternetScreen> createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
  //Biometria teste------------------------------Inicio
  //Future<void> _requestBiometricPermission() async {
  //
  /*

    implementar
    */
  //
  //}
  //Biometria teste------------------------------Fim
  // List to store captured image files
  final List<File> _imageFiles = [];
  // ImagePicker instance to handle image picking operations
  final ImagePicker _picker = ImagePicker();
  // Current index for the PageView, used for dot indicator
  int _current = 0;
  // Controller for the PageView to programmatically control it
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  ); // Adjusted for card view

  // State variable for the biometric toggle switch
  //bool _biometryEnabled = false;

  // Asynchronously requests camera permission and opens the camera if granted
  Future<void> _requestCameraPermission() async {
    // Get the current status of the camera permission
    final status = await Permission.camera.status;

    if (status.isGranted) {
      // If permission is already granted, open the camera
      _openCamera();
    } else if (status.isDenied) {
      // If permission is denied, request it from the user
      final result = await Permission.camera.request();
      if (result.isGranted) {
        // If permission is granted after request, open the camera
        _openCamera();
      } else {
        // If permission is still denied, show a dialog
        _showPermissionDeniedDialog('Camera');
      }
    } else if (status.isPermanentlyDenied) {
      // If permission is permanently denied, show a dialog to open app settings
      _showPermissionPermanentlyDeniedDialog('Camera');
    }
  }

  // Asynchronously requests photo library permission and opens the gallery if granted
  Future<void> _requestGalleryPermission() async {
    // For Android 13+ and iOS, use Permission.photos
    // For older Android versions, Permission.storage might be needed, but image_picker often handles this.
    final status = await Permission
        .photos
        .status; // Or Permission.storage for older Android versions

    if (status.isGranted) {
      _pickImageFromGallery();
    } else if (status.isDenied) {
      final result = await Permission.photos.request();
      if (result.isGranted) {
        _pickImageFromGallery();
      } else {
        _showPermissionDeniedDialog('Photo Library');
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog('Photo Library');
    }
  }

  // Asynchronously requests location permission
  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission already granted!')),
      );
    } else if (status.isDenied) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission granted!')),
        );
      } else {
        _showPermissionDeniedDialog('Location');
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog('Location');
    }
  }

  // Asynchronously requests storage permission (read/write memory)
  Future<void> _requestStoragePermission() async {
    // For Android 13+ and iOS, specific media permissions are preferred (e.g., Permission.photos).
    // For older Android versions, Permission.storage (which covers READ_EXTERNAL_STORAGE and WRITE_EXTERNAL_STORAGE) is relevant.
    // The image_picker package often handles the necessary storage permissions internally for its operations.
    // However, if you need general file access beyond image_picker, you'd explicitly request storage.
    final status = await Permission
        .storage
        .status; // Represents READ_EXTERNAL_STORAGE and WRITE_EXTERNAL_STORAGE

    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission already granted!')),
      );
    } else if (status.isDenied) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission granted!')),
        );
      } else {
        _showPermissionDeniedDialog('Storage');
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog('Storage');
    }
  }

  // Asynchronously requests Bluetooth permissions
  Future<void> _requestBluetoothPermission() async {
    // Request specific Bluetooth permissions for Android 12+
    // For older Android versions, BLUETOOTH and BLUETOOTH_ADMIN are used.
    // For iOS, NSBluetoothAlwaysUsageDescription is typically sufficient.
    final bluetoothScanStatus = await Permission.bluetoothScan.status;
    final bluetoothAdvertiseStatus = await Permission.bluetoothAdvertise.status;
    final bluetoothConnectStatus = await Permission.bluetoothConnect.status;

    bool allGranted =
        bluetoothScanStatus.isGranted &&
        bluetoothAdvertiseStatus.isGranted &&
        bluetoothConnectStatus.isGranted;

    if (allGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bluetooth permissions already granted!')),
      );
    } else {
      // Request all three permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
      ].request();

      if (statuses[Permission.bluetoothScan]!.isGranted &&
          statuses[Permission.bluetoothAdvertise]!.isGranted &&
          statuses[Permission.bluetoothConnect]!.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bluetooth permissions granted!')),
        );
      } else {
        // Check if any specific permission was permanently denied
        if (statuses[Permission.bluetoothScan]!.isPermanentlyDenied ||
            statuses[Permission.bluetoothAdvertise]!.isPermanentlyDenied ||
            statuses[Permission.bluetoothConnect]!.isPermanentlyDenied) {
          _showPermissionPermanentlyDeniedDialog('Bluetooth');
        } else {
          _showPermissionDeniedDialog('Bluetooth');
        }
      }
    }
  }

  // Asynchronously opens the camera to take a photo
  Future<void> _openCamera() async {
    try {
      // Pick an image from the camera
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        // If an image was picked, add it to the list of image files
        setState(() {
          _imageFiles.add(File(pickedFile.path));
        });
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image captured and stored!')),
        );
        // After the UI rebuilds, animate to the newly added image in the PageView
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_imageFiles.isNotEmpty) {
            // Ensure there are images to animate to
            _pageController.animateToPage(
              _imageFiles.length - 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        });
      } else {
        // If no image was captured, show a message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No image captured.')));
      }
    } catch (e) {
      // Catch and display any errors during camera operation
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening camera: $e')));
    }
  }

  // Asynchronously opens the gallery to pick a photo
  Future<void> _pickImageFromGallery() async {
    try {
      // Pick an image from the gallery
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        // If an image was picked, add it to the list of image files
        setState(() {
          _imageFiles.add(File(pickedFile.path));
        });
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image picked from gallery!')),
        );
        // After the UI rebuilds, animate to the newly added image in the PageView
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_imageFiles.isNotEmpty) {
            // Ensure there are images to animate to
            _pageController.animateToPage(
              _imageFiles.length - 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        });
      } else {
        // If no image was picked, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image picked from gallery.')),
        );
      }
    } catch (e) {
      // Catch and display any errors during gallery operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image from gallery: $e')),
      );
    }
  }

  // Shows an AlertDialog when a permission is denied
  void _showPermissionDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionName Permission Denied'),
          content: Text(
            'Please grant $permissionName permission to use this feature.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Shows an AlertDialog when a permission is permanently denied, offering to open app settings
  void _showPermissionPermanentlyDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionName Permission Permanently Denied'),
          content: Text(
            'Please enable $permissionName permission from app settings to use this feature.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings(); // Opens the app's settings page
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera and Image Slider')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("Internet")],
            ),
            // Display message if no images are captured, otherwise show the PageView
            _imageFiles.isEmpty
                ? const Text('No images captured yet.')
                : Column(
                    children: [
                      SizedBox(
                        height: 250.0, // Set a fixed height for the PageView
                        child: PageView.builder(
                          controller:
                              _pageController, // Assign the PageController
                          itemCount: _imageFiles
                              .length, // Number of items in the PageView
                          itemBuilder: (BuildContext context, int index) {
                            // Build each item in the PageView as a card
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ), // Increased margin for card separation
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(
                                  12.0,
                                ), // Slightly more rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors
                                        .grey
                                        .shade600, // Slightly stronger shadow
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: const Offset(
                                      0,
                                      5,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.file(
                                  _imageFiles[index], // Display the image file
                                  fit: BoxFit
                                      .cover, // Cover the entire container
                                  width: double
                                      .infinity, // Ensure it fills the width
                                ),
                              ),
                            );
                          },
                          onPageChanged: (index) {
                            // Update the current index when page changes for dot indicator
                            setState(() {
                              _current = index;
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
                            ), // Tap to jump to page
                            child: Container(
                              width: 8.0,
                              height: 8.0,
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
            const SizedBox(height: 20),
            // Row for buttons
            Column(
              // Use Wrap for better layout on smaller screens
              spacing: 10, // Horizontal spacing
              children: [
                ElevatedButton(
                  onPressed: _requestCameraPermission,
                  child: const Text('Open Camera & Take Photo'),
                ),
                ElevatedButton(
                  onPressed:
                      _requestGalleryPermission, // New button for gallery
                  child: const Text('Pick from Gallery'),
                ),
                ElevatedButton(
                  onPressed:
                      _requestLocationPermission, // New button for location
                  child: const Text('Request Location'),
                ),
                ElevatedButton(
                  onPressed:
                      _requestStoragePermission, // New button for storage
                  child: const Text('Request Storage'),
                ),
                ElevatedButton(
                  onPressed:
                      _requestBluetoothPermission, // New button for Bluetooth
                  child: const Text('Request Bluetooth'),
                ),
              ],
            ),
            const SizedBox(height: 20), // Spacing between buttons and switch
            // Biometric toggle switch
          ],
        ),
      ),
    );
  }
}

/*Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("Internet")],
            )*/
*/