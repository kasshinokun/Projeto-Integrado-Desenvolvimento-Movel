// Classe falsa de usuário para simular um usuário logado offline (sem Firebase)
// Implementa a interface User e agora inclui displayName e photoURL
import 'package:firebase_auth/firebase_auth.dart';

class FakeUser implements User {
  final String _uid;
  final String? _email;
  final String? _displayName;
  final String? _photoURL; // Caminho local da imagem

  FakeUser(this._uid, this._email, this._displayName, this._photoURL);

  @override
  String get uid => _uid;

  @override
  String? get email => _email;

  @override
  String? get displayName => _displayName;

  @override
  String? get photoURL => _photoURL; // Retorna o caminho local do arquivo

  @override
  bool get emailVerified => false;
  @override
  bool get isAnonymous => false;
  @override
  List<UserInfo> get providerData => [];

  // Métodos não implementados da interface User
  @override
  Future<void> delete() => throw UnimplementedError();
  @override
  Future<String> getIdToken([bool forceRefresh = false]) => throw UnimplementedError();
  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) => throw UnimplementedError();
  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) => throw UnimplementedError();
  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) => throw UnimplementedError();
  @override
  Future<void> reload() => throw UnimplementedError();
  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) => throw UnimplementedError();
  @override
  // ignore: override_on_non_overriding_member
  Future<void> sendEmailVerificationSms([ActionCodeSettings? actionCodeSettings]) => throw UnimplementedError();
  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) => throw UnimplementedError();
  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) => throw UnimplementedError();
  @override
  Future<void> updateEmail(String newEmail) => throw UnimplementedError();
  @override
  Future<void> updatePassword(String newPassword) => throw UnimplementedError();
  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential credential) => throw UnimplementedError();
  @override
  Future<void> updateDisplayName(String? displayName) => throw UnimplementedError();
  @override
  Future<void> updatePhotoURL(String? photoURL) => throw UnimplementedError();
  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) => throw UnimplementedError();
  
  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber, [RecaptchaVerifier? verifier]) {

    throw UnimplementedError();
  }
  
  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) {
    
    throw UnimplementedError();
  }
  
  @override
  Future<void> linkWithRedirect(AuthProvider provider) {
    
    throw UnimplementedError();
  }
  
  @override
 
  UserMetadata get metadata => throw UnimplementedError();
  
  @override
  
  MultiFactor get multiFactor => throw UnimplementedError();
  
  @override
 
  String? get phoneNumber => throw UnimplementedError();
  
  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) {
   
    throw UnimplementedError();
  }
  
  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) {
    
    throw UnimplementedError();
  }
  
  @override
  
  String? get refreshToken => throw UnimplementedError();
  
  @override
  
  String? get tenantId => throw UnimplementedError();
  
  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) {
    
    throw UnimplementedError();
  }
  
  @override
  Future<User> unlink(String providerId) {
    throw UnimplementedError();
  }

  
}