<<<<<<< HEAD
import 'package:local_auth/local_auth.dart';

final _auth = LocalAuthentication();

Future<bool> hasBiometrics() async {
  final isAvailable = await _auth.canCheckBiometrics;
  final isDeviceSupported = await _auth.isDeviceSupported();
  return isAvailable && isDeviceSupported;
}

Future<bool> authenticate() async {
  final isAuthAvailable = await hasBiometrics();
  if (!isAuthAvailable) return false;
  try {
    return await _auth.authenticate(
      localizedReason: 'Touch your finger on the sensor to login',
    );
  } catch (e) {
    return false;
  }
}
=======
import 'package:local_auth/local_auth.dart';

final _auth = LocalAuthentication();

Future<bool> hasBiometrics() async {
  final isAvailable = await _auth.canCheckBiometrics;
  final isDeviceSupported = await _auth.isDeviceSupported();
  return isAvailable && isDeviceSupported;
}

Future<bool> authenticate() async {
  final isAuthAvailable = await hasBiometrics();
  if (!isAuthAvailable) return false;
  try {
    return await _auth.authenticate(
      localizedReason: 'Touch your finger on the sensor to login',
    );
  } catch (e) {
    return false;
  }
}
>>>>>>> 42ef54f772b549574d2519cb976583f7ae711d7b
