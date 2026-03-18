import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_farming/screens/profile/user_model.dart';


class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user profile by UID
  Future<AppUser?> getUserProfile(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromDocument(doc);
  }

  // Update user profile
  Future<void> updateUserProfile(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  // Update only specific fields
  Future<void> updateUserFields(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  Future<Object?> getUser(String uid) async {}
}