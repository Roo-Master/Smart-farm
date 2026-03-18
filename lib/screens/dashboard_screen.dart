import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_farming/screens/profile/profile_service.dart';
import 'package:smart_farming/screens/profile/user_model.dart';
import 'package:smart_farming/wedgets/quick_action.dart';

import '../wedgets/infor_card.dart';
import 'crop_monitoring_screen.dart';

// Global cameras
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MaterialApp(home: DashboardScreen()));
}

// ---------------- Dashboard Screen ----------------
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CameraController? _cameraController;
  bool _isCameraActive = false;

  String _weatherAlert = "Weather is normal 🌤";
  String _soilAlert = "Soil moisture is optimal ✅";

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final profileService = ProfileService();
    final fetchedUser = await profileService.getUser(user.uid);

    setState(() {
      currentUser = fetchedUser as AppUser?;
    });
  }

  void _startCamera() async {
    if (cameras.isEmpty) return;
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController!.initialize();
    setState(() {
      _isCameraActive = true;
    });
  }

  void _stopCamera() {
    _cameraController?.dispose();
    setState(() {
      _isCameraActive = false;
      _cameraController = null;
    });
  }

  void _simulateWeatherAlert() {
    setState(() {
      _weatherAlert = "⚠️ Heavy rain expected tomorrow!";
    });
  }

  void _simulateSoilAlert() {
    setState(() {
      _soilAlert = "⚠️ Soil moisture too low in northern fields!";
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final userName = user?.name ?? "Loading...";
    final userRole = user?.role ?? "";
    final userRegion = user?.region ?? "";
    final userFarmerType = user?.farmerType ?? "";
    final profileImage = user?.profileImage ?? "https://i.pravatar.cc/300";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Welcome, $userName!"),
        backgroundColor: Colors.green.shade700,
        actions: [
          GestureDetector(
            onTap: () {
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfileScreen(user: user),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileImage),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Info Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                InfoCard(
                  title: "Soil Moisture",
                  value: "32%",
                  icon: Icons.water_drop,
                  color: Colors.blue,
                ),
                InfoCard(
                  title: "Market Price",
                  value: "KES 3,200",
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
                InfoCard(
                  title: "Equipment",
                  value: "Tractor Available",
                  icon: Icons.agriculture,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                QuickActionButton(
                  label: "Crop Monitor",
                  icon: Icons.grass,
                  route: '/crop_monitoring',
                ),
                QuickActionButton(
                  label: "Market",
                  icon: Icons.store,
                  route: '/marketplace',
                ),
                QuickActionButton(
                  label: "Irrigation",
                  icon: Icons.water,
                  route: '/equipment_booking',
                ),
                QuickActionButton(
                  label: "Equipment",
                  icon: Icons.settings,
                  route: '/equipment_booking',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // AI Crop Detection
            GestureDetector(
              onTap: () {
                _isCameraActive ? _stopCamera() : _startCamera();
              },
              child: FeatureCard(
                title: _isCameraActive
                    ? "Stop AI Crop Detection"
                    : "Start AI Crop Disease Detection",
                icon: Icons.camera_alt,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            if (_isCameraActive && _cameraController != null)
              SizedBox(height: 300, child: CameraPreview(_cameraController!)),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: _simulateWeatherAlert,
              child: FeatureCard(
                title: "Weather Alerts",
                icon: Icons.cloud,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _weatherAlert,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _simulateSoilAlert,
              child: FeatureCard(
                title: "Soil Alerts",
                icon: Icons.grass,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _soilAlert,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- User Profile Screen ----------------
class UserProfileScreen extends StatelessWidget {
  final AppUser user;
  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user.profileImage),
            ),
            const SizedBox(height: 15),
            Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(user.role, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.phone, "Phone", user.phone),
                    const Divider(),
                    _buildInfoRow(Icons.location_city, "Region", user.region),
                    const Divider(),
                    _buildInfoRow(Icons.agriculture, "Farmer Type", user.farmerType),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 15),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}