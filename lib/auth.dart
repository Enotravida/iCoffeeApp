import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailandPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signUpWithEmailandPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case "email-already-in-use":
          return "El correo electrónico ya está en uso.";
        case "user-not-found":
          return "No se encontró ningún usuario con ese correo electrónico.";
        case "wrong-password":
          return "Contraseña incorrecta.";
        default:
          return "Ocurrió un error desconocido.";
      }
    }
    return e.toString();
  }

  createUserWithEmailAndPassword({required String email, required String password}) {
  }
}
