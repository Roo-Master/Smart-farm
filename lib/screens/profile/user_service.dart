import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_farming/screens/profile/user_model.dart';


class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user
  Future<AppUser?> registerUser({
    required String name,
    required String phone,
    required String password,
    required String role,
    required String region,
    required String farmerType,
    String profileImage = 'https://i.pravatar.cc/300',
  }) async {
    final email = "$phone@farm.com";

    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    AppUser appUser = AppUser(
      uid: cred.user!.uid,
      name: name,
      phone: phone,
      role: role,
      region: region,
      farmerType: farmerType,
      profileImage: profileImage,
    );

    await _firestore.collection('users').doc(cred.user!.uid).set(appUser.toMap());

    await cred.user!.updateDisplayName(name);

    return appUser;
  }

  // Login user
  Future<AppUser?> loginUser(String phone, String password) async {
    final email = "$phone@farm.com";

    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    DocumentSnapshot doc =
    await _firestore.collection('users').doc(cred.user!.uid).get();

    if (doc.exists) {
      return AppUser.fromDocument(doc);
    }

    return null;
  }

  // Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get currently logged-in user
  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return AppUser.fromDocument(doc);
  }
}