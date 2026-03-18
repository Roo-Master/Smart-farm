import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// Global variable to store available cameras
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MaterialApp(home: CropMonitoringScreen()));
}

class CropMonitoringScreen extends StatefulWidget {
  const CropMonitoringScreen({super.key});

  @override
  State<CropMonitoringScreen> createState() => _CropMonitoringScreenState();
}

class _CropMonitoringScreenState extends State<CropMonitoringScreen> {
  CameraController? _cameraController;
  bool _isCameraActive = false;
  String _weatherAlert = "All good! 🌤";

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

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Crop Monitoring"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CropCard(
            cropName: "Maize",
            stage: "Flowering",
            health: "Healthy",
          ),
          const SizedBox(height: 16),
          const CropCard(
            cropName: "Tomatoes",
            stage: "Fruiting",
            health: "Needs Attention",
          ),
          const SizedBox(height: 16),
          // AI Crop Disease Detection Card
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
          const SizedBox(height: 16),
          if (_isCameraActive && _cameraController != null)
            SizedBox(height: 300, child: CameraPreview(_cameraController!)),
          const SizedBox(height: 16),
          // Satellite Crop Monitoring
          const FeatureCard(
            title: "Satellite Crop Monitoring",
            icon: Icons.satellite,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          // Farm Analytics Dashboard
          const FeatureCard(
            title: "Farm Analytics Dashboard",
            icon: Icons.bar_chart,
            color: Colors.purple,
          ),
          const SizedBox(height: 16),
          // Weather Alerts
          GestureDetector(
            onTap: _simulateWeatherAlert,
            child: FeatureCard(
              title: "Weather-based Crop Alerts",
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
        ],
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final String cropName;
  final String stage;
  final String health;

  const CropCard({
    super.key,
    required this.cropName,
    required this.stage,
    required this.health,
  });

  Color getHealthColor() {
    switch (health) {
      case "Healthy":
        return Colors.green;
      case "Needs Attention":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  IconData getHealthIcon() {
    switch (health) {
      case "Healthy":
        return Icons.check_circle;
      case "Needs Attention":
        return Icons.warning;
      default:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.eco, color: Colors.green, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cropName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Growth Stage: $stage",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(getHealthIcon(), color: getHealthColor()),
                const SizedBox(width: 6),
                Text(
                  health,
                  style: TextStyle(
                    color: getHealthColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const FeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
