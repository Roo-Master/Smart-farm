import 'package:flutter/material.dart';
import 'package:smart_farming/screens/crop_monitoring_screen.dart';
import 'package:smart_farming/screens/dashboard_screen.dart';
import 'package:smart_farming/screens/equipments_booking_screen.dart';
import 'package:smart_farming/screens/market_place_screen.dart';

import 'auth/login.dart';

void main() {
  runApp(const SmartFarmingApp());
}

class SmartFarmingApp extends StatelessWidget {
  const SmartFarmingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farming',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32), // Green
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light gray
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/crop_monitoring': (context) => const CropMonitoringScreen(),
        '/marketplace': (context) => const MarketplaceScreen(),
        '/equipment_booking': (context) => const EquipmentBookingScreen(),
      },
    );
  }
}
