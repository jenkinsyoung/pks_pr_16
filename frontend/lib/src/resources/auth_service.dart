import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<UserCredential> signIn(String email, String password) async {
    try{
     return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  Future <UserCredential> signUp(String email, String password) async {
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final String uid = userCredential.user?.uid ?? '';

      if (uid.isEmpty) {
        throw Exception('failed to get user UID');
      }

      await _fireStore.collection('users').doc(uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'role': 'user',
      });
      return userCredential;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  Future <void> signOut() async{
    return await FirebaseAuth.instance.signOut();
  }


  Future<String> getUserRole(String userID) async {
    DocumentSnapshot userDoc = await _fireStore.collection('users').doc(userID).get();
    final data = userDoc.data() as Map<String, dynamic>?;

    return data?['role'] as String;
  }

}
