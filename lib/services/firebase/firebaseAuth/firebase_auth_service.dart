import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<AuthCredential> getPhoneCredential(String verificationId, String otp) async {
    return PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
  }

  Future<AuthCredential> getEmailCredential(String email, String password) async {
    return EmailAuthProvider.credential(email: email, password: password);
  }

  Future<UserCredential> signInWithCredentials(AuthCredential authCredential) async {
    return await _firebaseAuth.signInWithCredential(authCredential);
  }

  Future<void> logoutFirebase() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> deleteFirebaseUser() async {
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.currentUser!.delete();
    }
  }
}
