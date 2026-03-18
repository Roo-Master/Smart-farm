import 'package:flutter/material.dart';
import 'package:smart_farming/screens/profile/profile_service.dart';
import 'package:smart_farming/screens/profile/user_model.dart';


class EditProfileScreen extends StatefulWidget {
  final AppUser user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();

  late TextEditingController _nameController;
  late TextEditingController _profileImageController;

  String role = "";
  String region = "";
  String farmerType = "";

  bool isLoading = false;

  // Example dropdown options
  final List<String> roles = ["Buyer", "Farmer"];
  final List<String> regions = [
    "Nairobi", "Mombasa", "Kisumu", "Nakuru", "Eldoret", "Thika", "Machakos"
  ];
  final List<String> farmerTypes = [
    "Dairy", "Livestock", "Crop Farming", "Poultry", "Mixed Farming"
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _profileImageController = TextEditingController(text: widget.user.profileImage);
    role = widget.user.role;
    region = widget.user.region;
    farmerType = widget.user.farmerType;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final updatedUser = AppUser(
      uid: widget.user.uid,
      name: _nameController.text.trim(),
      phone: widget.user.phone,
      role: role,
      region: region,
      farmerType: farmerType,
      profileImage: _profileImageController.text.trim(),
    );

    try {
      await _profileService.updateUserProfile(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context, updatedUser); // return updated user to profile screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profileImageController.text),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _profileImageController,
                decoration: const InputDecoration(
                  labelText: "Profile Image URL",
                  prefixIcon: Icon(Icons.image),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter image URL" : null,
              ),
              const SizedBox(height: 15),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 15),

              // Role
              DropdownButtonFormField<String>(
                value: role.isNotEmpty ? role : null,
                decoration: const InputDecoration(
                  labelText: "Role",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                items: roles
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => role = val);
                },
                validator: (val) => val == null || val.isEmpty ? "Select role" : null,
              ),
              const SizedBox(height: 15),

              // Region
              DropdownButtonFormField<String>(
                value: region.isNotEmpty ? region : null,
                decoration: const InputDecoration(
                  labelText: "Region",
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
                items: regions
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => region = val);
                },
                validator: (val) => val == null || val.isEmpty ? "Select region" : null,
              ),
              const SizedBox(height: 15),

              // Farmer Type
              DropdownButtonFormField<String>(
                value: farmerType.isNotEmpty ? farmerType : null,
                decoration: const InputDecoration(
                  labelText: "Farmer Type",
                  prefixIcon: Icon(Icons.agriculture),
                  border: OutlineInputBorder(),
                ),
                items: farmerTypes
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => farmerType = val);
                },
                validator: (val) =>
                val == null || val.isEmpty ? "Select farmer type" : null,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Profile", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}