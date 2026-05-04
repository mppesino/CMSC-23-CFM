import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  Future<String?> signIn(String email, String password) async {

    try{
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      print(credential);

    } on FirebaseAuthException catch (e) {
      return e.code;  // return error code for firebase errors
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    return null;
  }

  Future<String?> signUp(String firstName, String lastName, String email, String password) async {
    try{
      UserCredential credential =  await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(firstName);

      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(), 
            'userId': credential.user!.uid,
          });

    } on FirebaseAuthException catch (e) {
      return e.code;  // return error code for firebase errors
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
    return null;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

}

