import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String userType = "Farmer";
  String? selectedCounty;
  String? selectedFarmType;

  bool isLoading = false;

  void goToDashboard() async {
    setState(() => isLoading = true);

    // Simulate a short delay for loading effect
    await Future.delayed(const Duration(seconds: 1));

    setState(() => isLoading = false);

    // Navigate to Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    );
  }

  final List<String> counties = [
    "Nairobi", "Mombasa", "Kisumu", "Nakuru", "Eldoret",
    "Kiambu", "Machakos", "Kakamega", "Meru", "Nyeri",
    "Kilifi", "Kwale", "Bungoma", "Busia", "Siaya",
    "Homa Bay", "Migori", "Kisii", "Nyamira", "Kericho",
    "Bomet", "Narok", "Kajiado", "Laikipia", "Embu",
    "Tharaka Nithi", "Kitui", "Makueni", "Taita Taveta"
  ];

  final List<String> farmTypes = [
    "Crop Farming",
    "Dairy Farming",
    "Poultry Farming",
    "Livestock Keeping",
    "Fish Farming",
    "Mixed Farming"
  ];

  Future<void> register() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedCounty == null ||
        (userType == "Farmer" && selectedFarmType == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      final email = "${phoneController.text}@farm.com";

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(nameController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful")),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.app_registration,
                        size: 60, color: Colors.green),

                    const SizedBox(height: 10),

                    const Text(
                      "Create Account",
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    // Name
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: "Full Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Phone
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        labelText: "Phone Number",
                        hintText: "7XXXXXXXX",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Password
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // User Type
                    DropdownButtonFormField<String>(
                      value: userType,
                      items: ["Farmer", "Buyer"]
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          userType = value!;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.people),
                        labelText: "Register As",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // County Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedCounty,
                      items: counties
                          .map((county) => DropdownMenuItem(
                        value: county,
                        child: Text(county),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCounty = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on),
                        labelText: "County",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Farmer Type (ONLY if Farmer)
                    if (userType == "Farmer")
                      DropdownButtonFormField<String>(
                        value: selectedFarmType,
                        items: farmTypes
                            .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFarmType = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.agriculture),
                          labelText: "Farm Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Register Button
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : goToDashboard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          "Register",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Back to login
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child:
                      const Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}