import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String name;
  final String phone;
  final String role;       // Buyer / Farmer
  final String region;
  final String farmerType; // Dairy, Livestock, etc.
  final String profileImage;

  AppUser({
    required this.uid,
    required this.name,
    required this.phone,
    required this.role,
    required this.region,
    required this.farmerType,
    required this.profileImage,
  });

  // Create AppUser from Firestore document
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
      region: data['region'] ?? '',
      farmerType: data['farmerType'] ?? '',
      profileImage: data['profileImage'] ?? 'https://i.pravatar.cc/300',
    );
  }

  // Convert AppUser to Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'role': role,
      'region': region,
      'farmerType': farmerType,
      'profileImage': profileImage,
    };
  }
}